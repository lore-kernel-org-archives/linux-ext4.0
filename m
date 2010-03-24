From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: [PATCH] ext4/super.c: Fix error in ext4_fill_super: ext3_fs_type
	undeclared (first use in this function)
Date: Wed, 24 Mar 2010 12:45:27 +0100
Message-ID: <2d0a357f1003240445y27e9e56ete60d0786f42ac486@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d64544740d6804828a773b
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:62010 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0CXLp3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 07:45:29 -0400
Received: by ewy8 with SMTP id 8so1139196ewy.28
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 04:45:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016e6d64544740d6804828a773b
Content-Type: text/plain; charset=UTF-8

Not sure if this is really fixing the problem in [1].

--
Sedat

[1] http://marc.info/?l=linux-ext4&m=126942870916446&w=2

--0016e6d64544740d6804828a773b
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-ext4-super.c-Fix-error-in-ext4_fill_super-ext3_fs_ty.patch"
Content-Disposition: attachment;
	filename="0001-ext4-super.c-Fix-error-in-ext4_fill_super-ext3_fs_ty.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g762i6xb0

RnJvbSA3MjJiM2FjNDZkZjc2OWU1ZTc1OWI2ZjgyNDk4MmQzNGUxNDAzN2I0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDI0IE1hciAyMDEwIDEyOjIyOjM0ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gZXh0
NC9zdXBlci5jOiBGaXggZXJyb3IgaW4gZXh0NF9maWxsX3N1cGVyOiBleHQzX2ZzX3R5cGUgdW5k
ZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pCgotLS0KIGZzL2V4dDQvc3VwZXIu
YyB8ICAgIDIgKysKIDEgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL2V4dDQvc3VwZXIuYyBiL2ZzL2V4dDQvc3VwZXIuYwppbmRl
eCAxZGJiMzdhLi4yZGFjYzgyIDEwMDY0NAotLS0gYS9mcy9leHQ0L3N1cGVyLmMKKysrIGIvZnMv
ZXh0NC9zdXBlci5jCkBAIC0yNTUwLDcgKzI1NTAsOSBAQCBzdGF0aWMgaW50IGV4dDRfZmlsbF9z
dXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCB2b2lkICpkYXRhLCBpbnQgc2lsZW50KQogCSAq
IGVuYWJsZSBkZWxheWVkIGFsbG9jYXRpb24gYnkgZGVmYXVsdAogCSAqIFVzZSAtbyBub2RlbGFs
bG9jIHRvIHR1cm4gaXQgb2ZmCiAJICovCisjaWYgIWRlZmluZWQoQ09ORklHX0VYVDNfRlMpICYm
ICFkZWZpbmVkKENPTkZJR19FWFQzX0ZTX01PRFVMRSkgJiYgZGVmaW5lZChDT05GSUdfRVhUNF9V
U0VfRk9SX0VYVDIzKQkKIAlpZiAoc2ItPnNfYmRldi0+YmRfaG9sZGVyICE9ICZleHQzX2ZzX3R5
cGUpCisjZW5kaWYKIAkJc2V0X29wdChzYmktPnNfbW91bnRfb3B0LCBERUxBTExPQyk7CiAKIAlp
ZiAoIXBhcnNlX29wdGlvbnMoKGNoYXIgKikgZGF0YSwgc2IsICZqb3VybmFsX2Rldm51bSwKLS0g
CjEuNy4wLjMKCg==
--0016e6d64544740d6804828a773b--
