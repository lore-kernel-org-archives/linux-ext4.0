Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713830;
	b=Rw2zNjIcWOispmrkTNVMwSOiYPlJlPAMYOzVLPHaImfqZuhA5QF9hZ9WOcXA+DPhjxhK
	 dlrfn1EaxfYdHRIRpD05DqLKGqTgyjccm2Ig0EnNbvZJHZj1wpLXYQxD5OAnHA9hOXbWA
	 A2T88pD4VB/Yx0RR15Wv5VwJZvtwHgedIfnVP1XRuAq3nZtGffXvjzFcm8WGXp6ipre6z
	 tnLPZbWAn9TxBTckReisTBA1FQu8dzqtEKOX3i91+dCVwD9scznRTK29wV8/PSJxe9yG/
	 HPJ9tzjVmZBBPqil7MrFm9C3zreWR/CyMEo/B/tp2MIvKhmzmNZqVj9dHO1i6pE3pcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713830;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/y6VYn2itGN7fGu5FkKVb5hARtUa2u4lxD3sRFifgNI=;
	b=BsB6ysEZmIV77aYYfZBGAk2JHvjNMJkQCol80/h1pDec5g9BCkc4zjmfFgOpoW5Uvzw2
	 HEleGmK+hp5xPky//GQIwEO+Xp0/027376njuriZRhqQGzBi6gj+OLMhJX6w/NIx18swp
	 GqKGkVOAnPjmd1zQGlBJvmcSBOIN3FB8WbvD95YwCeeyDDVHpS3zWKEirY/2Mqxkl+AuR
	 x8y3ZjHv8vWmypJ0Ckiwgqutz1RLJsPOn6UtycOPtD31cRlIwEtbMIK2d3ATqGERP4PH2
	 Bvh5J1Z1Q9q4MtLJMwK2HJWkB7k7T/grhdDfKIIgdmDs8/LrjUm6MxJF6QGQtPY83Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dfZce2H5;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6B2606A331
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C6B2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dfZce2H5
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so28426325e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713828; x=1794318628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/y6VYn2itGN7fGu5FkKVb5hARtUa2u4lxD3sRFifgNI=;
        b=dfZce2H5wIf0lUqhoC4V41WUfK9f5mclk8b2WZg5/VNVxlrniVZbVDXtGOcmdhmBS5
         zmqdfbHJAjGmlofsLt8M7whh4DE7X8PjL9JTisQHNBK1iQZZ8AnmF+TcGm1HjdQt2/pH
         WmmXxn5+tKtk6YqMnn1bSIaUQYF839ZLUcUNfIc+rqSSYcNClg1DYDZA1/pHmOrxQNG1
         6SeL09H+TnayzG9ugBGGCwmeqyAOTRtTENiNlNl0SKsrWhg0n2xxATXUEwTGXXp2TiNI
         0alONK3+2FqIuqKRQ3AK2TSBxj0ZPtVsgs6i6iCGShwhUzW/NPqWWRxAfllEOIKZs6jb
         w93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713828; x=1794318628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/y6VYn2itGN7fGu5FkKVb5hARtUa2u4lxD3sRFifgNI=;
        b=n0qysuSAO97FqGcctotxCpGeT+DEqmFV81NSb8U0/GS7Jln5W93L5QazqDPthDpPzS
         1xJNYTMU5WYIfrhGZeYFZg6fZ5d1YDt5QOREyPoFmDLcQXiZ8RYQ4ANRCXpp9OxrFF82
         DUzoqa+Fj6TVmhNhTNN/qYgryN5B+cNZLHxca1Iru0tdE29ox1BHvfDUlYA1x1b0nUR2
         mQ2QgmKEeLIXXhAFsOBRth5+ADbDxyyS409lnPghEAXN8f2r1H5hrEn7yYprfQXhvk4y
         trdTAJfguDq/FGJGjb3YdS/xojB+BqM0AYBmJGbmmbj25b0pL9QGzISLlmMVPI6xI0By
         hjjw==
X-Gm-Message-State: APuU4Z9EP83xW2q+bVAZFSO/IvgsaS1fJTZBU3Nk9Ruh8LlQNh5FpqKo
	OGC/NhYpYQuHV+W1wHpi+3uioCK8HXXt7eKLR5PDpdhQhJP36onosC0sa5roXDhCB4c=
X-Gm-Gg: AYBFou0GKtCRAaP9eohNSbSn66hKAjdw6Cff0aygJPkRLxQiSFrq13+rGzhj97yNI70
	BKMgspjpI7umLE1n4HOO7ZmkRK6PReDreyj+KHiS+XSX0ptj9GAK/aSSCTXcHlUsk3OPFIKREl5
	TuWlzQFWd1H+Vb01Z1Dqv7eg/sp1rq5GSa/5szOO1NHi+q4zbwk09htSh2G2m6ODcrRx6r4+doQ
	+/dKwO/3GsU2nfjb4x73tvyhVg66LDb+XDz4uWngROu6FCoBAjbbkqBVtawVNlII32FRxjrlcqD
	0unEhTt29Ed8FOSYkeDbmoihYcDrvWN7QiuBcBcTnx63pmvGkhwekYwFgBANOe67JP4PmwyJSP4
	9UD9drsgq8lTG0bERD9GeqSFVvYfd9p1mDWkAQmkQFlhlMIOQrGjZtPEc/v8JiNJsYbWk1pPPBo
	W8pb9uy3mTP5Wn97N6246GmKkOqeVw+2+7qcVCj5NJ1/YehMI0LoAbpVS4//fYMBYICdqArkEUE
	67lFV9xdGPLFyoljszny7e618w3v5HhKcq0Nn+CTwvwLED3rlyIs0emlGXtKjKLAA2k2tBuNJlY
	qnBDWczAEfCK1C6xB8wn0Y7ID05J4ooOZXEb0lzJfP70iabNMA4alCMmcBss
X-Received: by 2002:a05:600c:1d07:b0:4a2:18d4:f9e0 with SMTP id 5b1f17b1804b1-4ac18c735b3mr302496755e9.25.1793713827771;
        Tue, 03 Nov 2026 05:50:27 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:27 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 08/12] ext4: rename ext4_dir_rec_len() and clarify dirdata usage
Date: Tue,  3 Nov 2026 13:49:15 +0000
Message-ID: <20261103134921.610047-9-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Rename ext4_dir_rec_len() to ext4_dirent_rec_len() to better
reflect that it computes the record length for a directory
entry based on the provided name length.

Update the comment to clarify handling of dirdata-enabled
directories and document the use of ext4_dir_entry_len()
when dirdata is present.

ext4_dir_entry_len() reads the dirdata of an entry, so the length of
the entry that do_split() hands to add_dirent_to_buf() now depends on
on-disk data.  add_dirent_to_buf() checks that this entry has room for
the new one before anything is written, instead of overrunning the
block when the directory is corrupted.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/dir.c    | 15 +++++++-------
 fs/ext4/ext4.h   | 16 ++++++++++-----
 fs/ext4/inline.c | 21 +++++++++++---------
 fs/ext4/namei.c  | 51 +++++++++++++++++++++++++++++++++---------------
 4 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 8d7b81e6948e..38911ae2bcfc 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -89,16 +89,15 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	bool fake = is_fake_dir_entry(de);
 	bool has_csum = ext4_has_feature_metadata_csum(dir->i_sb);
 
-	if (unlikely(rlen < ext4_dir_rec_len(1, fake ? NULL : dir)))
+	if (unlikely(rlen < ext4_dirent_rec_len(1, fake ? NULL : dir)))
 		error_msg = "rec_len is smaller than minimal";
 	else if (unlikely(rlen % 4 != 0))
 		error_msg = "rec_len % 4 != 0";
-	else if (unlikely(rlen < ext4_dir_rec_len(de->name_len,
-							fake ? NULL : dir)))
-		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(next_offset > size))
 		error_msg = "directory entry overrun";
-	else if (unlikely(next_offset > size - ext4_dir_rec_len(1,
+	else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir)))
+		error_msg = "rec_len is too small for name_len";
+	else if (unlikely(next_offset > size - ext4_dirent_rec_len(1,
 						  has_csum ? NULL : dir) &&
 			  next_offset != size))
 		error_msg = "directory entry too close to block end";
@@ -238,7 +237,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		if (!inode_eq_iversion(inode, info->cookie)) {
 			for (i = 0;
 			     i <= sb->s_blocksize -
-				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
+				  ext4_dirent_rec_len(1, has_csum ? NULL : inode) &&
 			     i < offset;) {
 				de = (struct ext4_dir_entry_2 *)
 					(bh->b_data + i);
@@ -249,7 +248,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 				 * failure will be detected in the
 				 * dirent test below. */
 				if (ext4_rec_len_from_disk(de->rec_len,
-					sb->s_blocksize) < ext4_dir_rec_len(1,
+					sb->s_blocksize) < ext4_dirent_rec_len(1,
 									inode))
 					break;
 				i += ext4_rec_len_from_disk(de->rec_len,
@@ -263,7 +262,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 
 		if (unlikely(offset < sb->s_blocksize &&
 			     offset > sb->s_blocksize -
-			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {
+			     ext4_dirent_rec_len(1, has_csum ? NULL : inode))) {
 			EXT4_ERROR_FILE(file, bh->b_blocknr,
 					"bad entry in directory: %s - offset=%u, size=%lu",
 					"directory entry too close to block end",
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fe6b8fe4634e..e42e5bcc2f28 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2655,11 +2655,16 @@ struct ext4_dirent_hash {
  * casefolded and encrypted need to store the hash as well, so we add room for
  * ext4_extended_dir_entry_2. For all entries related to '.' or '..' you should
  * pass NULL for dir, as those entries do not use the extra fields.
+ *
+ * For directories with the dirdata feature, extra data may follow the filename.
+ * Use ext4_dir_entry_len() to compute the length of a directory entry
+ * including any dirdata, or ext4_dirent_rec_len() directly when the total
+ * name_len (including dirdata length) is already known.
  */
-static inline unsigned int ext4_dir_rec_len(__u8 name_len,
+static inline unsigned int ext4_dirent_rec_len(unsigned int name_len,
 						const struct inode *dir)
 {
-	int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
+	unsigned int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
 
 	if (dir && ext4_hash_in_dirent(dir))
 		rec_len += sizeof(struct ext4_dir_entry_hash);
@@ -3067,7 +3072,8 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size,
 			     struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 **dest_de);
+			     struct ext4_dir_entry_2 **dest_de,
+			     int dlen);
 void ext4_insert_dentry(struct inode *dir, struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
@@ -4268,8 +4274,8 @@ static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
 	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
 	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
 
-	return max(ext4_dir_rec_len(de->name_len + dirdata, NULL),
-		   ext4_dir_rec_len(de->name_len, dir));
+	return max(ext4_dirent_rec_len(de->name_len + dirdata, NULL),
+		   ext4_dirent_rec_len(de->name_len, dir));
 }
 
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..bdf6f45a3de4 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -985,8 +985,11 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	int		err;
 	struct ext4_dir_entry_2 *de;
 
+	/* 'dlen' reserves space for dirdata extensions (LUFID, CFHASH) in the
+	 * slot.  The dirdata types are defined in the next patch; until then
+	 * dlen stays 0 and ext4_find_dest_de() ignores dirdata overhead. */
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de);
+				inline_size, fname, &de, 0);
 	if (err)
 		return err;
 
@@ -1064,7 +1067,7 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	int old_size = EXT4_I(dir)->i_inline_size - EXT4_MIN_INLINE_DATA_SIZE;
 	int new_size = get_max_inline_xattr_value_size(dir, iloc);
 
-	if (new_size - old_size <= ext4_dir_rec_len(1, NULL))
+	if (new_size - old_size <= ext4_dirent_rec_len(1, NULL))
 		return -ENOSPC;
 
 	ret = ext4_update_inline_data(handle, dir,
@@ -1318,7 +1321,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 1;
 			memcpy(fake.name, ".", 2);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1328,7 +1331,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 2;
 			memcpy(fake.name, "..", 3);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1436,8 +1439,8 @@ int ext4_read_inline_dir(struct file *file,
 	 * So we will use extra_offset and extra_size to indicate them
 	 * during the inline dir iteration.
 	 */
-	dotdot_offset = ext4_dir_rec_len(1, NULL);
-	dotdot_size = dotdot_offset + ext4_dir_rec_len(2, NULL);
+	dotdot_offset = ext4_dirent_rec_len(1, NULL);
+	dotdot_size = dotdot_offset + ext4_dirent_rec_len(2, NULL);
 	extra_offset = dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
 	extra_size = extra_offset + inline_size;
 
@@ -1463,7 +1466,7 @@ int ext4_read_inline_dir(struct file *file,
 			/* for other entry, the real offset in
 			 * the buf has to be tuned accordingly.
 			 */
-			if (i + ext4_dir_rec_len(1, NULL) > extra_size)
+			if (i + ext4_dirent_rec_len(1, NULL) > extra_size)
 				break;
 			de = (struct ext4_dir_entry_2 *)
 				(dir_buf + i - extra_offset);
@@ -1474,7 +1477,7 @@ int ext4_read_inline_dir(struct file *file,
 			 * failure will be detected in the
 			 * dirent test below. */
 			if (ext4_rec_len_from_disk(de->rec_len, extra_size)
-				< ext4_dir_rec_len(1, NULL))
+				< ext4_dirent_rec_len(1, NULL))
 				break;
 			i += ext4_rec_len_from_disk(de->rec_len,
 						    extra_size);
@@ -1504,7 +1507,7 @@ int ext4_read_inline_dir(struct file *file,
 		 * kmalloc(inline_size) buffer.  Make sure its header fits before
 		 * ext4_check_dir_entry() dereferences de->rec_len.
 		 */
-		if (ctx->pos + ext4_dir_rec_len(1, NULL) > extra_size)
+		if (ctx->pos + ext4_dirent_rec_len(1, NULL) > extra_size)
 			goto out;
 		de = (struct ext4_dir_entry_2 *)
 			(dir_buf + ctx->pos - extra_offset);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9953583ad6c3..0c91e4da00fb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -633,7 +633,7 @@ static inline unsigned int __dx_node_limit(struct inode *dir,
 					   const struct inode *hash_dir)
 {
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, hash_dir);
+			ext4_dirent_rec_len(0, hash_dir);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -763,7 +763,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += ext4_dir_rec_len(de->name_len, dir);
+			space += ext4_dirent_rec_len(de->name_len, dir);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -1141,7 +1141,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	/* csum entries are not larger in the casefolded encrypted case */
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   ext4_dir_rec_len(0,
+					   ext4_dirent_rec_len(0,
 							   csum ? NULL : dir));
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
@@ -1553,7 +1553,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* do minimal checking `by hand' */
 		if (de->name + de->name_len <= dlimit &&
 		    (!ext4_hash_in_dirent(dir) ||
-		     (char *)de + ext4_dir_rec_len(de->name_len, dir) <= dlimit) &&
+		     (char *)de + ext4_dirent_rec_len(de->name_len, dir) <= dlimit) &&
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
@@ -1937,7 +1937,7 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = ext4_dir_rec_len(de->name_len, dir);
+		rec_len = ext4_dir_entry_len(de, blocksize, dir);
 
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
@@ -1970,7 +1970,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = ext4_dir_rec_len(de->name_len, dir);
+			rec_len = ext4_dir_entry_len(de, blocksize, dir);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -2122,10 +2122,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		      void *buf, int buf_size,
 		      struct ext4_filename *fname,
-		      struct ext4_dir_entry_2 **dest_de)
+		      struct ext4_dir_entry_2 **dest_de,
+		      int dlen)
 {
 	struct ext4_dir_entry_2 *de;
-	unsigned short reclen = ext4_dir_rec_len(fname_len(fname), dir);
+	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen, dir);
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
@@ -2138,7 +2139,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			return -EFSCORRUPTED;
 		if (ext4_match(dir, fname, de))
 			return -EEXIST;
-		nlen = ext4_dir_rec_len(de->name_len, dir);
+		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
@@ -2161,7 +2162,7 @@ void ext4_insert_dentry(struct inode *dir,
 
 	int nlen, rlen;
 
-	nlen = ext4_dir_rec_len(de->name_len, dir);
+	nlen = ext4_dir_entry_len(de, buf_size, dir);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -2206,9 +2207,27 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 
 	if (!de) {
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
-					blocksize - csum_size, fname, &de);
+					blocksize - csum_size, fname, &de, 0);
 		if (err)
 			return err;
+	} else {
+		/*
+		 * do_split() hands over the last entry of a half.  Its length
+		 * comes from on-disk dirdata, so check that the new entry fits
+		 * before anything is written.
+		 */
+		unsigned int nlen = de->inode ?
+			ext4_dir_entry_len(de, blocksize, dir) : 0;
+		unsigned int rlen = ext4_rec_len_from_disk(de->rec_len,
+							   blocksize);
+
+		if (nlen > rlen ||
+		    rlen - nlen < ext4_dirent_rec_len(fname_len(fname), dir)) {
+			EXT4_ERROR_INODE(dir,
+				"no room for new entry in split block %llu",
+				(unsigned long long)bh->b_blocknr);
+			return -EFSCORRUPTED;
+		}
 	}
 	BUFFER_TRACE(bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, dir->i_sb, bh,
@@ -3032,7 +3051,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
+	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
 					   blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -3044,7 +3063,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 	if (inline_buf) {
 		de->rec_len = ext4_rec_len_to_disk(
-					ext4_dir_rec_len(de->name_len, NULL),
+					ext4_dirent_rec_len(de->name_len, NULL),
 					blocksize);
 		de = ext4_next_entry(de, blocksize);
 		header_size = (char *)de - bh->b_data;
@@ -3053,7 +3072,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dir_rec_len(1, NULL)),
+					(csum_size + ext4_dirent_rec_len(1, NULL)),
 					blocksize);
 	}
 
@@ -3176,8 +3195,8 @@ bool ext4_empty_dir(struct inode *inode)
 	}
 
 	sb = inode->i_sb;
-	if (inode->i_size < ext4_dir_rec_len(1, NULL) +
-					ext4_dir_rec_len(2, NULL)) {
+	if (inode->i_size < ext4_dirent_rec_len(1, NULL) +
+					ext4_dirent_rec_len(2, NULL)) {
 		EXT4_ERROR_INODE(inode, "invalid size");
 		return false;
 	}
-- 
2.52.0

