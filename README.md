# GC-bash
This repos is used for my work and researching.
The repos just focuses on how to build, how to run an unit test on circleCI and using docker.

# Unit test's folder structure
```
    Unit test structure					                   
/tests					                                                
----- /communications				                         
       ---- emails.py			                            
                def check_welcome_email()		            
                def check_product_email()		            
                def ....

----- /sms
      ---- def check_sending_sms()
      ---- def ....
----- /purchases
      ---- /PRODUCT
            ---- /sponsored_purchase.py
                    ---- def test1(): emailComms.check_welcome_email()
                    ---- def ....
            ---- /api_purchase.py
```

```
Base Unit test
  Purchase
    - Waiting for ...
```