From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [BUG] ext3/ext4 migration problem with dir_nlink feature flag
Date: Fri, 21 Jan 2011 16:34:24 +0900
Message-ID: <4D393700.4060804@rs.jp.nec.com>
References: <4CABE2A5.3000103@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050408040101010601040608"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44334 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1AUHeq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 02:34:46 -0500
In-Reply-To: <4CABE2A5.3000103@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050408040101010601040608
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

Unfortunately, this bug still exists in 2.6.38-rc1 with e2fsprogs-1.41.13.
Attached test program can reproduce this bug easily.
Please have a look and try.

Regards,
Akira Fujita

(2010/10/06 11:44), Akira Fujita wrote:
> Hi,
> 
> I found a bug which returns EIO by file access on ext3 (was ext4) whose
> dir_nlink feature flag is removed and has more than 64000 directories.
> Kernel: 2.6.36-rc6, e2fsprogs: 1.41.2
> Steps to reproduce are as follows:
> 
> 1. Create ext4 which does not have extent and flex_bg feature flags
> (Because this fs will be mounted as ext3 in step 3),
> then create more than 64000 directories.
> Therefore dir_nlink feature flag is set and link count becomes 1.
> 2. Remove dir_nlink feature flag with tune2fs command
> (e.g. tune2fs -O ^dir_nlink /dev/sdx).
> 3. Mount ext4 as ext3, then remove subdir (Link: 1->0).
> We cannot access parent directory, because link count goes wrong.
> 
> We should disallow tune2fs command to remove dir_nlink feature flag.
> 
> Regards,
> Akira Fujita
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 


--------------050408040101010601040608
Content-Type: application/x-shellscript;
 name="dir_nlink.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dir_nlink.sh"

IyEvYmluL2Jhc2gKCkRFVj0iIgkjZGV2aWNlIGZvciB0ZXN0Ck1QPSIiCSNtb3VudCBwb2lu
dApESVJOVU09NjUwMDAgICAgI2RyZWN0b3J5IGNvdW50IHdlIGNyZWF0ZQoKIyBBdCBsZWFz
dCwgbW9yZSB0aGFuIDY1MDAwIGlub2RlcyBhcmUgbmVlZGVkIHRvIGVuYWJsZSBkaXJfbmxp
ayBmZWF0dXJlIGZsYWcuCiMgU28sIHNwZWNpZnkgaW5vZGUgY291bnQgYnkgbWtmcywgaW4g
Y2FzZSB5b3UgdXNlIHNtYWxsIGRpc2sgZm9yIHRoaXMgdGVzdC4KbWtmcyAtdCBleHQzIC1O
IDcwMDAwICR7REVWfQptb3VudCAtdCBleHQ0ICR7REVWfSAke01QfQppPTAKd2hpbGUgWyAk
aSAtbGUgJHtESVJOVU19IF07IGRvCglta2RpciAtcCAke01QfS9ESVIvZGlyJHtpfQoJaWYg
WyAkPyAtbmUgMCBdO3RoZW4KCQllY2hvICJDYW4ndCBjcmVhdGUgZGlyJGkiCgkJZXhpdCAx
CglmaQoJaT1gZXhwciAke2l9ICsgMWAKZG9uZQojIGRpcl9ubGluayBmbGFnIG11c3QgYmUg
c2V0Ck5VTT1gZGVidWdmcyAtUiBzdGF0cyAke0RFVn0gfCBncmVwICJkaXJfbmxpbmsiIHwg
d2MgLWxgClsgJHtOVU19ID09ICIxIiBdIHx8IGV4aXQgMQoKc3luYwp1bW91bnQgJHtERVZ9
CmlmIFsgJD8gLW5lIDAgXTt0aGVuCgllY2hvICJzbGVlcCAxMCBzZWMiCglzbGVlcCAxMAoJ
dW1vdW50ICR7REVWfSB8fCBleGl0IDEKZmkKCiMgT25jZSBkaXIgY291bnQgYmVjb21lcyAx
ICg2NTAwMCspLCBkaXJfbmxpbmsgc2hvdWxkIG5vdCBiZSByZW1vdmVkLgojIEJ1dCB3ZSBj
YW4gZG8gaXQgd2l0aCBlMmZzcHJvZ3MuCnR1bmUyZnMgLU8gXmRpcl9ubGluayAke0RFVn0K
Cm1vdW50IC10IGV4dDMgJHtERVZ9ICR7TVB9Ck5VTT1gZGVidWdmcyAtUiBzdGF0cyAke0RF
Vn0gfCBncmVwICJkaXJfbmxpbmsiIHwgd2MgLWxgClsgJHtOVU19ICE9ICIxIiBdIHx8IGV4
aXQgMQoKZWNobyAiKiBMaW5rIGNvdW50IGlzIDEiCnN0YXQgJHtNUH0vRElSIHwgZ3JlcCAi
TGlua3M6IgpybWRpciAke01QfS9ESVIvZGlyMSAKZWNobyAiKiBMaW5rIGNvdW50IGJlY29t
ZXMgMCwgYWZ0ZXIgcmVtb3Zpbmcgb25lIGRpcmVjdG9yeSIKc3RhdCAke01QfS9ESVIgfCBn
cmVwICJMaW5rczoiCgoKbWtkaXIgJHtNUH0vRElSL2Rpci10ZXN0IHx8IGVjaG8gIiogQ2Fu
J3QgY3JlYXRlIGRpciwgc2luY2UgZGlyX25saWsgaXMgMCIKCnVtb3VudCAke0RFVn0KCiMg
ZnNjayBkZXRlY3RzIGVycm9yLiBCZWNhdXNlIHBhcmVudCBkaXJlY3RvcnkgY291bnQgaXMg
MAojIHRob3VnaCB0aGVyZSBhcmUgbWFueSBjaGlsZCBkaXJlY3RvcmllcyBpbiB0aGVyZS4K
ZnNjayAtZiAgJHtERVZ9Cgo=
--------------050408040101010601040608--
