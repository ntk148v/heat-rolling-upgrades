## Rolling upgrade scenario.

1. Deploy both versions of Heat service (Newton and Ocata)

2. Rename Heat container (Ocata version) by append suffix '_ocata' then stop
   these containers.

3. Stop all Heta container (Newton version) then start Heat container (Ocata
   version) immediately.

## Run send_request script.

1. Change auth config in test\_heat\_status/admin-openrc.

2. Run command:

    ```
    python send_request.py
    ```
