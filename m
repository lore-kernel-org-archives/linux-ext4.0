From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 5/5] ext4 : Update ext4 routines to call ext4_journal_start_tryhard()
 if the transaction allocation isn't supposed to fail.
Date: Sun, 24 Apr 2011 17:19:38 -0700
Message-ID: <BANLkTimTK+E3p3RF2Y_7BUeG1+f7wgKEgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6538572eb948904a1b32aba
Cc: Manish Katiyar <manish.katiyar@in.ibm.com>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54909 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1DYAT6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 20:19:58 -0400
Received: by qwk3 with SMTP id 3so798939qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 17:19:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016e6538572eb948904a1b32aba
Content-Type: text/plain; charset=ISO-8859-1

Update ext4 routines to call ext4_journal_start_tryhard() if the
transaction allocation isn't supposed to fail. When ext4_journal_start_tryhard
is called, allocation is done with GFP_NOFS flags instead of
GFP_KERNEL.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/extents.c |    6 +++---
 fs/ext4/ialloc.c  |    2 +-
 fs/ext4/inode.c   |   27 ++++++++++++++++-----------
 fs/ext4/super.c   |    8 ++++----
 4 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4890d6f..bf0bb9c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2337,7 +2337,7 @@ static int ext4_ext_remove_space(struct inode
*inode, ext4_lblk_t start)
 	ext_debug("truncate since %u\n", start);

 	/* probably first extent we're gonna free will be last in block */
-	handle = ext4_journal_start(inode, depth + 1);
+	handle = ext4_journal_start_tryhard(inode, depth + 1);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -3550,7 +3550,7 @@ void ext4_ext_truncate(struct inode *inode)
 	 * probably first extent we're gonna free will be last in block
 	 */
 	err = ext4_writepage_trans_blocks(inode);
-	handle = ext4_journal_start(inode, err);
+	handle = ext4_journal_start_tryhard(inode, err);
 	if (IS_ERR(handle))
 		return;

@@ -3762,7 +3762,7 @@ int ext4_convert_unwritten_extents(struct inode
*inode, loff_t offset,
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk += ret;
 		map.m_len = (max_blocks -= ret);
-		handle = ext4_journal_start(inode, credits);
+		handle = ext4_journal_start_tryhard(inode, credits);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			break;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..40902f3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1263,7 +1263,7 @@ extern int ext4_init_inode_table(struct
super_block *sb, ext4_group_t group,
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
 		goto out;

-	handle = ext4_journal_start_sb(sb, 1);
+	handle = ext4_journal_start_sb_tryhard(sb, 1);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..0c2b693 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -129,7 +129,7 @@ static handle_t *start_transaction(struct inode *inode)
 {
 	handle_t *result;

-	result = ext4_journal_start(inode, blocks_for_truncate(inode));
+	result = ext4_journal_start_tryhard(inode, blocks_for_truncate(inode));
 	if (!IS_ERR(result))
 		return result;

@@ -204,7 +204,8 @@ void ext4_evict_inode(struct inode *inode)
 	if (is_bad_inode(inode))
 		goto no_delete;

-	handle = ext4_journal_start(inode, blocks_for_truncate(inode)+3);
+	handle = ext4_journal_start_tryhard(inode,
+					    blocks_for_truncate(inode)+3);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
@@ -1401,7 +1402,7 @@ static int _ext4_get_block(struct inode *inode,
sector_t iblock,
 		if (map.m_len > DIO_MAX_BLOCKS)
 			map.m_len = DIO_MAX_BLOCKS;
 		dio_credits = ext4_chunk_trans_blocks(inode, map.m_len);
-		handle = ext4_journal_start(inode, dio_credits);
+		handle = ext4_journal_start_tryhard(inode, dio_credits);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			return ret;
@@ -2558,7 +2559,8 @@ static int __ext4_journalled_writepage(struct page *page,
 	 * references to buffers so we are safe */
 	unlock_page(page);

-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	handle = ext4_journal_start_tryhard(inode,
+					    ext4_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -2990,7 +2992,7 @@ retry:
 		needed_blocks = ext4_da_writepages_trans_blocks(inode);

 		/* start a new transaction*/
-		handle = ext4_journal_start(inode, needed_blocks);
+		handle = ext4_journal_start_tryhard(inode, needed_blocks);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
@@ -5279,8 +5281,9 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)

 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
-		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
-					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
+		handle = ext4_journal_start(inode,
+					    (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
+					    EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
@@ -5335,7 +5338,7 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 							    attr->ia_size);
 			if (error) {
 				/* Do as much error cleanup as possible */
-				handle = ext4_journal_start(inode, 3);
+				handle = ext4_journal_start_tryhard(inode, 3);
 				if (IS_ERR(handle)) {
 					ext4_orphan_del(NULL, inode);
 					goto err_out;
@@ -5371,7 +5374,9 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 		rc = ext4_acl_chmod(inode);

 err_out:
-	ext4_std_error(inode->i_sb, error);
+	if (error != -ENOMEM) {
+		ext4_std_error(inode->i_sb, error);
+	}
 	if (!error)
 		error = rc;
 	return error;
@@ -5687,7 +5692,7 @@ void ext4_dirty_inode(struct inode *inode)
 {
 	handle_t *handle;

-	handle = ext4_journal_start(inode, 2);
+	handle = ext4_journal_start_tryhard(inode, 2);
 	if (IS_ERR(handle))
 		goto out;

@@ -5771,7 +5776,7 @@ int ext4_change_inode_journal_flag(struct inode
*inode, int val)

 	/* Finally we can mark the inode as dirty. */

-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start_tryhard(inode, 1);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 03eac6a..b0fc83e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4526,7 +4526,7 @@ static int ext4_write_dquot(struct dquot *dquot)
 	struct inode *inode;

 	inode = dquot_to_inode(dquot);
-	handle = ext4_journal_start(inode,
+	handle = ext4_journal_start_tryhard(inode,
 				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -4542,7 +4542,7 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 	int ret, err;
 	handle_t *handle;

-	handle = ext4_journal_start(dquot_to_inode(dquot),
+	handle = ext4_journal_start_tryhard(dquot_to_inode(dquot),
 				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -4558,7 +4558,7 @@ static int ext4_release_dquot(struct dquot *dquot)
 	int ret, err;
 	handle_t *handle;

-	handle = ext4_journal_start(dquot_to_inode(dquot),
+	handle = ext4_journal_start_tryhard(dquot_to_inode(dquot),
 				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
 	if (IS_ERR(handle)) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
@@ -4590,7 +4590,7 @@ static int ext4_write_info(struct super_block
*sb, int type)
 	handle_t *handle;

 	/* Data block + inode block */
-	handle = ext4_journal_start(sb->s_root->d_inode, 2);
+	handle = ext4_journal_start_tryhard(sb->s_root->d_inode, 2);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit_info(sb, type);
-- 
1.7.1


-- 
Thanks -
Manish

--0016e6538572eb948904a1b32aba
Content-Type: text/x-patch; charset=US-ASCII;
	name="0005-Update-ext4-routines-to-call-ext4_journal_start_tryh.patch"
Content-Disposition: attachment;
	filename="0005-Update-ext4-routines-to-call-ext4_journal_start_tryh.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmwnt6p10

RnJvbSBiOWRkNzVmZDcyNzFhN2Q3MjkwODc1YjA4ZDQwODM3YjI4MWM2Zjk0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDI0IEFwciAyMDExIDE2OjU3OjExIC0wNzAwClN1YmplY3Q6IFtQQVRDSCA1LzVd
IFVwZGF0ZSBleHQ0IHJvdXRpbmVzIHRvIGNhbGwgZXh0NF9qb3VybmFsX3N0YXJ0X3RyeWhhcmQo
KSBpZiB0aGUKIHRyYW5zYWN0aW9uIGFsbG9jYXRpb24gaXNuJ3Qgc3VwcG9zZWQgdG8gZmFpbC4g
V2hlbiBleHQ0X2pvdXJuYWxfc3RhcnRfdHJ5aGFyZAogaXMgY2FsbGVkLCBhbGxvY2F0aW9uIGlz
IGRvbmUgd2l0aCBHRlBfTk9GUyBmbGFncyBpbnN0ZWFkIG9mCiBHRlBfS0VSTkVMLgoKClNpZ25l
ZC1vZmYtYnk6IE1hbmlzaCBLYXRpeWFyIDxta2F0aXlhckBnbWFpbC5jb20+Ci0tLQogZnMvZXh0
NC9leHRlbnRzLmMgfCAgICA2ICsrKy0tLQogZnMvZXh0NC9pYWxsb2MuYyAgfCAgICAyICstCiBm
cy9leHQ0L2lub2RlLmMgICB8ICAgMjcgKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tCiBmcy9l
eHQ0L3N1cGVyLmMgICB8ICAgIDggKysrKy0tLS0KIDQgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0
aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9leHRlbnRzLmMg
Yi9mcy9leHQ0L2V4dGVudHMuYwppbmRleCA0ODkwZDZmLi5iZjBiYjljIDEwMDY0NAotLS0gYS9m
cy9leHQ0L2V4dGVudHMuYworKysgYi9mcy9leHQ0L2V4dGVudHMuYwpAQCAtMjMzNyw3ICsyMzM3
LDcgQEAgc3RhdGljIGludCBleHQ0X2V4dF9yZW1vdmVfc3BhY2Uoc3RydWN0IGlub2RlICppbm9k
ZSwgZXh0NF9sYmxrX3Qgc3RhcnQpCiAJZXh0X2RlYnVnKCJ0cnVuY2F0ZSBzaW5jZSAldVxuIiwg
c3RhcnQpOwogCiAJLyogcHJvYmFibHkgZmlyc3QgZXh0ZW50IHdlJ3JlIGdvbm5hIGZyZWUgd2ls
bCBiZSBsYXN0IGluIGJsb2NrICovCi0JaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0KGlub2Rl
LCBkZXB0aCArIDEpOworCWhhbmRsZSA9IGV4dDRfam91cm5hbF9zdGFydF90cnloYXJkKGlub2Rl
LCBkZXB0aCArIDEpOwogCWlmIChJU19FUlIoaGFuZGxlKSkKIAkJcmV0dXJuIFBUUl9FUlIoaGFu
ZGxlKTsKIApAQCAtMzU1MCw3ICszNTUwLDcgQEAgdm9pZCBleHQ0X2V4dF90cnVuY2F0ZShzdHJ1
Y3QgaW5vZGUgKmlub2RlKQogCSAqIHByb2JhYmx5IGZpcnN0IGV4dGVudCB3ZSdyZSBnb25uYSBm
cmVlIHdpbGwgYmUgbGFzdCBpbiBibG9jawogCSAqLwogCWVyciA9IGV4dDRfd3JpdGVwYWdlX3Ry
YW5zX2Jsb2Nrcyhpbm9kZSk7Ci0JaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0KGlub2RlLCBl
cnIpOworCWhhbmRsZSA9IGV4dDRfam91cm5hbF9zdGFydF90cnloYXJkKGlub2RlLCBlcnIpOwog
CWlmIChJU19FUlIoaGFuZGxlKSkKIAkJcmV0dXJuOwogCkBAIC0zNzYyLDcgKzM3NjIsNyBAQCBp
bnQgZXh0NF9jb252ZXJ0X3Vud3JpdHRlbl9leHRlbnRzKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGxv
ZmZfdCBvZmZzZXQsCiAJd2hpbGUgKHJldCA+PSAwICYmIHJldCA8IG1heF9ibG9ja3MpIHsKIAkJ
bWFwLm1fbGJsayArPSByZXQ7CiAJCW1hcC5tX2xlbiA9IChtYXhfYmxvY2tzIC09IHJldCk7Ci0J
CWhhbmRsZSA9IGV4dDRfam91cm5hbF9zdGFydChpbm9kZSwgY3JlZGl0cyk7CisJCWhhbmRsZSA9
IGV4dDRfam91cm5hbF9zdGFydF90cnloYXJkKGlub2RlLCBjcmVkaXRzKTsKIAkJaWYgKElTX0VS
UihoYW5kbGUpKSB7CiAJCQlyZXQgPSBQVFJfRVJSKGhhbmRsZSk7CiAJCQlicmVhazsKZGlmZiAt
LWdpdCBhL2ZzL2V4dDQvaWFsbG9jLmMgYi9mcy9leHQ0L2lhbGxvYy5jCmluZGV4IDIxYmIyZjYu
LjQwOTAyZjMgMTAwNjQ0Ci0tLSBhL2ZzL2V4dDQvaWFsbG9jLmMKKysrIGIvZnMvZXh0NC9pYWxs
b2MuYwpAQCAtMTI2Myw3ICsxMjYzLDcgQEAgZXh0ZXJuIGludCBleHQ0X2luaXRfaW5vZGVfdGFi
bGUoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgZXh0NF9ncm91cF90IGdyb3VwLAogCWlmIChnZHAt
PmJnX2ZsYWdzICYgY3B1X3RvX2xlMTYoRVhUNF9CR19JTk9ERV9aRVJPRUQpKQogCQlnb3RvIG91
dDsKIAotCWhhbmRsZSA9IGV4dDRfam91cm5hbF9zdGFydF9zYihzYiwgMSk7CisJaGFuZGxlID0g
ZXh0NF9qb3VybmFsX3N0YXJ0X3NiX3RyeWhhcmQoc2IsIDEpOwogCWlmIChJU19FUlIoaGFuZGxl
KSkgewogCQlyZXQgPSBQVFJfRVJSKGhhbmRsZSk7CiAJCWdvdG8gb3V0OwpkaWZmIC0tZ2l0IGEv
ZnMvZXh0NC9pbm9kZS5jIGIvZnMvZXh0NC9pbm9kZS5jCmluZGV4IGYyZmE1ZTguLjBjMmI2OTMg
MTAwNjQ0Ci0tLSBhL2ZzL2V4dDQvaW5vZGUuYworKysgYi9mcy9leHQ0L2lub2RlLmMKQEAgLTEy
OSw3ICsxMjksNyBAQCBzdGF0aWMgaGFuZGxlX3QgKnN0YXJ0X3RyYW5zYWN0aW9uKHN0cnVjdCBp
bm9kZSAqaW5vZGUpCiB7CiAJaGFuZGxlX3QgKnJlc3VsdDsKIAotCXJlc3VsdCA9IGV4dDRfam91
cm5hbF9zdGFydChpbm9kZSwgYmxvY2tzX2Zvcl90cnVuY2F0ZShpbm9kZSkpOworCXJlc3VsdCA9
IGV4dDRfam91cm5hbF9zdGFydF90cnloYXJkKGlub2RlLCBibG9ja3NfZm9yX3RydW5jYXRlKGlu
b2RlKSk7CiAJaWYgKCFJU19FUlIocmVzdWx0KSkKIAkJcmV0dXJuIHJlc3VsdDsKIApAQCAtMjA0
LDcgKzIwNCw4IEBAIHZvaWQgZXh0NF9ldmljdF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQog
CWlmIChpc19iYWRfaW5vZGUoaW5vZGUpKQogCQlnb3RvIG5vX2RlbGV0ZTsKIAotCWhhbmRsZSA9
IGV4dDRfam91cm5hbF9zdGFydChpbm9kZSwgYmxvY2tzX2Zvcl90cnVuY2F0ZShpbm9kZSkrMyk7
CisJaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0X3RyeWhhcmQoaW5vZGUsCisJCQkJCSAgICBi
bG9ja3NfZm9yX3RydW5jYXRlKGlub2RlKSszKTsKIAlpZiAoSVNfRVJSKGhhbmRsZSkpIHsKIAkJ
ZXh0NF9zdGRfZXJyb3IoaW5vZGUtPmlfc2IsIFBUUl9FUlIoaGFuZGxlKSk7CiAJCS8qCkBAIC0x
NDAxLDcgKzE0MDIsNyBAQCBzdGF0aWMgaW50IF9leHQ0X2dldF9ibG9jayhzdHJ1Y3QgaW5vZGUg
Kmlub2RlLCBzZWN0b3JfdCBpYmxvY2ssCiAJCWlmIChtYXAubV9sZW4gPiBESU9fTUFYX0JMT0NL
UykKIAkJCW1hcC5tX2xlbiA9IERJT19NQVhfQkxPQ0tTOwogCQlkaW9fY3JlZGl0cyA9IGV4dDRf
Y2h1bmtfdHJhbnNfYmxvY2tzKGlub2RlLCBtYXAubV9sZW4pOwotCQloYW5kbGUgPSBleHQ0X2pv
dXJuYWxfc3RhcnQoaW5vZGUsIGRpb19jcmVkaXRzKTsKKwkJaGFuZGxlID0gZXh0NF9qb3VybmFs
X3N0YXJ0X3RyeWhhcmQoaW5vZGUsIGRpb19jcmVkaXRzKTsKIAkJaWYgKElTX0VSUihoYW5kbGUp
KSB7CiAJCQlyZXQgPSBQVFJfRVJSKGhhbmRsZSk7CiAJCQlyZXR1cm4gcmV0OwpAQCAtMjU1OCw3
ICsyNTU5LDggQEAgc3RhdGljIGludCBfX2V4dDRfam91cm5hbGxlZF93cml0ZXBhZ2Uoc3RydWN0
IHBhZ2UgKnBhZ2UsCiAJICogcmVmZXJlbmNlcyB0byBidWZmZXJzIHNvIHdlIGFyZSBzYWZlICov
CiAJdW5sb2NrX3BhZ2UocGFnZSk7CiAKLQloYW5kbGUgPSBleHQ0X2pvdXJuYWxfc3RhcnQoaW5v
ZGUsIGV4dDRfd3JpdGVwYWdlX3RyYW5zX2Jsb2Nrcyhpbm9kZSkpOworCWhhbmRsZSA9IGV4dDRf
am91cm5hbF9zdGFydF90cnloYXJkKGlub2RlLAorCQkJCQkgICAgZXh0NF93cml0ZXBhZ2VfdHJh
bnNfYmxvY2tzKGlub2RlKSk7CiAJaWYgKElTX0VSUihoYW5kbGUpKSB7CiAJCXJldCA9IFBUUl9F
UlIoaGFuZGxlKTsKIAkJZ290byBvdXQ7CkBAIC0yOTkwLDcgKzI5OTIsNyBAQCByZXRyeToKIAkJ
bmVlZGVkX2Jsb2NrcyA9IGV4dDRfZGFfd3JpdGVwYWdlc190cmFuc19ibG9ja3MoaW5vZGUpOwog
CiAJCS8qIHN0YXJ0IGEgbmV3IHRyYW5zYWN0aW9uKi8KLQkJaGFuZGxlID0gZXh0NF9qb3VybmFs
X3N0YXJ0KGlub2RlLCBuZWVkZWRfYmxvY2tzKTsKKwkJaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0
YXJ0X3RyeWhhcmQoaW5vZGUsIG5lZWRlZF9ibG9ja3MpOwogCQlpZiAoSVNfRVJSKGhhbmRsZSkp
IHsKIAkJCXJldCA9IFBUUl9FUlIoaGFuZGxlKTsKIAkJCWV4dDRfbXNnKGlub2RlLT5pX3NiLCBL
RVJOX0NSSVQsICIlczogamJkMl9zdGFydDogIgpAQCAtNTI3OSw4ICs1MjgxLDkgQEAgaW50IGV4
dDRfc2V0YXR0cihzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVjdCBpYXR0ciAqYXR0cikKIAog
CQkvKiAodXNlcitncm91cCkqKG9sZCtuZXcpIHN0cnVjdHVyZSwgaW5vZGUgd3JpdGUgKHNiLAog
CQkgKiBpbm9kZSBibG9jaywgPyAtIGJ1dCB0cnVuY2F0ZSBpbm9kZSB1cGRhdGUgaGFzIGl0KSAq
LwotCQloYW5kbGUgPSBleHQ0X2pvdXJuYWxfc3RhcnQoaW5vZGUsIChFWFQ0X01BWFFVT1RBU19J
TklUX0JMT0NLUyhpbm9kZS0+aV9zYikrCi0JCQkJCUVYVDRfTUFYUVVPVEFTX0RFTF9CTE9DS1Mo
aW5vZGUtPmlfc2IpKSszKTsKKwkJaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0KGlub2RlLAor
CQkJCQkgICAgKEVYVDRfTUFYUVVPVEFTX0lOSVRfQkxPQ0tTKGlub2RlLT5pX3NiKSsKKwkJCQkJ
ICAgIEVYVDRfTUFYUVVPVEFTX0RFTF9CTE9DS1MoaW5vZGUtPmlfc2IpKSszKTsKIAkJaWYgKElT
X0VSUihoYW5kbGUpKSB7CiAJCQllcnJvciA9IFBUUl9FUlIoaGFuZGxlKTsKIAkJCWdvdG8gZXJy
X291dDsKQEAgLTUzMzUsNyArNTMzOCw3IEBAIGludCBleHQ0X3NldGF0dHIoc3RydWN0IGRlbnRy
eSAqZGVudHJ5LCBzdHJ1Y3QgaWF0dHIgKmF0dHIpCiAJCQkJCQkJICAgIGF0dHItPmlhX3NpemUp
OwogCQkJaWYgKGVycm9yKSB7CiAJCQkJLyogRG8gYXMgbXVjaCBlcnJvciBjbGVhbnVwIGFzIHBv
c3NpYmxlICovCi0JCQkJaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0KGlub2RlLCAzKTsKKwkJ
CQloYW5kbGUgPSBleHQ0X2pvdXJuYWxfc3RhcnRfdHJ5aGFyZChpbm9kZSwgMyk7CiAJCQkJaWYg
KElTX0VSUihoYW5kbGUpKSB7CiAJCQkJCWV4dDRfb3JwaGFuX2RlbChOVUxMLCBpbm9kZSk7CiAJ
CQkJCWdvdG8gZXJyX291dDsKQEAgLTUzNzEsNyArNTM3NCw5IEBAIGludCBleHQ0X3NldGF0dHIo
c3RydWN0IGRlbnRyeSAqZGVudHJ5LCBzdHJ1Y3QgaWF0dHIgKmF0dHIpCiAJCXJjID0gZXh0NF9h
Y2xfY2htb2QoaW5vZGUpOwogCiBlcnJfb3V0OgotCWV4dDRfc3RkX2Vycm9yKGlub2RlLT5pX3Ni
LCBlcnJvcik7CisJaWYgKGVycm9yICE9IC1FTk9NRU0pIHsKKwkJZXh0NF9zdGRfZXJyb3IoaW5v
ZGUtPmlfc2IsIGVycm9yKTsKKwl9CiAJaWYgKCFlcnJvcikKIAkJZXJyb3IgPSByYzsKIAlyZXR1
cm4gZXJyb3I7CkBAIC01Njg3LDcgKzU2OTIsNyBAQCB2b2lkIGV4dDRfZGlydHlfaW5vZGUoc3Ry
dWN0IGlub2RlICppbm9kZSkKIHsKIAloYW5kbGVfdCAqaGFuZGxlOwogCi0JaGFuZGxlID0gZXh0
NF9qb3VybmFsX3N0YXJ0KGlub2RlLCAyKTsKKwloYW5kbGUgPSBleHQ0X2pvdXJuYWxfc3RhcnRf
dHJ5aGFyZChpbm9kZSwgMik7CiAJaWYgKElTX0VSUihoYW5kbGUpKQogCQlnb3RvIG91dDsKIApA
QCAtNTc3MSw3ICs1Nzc2LDcgQEAgaW50IGV4dDRfY2hhbmdlX2lub2RlX2pvdXJuYWxfZmxhZyhz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBpbnQgdmFsKQogCiAJLyogRmluYWxseSB3ZSBjYW4gbWFyayB0
aGUgaW5vZGUgYXMgZGlydHkuICovCiAKLQloYW5kbGUgPSBleHQ0X2pvdXJuYWxfc3RhcnQoaW5v
ZGUsIDEpOworCWhhbmRsZSA9IGV4dDRfam91cm5hbF9zdGFydF90cnloYXJkKGlub2RlLCAxKTsK
IAlpZiAoSVNfRVJSKGhhbmRsZSkpCiAJCXJldHVybiBQVFJfRVJSKGhhbmRsZSk7CiAKZGlmZiAt
LWdpdCBhL2ZzL2V4dDQvc3VwZXIuYyBiL2ZzL2V4dDQvc3VwZXIuYwppbmRleCAwM2VhYzZhLi5i
MGZjODNlIDEwMDY0NAotLS0gYS9mcy9leHQ0L3N1cGVyLmMKKysrIGIvZnMvZXh0NC9zdXBlci5j
CkBAIC00NTI2LDcgKzQ1MjYsNyBAQCBzdGF0aWMgaW50IGV4dDRfd3JpdGVfZHF1b3Qoc3RydWN0
IGRxdW90ICpkcXVvdCkKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlOwogCiAJaW5vZGUgPSBkcXVvdF90
b19pbm9kZShkcXVvdCk7Ci0JaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0KGlub2RlLAorCWhh
bmRsZSA9IGV4dDRfam91cm5hbF9zdGFydF90cnloYXJkKGlub2RlLAogCQkJCSAgICBFWFQ0X1FV
T1RBX1RSQU5TX0JMT0NLUyhkcXVvdC0+ZHFfc2IpKTsKIAlpZiAoSVNfRVJSKGhhbmRsZSkpCiAJ
CXJldHVybiBQVFJfRVJSKGhhbmRsZSk7CkBAIC00NTQyLDcgKzQ1NDIsNyBAQCBzdGF0aWMgaW50
IGV4dDRfYWNxdWlyZV9kcXVvdChzdHJ1Y3QgZHF1b3QgKmRxdW90KQogCWludCByZXQsIGVycjsK
IAloYW5kbGVfdCAqaGFuZGxlOwogCi0JaGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0KGRxdW90
X3RvX2lub2RlKGRxdW90KSwKKwloYW5kbGUgPSBleHQ0X2pvdXJuYWxfc3RhcnRfdHJ5aGFyZChk
cXVvdF90b19pbm9kZShkcXVvdCksCiAJCQkJICAgIEVYVDRfUVVPVEFfSU5JVF9CTE9DS1MoZHF1
b3QtPmRxX3NiKSk7CiAJaWYgKElTX0VSUihoYW5kbGUpKQogCQlyZXR1cm4gUFRSX0VSUihoYW5k
bGUpOwpAQCAtNDU1OCw3ICs0NTU4LDcgQEAgc3RhdGljIGludCBleHQ0X3JlbGVhc2VfZHF1b3Qo
c3RydWN0IGRxdW90ICpkcXVvdCkKIAlpbnQgcmV0LCBlcnI7CiAJaGFuZGxlX3QgKmhhbmRsZTsK
IAotCWhhbmRsZSA9IGV4dDRfam91cm5hbF9zdGFydChkcXVvdF90b19pbm9kZShkcXVvdCksCisJ
aGFuZGxlID0gZXh0NF9qb3VybmFsX3N0YXJ0X3RyeWhhcmQoZHF1b3RfdG9faW5vZGUoZHF1b3Qp
LAogCQkJCSAgICBFWFQ0X1FVT1RBX0RFTF9CTE9DS1MoZHF1b3QtPmRxX3NiKSk7CiAJaWYgKElT
X0VSUihoYW5kbGUpKSB7CiAJCS8qIFJlbGVhc2UgZHF1b3QgYW55d2F5IHRvIGF2b2lkIGVuZGxl
c3MgY3ljbGUgaW4gZHFwdXQoKSAqLwpAQCAtNDU5MCw3ICs0NTkwLDcgQEAgc3RhdGljIGludCBl
eHQ0X3dyaXRlX2luZm8oc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgaW50IHR5cGUpCiAJaGFuZGxl
X3QgKmhhbmRsZTsKIAogCS8qIERhdGEgYmxvY2sgKyBpbm9kZSBibG9jayAqLwotCWhhbmRsZSA9
IGV4dDRfam91cm5hbF9zdGFydChzYi0+c19yb290LT5kX2lub2RlLCAyKTsKKwloYW5kbGUgPSBl
eHQ0X2pvdXJuYWxfc3RhcnRfdHJ5aGFyZChzYi0+c19yb290LT5kX2lub2RlLCAyKTsKIAlpZiAo
SVNfRVJSKGhhbmRsZSkpCiAJCXJldHVybiBQVFJfRVJSKGhhbmRsZSk7CiAJcmV0ID0gZHF1b3Rf
Y29tbWl0X2luZm8oc2IsIHR5cGUpOwotLSAKMS43LjEKCg==
--0016e6538572eb948904a1b32aba--
