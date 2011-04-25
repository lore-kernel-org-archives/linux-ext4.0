From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 1/5] jbd2: Pass extra bool parameter in journal routines to
 specify if its ok to fail the journal transaction allocation.
Date: Sun, 24 Apr 2011 17:10:41 -0700
Message-ID: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636833ec4ea6d0e04a1b30a06
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43162 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab1DYALC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 20:11:02 -0400
Received: by qyk7 with SMTP id 7so505969qyk.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 17:11:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001636833ec4ea6d0e04a1b30a06
Content-Type: text/plain; charset=ISO-8859-1

Pass extra bool parameter in journal routines to specify if its ok to
fail the journal transaction allocation. If 'true' is passed
transaction allocation is done through GFP_KERNEL  and ENOMEM is
returned else GFP_NOFS is used.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/jbd2/transaction.c |   12 +++++++-----
 include/linux/jbd2.h  |    4 ++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..b02d6a4 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -349,9 +349,10 @@ handle_t *jbd2__journal_start(journal_t *journal,
int nblocks, int gfp_mask)
 EXPORT_SYMBOL(jbd2__journal_start);


-handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
+handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool errok)
 {
-	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
+	return jbd2__journal_start(journal, nblocks,
+				   errok ? GFP_KERNEL : GFP_NOFS);
 }
 EXPORT_SYMBOL(jbd2_journal_start);

@@ -483,9 +484,10 @@ int jbd2__journal_restart(handle_t *handle, int
nblocks, int gfp_mask)
 EXPORT_SYMBOL(jbd2__journal_restart);


-int jbd2_journal_restart(handle_t *handle, int nblocks)
+int jbd2_journal_restart(handle_t *handle, int nblocks, bool errok)
 {
-	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
+	return jbd2__journal_restart(handle, nblocks,
+				     errok ? GFP_KERNEL : GFP_NOFS);
 }
 EXPORT_SYMBOL(jbd2_journal_restart);

@@ -1436,7 +1438,7 @@ int jbd2_journal_force_commit(journal_t *journal)
 	handle_t *handle;
 	int ret;

-	handle = jbd2_journal_start(journal, 1);
+	handle = jbd2_journal_start(journal, 1, false);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 	} else {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a32dcae..a64aced 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1103,9 +1103,9 @@ static inline handle_t *journal_current_handle(void)
  * Register buffer modifications against the current transaction.
  */

-extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
+extern handle_t *jbd2_journal_start(journal_t *, int nblocks, bool errok);
 extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
-extern int	 jbd2_journal_restart(handle_t *, int nblocks);
+extern int	 jbd2_journal_restart(handle_t *, int nblocks, bool errok);
 extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
 extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
-- 
1.7.1


-- 
Thanks -
Manish

--001636833ec4ea6d0e04a1b30a06
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-Pass-extra-bool-parameter-in-journal-routines-to-spe.patch"
Content-Disposition: attachment;
	filename="0001-Pass-extra-bool-parameter-in-journal-routines-to-spe.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmwnhyci0

RnJvbSBjOWVkYmQ4ZDFkYTAyYWRhMjYxNWFjZWMzZTMwODNiNDY2OWY2ZDllIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDI0IEFwciAyMDExIDAwOjE0OjU0IC0wNzAwClN1YmplY3Q6IFtQQVRDSCAxLzVd
IFBhc3MgZXh0cmEgYm9vbCBwYXJhbWV0ZXIgaW4gam91cm5hbCByb3V0aW5lcyB0byBzcGVjaWZ5
IGlmIGl0cyBvayB0byBmYWlsIHRoZSBqb3VybmFsIHRyYW5zYWN0aW9uIGFsbG9jYXRpb24uIElm
ICd0cnVlJyBpcyBwYXNzZWQgdHJhbnNhY3Rpb24gYWxsb2NhdGlvbiBpcyBkb25lIHRocm91Z2gg
R0ZQX0tFUk5FTCBlbHNlIEdGUF9OT0ZTIGlzIHVzZWQuCgpTaWduZWQtb2ZmLWJ5OiBNYW5pc2gg
S2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgotLS0KIGZzL2piZDIvdHJhbnNhY3Rpb24uYyB8
ICAgMTIgKysrKysrKy0tLS0tCiBpbmNsdWRlL2xpbnV4L2piZDIuaCAgfCAgICA0ICsrLS0KIDIg
ZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL2piZDIvdHJhbnNhY3Rpb24uYyBiL2ZzL2piZDIvdHJhbnNhY3Rpb24uYwppbmRleCAw
NWZhNzdhLi5iMDJkNmE0IDEwMDY0NAotLS0gYS9mcy9qYmQyL3RyYW5zYWN0aW9uLmMKKysrIGIv
ZnMvamJkMi90cmFuc2FjdGlvbi5jCkBAIC0zNDksOSArMzQ5LDEwIEBAIGhhbmRsZV90ICpqYmQy
X19qb3VybmFsX3N0YXJ0KGpvdXJuYWxfdCAqam91cm5hbCwgaW50IG5ibG9ja3MsIGludCBnZnBf
bWFzaykKIEVYUE9SVF9TWU1CT0woamJkMl9fam91cm5hbF9zdGFydCk7CiAKIAotaGFuZGxlX3Qg
KmpiZDJfam91cm5hbF9zdGFydChqb3VybmFsX3QgKmpvdXJuYWwsIGludCBuYmxvY2tzKQoraGFu
ZGxlX3QgKmpiZDJfam91cm5hbF9zdGFydChqb3VybmFsX3QgKmpvdXJuYWwsIGludCBuYmxvY2tz
LCBib29sIGVycm9rKQogewotCXJldHVybiBqYmQyX19qb3VybmFsX3N0YXJ0KGpvdXJuYWwsIG5i
bG9ja3MsIEdGUF9OT0ZTKTsKKwlyZXR1cm4gamJkMl9fam91cm5hbF9zdGFydChqb3VybmFsLCBu
YmxvY2tzLAorCQkJCSAgIGVycm9rID8gR0ZQX0tFUk5FTCA6IEdGUF9OT0ZTKTsKIH0KIEVYUE9S
VF9TWU1CT0woamJkMl9qb3VybmFsX3N0YXJ0KTsKIApAQCAtNDgzLDkgKzQ4NCwxMCBAQCBpbnQg
amJkMl9fam91cm5hbF9yZXN0YXJ0KGhhbmRsZV90ICpoYW5kbGUsIGludCBuYmxvY2tzLCBpbnQg
Z2ZwX21hc2spCiBFWFBPUlRfU1lNQk9MKGpiZDJfX2pvdXJuYWxfcmVzdGFydCk7CiAKIAotaW50
IGpiZDJfam91cm5hbF9yZXN0YXJ0KGhhbmRsZV90ICpoYW5kbGUsIGludCBuYmxvY2tzKQoraW50
IGpiZDJfam91cm5hbF9yZXN0YXJ0KGhhbmRsZV90ICpoYW5kbGUsIGludCBuYmxvY2tzLCBib29s
IGVycm9rKQogewotCXJldHVybiBqYmQyX19qb3VybmFsX3Jlc3RhcnQoaGFuZGxlLCBuYmxvY2tz
LCBHRlBfTk9GUyk7CisJcmV0dXJuIGpiZDJfX2pvdXJuYWxfcmVzdGFydChoYW5kbGUsIG5ibG9j
a3MsCisJCQkJICAgICBlcnJvayA/IEdGUF9LRVJORUwgOiBHRlBfTk9GUyk7CiB9CiBFWFBPUlRf
U1lNQk9MKGpiZDJfam91cm5hbF9yZXN0YXJ0KTsKIApAQCAtMTQzNiw3ICsxNDM4LDcgQEAgaW50
IGpiZDJfam91cm5hbF9mb3JjZV9jb21taXQoam91cm5hbF90ICpqb3VybmFsKQogCWhhbmRsZV90
ICpoYW5kbGU7CiAJaW50IHJldDsKIAotCWhhbmRsZSA9IGpiZDJfam91cm5hbF9zdGFydChqb3Vy
bmFsLCAxKTsKKwloYW5kbGUgPSBqYmQyX2pvdXJuYWxfc3RhcnQoam91cm5hbCwgMSwgZmFsc2Up
OwogCWlmIChJU19FUlIoaGFuZGxlKSkgewogCQlyZXQgPSBQVFJfRVJSKGhhbmRsZSk7CiAJfSBl
bHNlIHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvamJkMi5oIGIvaW5jbHVkZS9saW51eC9q
YmQyLmgKaW5kZXggYTMyZGNhZS4uYTY0YWNlZCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9q
YmQyLmgKKysrIGIvaW5jbHVkZS9saW51eC9qYmQyLmgKQEAgLTExMDMsOSArMTEwMyw5IEBAIHN0
YXRpYyBpbmxpbmUgaGFuZGxlX3QgKmpvdXJuYWxfY3VycmVudF9oYW5kbGUodm9pZCkKICAqIFJl
Z2lzdGVyIGJ1ZmZlciBtb2RpZmljYXRpb25zIGFnYWluc3QgdGhlIGN1cnJlbnQgdHJhbnNhY3Rp
b24uCiAgKi8KIAotZXh0ZXJuIGhhbmRsZV90ICpqYmQyX2pvdXJuYWxfc3RhcnQoam91cm5hbF90
ICosIGludCBuYmxvY2tzKTsKK2V4dGVybiBoYW5kbGVfdCAqamJkMl9qb3VybmFsX3N0YXJ0KGpv
dXJuYWxfdCAqLCBpbnQgbmJsb2NrcywgYm9vbCBlcnJvayk7CiBleHRlcm4gaGFuZGxlX3QgKmpi
ZDJfX2pvdXJuYWxfc3RhcnQoam91cm5hbF90ICosIGludCBuYmxvY2tzLCBpbnQgZ2ZwX21hc2sp
OwotZXh0ZXJuIGludAkgamJkMl9qb3VybmFsX3Jlc3RhcnQoaGFuZGxlX3QgKiwgaW50IG5ibG9j
a3MpOworZXh0ZXJuIGludAkgamJkMl9qb3VybmFsX3Jlc3RhcnQoaGFuZGxlX3QgKiwgaW50IG5i
bG9ja3MsIGJvb2wgZXJyb2spOwogZXh0ZXJuIGludAkgamJkMl9fam91cm5hbF9yZXN0YXJ0KGhh
bmRsZV90ICosIGludCBuYmxvY2tzLCBpbnQgZ2ZwX21hc2spOwogZXh0ZXJuIGludAkgamJkMl9q
b3VybmFsX2V4dGVuZCAoaGFuZGxlX3QgKiwgaW50IG5ibG9ja3MpOwogZXh0ZXJuIGludAkgamJk
Ml9qb3VybmFsX2dldF93cml0ZV9hY2Nlc3MoaGFuZGxlX3QgKiwgc3RydWN0IGJ1ZmZlcl9oZWFk
ICopOwotLSAKMS43LjEKCg==
--001636833ec4ea6d0e04a1b30a06--
