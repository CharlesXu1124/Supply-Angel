using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleRotator : MonoBehaviour {
	public Vector3 rotSpeed = new Vector3(0, 0, 0);

	void Update() {
		float movement = Time.deltaTime * 500;
		transform.Rotate(rotSpeed.x * movement, rotSpeed.y * movement, rotSpeed.z * movement);
	}
}
