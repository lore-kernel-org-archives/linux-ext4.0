From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: RHEL e2fsprogs-1.40.4-sb_feature_check_ignore.patch
Date: Fri, 18 Jul 2014 19:50:55 +0000
Message-ID: <CFEED6C0.B22C8%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_CFEED6C0B22C8andreasdilgerintelcom_"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41000 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761989AbaGRTvA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2014 15:51:00 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--_002_CFEED6C0B22C8andreasdilgerintelcom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F7DC786E8617543B354160CB2AA48F5@intel.com>
Content-Transfer-Encoding: quoted-printable

I was looking through the RHEL e2fsprogs.spec file and saw that you are
still
carrying the e2fsprogs-1.40.4-sb_feature_check_ignore.patch to avoid
problems
if the kernel sets xattrs on a new filesystem and doesn't copy this into
the
backup superblock.

It seems that mke2fs enables the xattr feature in the superblock by default
for all filesystems (courtesy of misc/default_profile.c), and e2fsck
doesn't
drop COMPAT_EXT_XATTR even if the filesystem doesn't have xattrs, so most
of
the danger of not having this patch are behind us.

That said, it probably still makes sense to include this patch into the
upstream e2fsprogs, unless there is some reason not to?  It looks pretty
low risk.

Cheers, Andreas
--=20
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division



--_002_CFEED6C0B22C8andreasdilgerintelcom_
Content-Type: application/octet-stream;
	name="e2fsprogs-1.40.4-sb_feature_check_ignore.patch"
Content-Description: e2fsprogs-1.40.4-sb_feature_check_ignore.patch
Content-Disposition: attachment;
	filename="e2fsprogs-1.40.4-sb_feature_check_ignore.patch"; size=1196;
	creation-date="Fri, 18 Jul 2014 19:50:55 GMT";
	modification-date="Fri, 18 Jul 2014 19:50:55 GMT"
Content-ID: <CBE7AB0EA3CBCD418FCD40F9CB4AF31B@intel.com>
Content-Transfer-Encoding: base64

SW5kZXg6IGUyZnNwcm9ncy0xLjQxLjUvZTJmc2NrL3N1cGVyLmMKPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gZTJm
c3Byb2dzLTEuNDEuNS5vcmlnL2UyZnNjay9zdXBlci5jCisrKyBlMmZzcHJvZ3MtMS40MS41L2Uy
ZnNjay9zdXBlci5jCkBAIC04NjksNyArODY5LDExIEBAIHZvaWQgY2hlY2tfc3VwZXJfYmxvY2so
ZTJmc2NrX3QgY3R4KQogICogdW5mb3J0dW5hdGVseSwgd2Ugc2hvdWxkbid0IGlnbm9yZSBpdCBz
aW5jZSBpZiBpdCdzIG5vdCBzZXQgaW4gdGhlCiAgKiBiYWNrdXAsIHRoZSBleHRlbmRlZCBhdHRy
aWJ1dGVzIGluIHRoZSBmaWxlc3lzdGVtIHdpbGwgYmUgc3RyaXBwZWQKICAqIGF3YXkuCisgKgor
ICogV2VsbCwgSSdtIHN0aWxsIGdvaW5nIHRoYXQgcm91dGUgZm9yIG5vdywgJ3RpbCBJIGRvIHNv
bWV0aGluZworICogYmV0dGVyLiAgRnVsbC1mc2NrIGFmdGVyIGEgZnJlc2ggaW5zdGFsbCBpcyBq
dXN0IG5vIGdvb2QuICAtRVJTCiAgKi8KKyNkZWZpbmUgRkVBVFVSRV9DT01QQVRfSUdOT1JFCQko
RVhUMl9GRUFUVVJFX0NPTVBBVF9FWFRfQVRUUikKICNkZWZpbmUgRkVBVFVSRV9ST19DT01QQVRf
SUdOT1JFCShFWFQyX0ZFQVRVUkVfUk9fQ09NUEFUX0xBUkdFX0ZJTEV8IFwKIAkJCQkJIEVYVDRf
RkVBVFVSRV9ST19DT01QQVRfRElSX05MSU5LKQogI2RlZmluZSBGRUFUVVJFX0lOQ09NUEFUX0lH
Tk9SRQooRVhUM19GRUFUVVJFX0lOQ09NUEFUX0VYVEVOVFN8IFwKQEAgLTkyMSw2ICs5MjUsOSBA
QCBpbnQgY2hlY2tfYmFja3VwX3N1cGVyX2Jsb2NrKGUyZnNja190IGN0CiAJCQkoRVhUMl9JTk9E
RV9TSVpFKGJhY2t1cF9zYikgPCBFWFQyX0dPT0RfT0xEX0lOT0RFX1NJWkUpKQogCQkJY29udGlu
dWU7CiAKKyNkZWZpbmUgU1VQRVJfQ09NUEFUX0RJRkZFUkVOVCh4KSAgICAgIFwKKwkoKGZzLT5z
dXBlci0+eCAmIH5GRUFUVVJFX0NPTVBBVF9JR05PUkUpICE9ICAgICBcCisJIChiYWNrdXBfc2It
PnggJiB+RkVBVFVSRV9DT01QQVRfSUdOT1JFKSkKICNkZWZpbmUgU1VQRVJfSU5DT01QQVRfRElG
RkVSRU5UKHgpICAgIFwKIAkoKGZzLT5zdXBlci0+eCAmIH5GRUFUVVJFX0lOQ09NUEFUX0lHTk9S
RSkgIT0gICBcCiAJIChiYWNrdXBfc2ItPnggJiB+RkVBVFVSRV9JTkNPTVBBVF9JR05PUkUpKQo=

--_002_CFEED6C0B22C8andreasdilgerintelcom_--
