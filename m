From: <paul.chavent@fnac.net>
Subject: Re: What represent 646345728 bytes
Date: Mon,  1 Feb 2010 18:06:55 +0100 (CET)
Message-ID: <20027776.19701265044015458.JavaMail.www@wsfrf1112>
Reply-To: <paul.chavent@fnac.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_935_24391891.1265044015456"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtaweb11.services.sfr.fr ([93.17.128.28]:63149 "EHLO
	smtp11.services.sfr.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751054Ab0BARG5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 12:06:57 -0500
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf1102.sfr.fr (SMTP Server) with ESMTP id 7E72370000A1
	for <linux-ext4@vger.kernel.org>; Mon,  1 Feb 2010 18:06:55 +0100 (CET)
Received: from wsfrf1112 (wsfrf1112 [10.18.24.26])
	by msfrf1102.sfr.fr (SMTP Server) with ESMTP id 719277000082
	for <linux-ext4@vger.kernel.org>; Mon,  1 Feb 2010 18:06:55 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

------=_Part_935_24391891.1265044015456
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Thank you Eric for your reply.

My problem with preallocation is that i don't know the size of my final tar archive. So i would prefer to don't make any supposition.

Yes, i write a stream of 640x480x1 pnm images (307215 bytes each) to a single tar file.
So lets say that each write is 307712 (divisible by 512 bytes for tar).

Here is a test bench program that reproduce the behaviour of the real app.

The program log some write overhead at 645579776bytes and other at 645887488bytes, so not exactly the same thing as in the real app.

You will be able to tell me if my test bench is correct (metric, compilation options, etc.).

The system on which i run the test bench has no other workload, no other disk access.

Please find the attached files : 
- test bench source 
- the dumpe2fs log

Tonight, i will try with the "-O ^uninit_bg at mkfs time".

Thanks.

Paul.



------=_Part_935_24391891.1265044015456
Content-Type: text/plain; name=dumpe2fs.txt
content-transfer-encoding: quoted-printable
Content-Disposition: attachment; size=1889; filename=dumpe2fs.txt

dumpe2fs 1.41.9 (22-Aug-2009)
Filesystem volume name:   DATA
Last mounted on:          /var/data
Filesystem UUID:          7b19bf38-cf32-11de-a163-0060c2140392
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      ext_attr resize_inode dir_index filetype extent f=
lex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         not clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              3670016
Block count:              14653288
Reserved block count:     732664
Free blocks:              11828118
Free inodes:              3669685
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1020
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Thu Nov 12 02:24:18 2009
Last mount time:          Thu Nov 12 02:26:17 2009
Last write time:          Thu Nov 12 06:05:46 2009
Mount count:              1
Maximum mount count:      30
Last checked:             Thu Nov 12 02:24:18 2009
Check interval:           15552000 (6 months)
Next check after:         Tue May 11 02:24:18 2010
Lifetime writes:          11 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Default directory hash:   half_md4
Directory Hash Seed:      7b19c00a-cf32-11de-a163-0060c2140392

------=_Part_935_24391891.1265044015456
Content-Type: application/octet-stream; name=main.c
content-transfer-encoding: base64
Content-Disposition: attachment; size=5604; filename=main.c

LyogZ2NjIC1XYWxsIC1EX0ZJTEVfT0ZGU0VUX0JJVFM9NjQgLURfR05VX1NPVVJDRSAtbyBtYWlu
IG1haW4uYyAtbHJ0ICovCgovKiBvcGVuICovCiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1
ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDxmY250bC5oPgoKLyogd3JpdGUsY2xvc2UscGF0aGNv
bmYgKi8KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKLyogcG9zaXhfbWVtYWxpZ24gKi8KI2luY2x1ZGUg
PHN0ZGxpYi5oPgoKLyogcGVycm9yICovCiNpbmNsdWRlIDxzdGRpby5oPgoKLyogc2lnbmFsICov
CiNpbmNsdWRlIDxzaWduYWwuaD4KCi8qIGNsb2NrXyogKi8KI2luY2x1ZGUgPHRpbWUuaD4KCi8q
IGlvYiAqLwojaW5jbHVkZSA8c3lzL2lvLmg+CgojZGVmaW5lIFBQX0RBVEEgMHgzNzgKCnN0YXRp
YyB2b2xhdGlsZSBpbnQgZmxhZyA9IDE7Cgp2b2lkIHNpZ19oYW5kbGVyKGludCBzaWdfbnVtKQp7
CiAgZmxhZyA9IDA7Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKewogIC8qCiAg
ICogSSBzdHJlYW0gNjQweDQ4MHgxIHBubSBpbWFnZXMgKDMwNzIxNSBieXRlcyBlYWNoKSB0byBh
IHRhciBmaWxlLgogICAqIFRoZSB3cml0ZSBidWZmZXIgaXMgbXVsdGlwbGUgb2YgNTEyLgogICAq
IFNvIDMwNzcxMiBieXRlcy4KICAgKi8KICBjb25zdCBpbnQgYnVmZmVyX3NpemUgPSAzMDc3MTI7
CiAgLyoKICAgKiBBbGlnbmVtZW50IGZvciBkaXJlY3QgaW8KICAgKi8KICBpbnQgYnVmZmVyX2Fs
aWdubWVudDsKICAvKgogICAqIFRoZSBidWZmZXIgd2lsbCBiZSBhbGxvY2F0ZWQgZHluYW1pY2Fs
eSBmb3IgYWxpZ25lbWVudAogICAqLwogIHZvaWQgKmJ1ZmZlcjsKCiAgaW50IGZkOwoKICAvKgog
ICAqIE1vbml0b3JpbmcgdmFyaWFibGUKICAgKi8KICB1bnNpZ25lZCBsb25nIGxvbmcgc2FtcGxl
ID0gMDsKICBzdHJ1Y3QgdGltZXNwZWMgc3RhcnRfdGltZTsKICBzdHJ1Y3QgdGltZXNwZWMgc3Rv
cF90aW1lOwogIHVuc2lnbmVkIGxvbmcgbG9uZyBkaWZmX2N1cjsKICB1bnNpZ25lZCBsb25nIGxv
bmcgZGlmZl9taW47CiAgdW5zaWduZWQgbG9uZyBsb25nIGRpZmZfbWF4OwogIHVuc2lnbmVkIGxv
bmcgbG9uZyBkaWZmX21veTsKICBzdHJ1Y3QgdGltZXNwZWMgdHM7CiAgdW5zaWduZWQgbG9uZyBs
b25nIHBlcmlvZF9ucyA9IDEwMDAwMDAwMDsKCiAgLyogaGFuZGxlIGN0cmwtYyAqLwogIHN0cnVj
dCBzaWdhY3Rpb24gc2lnYWN0OwogIHNpZ2FjdC5zYV9oYW5kbGVyPSBzaWdfaGFuZGxlcjsKICBz
aWdhY3Quc2FfZmxhZ3MgPSBTQV9SRVNFVEhBTkQ7CiAgc2lnYWN0aW9uKFNJR0lOVCwgJnNpZ2Fj
dCwgTlVMTCk7CgogIC8qIG9wZW4gKi8KICBmZCA9IG9wZW4oInRlc3QubG9nIiwgT19XUk9OTFkg
fCBPX0NSRUFUIHwgT19UUlVOQyB8IE9fU1lOQyB8IE9fRElSRUNULCAwNjQ0KTsKICBpZihmZCA8
IDApCiAgICB7CiAgICAgIHBlcnJvcigib3BlbiIpOwogICAgICByZXR1cm4gRVhJVF9GQUlMVVJF
OwogICAgfQogCiAgLyogY29tcHV0ZSBhbGlnbmVtZW50IGNvbnN0cmFpbnRzIGZvciBkaXJlY3Qg
aW8gKi8KICBidWZmZXJfYWxpZ25tZW50ID0gcGF0aGNvbmYoInRlc3QubG9nIiwgX1BDX1JFQ19Y
RkVSX0FMSUdOKTsKICBpZihidWZmZXJfYWxpZ25tZW50IDwgMCkKICAgIHsKICAgICAgcGVycm9y
KCJwYXRoY29uZiIpOwogICAgICByZXR1cm4gRVhJVF9GQUlMVVJFOwogICAgfQoKICAvKiBhbGxv
YyBhbGlnbmVkIGJ1ZmZlciAqLwogIGlmKHBvc2l4X21lbWFsaWduKCh2b2lkICoqKSZidWZmZXIs
IGJ1ZmZlcl9hbGlnbm1lbnQsIGJ1ZmZlcl9zaXplKSkKICAgIHsKICAgICAgcGVycm9yKCJwb3Np
eF9tZW1hbGlnbiIpOwogICAgICByZXR1cm4gRVhJVF9GQUlMVVJFOwogICAgfQogICAgIAogIC8q
IGZvciBwcCBtb25pdG9yaW5nICovCiAgaW9wZXJtKFBQX0RBVEEsIDEsIDEpOwoKICBjbG9ja19n
ZXR0aW1lKENMT0NLX01PTk9UT05JQywgJnRzKTsKCiAgd2hpbGUoZmxhZykKICAgIHsKICAgICAg
aW50IG5iX3dyaXRlOwoKICAgICAgY2xvY2tfZ2V0dGltZShDTE9DS19NT05PVE9OSUMsICZzdGFy
dF90aW1lKTsKCiAgICAgIG91dGIoKGluYihQUF9EQVRBKSB8ICgweDAwMDEpKSwgUFBfREFUQSk7
CgogICAgICBuYl93cml0ZSA9IHdyaXRlKGZkLCBidWZmZXIsIGJ1ZmZlcl9zaXplKTsKIAogICAg
ICBvdXRiKChpbmIoUFBfREFUQSkgJiB+KDB4MDAwMSkpLCBQUF9EQVRBKTsKIAogICAgICBjbG9j
a19nZXR0aW1lKENMT0NLX01PTk9UT05JQywgJnN0b3BfdGltZSk7CgogICAgICAvKiBlcnJvciBo
YW5kbGluZyAqLwogICAgICBpZihuYl93cml0ZSAhPSBidWZmZXJfc2l6ZSkKICAgICAgICB7CiAg
ICAgICAgICBwZXJyb3IoIndyaXRlIik7CiAgICAgICAgICByZXR1cm4gRVhJVF9GQUlMVVJFOwog
ICAgICAgIH0KCiAgICAgIC8qIGNvbXB1dGUgc3RhdHMgKi8KICAgICAgaWYoc3RvcF90aW1lLnR2
X25zZWMgPCBzdGFydF90aW1lLnR2X25zZWMpCiAgICAgICAgewogICAgICAgICAgc3RvcF90aW1l
LnR2X3NlYy0tOwogICAgICAgICAgc3RvcF90aW1lLnR2X25zZWMrPTEwMDAwMDAwMDA7CiAgICAg
ICAgfSAKICAgIAogICAgICBkaWZmX2N1ciA9IChzdG9wX3RpbWUudHZfc2VjIC0gc3RhcnRfdGlt
ZS50dl9zZWMpICogMTAwMDAwMDAwMFVMTCArIChzdG9wX3RpbWUudHZfbnNlYyAtIHN0YXJ0X3Rp
bWUudHZfbnNlYyk7CgogICAgICBpZihzYW1wbGUgPT0gMCkKICAgICAgICB7CiAgICAgICAgICBk
aWZmX21pbiA9IGRpZmZfY3VyOwogICAgICAgICAgZGlmZl9tYXggPSBkaWZmX2N1cjsKICAgICAg
ICAgIGRpZmZfbW95ID0gZGlmZl9jdXI7CiAgICAgICAgfQogICAgICBlbHNlCiAgICAgICAgewog
ICAgICAgICAgaWYoZGlmZl9jdXIgPCBkaWZmX21pbikKICAgICAgICAgICAgewogICAgICAgICAg
ICAgIGRpZmZfbWluID0gZGlmZl9jdXI7CiAgICAgICAgICAgIH0KICAgICAgICAgIGlmKGRpZmZf
bWF4IDwgZGlmZl9jdXIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICBkaWZmX21heCA9IGRp
ZmZfY3VyOwogICAgICAgICAgICB9CiAgICAgICAgICBpZihkaWZmX2N1ciA8IGRpZmZfbW95KQog
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgZGlmZl9tb3kgPSBkaWZmX21veSAtIChkaWZmX21v
eSAtIGRpZmZfY3VyKSAvIHNhbXBsZTsKICAgICAgICAgICAgfQogICAgICAgICAgZWxzZQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgZGlmZl9tb3kgPSBkaWZmX21veSArIChkaWZmX2N1ciAt
IGRpZmZfbW95KSAvIHNhbXBsZTsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgc2FtcGxl
Kys7CgogICAgICAvKiBwcmludCBzdXNwZWN0IHdyaXRlICovCiAgICAgIGlmKDIwMDAwMDAwIDwg
ZGlmZl9jdXIpCiAgICAgICAgewogICAgICAgICAgc3RydWN0IHN0YXQgYnVmOwogICAgICAgICAg
ZnN0YXQoZmQsICZidWYpOwogICAgICAgICAgZnByaW50ZihzdGRlcnIsICIlbGx1ICVsbHVcbiIs
IGJ1Zi5zdF9zaXplLCBkaWZmX2N1cik7CiAgICAgICAgfQoKICAgICAgLyogc2xlZXAgKi8KICAg
ICAgdHMudHZfbnNlYyArPSBwZXJpb2RfbnM7CiAgICAgIHdoaWxlKHRzLnR2X25zZWMgPj0gMTAw
MDAwMDAwMCkKICAgICAgICB7CiAgICAgICAgICB0cy50dl9uc2VjIC09IDEwMDAwMDAwMDA7CiAg
ICAgICAgICB0cy50dl9zZWMrKzsKICAgICAgICB9CgogICAgICBjbG9ja19uYW5vc2xlZXAoQ0xP
Q0tfTU9OT1RPTklDLCBUSU1FUl9BQlNUSU1FLCAmdHMsIE5VTEwpOwogICAgfQoKICBjbG9zZShm
ZCk7CgogIGZwcmludGYoc3RkZXJyLCAiZGlmZiBtaW4gOiAlbGx1XG4iLCBkaWZmX21pbik7CiAg
ZnByaW50ZihzdGRlcnIsICJkaWZmIG1veSA6ICVsbHVcbiIsIGRpZmZfbW95KTsKICBmcHJpbnRm
KHN0ZGVyciwgImRpZmYgbWF4IDogJWxsdVxuIiwgZGlmZl9tYXgpOwogIGZwcmludGYoc3RkZXJy
LCAiJWxsdSBpdGVyYXRpb25zXG4iLCBzYW1wbGUpOwoKICByZXR1cm4gRVhJVF9TVUNDRVNTOwp9
Cg==
------=_Part_935_24391891.1265044015456--


