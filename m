From: Coly Li <coly.li@suse.de>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE using
 fallocate
Date: Thu, 29 Apr 2010 00:15:27 +0800
Message-ID: <4BD85F1F.7030100@suse.de>
References: <201004281854.49730.knikanth@suse.de>
Reply-To: coly.li@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Eelis <opensuse.org@contacts.eelis.net>
To: Nikanth Karthikesan <knikanth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0D1QCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Apr 2010 12:02:52 -0400
In-Reply-To: <201004281854.49730.knikanth@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 04/28/2010 09:24 PM, Nikanth Karthikesan Wrote:
> Prevent creation of files larger than RLIMIT_FSIZE using fallocate.
> 
> Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
> and create a file larger than the limit. Add a check for new size in
> the fallocate system call.
> 
> File-systems supporting fallocate such as ext4 are affected by this
> bug. 
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> Reported-by: Eelis - <opensuse.org@contacts.eelis.net>
> 
> ---
> 
> diff --git a/fs/open.c b/fs/open.c
> index 74e5cd9..95ce069 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -412,10 +412,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>  		return -ENODEV;
>  
> -	/* Check for wrap through zero too */
> -	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
> +	/* Check for wrap through zero */
> +	if (offset+len < 0)
>  		return -EFBIG;
>  
> +	ret = inode_newsize_ok(inode, (offset + len));
> +	if (ret)
> +		return ret;
> +
>  	if (!inode->i_op->fallocate)
>  		return -EOPNOTSUPP;
>  

Hi Nikanth,

>From definition of inode_newsize_ok(), it says,
 64 /**
 65  * inode_newsize_ok - may this inode be truncated to a given size
 66  * @inode:      the inode to be truncated
 67  * @offset:     the new size to assign to the inode
 68  * @Returns:    0 on success, -ve errno on failure
 69  *
 70  * inode_newsize_ok will check filesystem limits and ulimits to check that the
 71  * new inode size is within limits. inode_newsize_ok will also send SIGXFSZ
 72  * when necessary. Caller must not proceed with inode size change if failure is
 73  * returned. @inode must be a file (not directory), with appropriate
 74  * permissions to allow truncate (inode_newsize_ok does NOT check these
 75  * conditions).
 76  *
 77  * inode_newsize_ok must be called with i_mutex held.
 78  */

In execution path of do_fallocate(), it seems no i_mutex held, and inode might be directory. Using inode_newsize_ok()
might be confused ?

How about this one ?

 fs/open.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 74e5cd9..24d75a4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -383,6 +383,7 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
 int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
+	unsigned long limit;
 	long ret;

 	if (offset < 0 || len <= 0)
@@ -412,10 +413,19 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
 		return -ENODEV;

-	/* Check for wrap through zero too */
-	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
+	/* Check for wrap through zero */
+	if ((offset + len) < 0)
 		return -EFBIG;

+	/* Check for rlimit */
+	if ((offset + len) > inode->i_size) {
+		limit = rlimit(RLIMIT_FSIZE);
+		if (limit != RLIM_INFINITY && (offset + len) > limit)
+			return -EFBIG;
+		if ((offset + len) > inode->i_sb->s_maxbytes)
+			return -EFBIG;
+	}
+
 	if (!inode->i_op->fallocate)
 		return -EOPNOTSUPP;

Something I don't understand here is, why no i_mutex hold here ?

-- 
Coly Li
SuSE Labs
