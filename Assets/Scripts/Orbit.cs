using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Orbit : Rotate{
    [SerializeField] public Transform target;
    [SerializeField]public float orbitSpeed;

    void Update(){
        base.Update();
        if (target != null)
        {
            transform.RotateAround(target.position, Vector3.up, orbitSpeed * Time.deltaTime);
        }
    }
}
