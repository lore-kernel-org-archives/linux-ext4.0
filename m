Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F76199FB0;
	Sun, 26 Apr 2026 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777183811; cv=none; b=dT+UFTIpFLaZJOcOLjFpRXenxkZIr1ThupGl7huEbvzV7ReSmd3WXH1HM2siyIxQhwF3BSPcHG6O5DGZyMgG8foQcecUOmpC4rLXWuCsmnulW2QwlGtfk97i3c+37w+zvdgXPFB4pyH5XnJ+9up15/euDTjIVB2xNRjvhoi6bfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777183811; c=relaxed/simple;
	bh=3N3qSO6MSIoGnvIb9NPtscc7rRE2OiowJp5tLfBb7YQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I3HcaPRwecyaaIzeKastr+vJfb3O8TEVCv61hUiDvaQwehgCSO0wVgmnnvYGYa35gPSayNTs6SHYJntlnIc23f+DrY4jJaRqA52ZKsfgIiY9PjsqWprX4pLCtVFLgt8HPgKV+DbA4un6dPy56J8DhlJC0wibmayBZU5dzPbTu0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=OlCHV83d; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="OlCHV83d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VkekR0ZQnUPB8h/ezh7yPJ5uGQoJ/UJN/CJfNPlzUlA=; b=OlCHV83dFVTNE7YCwNCWT10V6S
	TLgmd35QRm5CKtkkdiTNBYuhOrC2SGR1GnzRMNWW1yGIZmgdHuOg9JxnejZ8PsY9GR7yTAfS2c579
	naKT4eS6R90RdrHXmhgYGauZIXVdjLUcubvnGyCEAjSm/+/wfL7ZvTaFUWlwuKOtwZqZXyqACIAlm
	Pxi85any2T6FsOujDvx85cwSFHjUuOeGuGMcm9WrOHxTfm62PRx/bDtjZ3RUSlvCGeO54ePrxZ5wb
	FhJYfav4AmH5VMNKE74N7aFJhIaQHmvPytPyBRpp2ENTPGbnygi0w42/LF2sbBC/ONUjdnNks146b
	Bq4vCbWw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wGsgz-00000004Hq9-1D63;
	Sun, 26 Apr 2026 06:10:09 +0000
Date: Sun, 26 Apr 2026 07:10:09 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: why does ext4_sync_parent() bother with d_find_any_alias() at all?
Message-ID: <20260426061009.GQ3518998@ZenIV>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

	The caller has a dentry for that inode, after all...
Am I missing something there?  IOW, is there anything wrong
with something like (untested) patch below?

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 924726dcc85f..c635cd732c2e 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -43,16 +43,14 @@
  * the parent directory's parent as well, and so on recursively, if
  * they are also freshly created.
  */
-static int ext4_sync_parent(struct inode *inode)
+static int ext4_sync_parent(struct inode *inode, struct dentry *dentry)
 {
-	struct dentry *dentry, *next;
+	struct dentry *next;
 	int ret = 0;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY))
 		return 0;
-	dentry = d_find_any_alias(inode);
-	if (!dentry)
-		return 0;
+	dget(dentry);
 	while (ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
 
@@ -99,7 +97,7 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	if (ret)
 		return ret;
 
-	ret = ext4_sync_parent(inode);
+	ret = ext4_sync_parent(inode, file->f_path.dentry);
 
 	if (test_opt(inode->i_sb, BARRIER))
 		*needs_barrier = true;
