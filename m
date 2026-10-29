Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276835;
	b=xcxzgsGr8t3M1cJ96QTaUtsxDtKH6txaeqJqjwKS5ShMDdj2IDfSi1JYBP5XAQwGzMzE
	 qLIcsBJdnOFUU4X7fYGSpMGDuGaV02QSzXC6acRpJb9rmiOgkTGZAQhNsaek9t9k0aZE1
	 VGVX5Gq/NC/TXfIBp9qcoHIN/MeRYYLcX5gpcFjL1oH8G03zNcdddvyOgw5A6IAOQ9YIL
	 YCIOb69WlGGlsyLrY0A7aCwCQziUk+0bQULjsfQIaOySGR0LYuRBAjlpRIPbTgO9tSuRr
	 Q4nqO2RxTebAMGop1orQ9P1VHs23eo8p4eR7V5JsVoFyPTZwmH90rEHy0xytwivx90Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276835;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=yT8FYe4mS2yBjLMyv3r97qIHTDKlEF4tXi21wYvfZKw=;
	b=AcAVrS1S3NwNFfQc92PZCgZBua7yYWX1TXs+6VkvQuErUmLMfLWU6A97Sx04EnfsAeB1
	 H1MFOOcccWLSPRMuuU4a5pRU0rFJBDYxHFVm8Xu7m3cwRzBekU/yLDPCaJc4ckeTyBgS+
	 +fFc++eVlNLZV9QArI88db5F1jqqzqSCMhKBUhN4CsnBxVy6gBQf955d8jSa/8/gSrnH3
	 xgaT195YkfHyfXQ12O6wKmrOdpHCa94INzNNi1BfLA0vS1jFdoH6AdOOEAmvZwklR9o4r
	 +xdlJ7rSTnHXFGgNzJJucHfgfkw0HRCoC69MLXq9i4txivbEN05YEe/wDEAEwmQPndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sc+Sl5Yl;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7AE606A32A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F7AE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sc+Sl5Yl
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9252975e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276834; x=1793881634; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yT8FYe4mS2yBjLMyv3r97qIHTDKlEF4tXi21wYvfZKw=;
        b=Sc+Sl5Ylaw6DUyvea3z4kpwvXIltEooXNHMF4XYx5XkeJfjINmHG2LMok+8PfXFdlz
         XJsOmdmthPmnbNTY1ni5pQzFNPytOd41pmONv98VwLb+qPNQ4vDj1gKSWOp8k+zLpXF7
         N7tAz+l1pv1XQ0MKlNeZojs93mYEftuJ8Y/8zxk2ZqFtrA/8RE8NxgJ43U3p3zDdalMV
         Rh+GiLMzzKPtg5cNyVv9VioFWXlsqSkluFB+vQWrwfevpBOZr9HZTB+38gAFukISB3hN
         O+T5JIrrNCQWfe1nskORKKdh2wdS1/TJtriAsnUTp7tVuuDtZ8qD8CM4rEPIN+0msW9O
         rc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276834; x=1793881634;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yT8FYe4mS2yBjLMyv3r97qIHTDKlEF4tXi21wYvfZKw=;
        b=oGZTnIDEcZhNi7YjiFdQ2UfFGB7CivYGhIMhtV88dEtvz7g2VsZtqzXCg93XelBw7A
         eF0ZrpiLjaDLPFgTQF6UuTkUv1Iwf37hMVYnUBi5dIhlgl7mhRKwKMANoBQ//ekEmfsS
         /nkeeCb8MsQmpwAoiy6p9jjzs1v99RyCrg4A1LhtgUx3CEe0sdkVKyaZY8k0m2qvAWBY
         gayWphpGdE46V+3J1Pf6AtORhhgMPa3POT6+9ceDIwtJxWqFPrwK0q0qALvXB5a9tFj6
         vl3eY4rooP9RtM4thIaPWIlFSa7NjhF6eJskNdYrXxaTNB7d/VFhK7S2gW/ZLct2w2bD
         l6VQ==
X-Gm-Message-State: AFq9FYKhjoy4qf8XNqQUViXxjz+TaTv8ExhIrEPf/NvBLqmq/3MZ8oYJ
	DayIdHQjayqiNkhlX80Vvl6dYUc4kR9OII4waQbYLI2oMVt2llWslfKZjq3Dvu/k
X-Gm-Gg: AYBFou3G4xQdbpZ9fYpCwUuxGNuZQl8+y9tTLED9c7xShiyzcdnLY9q1EvlWkku3SMs
	jSEypMfFGFxpOpco0KjHY4UyFjFc0JtnZcoYFSD1rHurp7kk/zGnVZVw0P3J+lBDLIzs3TOKOfy
	GDPJsq3RzDDZQ8EG4ciEIJew1IhPrzfj9s1x5toBjKzj4RC7j7W0smMrGXppDc/7X8UvSAtUyf/
	v7owC/z75tw3YLGOd9zdbRm5/DYxNaCFojAFpxYqLddQUxJnNcgtaDEWVVmXHF8/fPxXEe0iV/S
	XTM/gSGWnIjcpBp8yEpNqDNW7Way7MuziOQkTzvVn2E3Gq/wj6aY6/18FCvwME/CtZ07bGZ8aT+
	yniTR9WlZIAbKZAyZWvmAUKH4/xSZ3FGDDr6E80Og/yF78K45S6TNSEHITvSK5N/eZrgwumXy8S
	oVuO9Pz8w+uH1ubHP/US/4TjZywT75FhqhGMPlk9q90sftTcX+z6XnmkGqPCKvNadQD5/ljEs/h
	pwXjrBfYP8FXiVPKE606z41qbO+sLE+K6Kq7NhF1yRM1/o1fsfU4jnrTLOnqSA8aIBduGTxlCFi
	X/n19O8kIUHOAiTLyoqTYyB5EI/CxKXRoa6DNUZVfirUCNyq+rhwMY2th91+
X-Received: by 2002:a05:600c:6cf:b0:4a2:c41:d85b with SMTP id 5b1f17b1804b1-4aa8b060ac7mr46550975e9.17.1793276833233;
        Thu, 29 Oct 2026 05:27:13 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:12 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 07/11] ext4: rename ext4_dir_rec_len() and clarify dirdata usage
Date: Thu, 29 Oct 2026 12:24:06 +0000
Message-ID: <20261029122413.230409-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Rename ext4_dir_rec_len() to ext4_dirent_rec_len() to better
reflect that it computes the record length for a directory
entry based on the provided name length.

Update the comment to clarify handling of dirdata-enabled
directories and document the use of ext4_dir_entry_len()
when dirdata is present.

No functional changes.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/dir.c    | 15 +++++++--------
 fs/ext4/ext4.h   | 14 ++++++++++----
 fs/ext4/inline.c | 21 ++++++++++++---------
 fs/ext4/namei.c  | 33 +++++++++++++++++----------------
 4 files changed, 46 insertions(+), 37 deletions(-)

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
index 2d6d3be4ef7d..839274c4d7fc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2649,11 +2649,16 @@ struct ext4_dirent_hash {
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
 
 	/*
 	 * Without dirdata, the casefold+fscrypt hash lives at a fixed position
@@ -3069,7 +3074,8 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size,
 			     struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 **dest_de);
+			     struct ext4_dir_entry_2 **dest_de,
+			     int dlen);
 void ext4_insert_dentry(struct inode *dir, struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
@@ -4266,7 +4272,7 @@ static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
 	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
 	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
 
-	return ext4_dir_rec_len(de->name_len + dirdata, dir);
+	return ext4_dirent_rec_len(de->name_len + dirdata, dir);
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
index b3acab0689c9..e54608950fb3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -618,7 +618,7 @@ static inline unsigned dx_node_limit(struct inode *dir)
 	/* dx_node fake_dirent is always 8 bytes — it never carries a casefold
 	 * hash, so pass NULL to suppress the hash-size term. */
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, NULL);
+			ext4_dirent_rec_len(0, NULL);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -728,7 +728,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += ext4_dir_rec_len(de->name_len, dir);
+			space += ext4_dirent_rec_len(de->name_len, dir);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -1106,7 +1106,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	/* csum entries are not larger in the casefolded encrypted case */
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   ext4_dir_rec_len(0,
+					   ext4_dirent_rec_len(0,
 							   csum ? NULL : dir));
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
@@ -1518,7 +1518,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* do minimal checking `by hand' */
 		if (de->name + de->name_len <= dlimit &&
 		    (!ext4_hash_in_dirent(dir) ||
-		     (char *)de + ext4_dir_rec_len(de->name_len, dir) <= dlimit) &&
+		     (char *)de + ext4_dirent_rec_len(de->name_len, dir) <= dlimit) &&
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
@@ -1902,7 +1902,7 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = ext4_dir_rec_len(de->name_len, dir);
+		rec_len = ext4_dir_entry_len(de, blocksize, dir);
 
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
@@ -1935,7 +1935,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = ext4_dir_rec_len(de->name_len, dir);
+			rec_len = ext4_dir_entry_len(de, blocksize, dir);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -2087,10 +2087,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
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
@@ -2103,7 +2104,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			return -EFSCORRUPTED;
 		if (ext4_match(dir, fname, de))
 			return -EEXIST;
-		nlen = ext4_dir_rec_len(de->name_len, dir);
+		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
@@ -2126,7 +2127,7 @@ void ext4_insert_dentry(struct inode *dir,
 
 	int nlen, rlen;
 
-	nlen = ext4_dir_rec_len(de->name_len, dir);
+	nlen = ext4_dir_entry_len(de, buf_size, dir);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -2171,7 +2172,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 
 	if (!de) {
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
-					blocksize - csum_size, fname, &de);
+					blocksize - csum_size, fname, &de, 0);
 		if (err)
 			return err;
 	}
@@ -2995,7 +2996,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
+	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
 					   blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -3007,7 +3008,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 	if (inline_buf) {
 		de->rec_len = ext4_rec_len_to_disk(
-					ext4_dir_rec_len(de->name_len, NULL),
+					ext4_dirent_rec_len(de->name_len, NULL),
 					blocksize);
 		de = ext4_next_entry(de, blocksize);
 		header_size = (char *)de - bh->b_data;
@@ -3016,7 +3017,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dir_rec_len(1, NULL)),
+					(csum_size + ext4_dirent_rec_len(1, NULL)),
 					blocksize);
 	}
 
@@ -3139,8 +3140,8 @@ bool ext4_empty_dir(struct inode *inode)
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

