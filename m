From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] ext4: remove ext4_dir_llseek
Date: Wed, 25 Apr 2012 14:23:14 -0500
Message-ID: <4F984F22.10203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab2DYTXP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Apr 2012 15:23:15 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3PJNFwF027208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Apr 2012 15:23:15 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q3PJNEcF031445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Apr 2012 15:23:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_dir_llseek() was recently added as part of a patch to allow
returning 64-bit name hashes.  However, reworking _llseek() is not
necessary to achieve that goal.  One unfortunate side effect of the
change is that it cut&pasted VFS code back into ext4, after Andi
had just removed other _llseek cut&paste in ext4 by extending the
VFS functionality.

It also re-introduced i_mutex locking in the dir llseek paths,
un-doing the upstream (mostly) lockless llseek changes from Andi
in this case.

Because of the above reasons, and because it introduces new
EINVAL returns which were not there before, and because SEEK_END+offset
behaves differently from SEEK_SET w.r.t. offset limits, and because
it's not clear what problem this is solving, remove it for now.

(NFS only uses SEEK_SET and SEEK_CUR, so changes to SEEK_END shouldn't
affect it.)

If & when a problematic and testable real-world use case is described,
this can be re-fixed properly, possibly by expanding the VFS _llseek()
functions to handle custom EOF offsets for cases such as this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Ok, I'm being something of a devil's advocate here, but - if the change
is to stay, it needs to be documented & justified with a real-world
usecase, I think?  The net effect of the changes seems to be using the
max hash value for offset limits and for EOF, not i_size and s_maxbytes.

<viro> frankly, seeks on directories have always been a source of PITA
<viro> what userland code do you have that does SEEK_END - offset on directories?

and - I didn't have an answer...

I do also have a VFS patch in my back pocket to override EOF & s_maxbytes limits,
but we'll need a good explanation of why it's warranted, I think.

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index b867862..4542d30 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -310,78 +310,6 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
 		return EXT4_HTREE_EOF_64BIT;
 }
 
-
-/*
- * ext4_dir_llseek() based on generic_file_llseek() to handle both
- * non-htree and htree directories, where the "offset" is in terms
- * of the filename hash value instead of the byte offset.
- *
- * NOTE: offsets obtained *before* ext4_set_inode_flag(dir, EXT4_INODE_INDEX)
- *       will be invalid once the directory was converted into a dx directory
- */
-loff_t ext4_dir_llseek(struct file *file, loff_t offset, int origin)
-{
-	struct inode *inode = file->f_mapping->host;
-	loff_t ret = -EINVAL;
-	int dx_dir = is_dx_dir(inode);
-
-	mutex_lock(&inode->i_mutex);
-
-	/* NOTE: relative offsets with dx directories might not work
-	 *       as expected, as it is difficult to figure out the
-	 *       correct offset between dx hashes */
-
-	switch (origin) {
-	case SEEK_END:
-		if (unlikely(offset > 0))
-			goto out_err; /* not supported for directories */
-
-		/* so only negative offsets are left, does that have a
-		 * meaning for directories at all? */
-		if (dx_dir)
-			offset += ext4_get_htree_eof(file);
-		else
-			offset += inode->i_size;
-		break;
-	case SEEK_CUR:
-		/*
-		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
-		 * position-querying operation.  Avoid rewriting the "same"
-		 * f_pos value back to the file because a concurrent read(),
-		 * write() or lseek() might have altered it
-		 */
-		if (offset == 0) {
-			offset = file->f_pos;
-			goto out_ok;
-		}
-
-		offset += file->f_pos;
-		break;
-	}
-
-	if (unlikely(offset < 0))
-		goto out_err;
-
-	if (!dx_dir) {
-		if (offset > inode->i_sb->s_maxbytes)
-			goto out_err;
-	} else if (offset > ext4_get_htree_eof(file))
-		goto out_err;
-
-	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
-	}
-
-out_ok:
-	ret = offset;
-out_err:
-	mutex_unlock(&inode->i_mutex);
-
-	return ret;
-}
