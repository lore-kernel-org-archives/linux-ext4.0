From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 23/45] CacheFiles: Be consistent about the use of	mapping
 vs file->f_mapping in Ext3 [ver #41]
Date: Sat, 22 Nov 2008 11:38:39 -0600
Message-ID: <20081122173839.GJ3186@webber.adilger.int>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
 <20081120144338.10667.55564.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20081120144338.10667.55564.stgit@warthog.procyon.org.uk>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 20, 2008  14:43 +0000, David Howells wrote:
> Change all the usages of file->f_mapping in ext3_*write_end() functions to use
> the mapping argument directly.  This has two consequences:
> 
>  (*) Consistency.  Without this patch sometimes one is used and sometimes the
>      other is.
> 
>  (*) A NULL file pointer can be passed.  This feature is then made use of by
>      the generic hook in the next patch, which is used by CacheFiles to write
>      pages to a file without setting up a file struct.

The same patch is needed for ext4.

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/ext3/inode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index f8424ad..10c4c19 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1230,7 +1230,7 @@ static int ext3_generic_write_end(struct file *file,
>  				loff_t pos, unsigned len, unsigned copied,
>  				struct page *page, void *fsdata)
>  {
> -	struct inode *inode = file->f_mapping->host;
> +	struct inode *inode = mapping->host;
>  
>  	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
>  
> @@ -1255,7 +1255,7 @@ static int ext3_ordered_write_end(struct file *file,
>  				struct page *page, void *fsdata)
>  {
>  	handle_t *handle = ext3_journal_current_handle();
> -	struct inode *inode = file->f_mapping->host;
> +	struct inode *inode = mapping->host;
>  	unsigned from, to;
>  	int ret = 0, ret2;
>  
> @@ -1297,7 +1297,7 @@ static int ext3_writeback_write_end(struct file *file,
>  				struct page *page, void *fsdata)
>  {
>  	handle_t *handle = ext3_journal_current_handle();
> -	struct inode *inode = file->f_mapping->host;
> +	struct inode *inode = mapping->host;
>  	int ret = 0, ret2;
>  	loff_t new_i_size;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

