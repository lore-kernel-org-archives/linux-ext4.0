From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an invalid file system
Date: Mon, 28 May 2012 14:29:05 -0600
Message-ID: <4790434C-0DF2-4186-BE4C-CE97633F107C@dilger.ca>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60339 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab2E1U3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 May 2012 16:29:06 -0400
In-Reply-To: <1338226422-8845-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-28, at 11:33 AM, Theodore Ts'o wrote:
> If we rmdir a directory which is a hard link to '.', we will deadlock
> trying to grab the directory's i_mutex.  Check for this condition and
> return EINVAL, which is what we return if the user attempts to rmdir
> "/foo/bar/."
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> fs/namei.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 0062dd1..081f872 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2774,6 +2774,17 @@ static long do_rmdir(int dfd, const char __user *pathname)
> 		error = -ENOENT;
> 		goto exit3;
> 	}
> +	if (nd.path.dentry->d_inode == dentry->d_inode) {
> +		/*
> +		 * Corrupt file system where there is a symlink to
> +		 * '.'; treat it as if we are trying to rmdir '.'
> +		 *
> +		 * XXX Should we call into the low-level file system
> +		 * to request that the file system be marked corrupt?
> +		 */
> +		error = -EINVAL;
> +		goto exit3;
> +	}
> 	error = mnt_want_write(nd.path.mnt);
> 	if (error)
> 		goto exit3;

This patch is good from the POV of covering all filesystems, and
avoiding the deadlock at the dcache level.  It would be possible to
detect this problem in the filesystem itself during lookup, before
the bad link got into the dcache itself.  Something like:

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 349d7b3..4a9c99d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1037,6 +1037,12 @@ static struct dentry *ext4_lookup(struct inode
 			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
 			return ERR_PTR(-EIO);
 		}
+		if (ino == dir->i_ino) {
+			EXT4_ERROR_INODE(dir, "'%.*s' linked to parent dir",
+					 dentry->d_name.len,
+					 dentry->d_name.name);
+			return ERR_PTR(-EIO);
+		}
 		inode = ext4_iget(dir->i_sb, ino);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,

Though -EIO could be replaced with -EBADF or -ELOOP, or something else.


Cheers, Andreas





