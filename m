From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 3/5] ocfs2: Update ocfs2 routines to use the updated journal
 routines to specify gfp_mask for transaction allocation.
Date: Sun, 24 Apr 2011 17:15:35 -0700
Message-ID: <BANLkTi=H5zs9KnrUtXd=Q4uz3rTFGzfqhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364999f972708704a1b31c03
Cc: Manish Katiyar <manish.katiyar@in.ibm.com>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44414 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1DYAP4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 20:15:56 -0400
Received: by qyg14 with SMTP id 14so952253qyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 17:15:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016364999f972708704a1b31c03
Content-Type: text/plain; charset=ISO-8859-1

Update ocfs2 routines to use the updated journal routines passing an
extra parameter to specify whether transaction allocation can fail or
not.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ocfs2/journal.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index b141a44..51c60be 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -338,6 +338,16 @@ finally:
 	return status;
 }

+static handle_t *ocfs2_journal_start(journal_t *journal, int blocks)
+{
+	return jbd2_journal_start(journal, blocks, false);
+}
+
+static int ocfs2_journal_restart(handle_t *handle, int blocks)
+{
+	return jbd2_journal_restart(handle, blocks, false);
+}
+
 handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 {
 	journal_t *journal = osb->journal->j_journal;
@@ -353,11 +363,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super
*osb, int max_buffs)

 	/* Nested transaction? Just return the handle... */
 	if (journal_current_handle())
-		return jbd2_journal_start(journal, max_buffs);
+		return ocfs2_journal_start(journal, max_buffs);

 	down_read(&osb->journal->j_trans_barrier);

-	handle = jbd2_journal_start(journal, max_buffs);
+	handle = ocfs2_journal_start(journal, max_buffs);
 	if (IS_ERR(handle)) {
 		up_read(&osb->journal->j_trans_barrier);

@@ -437,7 +447,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)

 	if (status > 0) {
 		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
-		status = jbd2_journal_restart(handle,
+		status = ocfs2_journal_restart(handle,
 					      old_nblocks + nblocks);
 		if (status < 0) {
 			mlog_errno(status);
-- 
1.7.1


-- 
Thanks -
Manish

--0016364999f972708704a1b31c03
Content-Type: text/x-patch; charset=US-ASCII;
	name="0003-Update-ocfs-routines-to-use-the-updated-journal-rout.patch"
Content-Disposition: attachment;
	filename="0003-Update-ocfs-routines-to-use-the-updated-journal-rout.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmwno0k50

RnJvbSBiYjk1ODMwYjI3MGZjZTA0M2I1YjkwMWQ1M2QzOTExODllZTk2ODc4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDI0IEFwciAyMDExIDAwOjI3OjMxIC0wNzAwClN1YmplY3Q6IFtQQVRDSCAzLzVd
IFVwZGF0ZSBvY2ZzIHJvdXRpbmVzIHRvIHVzZSB0aGUgdXBkYXRlZCBqb3VybmFsIHJvdXRpbmVz
IHBhc3NpbmcgYW4gZXh0cmEgcGFyYW1ldGVyIHRvIHNwZWNpZnkgd2hldGhlciB0cmFuc2FjdGlv
biBhbGxvY2F0aW9uIGNhbiBmYWlsIG9yIG5vdC4KClNpZ25lZC1vZmYtYnk6IE1hbmlzaCBLYXRp
eWFyIDxta2F0aXlhckBnbWFpbC5jb20+Ci0tLQogZnMvb2NmczIvam91cm5hbC5jIHwgICAxNiAr
KysrKysrKysrKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvb2NmczIvam91cm5hbC5jIGIvZnMvb2NmczIvam91
cm5hbC5jCmluZGV4IGIxNDFhNDQuLjUxYzYwYmUgMTAwNjQ0Ci0tLSBhL2ZzL29jZnMyL2pvdXJu
YWwuYworKysgYi9mcy9vY2ZzMi9qb3VybmFsLmMKQEAgLTMzOCw2ICszMzgsMTYgQEAgZmluYWxs
eToKIAlyZXR1cm4gc3RhdHVzOwogfQogCitzdGF0aWMgaGFuZGxlX3QgKm9jZnMyX2pvdXJuYWxf
c3RhcnQoam91cm5hbF90ICpqb3VybmFsLCBpbnQgYmxvY2tzKQoreworCXJldHVybiBqYmQyX2pv
dXJuYWxfc3RhcnQoam91cm5hbCwgYmxvY2tzLCBmYWxzZSk7Cit9CisKK3N0YXRpYyBpbnQgb2Nm
czJfam91cm5hbF9yZXN0YXJ0KGhhbmRsZV90ICpoYW5kbGUsIGludCBibG9ja3MpCit7CisJcmV0
dXJuIGpiZDJfam91cm5hbF9yZXN0YXJ0KGhhbmRsZSwgYmxvY2tzLCBmYWxzZSk7Cit9CisKIGhh
bmRsZV90ICpvY2ZzMl9zdGFydF90cmFucyhzdHJ1Y3Qgb2NmczJfc3VwZXIgKm9zYiwgaW50IG1h
eF9idWZmcykKIHsKIAlqb3VybmFsX3QgKmpvdXJuYWwgPSBvc2ItPmpvdXJuYWwtPmpfam91cm5h
bDsKQEAgLTM1MywxMSArMzYzLDExIEBAIGhhbmRsZV90ICpvY2ZzMl9zdGFydF90cmFucyhzdHJ1
Y3Qgb2NmczJfc3VwZXIgKm9zYiwgaW50IG1heF9idWZmcykKIAogCS8qIE5lc3RlZCB0cmFuc2Fj
dGlvbj8gSnVzdCByZXR1cm4gdGhlIGhhbmRsZS4uLiAqLwogCWlmIChqb3VybmFsX2N1cnJlbnRf
aGFuZGxlKCkpCi0JCXJldHVybiBqYmQyX2pvdXJuYWxfc3RhcnQoam91cm5hbCwgbWF4X2J1ZmZz
KTsKKwkJcmV0dXJuIG9jZnMyX2pvdXJuYWxfc3RhcnQoam91cm5hbCwgbWF4X2J1ZmZzKTsKIAog
CWRvd25fcmVhZCgmb3NiLT5qb3VybmFsLT5qX3RyYW5zX2JhcnJpZXIpOwogCi0JaGFuZGxlID0g
amJkMl9qb3VybmFsX3N0YXJ0KGpvdXJuYWwsIG1heF9idWZmcyk7CisJaGFuZGxlID0gb2NmczJf
am91cm5hbF9zdGFydChqb3VybmFsLCBtYXhfYnVmZnMpOwogCWlmIChJU19FUlIoaGFuZGxlKSkg
ewogCQl1cF9yZWFkKCZvc2ItPmpvdXJuYWwtPmpfdHJhbnNfYmFycmllcik7CiAKQEAgLTQzNyw3
ICs0NDcsNyBAQCBpbnQgb2NmczJfZXh0ZW5kX3RyYW5zKGhhbmRsZV90ICpoYW5kbGUsIGludCBu
YmxvY2tzKQogCiAJaWYgKHN0YXR1cyA+IDApIHsKIAkJdHJhY2Vfb2NmczJfZXh0ZW5kX3RyYW5z
X3Jlc3RhcnQob2xkX25ibG9ja3MgKyBuYmxvY2tzKTsKLQkJc3RhdHVzID0gamJkMl9qb3VybmFs
X3Jlc3RhcnQoaGFuZGxlLAorCQlzdGF0dXMgPSBvY2ZzMl9qb3VybmFsX3Jlc3RhcnQoaGFuZGxl
LAogCQkJCQkgICAgICBvbGRfbmJsb2NrcyArIG5ibG9ja3MpOwogCQlpZiAoc3RhdHVzIDwgMCkg
ewogCQkJbWxvZ19lcnJubyhzdGF0dXMpOwotLSAKMS43LjEKCg==
--0016364999f972708704a1b31c03--
