From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Log inode exhaustion to dmesg
Date: Mon, 23 Oct 2017 08:04:41 -0400
Message-ID: <20171023120441.ia63kvt4uj7o7im3@thunk.org>
References: <20171023120247.lsupeazdwwpaisek@gaztest-VM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Team Athena <teamathena.nitc@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49426 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932111AbdJWMEp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 23 Oct 2017 08:04:45 -0400
Content-Disposition: inline
In-Reply-To: <20171023120247.lsupeazdwwpaisek@gaztest-VM>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The Signed-off-by needs to contain your real name (sorry, no
pseudonyms or anonymous contributions.)  That's because it has a
formal legal meaning.  See Section 11: "Sign your work - the
Developer’s Certificate of Origin" of the Submitting Patches
docuementation:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

(Also, you should use ext4_warning() and not a bare printk).

						- Ted

On Mon, Oct 23, 2017 at 05:32:47PM +0530, Team Athena wrote:
> Make a log in dmesg when file creation fails due to no free inodes.
> The error code for both "out of disk space" and "out of inode" is the same.
> This is misleading to the user. Logging the exact reason helps to find and
> correct the issue from the users' side.
> 
> Fix bug 197335 - https://bugzilla.kernel.org/show_bug.cgi?id=197335
> 
> Signed-off-by: Team Athena <teamathena.nitc@gmail.com>
> ---
>  fs/ext4/namei.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index c1cf020d..c3990d2d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2463,6 +2463,8 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  		ext4_journal_stop(handle);
>  	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
>  		goto retry;
> +	else if (err == -ENOSPC && printk_ratelimited())
> +		printk(pr_warning "ext4: No space on disk, inode usage full");
>  	return err;
>  }
>  
> -- 
> 2.11.0
> 
