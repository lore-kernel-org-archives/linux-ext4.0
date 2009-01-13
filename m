From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext2: Update also inode on disk when dir is IS_DIRSYNC
Date: Tue, 13 Jan 2009 15:17:16 -0800
Message-ID: <20090113151716.cefb738b.akpm@linux-foundation.org>
References: <1231850522-11074-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jack@suse.cz, pavel@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758497AbZAMXRx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 18:17:53 -0500
In-Reply-To: <1231850522-11074-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 13 Jan 2009 13:42:02 +0100
Jan Kara <jack@suse.cz> wrote:

> We used to just write changed page for IS_DIRSYNC inodes. But we also have to
> update directory inode itself just for the case that we've allocated a new
> block and changed i_size.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> CC: Pavel Machek <pavel@suse.cz>
> ---
>  fs/ext2/dir.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
>   Andrew, would you please merge the patch? Ext3 and ext4 don't have this
> problem BTW.
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index 9a0fc40..7fba549 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -94,11 +94,10 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
>  		i_size_write(dir, pos+len);
>  		mark_inode_dirty(dir);
>  	}
> +	unlock_page(page);
>  
>  	if (IS_DIRSYNC(dir))
> -		err = write_one_page(page, 1);
> -	else
> -		unlock_page(page);
> +		err = ext2_sync_inode(dir);
>  

But with this change we no longer sync the data page?  Don't we need
something like this:

static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
{
	struct address_space *mapping = page->mapping;
	struct inode *dir = mapping->host;
	int err = 0;

	dir->i_version++;
	block_write_end(NULL, mapping, pos, len, len, page, NULL);

	if (pos+len > dir->i_size) {
		i_size_write(dir, pos+len);
		mark_inode_dirty(dir);
	}

	if (IS_DIRSYNC(dir)) {
		err = write_one_page(page, 1);
		if (err == 0)
			err = ext2_sync_inode(dir);
	} else {
		unlock_page(page);
	}

	return err;
}

?
