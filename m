From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] always set EXCLUSIVE flag for modifying e2fsck
Date: Tue, 23 Feb 2010 12:56:12 -0700
Message-ID: <8794863F-ED0D-41B9-831A-3AA473E6BB1C@sun.com>
References: <20090923095640.GX10562@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_jONVwzbR6wWG0YmE/nP8UA)"
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64290 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0BWT4a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 14:56:30 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1NJuTdD004184
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 11:56:29 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KYB00K008F6W600@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 23 Feb 2010 11:56:29 -0800 (PST)
In-reply-to: <20090923095640.GX10562@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_jONVwzbR6wWG0YmE/nP8UA)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

The checks done by e2fsck for mounted vs. read-only runs is confusing.

On the one hand, if e2fsck is NOT run with the "-n" flag (i.e. it might
modify the filesystem), there is no guarantee that it will open the
filesystem with the EXCLUSIVE flag (i.e. O_EXCL) to prevent the block
device from being used later (i.e. mounted while e2fsck is running).

On the other hand, if e2fsck IS run with "-n" (i.e. read-only),
and the /etc/fstab or /proc/mounts does not report the same block
device to match the mountpoint (which happens for Lustre, and can
also happen if there is an overlay mount) then the e2fsck incorrectly
thinks the filesystem is unmounted, but fails because the EXCLUSIVE
flag is set even though it is running read-only.

Fix this so that "e2fsck -n" never sets EXCLUSIVE, and when run without
"-n" it will always set EXCLUSIVE unless the user answered "yes" to:

         /dev/sda1 is mounted.

         WARNING!!!  Running e2fsck on a mounted filesystem may cause
         SEVERE filesystem damage.

         Do you really want to continue (y/n)?


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--Boundary_(ID_jONVwzbR6wWG0YmE/nP8UA)
Content-type: application/octet-stream; name=e2fsprogs-e2fsck_exclusive.patch;
 x-unix-mode=0664
Content-transfer-encoding: BASE64
Content-disposition: attachment; filename=e2fsprogs-e2fsck_exclusive.patch

VGhlIGNoZWNrcyBkb25lIGJ5IGUyZnNjayBmb3IgbW91bnRlZCB2cy4gcmVhZC1v
bmx5IHJ1bnMgaXMgY29uZnVzaW5nLg0KDQpPbiB0aGUgb25lIGhhbmQsIGlmIGUy
ZnNjayBpcyBOT1QgcnVuIHdpdGggdGhlICItbiIgZmxhZyAoaS5lLiBpdCBtaWdo
dA0KbW9kaWZ5IHRoZSBmaWxlc3lzdGVtKSwgdGhlcmUgaXMgbm8gZ3VhcmFudGVl
IHRoYXQgaXQgd2lsbCBvcGVuIHRoZQ0KZmlsZXN5c3RlbSB3aXRoIHRoZSBFWENM
VVNJVkUgZmxhZyAoaS5lLiBPX0VYQ0wpIHRvIHByZXZlbnQgdGhlIGJsb2NrDQpk
ZXZpY2UgZnJvbSBiZWluZyB1c2VkIGxhdGVyIChpLmUuIG1vdW50ZWQgd2hpbGUg
ZTJmc2NrIGlzIHJ1bm5pbmcpLg0KDQpPbiB0aGUgb3RoZXIgaGFuZCwgaWYgZTJm
c2NrIGlzIHJ1biB3aXRoICItbiIgKGkuZS4gcmVhZC1vbmx5KSwNCmFuZCB0aGUg
L2V0Yy9mc3RhYiBvciAvcHJvYy9tb3VudHMgZG9lcyBub3QgcmVwb3J0IHRoZSBz
YW1lIGJsb2NrDQpkZXZpY2UgdG8gbWF0Y2ggdGhlIG1vdW50cG9pbnQgKHdoaWNo
IGhhcHBlbnMgZm9yIEx1c3RyZSwgYW5kIGNhbg0KYWxzbyBoYXBwZW4gaWYgdGhl
cmUgaXMgYW4gb3ZlcmxheSBtb3VudCkgdGhlbiB0aGUgZTJmc2NrIHRoaW5rcw0K
dGhlIGZpbGVzeXN0ZW0gaXMgdW5tb3VudGVkLCBidXQgZmFpbHMgYmVjYXVzZSB0
aGUgRVhDTFVTSVZFIGZsYWcNCmlzIHNldCBldmVuIHRob3VnaCBpdCBpcyBydW5u
aW5nIHJlYWQtb25seS4NCg0KRml4IHRoaXMgc28gdGhhdCAiZTJmc2NrIC1uIiBu
ZXZlciBzZXRzIEVYQ0xVU0lWRSwgYW5kIHdoZW4gcnVuIHdpdGhvdXQNCiItbiIg
aXQgd2lsbCBhbHdheXMgc2V0IEVYQ0xVU0lWRSB1bmxlc3MgdGhlIHVzZXIgYW5z
d2VyZWQgInllcyIgdG86DQoNCiAgICAgICAgL2Rldi9zZGExIGlzIG1vdW50ZWQu
ICANCg0KICAgICAgICBXQVJOSU5HISEhICBSdW5uaW5nIGUyZnNjayBvbiBhIG1v
dW50ZWQgZmlsZXN5c3RlbSBtYXkgY2F1c2UNCiAgICAgICAgU0VWRVJFIGZpbGVz
eXN0ZW0gZGFtYWdlLg0KDQogICAgICAgIERvIHlvdSByZWFsbHkgd2FudCB0byBj
b250aW51ZSAoeS9uKT8NCg0KDQpTaWduZWQtb2ZmLWJ5OiBBbmRyZWFzIERpbGdl
ciA8YWRpbGdlckBzdW4uY29tPg0KDQpJbmRleDogZTJmc3Byb2dzLTEuNDEuNi9l
MmZzY2svdW5peC5jDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gZTJmc3Byb2dz
LTEuNDEuNi5vcmlnL2UyZnNjay91bml4LmMNCisrKyBlMmZzcHJvZ3MtMS40MS42
L2UyZnNjay91bml4LmMNCkBAIC0xMjMwLDkgKzEyMzAsMTQgQEAgcmVzdGFydDoN
CiAJCWlvX3B0ciA9IHVuaXhfaW9fbWFuYWdlcjsNCiAJZmxhZ3MgPSBFWFQyX0ZM
QUdfTk9GUkVFX09OX0VSUk9SOw0KIAlpZiAoKGN0eC0+b3B0aW9ucyAmIEUyRl9P
UFRfUkVBRE9OTFkpID09IDApDQotCQlmbGFncyB8PSBFWFQyX0ZMQUdfUlc7DQot
CWlmICgoY3R4LT5tb3VudF9mbGFncyAmIEVYVDJfTUZfTU9VTlRFRCkgPT0gMCkN
Ci0JCWZsYWdzIHw9IEVYVDJfRkxBR19FWENMVVNJVkU7DQorCQlmbGFncyB8PSBF
WFQyX0ZMQUdfUlcgfCBFWFQyX0ZMQUdfRVhDTFVTSVZFOw0KKwkvKiBXZSB3b3Vs
ZCBoYXZlIGFib3J0ZWQgYWJvdmUgaW4gY2hlY2tfbW91bnQoKSB1bmxlc3MgdGhl
IHVzZXINCisJICogYXNrcyBmb3IgdGhpcy4gIElmIHRoZSBkZXZpY2UgaXMgbW91
bnRlZCwgYnV0IGl0IHdhc24ndCBmb3VuZCBpbg0KKwkgKiAvZXRjL210YWIgb3Ig
L3Byb2MvbW91bnRzIGJ5IGV4dDJmc19jaGVja19pZl9tb3VudGVkKCksIG9yIGl0
IGlzDQorCSAqIG5vdCB0aGUgcm9vdCBmaWxlc3lzdGVtIHRoZW4gRVhUMl9NRl9N
T1VOVEVEIHdvdWxkIG5vdCBiZSBzZXQsDQorCSAqIGFuZCB3ZSBkbyBub3QgY2xl
YXIgRVhUMl9GTEFHX0VYQ0xVU0lWRS4gKi8NCisJaWYgKChjdHgtPm1vdW50X2Zs
YWdzICYgRVhUMl9NRl9NT1VOVEVEKSAhPSAwKQ0KKwkJZmxhZ3MgJj0gfkVYVDJf
RkxBR19FWENMVVNJVkU7DQogDQogCXJldHZhbCA9IHRyeV9vcGVuX2ZzKGN0eCwg
ZmxhZ3MsIGlvX3B0ciwgJmZzKTsNCiANCg==

--Boundary_(ID_jONVwzbR6wWG0YmE/nP8UA)--
