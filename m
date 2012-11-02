From: Wilmer van der Gaast <wilmer@gaast.net>
Subject: Re: Bug#692104: linux-image-3.2.0-3-amd64: NULL pointer dereference
  in ext4fs
Date: Fri, 02 Nov 2012 22:52:35 +0100
Message-ID: <509440A3.5020604@gaast.net>
References: <50938953.6010001@gaast.net> <1351866830.13356.100.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040809040308040305000707"
Cc: linux-ext4@vger.kernel.org, 692104@bugs.debian.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from roy.gaast.net ([80.101.33.21]:32964 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab2KBWAj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2012 18:00:39 -0400
In-Reply-To: <1351866830.13356.100.camel@deadeye.wl.decadent.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040809040308040305000707
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 02-11-12 15:33, Ben Hutchings wrote:
>> I don't know what exactly triggered this, but the result was that my /home
>> was no longer accessible after this event.  My root filesystem was still
>> okay.
> I assume this means it was no longer accessible until the next boot.
>
Oh yes, definitely. Sorry for not being clear.

Also, this has just happened again. This time, after me not having 
touched the laptop for over ten hours. I'm starting to wonder whether my 
filesystem is corrupted. I'll make an LVM snapshot and then do a full fsck.

I'll attach the backtrace. Seems to be the same like this morning.


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +

--------------040809040308040305000707
Content-Type: text/plain;
 name="crash2.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="crash2.txt"

QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ug
YXQgICAgICAgICAgIChudWxsKQpJUDogWzxmZmZmZmZmZmEwMTZiZTRiPl0gZXh0NF9tYl9n
b29kX2dyb3VwKzB4MzkvMHhjZCBbZXh0NF0KUEdEIDEyYWMyMjA2NyBQVUQgMTJkZTVmMDY3
IFBNRCAwIApPb3BzOiAwMDAwIFsjMV0gU01QIApDUFUgMCAKTW9kdWxlcyBsaW5rZWQgaW46
IHBhcnBvcnRfcGMgcHBkZXYgbHAgcGFycG9ydCBibmVwIHJmY29tbSBibHVldG9vdGggY3B1
ZnJlcV9jb25zZXJ2YXRpdmUgY3B1ZnJlcV91c2Vyc3BhY2UgY3B1ZnJlcV9wb3dlcnNhdmUg
Y3B1ZnJlcV9zdGF0cyB1aW5wdXQgZnVzZSBuZnNkIG5mcyBuZnNfYWNsIGF1dGhfcnBjZ3Nz
IGZzY2FjaGUgbG9ja2Qgc3VucnBjIGV4dDMgamJkIGV4dDIgbG9vcCBrdm1faW50ZWwga3Zt
IHNuZF9oZGFfY29kZWNfY29uZXhhbnQgc25kX2hkYV9pbnRlbCBzbmRfaGRhX2NvZGVjIHNu
ZF9od2RlcCBzbmRfcGNtX29zcyBzbmRfbWl4ZXJfb3NzIHNuZF9wY20gYXJjNCBzbmRfcGFn
ZV9hbGxvYyBzbmRfc2VxX21pZGkgc25kX3NlcV9taWRpX2V2ZW50IHNuZF9yYXdtaWRpIGl3
bHdpZmkgc25kX3NlcSBwc21vdXNlIHNuZF9zZXFfZGV2aWNlIGlUQ09fd2R0IHBjc3BrciBz
ZXJpb19yYXcgc25kX3RpbWVyIGV2ZGV2IGNvcmV0ZW1wIGlUQ09fdmVuZG9yX3N1cHBvcnQg
aTJjX2k4MDEgbWFjODAyMTEgYmF0dGVyeSB0aGlua3BhZF9hY3BpIGk5MTUgYWNwaV9jcHVm
cmVxIHRwbV90aXMgbnZyYW0gY2ZnODAyMTEgdHBtIHRwbV9iaW9zIHJma2lsbCBhYyBwb3dl
cl9zdXBwbHkgc25kIGRybV9rbXNfaGVscGVyIGRybSBtcGVyZiBpMmNfYWxnb19iaXQgd21p
IGkyY19jb3JlIHZpZGVvIHNvdW5kY29yZSBwcm9jZXNzb3IgYnV0dG9uIGV4dDQgY3JjMTYg
amJkMiBtYmNhY2hlIHNoYTI1Nl9nZW5lcmljIGNyeXB0ZCBhZXNfeDg2XzY0IGFlc19nZW5l
cmljIGNiYyBkbV9jcnlwdCBkbV9tb2Qgc2cgc2RfbW9kIGNyY190MTBkaWYgdGhlcm1hbCB0
aGVybWFsX3N5cyBhaGNpIGxpYmFoY2kgdWhjaV9oY2QgbGliYXRhIGVoY2lfaGNkIHNjc2lf
bW9kIHVzYmNvcmUgdXNiX2NvbW1vbiBlMTAwMGUgW2xhc3QgdW5sb2FkZWQ6IHNjc2lfd2Fp
dF9zY2FuXQoKUGlkOiAzODQ4LCBjb21tOiBmaXJlZm94LWJpbiBOb3QgdGFpbnRlZCAzLjIu
MC0zLWFtZDY0ICMxIExFTk9WTyA3NDY1Q1RPLzc0NjVDVE8KUklQOiAwMDEwOls8ZmZmZmZm
ZmZhMDE2YmU0Yj5dICBbPGZmZmZmZmZmYTAxNmJlNGI+XSBleHQ0X21iX2dvb2RfZ3JvdXAr
MHgzOS8weGNkIFtleHQ0XQpSU1A6IDAwMTg6ZmZmZjg4MDEyZGVlZDhjOCAgRUZMQUdTOiAw
MDAxMDI5MwpSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODgwMGI4OTI0OGQ4IFJD
WDogMDAwMDAwMDAwMDAwMDAwMgpSRFg6IGZmZmY4ODAxMmFjNWUwMDAgUlNJOiAwMDAwMDAw
MDAwMDAwMDU4IFJESTogZmZmZjg4MDEzNjNjMDQwMApSQlA6IDAwMDAwMDAwMDAwMDAxNTgg
UjA4OiBmZmZmODgwMTE2YTBhNDU4IFIwOTogZmZmZjg4MDExNmEwYTQ1OApSMTA6IGZmZmY4
ODAxMTZhMGE0NTggUjExOiBmZmZmODgwMTE2YTBhNDU4IFIxMjogMDAwMDAwMDAwMDAwMDAw
MApSMTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiBmZmZmODgwMTM2M2MwNDAwIFIxNTogMDAw
MDAwMDAwMDAwMDAwMApGUzogIDAwMDA3ZmE3M2JhZmU3MDAoMDAwMCkgR1M6ZmZmZjg4MDEz
YmMwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCkNTOiAgMDAxMCBEUzogMDAw
MCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKQ1IyOiAwMDAwMDAwMDAwMDAwMDAw
IENSMzogMDAwMDAwMDEyZDJjMDAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZjAKRFIwOiAwMDAw
MDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAw
MDAKRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAw
MDAwMDAwMDAwMDA0MDAKUHJvY2VzcyBmaXJlZm94LWJpbiAocGlkOiAzODQ4LCB0aHJlYWRp
bmZvIGZmZmY4ODAxMmRlZWMwMDAsIHRhc2sgZmZmZjg4MDEzMmUyNzFlMCkKU3RhY2s6CmZm
ZmY4ODAxMTZhMGE0NTggZmZmZjg4MDBiODkyNDhkOCBmZmZmODgwMTMyZTk3ODAwIGZmZmY4
ODAxMzYzYzA0MDAKMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMTUwIDAwMDAwMDAw
MDAwMDAxNTggZmZmZmZmZmZhMDE2ZDM5NwowMDAwMDAwMzAwMDAwMDAwIGZmZmY4ODAxMzJl
OTdhZjggMDAwMDAwMDBmZmZmZmZmZiBmZmZmODgwMTMyZTI3MWUwCkNhbGwgVHJhY2U6Cls8
ZmZmZmZmZmZhMDE2ZDM5Nz5dID8gZXh0NF9tYl9yZWd1bGFyX2FsbG9jYXRvcisweDExMC8w
eDI2NCBbZXh0NF0KWzxmZmZmZmZmZjgxMDM2NDU3Pl0gPyBzaG91bGRfcmVzY2hlZCsweDUv
MHgyMwpbPGZmZmZmZmZmYTAxNmU1MGE+XSA/IGV4dDRfbWJfbmV3X2Jsb2NrcysweDFjMi8w
eDQwMyBbZXh0NF0KWzxmZmZmZmZmZmEwMTY5MDBmPl0gPyBfX2V4dDRfaGFuZGxlX2RpcnR5
X21ldGFkYXRhKzB4ZDcvMHhlOCBbZXh0NF0KWzxmZmZmZmZmZmEwMTcxZWFiPl0gPyBleHQ0
X2FsbG9jX2JyYW5jaCsweDFhYi8weDQ2OCBbZXh0NF0KWzxmZmZmZmZmZmEwMTJmYmYxPl0g
PyBqYmQyX2pvdXJuYWxfc3RvcCsweDIwOS8weDIxYiBbamJkMl0KWzxmZmZmZmZmZmEwMTcy
OTIyPl0gPyBleHQ0X2luZF9tYXBfYmxvY2tzKzB4Mjg5LzB4NGE2IFtleHQ0XQpbPGZmZmZm
ZmZmYTAxNDg0YmU+XSA/IGV4dDRfZGFfd3JpdGVfZW5kKzB4MWYxLzB4MjMyIFtleHQ0XQpb
PGZmZmZmZmZmODEwYmQ1ZDk+XSA/IHJlbGVhc2VfcGFnZXMrMHg2OC8weDE0ZApbPGZmZmZm
ZmZmODEwYmQ1ZDk+XSA/IHJlbGVhc2VfcGFnZXMrMHg2OC8weDE0ZApbPGZmZmZmZmZmODEx
YWQwOTk+XSA/IF9fbG9va3VwX3RhZysweGI2LzB4MTIwCls8ZmZmZmZmZmZhMDE0NTYzNz5d
ID8gZXh0NF9tYXBfYmxvY2tzKzB4MTE0LzB4MWYwIFtleHQ0XQpbPGZmZmZmZmZmODExYWQ4
MGE+XSA/IHJhZGl4X3RyZWVfZ2FuZ19sb29rdXBfdGFnX3Nsb3QrMHg3Ny8weDk4Cls8ZmZm
ZmZmZmY4MTBmMzY5Nj5dID8gbWVtX2Nncm91cF9hZGRfbHJ1X2xpc3QrMHhkLzB4YWEKWzxm
ZmZmZmZmZmEwMTQ4NThkPl0gPyBtcGFnZV9kYV9tYXBfYW5kX3N1Ym1pdCsweDhlLzB4MmY5
IFtleHQ0XQpbPGZmZmZmZmZmYTAxNDhhZGY+XSA/IHdyaXRlX2NhY2hlX3BhZ2VzX2RhKzB4
MjE0LzB4MmM1IFtleHQ0XQpbPGZmZmZmZmZmYTAxNDhlMzI+XSA/IGV4dDRfZGFfd3JpdGVw
YWdlcysweDJhMi8weDQ1YiBbZXh0NF0KWzxmZmZmZmZmZjgxMGI0Y2QwPl0gPyBfX2ZpbGVt
YXBfZmRhdGF3cml0ZV9yYW5nZSsweDRiLzB4NTAKWzxmZmZmZmZmZmEwMTQxNWFhPl0gPyBl
eHQ0X3JlbGVhc2VfZmlsZSsweDFiLzB4OTMgW2V4dDRdCls8ZmZmZmZmZmY4MTBmYTMwZD5d
ID8gZnB1dCsweGY5LzB4MWExCls8ZmZmZmZmZmY4MTBmODAzNj5dID8gZmlscF9jbG9zZSsw
eDYyLzB4NmEKWzxmZmZmZmZmZjgxMGY4MGNjPl0gPyBzeXNfY2xvc2UrMHg4ZS8weGNiCls8
ZmZmZmZmZmY4MTM0ZmM5Mj5dID8gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiCkNv
ZGU6IDUzIDQ4IDg5IGZiIDQxIDUyIDRjIDhiIDc3IDA4IDQ5IDhiIDg2IGIwIDAyIDAwIDAw
IDRjIDg5IGY3IDQ0IDhiIGI4IDIwIDAzIDAwIDAwIGU4IGZkIGRjIGZmIGZmIDQxIDgzIGZk
IDAzIDQ5IDg5IGM0IDc2IDAyIDBmIDBiIDw0OD4gOGIgMDAgYTggMDEgNzQgMGUgODkgZWUg
NGMgODkgZjcgZTggMTggZmUgZmYgZmYgODUgYzAgNzUgNjkgClJJUCAgWzxmZmZmZmZmZmEw
MTZiZTRiPl0gZXh0NF9tYl9nb29kX2dyb3VwKzB4MzkvMHhjZCBbZXh0NF0KUlNQIDxmZmZm
ODgwMTJkZWVkOGM4PgpDUjI6IDAwMDAwMDAwMDAwMDAwMDAKLS0tWyBlbmQgdHJhY2UgNGJl
NzZlNDJmYzY2MDA2YSBdLS0tCg==
--------------040809040308040305000707--
