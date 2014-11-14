From: Steve French <smfrench@gmail.com>
Subject: Re: xfstests and ext4
Date: Thu, 13 Nov 2014 17:20:34 -0800
Message-ID: <CAH2r5mvi2LijxWia2sCf+em7rfPtBn_fg6WKU=aftVUTuzXMgw@mail.gmail.com>
References: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
 <20141114000216.GN28565@dastard>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1135ef1eb8298a0507c77045
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:62845 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935085AbaKNBUz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2014 20:20:55 -0500
In-Reply-To: <20141114000216.GN28565@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001a1135ef1eb8298a0507c77045
Content-Type: text/plain; charset=UTF-8

On Thu, Nov 13, 2014 at 6:02 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Nov 13, 2014 at 05:38:53PM -0600, Steve French wrote:
>> To get xfstests to build on Ubuntu 14.10 and run (after adding various
>> packages I could get all but 11 of the tests to build and run) I had
>> to install the following packages:
>>
>> sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs automake
>> libuuid1 libuuidm-ocaml-dev attr libattr1-dev libacl1-dev libaio-dev
>> xfsprogs libgdbm-dev gawk fio dbench
>
> Documentation patch for the README file?
>
> Cheers,
>
> Dave.

Patch attached



[PATCH] common: update README to list build dependencies

Add sample list of packages (dependencies) required to build XFSTESTS
and add a step to the instructions to mention creating the test
user needed for some of the ACL tests.

Signed-off-by: Steve French <smfrench@gmail.com>
---
 README            | 6 ++++++


diff --git a/README b/README
index 8a362bd..8db7efe 100644
--- a/README
+++ b/README
@@ -4,8 +4,14 @@ _______________________

 Building Linux:
     - cd into the xfstests directory
+    - install prerequisite packages
+      For example, for Ubuntu:
+        "sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs
+         automake gcc libuuid1 libuuidm-ocaml-dev attr libattr1-dev
+         libacl1-dev libaio-dev xfsprogs libgdbm-dev gawk fio dbench"
     - run make
     - run make install
+    - create fsgqa test user ("sudo useradd fsgqa")

 Building IRIX:
     - cd into the xfstests directory


-- 
Thanks,

Steve

On Thu, Nov 13, 2014 at 4:02 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Nov 13, 2014 at 05:38:53PM -0600, Steve French wrote:
>> To get xfstests to build on Ubuntu 14.10 and run (after adding various
>> packages I could get all but 11 of the tests to build and run) I had
>> to install the following packages:
>>
>> sudo apt-get install xfslibs-dev uuid-dev libtool e2fsprogs automake
>> libuuid1 libuuidm-ocaml-dev attr libattr1-dev libacl1-dev libaio-dev
>> xfsprogs libgdbm-dev gawk fio dbench
>
> Documentation patch for the README file?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Thanks,

Steve

--001a1135ef1eb8298a0507c77045
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-common-update-README-to-list-build-dependencies.patch"
Content-Disposition: attachment;
	filename="0001-common-update-README-to-list-build-dependencies.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2guyoso0

RnJvbSAxODIyZTczMzY4NGYwMzFiMTMzOTI3ODJlMmE3ZWVmMWFiMTAyZDE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogVGh1LCAxMyBOb3YgMjAxNCAxNzowNzoyNyAtMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGNvbW1v
bjogdXBkYXRlIFJFQURNRSB0byBsaXN0IGJ1aWxkIGRlcGVuZGVuY2llcwoKQWRkIHNhbXBsZSBs
aXN0IG9mIHBhY2thZ2VzIChkZXBlbmRlbmNpZXMpIHJlcXVpcmVkIHRvIGJ1aWxkIFhGU1RFU1RT
CmFuZCBhZGQgYSBzdGVwIHRvIHRoZSBpbnN0cnVjdGlvbnMgdG8gbWVudGlvbiBjcmVhdGluZyB0
aGUgdGVzdAp1c2VyIG5lZWRlZCBmb3Igc29tZSBvZiB0aGUgQUNMIHRlc3RzLgoKU2lnbmVkLW9m
Zi1ieTogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+Ci0tLQogUkVBRE1FIHwgNiAr
KysrKysKIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9SRUFE
TUUgYi9SRUFETUUKaW5kZXggOGEzNjJiZC4uOGRiN2VmZSAxMDA2NDQKLS0tIGEvUkVBRE1FCisr
KyBiL1JFQURNRQpAQCAtNCw4ICs0LDE0IEBAIF9fX19fX19fX19fX19fX19fX19fX19fCiAKIEJ1
aWxkaW5nIExpbnV4OgogCS0gY2QgaW50byB0aGUgeGZzdGVzdHMgZGlyZWN0b3J5CisJLSBpbnN0
YWxsIHByZXJlcXVpc2l0ZSBwYWNrYWdlcworCSAgRm9yIGV4YW1wbGUsIGZvciBVYnVudHU6CisJ
CSJzdWRvIGFwdC1nZXQgaW5zdGFsbCB4ZnNsaWJzLWRldiB1dWlkLWRldiBsaWJ0b29sIGUyZnNw
cm9ncworCQkgYXV0b21ha2UgZ2NjIGxpYnV1aWQxIGxpYnV1aWRtLW9jYW1sLWRldiBhdHRyIGxp
YmF0dHIxLWRldgorCQkgbGliYWNsMS1kZXYgbGliYWlvLWRldiB4ZnNwcm9ncyBsaWJnZGJtLWRl
diBnYXdrIGZpbyBkYmVuY2giCiAJLSBydW4gbWFrZQogCS0gcnVuIG1ha2UgaW5zdGFsbAorCS0g
Y3JlYXRlIGZzZ3FhIHRlc3QgdXNlciAoInN1ZG8gdXNlcmFkZCBmc2dxYSIpCiAJCiBCdWlsZGlu
ZyBJUklYOgogCS0gY2QgaW50byB0aGUgeGZzdGVzdHMgZGlyZWN0b3J5IAotLSAKMi4xLjAKCg==
--001a1135ef1eb8298a0507c77045--
