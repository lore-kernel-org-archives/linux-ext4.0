From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: pair trace_ext4_writepages &
 trace_ext4_writepages_result
Date: Thu, 17 Oct 2013 15:31:34 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310171531040.3212@localhost.localdomain>
References: <1382012926-398-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1382012926-398-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 17 Oct 2013, Ming Lei wrote:

> Date: Thu, 17 Oct 2013 20:28:46 +0800
> From: Ming Lei <ming.lei@canonical.com>
> To: linux-kernel@vger.kernel.org
> Cc: Jan Kara <jack@suse.cz>, Ming Lei <ming.lei@canonical.com>,
>     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Subject: [PATCH] ext4: pair trace_ext4_writepages &
>     trace_ext4_writepages_result
> 
> Pair the two trace events to make troubeshooting writepages
> easier, and it should be more convinient to write a simple script
> to parse the traces.
> 
> Cc: Ted Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

It looks good.

Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> ---
>  fs/ext4/inode.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 32beaa4..0ad73d4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2420,16 +2420,15 @@ static int ext4_writepages(struct address_space *mapping,
>  	 * because that could violate lock ordering on umount
>  	 */
>  	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
> -		return 0;
> +		goto out_writepages;
>  
>  	if (ext4_should_journal_data(inode)) {
>  		struct blk_plug plug;
> -		int ret;
>  
>  		blk_start_plug(&plug);
>  		ret = write_cache_pages(mapping, wbc, __writepage, mapping);
>  		blk_finish_plug(&plug);
> -		return ret;
> +		goto out_writepages;
>  	}
>  
>  	/*
> @@ -2442,8 +2441,10 @@ static int ext4_writepages(struct address_space *mapping,
>  	 * *never* be called, so if that ever happens, we would want
>  	 * the stack trace.
>  	 */
> -	if (unlikely(sbi->s_mount_flags & EXT4_MF_FS_ABORTED))
> -		return -EROFS;
> +	if (unlikely(sbi->s_mount_flags & EXT4_MF_FS_ABORTED)) {
> +		ret = -EROFS;
> +		goto out_writepages;
> +	}
>  
>  	if (ext4_should_dioread_nolock(inode)) {
>  		/*
> 
