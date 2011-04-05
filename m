From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: sync the directory inode in ext4_sync_parent()
Date: Tue, 05 Apr 2011 12:35:38 -0700
Message-ID: <4D9B6F0A.5080705@redhat.com>
References: <1302031663-13547-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab1DETfm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Apr 2011 15:35:42 -0400
In-Reply-To: <1302031663-13547-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/5/11 12:27 PM, Curt Wohlgemuth wrote:
> ext4 has taken the stance that, in the absence of a journal,
> when an fsync/fdatasync of an inode is done, the parent
> directory should be sync'ed if this inode entry is new.
> ext4_sync_parent(), which implements this, does indeed sync
> the dirent pages for parent directories, but it does not
> sync the directory *inode*.  This patch fixes this.
> 
> I tested this using a power fail test, which panics a
> machine running a file server getting requests from a
> client.  Without this patch, on about every other test run,
> the server is missing many, many files that had been synced.
> With this patch, on > 6 runs, I see zero files being lost.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
>  fs/ext4/fsync.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 7f74019..a276348 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -128,6 +128,7 @@ extern int ext4_flush_completed_IO(struct inode *inode)
>  static void ext4_sync_parent(struct inode *inode)
>  {
>  	struct dentry *dentry = NULL;
> +	int ret;
>  
>  	while (inode && ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
>  		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
> @@ -136,7 +137,15 @@ static void ext4_sync_parent(struct inode *inode)
>  		if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
>  			break;
>  		inode = dentry->d_parent->d_inode;
> -		sync_mapping_buffers(inode->i_mapping);
> +		ret = sync_mapping_buffers(inode->i_mapping);
> +		if (! ret) {
> +			struct writeback_control wbc = {
> +				.sync_mode = WB_SYNC_ALL,
> +				.nr_to_write = 0, /* metadata-only; caller
> +						     takes care of data */
> +			};
> +			(void)sync_inode(inode, &wbc);

I know ext4_sync_parent was a void already, but why don't we send errors back up through ext4_sync_file?

-Eric

> +		}
>  	}
>  }
>  

