From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 2/5] ext4 : Update low level ext4 journal routines to specify
 gfp_mask for transaction allocation.
Date: Sun, 24 Apr 2011 17:13:18 -0700
Message-ID: <BANLkTinfvAXWwjtMnYRBL5JHLmYJGhS-aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163649a3ad474d4e04a1b3144c
Cc: Manish Katiyar <manish.katiyar@in.ibm.com>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:32863 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1DYANj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 20:13:39 -0400
Received: by qyk7 with SMTP id 7so506389qyk.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 17:13:38 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--00163649a3ad474d4e04a1b3144c
Content-Type: text/plain; charset=ISO-8859-1

Update low level ext4 journal routines to pass an extra parameter
to journal allocation routines to specify whether transaction allocation
can fail or not. With this patch ext4_journal_start() can fail due to
ENOMEM. Added a new interface ext4_journal_start_tryhard() which isn't
supposed to fail and keep retrying till the allocation succeeds.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/ext4_jbd2.h |    8 +++++++-
 fs/ext4/super.c     |   15 +++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d0f5353..ee6385c 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -162,6 +162,7 @@ int __ext4_handle_dirty_super(const char *where,
unsigned int line,
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))

 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
+handle_t *ext4_journal_start_sb_tryhard(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, unsigned int line,
handle_t *handle);

 #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
@@ -207,6 +208,11 @@ static inline handle_t *ext4_journal_start(struct
inode *inode, int nblocks)
 	return ext4_journal_start_sb(inode->i_sb, nblocks);
 }

+static inline handle_t *ext4_journal_start_tryhard(struct inode
*inode, int nblocks)
+{
+	return ext4_journal_start_sb_tryhard(inode->i_sb, nblocks);
+}
+
 #define ext4_journal_stop(handle) \
 	__ext4_journal_stop(__func__, __LINE__, (handle))

@@ -225,7 +231,7 @@ static inline int ext4_journal_extend(handle_t
*handle, int nblocks)
 static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_restart(handle, nblocks);
+		return jbd2_journal_restart(handle, nblocks, false);
 	return 0;
 }

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..03eac6a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -247,7 +247,8 @@ static void ext4_put_nojournal(handle_t *handle)
  * ext4 prevents a new handle from being started by s_frozen, which
  * is in an upper layer.
  */
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+static handle_t *__ext4_journal_start_sb(struct super_block *sb,
+					 int nblocks, bool errok)
 {
 	journal_t *journal;
 	handle_t  *handle;
@@ -279,7 +280,17 @@ handle_t *ext4_journal_start_sb(struct
super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks);
+	return jbd2_journal_start(journal, nblocks, errok);
+}
+
+handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+{
+	return __ext4_journal_start_sb(sb, nblocks, true);
+}
+
+handle_t *ext4_journal_start_sb_tryhard(struct super_block *sb, int nblocks)
+{
+	return __ext4_journal_start_sb(sb, nblocks, false);
 }

 /*
-- 
1.7.1

-- 
Thanks -
Manish

--00163649a3ad474d4e04a1b3144c
Content-Type: text/x-patch; charset=US-ASCII;
	name="0002-Update-low-level-ext4-journal-routines-to-pass-an-ex.patch"
Content-Disposition: attachment;
	filename="0002-Update-low-level-ext4-journal-routines-to-pass-an-ex.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmwnjtrf0

RnJvbSAzNjVkMjljZDhkNWIxMzllMzMyOTY1YTUzNmRkMzgwZTY1NmJiZDE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDI0IEFwciAyMDExIDE2OjQ5OjQ4IC0wNzAwClN1YmplY3Q6IFtQQVRDSCAyLzVd
IFVwZGF0ZSBsb3cgbGV2ZWwgZXh0NCBqb3VybmFsIHJvdXRpbmVzIHRvIHBhc3MgYW4gZXh0cmEg
cGFyYW10ZXIKIHRvIGpvdXJuYWwgYWxsb2NhdGlvbiByb3V0aW5lcyB0byBzcGVjaWZ5IHdoZXRo
ZXIgdHJhbnNhY3Rpb24gYWxsb2NhdGlvbgogY2FuIGZhaWwgb3Igbm90LiBXaXRoIHRoaXMgcGF0
Y2ggZXh0NF9qb3VybmFsX3N0YXJ0KCkgY2FuIGZhaWwgZHVlIHRvCiBFTk9NRU0uIEFkZGVkIGEg
bmV3IGludGVyZmFjZSBleHQ0X2pvdXJuYWxfc3RhcnRfdHJ5aGFyZCgpIHdoaWNoIGlzbid0CiBz
dXBwb3NlZCB0byBmYWlsIGFuZCBrZWVwIHJldHJ5aW5nIHRpbGwgdGhlIGFsbG9jYXRpb24gc3Vj
Y2VlZHMuCgoKU2lnbmVkLW9mZi1ieTogTWFuaXNoIEthdGl5YXIgPG1rYXRpeWFyQGdtYWlsLmNv
bT4KLS0tCiBmcy9leHQ0L2V4dDRfamJkMi5oIHwgICAgOCArKysrKysrLQogZnMvZXh0NC9zdXBl
ci5jICAgICB8ICAgMTUgKysrKysrKysrKysrKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDIwIGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9leHQ0X2piZDIu
aCBiL2ZzL2V4dDQvZXh0NF9qYmQyLmgKaW5kZXggZDBmNTM1My4uZWU2Mzg1YyAxMDA2NDQKLS0t
IGEvZnMvZXh0NC9leHQ0X2piZDIuaAorKysgYi9mcy9leHQ0L2V4dDRfamJkMi5oCkBAIC0xNjIs
NiArMTYyLDcgQEAgaW50IF9fZXh0NF9oYW5kbGVfZGlydHlfc3VwZXIoY29uc3QgY2hhciAqd2hl
cmUsIHVuc2lnbmVkIGludCBsaW5lLAogCV9fZXh0NF9oYW5kbGVfZGlydHlfc3VwZXIoX19mdW5j
X18sIF9fTElORV9fLCAoaGFuZGxlKSwgKHNiKSkKIAogaGFuZGxlX3QgKmV4dDRfam91cm5hbF9z
dGFydF9zYihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBpbnQgbmJsb2Nrcyk7CitoYW5kbGVfdCAq
ZXh0NF9qb3VybmFsX3N0YXJ0X3NiX3RyeWhhcmQoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgaW50
IG5ibG9ja3MpOwogaW50IF9fZXh0NF9qb3VybmFsX3N0b3AoY29uc3QgY2hhciAqd2hlcmUsIHVu
c2lnbmVkIGludCBsaW5lLCBoYW5kbGVfdCAqaGFuZGxlKTsKIAogI2RlZmluZSBFWFQ0X05PSk9V
Uk5BTF9NQVhfUkVGX0NPVU5UICgodW5zaWduZWQgbG9uZykgNDA5NikKQEAgLTIwNyw2ICsyMDgs
MTEgQEAgc3RhdGljIGlubGluZSBoYW5kbGVfdCAqZXh0NF9qb3VybmFsX3N0YXJ0KHN0cnVjdCBp
bm9kZSAqaW5vZGUsIGludCBuYmxvY2tzKQogCXJldHVybiBleHQ0X2pvdXJuYWxfc3RhcnRfc2Io
aW5vZGUtPmlfc2IsIG5ibG9ja3MpOwogfQogCitzdGF0aWMgaW5saW5lIGhhbmRsZV90ICpleHQ0
X2pvdXJuYWxfc3RhcnRfdHJ5aGFyZChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBpbnQgbmJsb2NrcykK
K3sKKwlyZXR1cm4gZXh0NF9qb3VybmFsX3N0YXJ0X3NiX3RyeWhhcmQoaW5vZGUtPmlfc2IsIG5i
bG9ja3MpOworfQorCiAjZGVmaW5lIGV4dDRfam91cm5hbF9zdG9wKGhhbmRsZSkgXAogCV9fZXh0
NF9qb3VybmFsX3N0b3AoX19mdW5jX18sIF9fTElORV9fLCAoaGFuZGxlKSkKIApAQCAtMjI1LDcg
KzIzMSw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGV4dDRfam91cm5hbF9leHRlbmQoaGFuZGxlX3Qg
KmhhbmRsZSwgaW50IG5ibG9ja3MpCiBzdGF0aWMgaW5saW5lIGludCBleHQ0X2pvdXJuYWxfcmVz
dGFydChoYW5kbGVfdCAqaGFuZGxlLCBpbnQgbmJsb2NrcykKIHsKIAlpZiAoZXh0NF9oYW5kbGVf
dmFsaWQoaGFuZGxlKSkKLQkJcmV0dXJuIGpiZDJfam91cm5hbF9yZXN0YXJ0KGhhbmRsZSwgbmJs
b2Nrcyk7CisJCXJldHVybiBqYmQyX2pvdXJuYWxfcmVzdGFydChoYW5kbGUsIG5ibG9ja3MsIGZh
bHNlKTsKIAlyZXR1cm4gMDsKIH0KIApkaWZmIC0tZ2l0IGEvZnMvZXh0NC9zdXBlci5jIGIvZnMv
ZXh0NC9zdXBlci5jCmluZGV4IDg1NTNkZmIuLjAzZWFjNmEgMTAwNjQ0Ci0tLSBhL2ZzL2V4dDQv
c3VwZXIuYworKysgYi9mcy9leHQ0L3N1cGVyLmMKQEAgLTI0Nyw3ICsyNDcsOCBAQCBzdGF0aWMg
dm9pZCBleHQ0X3B1dF9ub2pvdXJuYWwoaGFuZGxlX3QgKmhhbmRsZSkKICAqIGV4dDQgcHJldmVu
dHMgYSBuZXcgaGFuZGxlIGZyb20gYmVpbmcgc3RhcnRlZCBieSBzX2Zyb3plbiwgd2hpY2gKICAq
IGlzIGluIGFuIHVwcGVyIGxheWVyLgogICovCi1oYW5kbGVfdCAqZXh0NF9qb3VybmFsX3N0YXJ0
X3NiKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGludCBuYmxvY2tzKQorc3RhdGljIGhhbmRsZV90
ICpfX2V4dDRfam91cm5hbF9zdGFydF9zYihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAorCQkJCQkg
aW50IG5ibG9ja3MsIGJvb2wgZXJyb2spCiB7CiAJam91cm5hbF90ICpqb3VybmFsOwogCWhhbmRs
ZV90ICAqaGFuZGxlOwpAQCAtMjc5LDcgKzI4MCwxNyBAQCBoYW5kbGVfdCAqZXh0NF9qb3VybmFs
X3N0YXJ0X3NiKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGludCBuYmxvY2tzKQogCQlleHQ0X2Fi
b3J0KHNiLCAiRGV0ZWN0ZWQgYWJvcnRlZCBqb3VybmFsIik7CiAJCXJldHVybiBFUlJfUFRSKC1F
Uk9GUyk7CiAJfQotCXJldHVybiBqYmQyX2pvdXJuYWxfc3RhcnQoam91cm5hbCwgbmJsb2Nrcyk7
CisJcmV0dXJuIGpiZDJfam91cm5hbF9zdGFydChqb3VybmFsLCBuYmxvY2tzLCBlcnJvayk7Cit9
CisgCitoYW5kbGVfdCAqZXh0NF9qb3VybmFsX3N0YXJ0X3NiKHN0cnVjdCBzdXBlcl9ibG9jayAq
c2IsIGludCBuYmxvY2tzKQoreworCXJldHVybiBfX2V4dDRfam91cm5hbF9zdGFydF9zYihzYiwg
bmJsb2NrcywgdHJ1ZSk7Cit9CisKK2hhbmRsZV90ICpleHQ0X2pvdXJuYWxfc3RhcnRfc2JfdHJ5
aGFyZChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBpbnQgbmJsb2NrcykKK3sKKwlyZXR1cm4gX19l
eHQ0X2pvdXJuYWxfc3RhcnRfc2Ioc2IsIG5ibG9ja3MsIGZhbHNlKTsKIH0KIAogLyoKLS0gCjEu
Ny4xCgo=
--00163649a3ad474d4e04a1b3144c--
