## Rolling upgrade scenario - Kolla.

1. Clone this repository. And cd into it.

2. Setup Ocata cluster with Kolla, get 6 Heat containers: heat\_engine (2),
   heat\_api (2), heat\_api\_cfn (2).

3. Rename these containers by appending 'ocata' suffix. Then stop them. You
   can use the bellow script or do it manually"

    ```
    scripts/rename_n_stop_heat_container.sh
    ```

    __Note__: After that, we will have 6 containers: heat\_engine\_ocata (2),
    heat\_api\_ocata (2), heat\_api\_cfn\_ocata (2).

4. Re-deploy another Kolla cluster (Nova, Neutron, Heat (of course), Glance,
   Horizon) - Newton release.

5. Clone new source code (Ocata release) and run db\_sync:

    ```
    heat_manage db_sync
    ```

6. Create new rabbitmq vhost (e.g: 'ocata') and set user permissions.

7. Re-configure transport\_url configuration in
   /etc/kolla/<heat_service>/heat.conf:

    ```
    transport_url = rabbit://<user>:<password>@<host>:5672/<new_vhost>
    ```
8. Stop Heat containers (Newton release) then start Heat container (Ocata).
   Note: Don't stop all api containers before stop all engine containers.

9. During these steps (5->8), send async request (CREATE, LIST, DELETE stack).

## Run send\_request script.

1. Change auth config in test\_heat\_status/admin-openrc.

2. Run command:

    ```
    python send_request.py
    ```
