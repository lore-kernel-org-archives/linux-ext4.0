From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE
 using fallocate
Date: Fri, 30 Apr 2010 14:33:19 -0700
Message-ID: <20100430143319.d51d6d77.akpm@linux-foundation.org>
References: <201004281854.49730.knikanth@suse.de>
	<4BD85F1F.7030100@suse.de>
	<201004291014.07194.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: coly.li@suse.de, Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757426Ab0D3VeA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Apr 2010 17:34:00 -0400
In-Reply-To: <201004291014.07194.knikanth@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(Amit Arora <aarora@in.ibm.com> wrote fallocate.  cc added)

On Thu, 29 Apr 2010 10:14:06 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> Here is an updated patch that takes the i_mutex and calls inode_newsize_ok()
> only for regular files.

err, no.  It's taking i_lock where it meant to take i_mutex.

> Thanks
> Nikanth
> 
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
> index 74e5cd9..4ca57c9 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -405,17 +405,26 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (S_ISFIFO(inode->i_mode))
>  		return -ESPIPE;
>  
> -	/*
> -	 * Let individual file system decide if it supports preallocation
> -	 * for directories or not.
> -	 */
> -	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> -		return -ENODEV;
> -
> -	/* Check for wrap through zero too */
> -	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
> +	/* Check for wrap through zero */
> +	if (offset+len < 0)
>  		return -EFBIG;

I suggest that this test be moved up to where the function tests `if
(offset < 0 || len <= 0)' - it seems more logical.

Also,

-	if (offset+len < 0)
+	if (offset + len < 0)

for consistency with most other kernel code, please.

> +	if (S_ISREG(inode->i_mode)) {
> +		spin_lock(&inode->i_lock);
> +		ret = inode_newsize_ok(inode, (offset + len));
> +		spin_unlock(&inode->i_lock);
> +		if (ret)
> +			return ret;
> +	} else if (S_ISDIR(inode->i_mode)) {
> +		/*
> +		 * Let individual file system decide if it supports
> +		 * preallocation for directories or not.
> +		 */
> +		if (offset > inode->i_sb->s_maxbytes)
> +			return -EFBIG;
> +	} else
> +		return -ENODEV;
> +
>  	if (!inode->i_op->fallocate)
>  		return -EOPNOTSUPP;

Also, there doesn't seem to be much point in doing

	mutex_lock(i_mutex);
	if (some_condition)
		bale out
	mutex_unlock(i_mutex);

	<stuff>

because `some_condition' can now become true before or during the
execution of `stuff'.

IOW, it's racy.
