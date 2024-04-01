using UnityEngine;
using UnityEditor;
using System.IO;

public class TextureToMaterialProcessor : AssetPostprocessor{
    static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths){
        string texturesFolder = "Assets/Textures";
        string materialsFolder = "Assets/Materials";
        string[] textureDataTypes = {"png", "jpg"};

        if (!Directory.Exists(texturesFolder)){
            return;
        }

        Directory.CreateDirectory(materialsFolder);

        string[] subFolders = Directory.GetDirectories(texturesFolder);

        foreach (string subFolder in subFolders){
            string subFolderName = Path.GetFileName(subFolder);
            if(subFolderName == "Omit"){
                continue;
            }
            string subFolderGenerated = Path.Combine(materialsFolder, subFolderName);
            Directory.CreateDirectory(subFolderGenerated);
            foreach(string textureDataType in textureDataTypes){
                
                //Obtén todos los archivos de imagen de la subcarpeta
                string[] textureFiles = Directory.GetFiles(subFolder, $"*.{textureDataType}");

                foreach (string file in textureFiles){
                    //Lee la imagen
                    Texture2D texture = AssetDatabase.LoadAssetAtPath<Texture2D>(file);

                    //Crea un nuevo material con el mismo nombre
                    string fileName = Path.GetFileNameWithoutExtension(file);
                    string createdPath = Path.Combine(subFolderGenerated, $"{fileName}.mat");

                    // Verifica si el archivo del material ya existe
                    if (File.Exists(createdPath)){
                        continue;
                    }

                    Material newMaterial = new Material(Shader.Find("Standard"));
                    newMaterial.mainTexture = texture;

                    //Guarda el nuevo material en la subcarpeta generada
                    AssetDatabase.CreateAsset(newMaterial, createdPath);

                    Debug.Log($"Material generado: {createdPath}");
                }
            }
        }
    }
}