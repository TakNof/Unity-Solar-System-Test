using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour{

    [SerializeField]public float rotationSpeed;
    protected void Update()
    {
        transform.Rotate(0.0f, rotationSpeed, 0.0f, Space.Self);
    }
}
