From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 16/18] ext4: use errseq_t based error handling for
 reporting data writeback errors
Date: Thu, 29 Jun 2017 07:12:21 -0700
Message-ID: <20170629141221.GA17251@infradead.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
 <20170629131954.28733-17-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
	tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
	ross.zwisler@linux.intel.com, corbet@lwn.net,
	Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
	David Sterba <dsterba@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org
To: jlayton@kernel.org
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170629131954.28733-17-jlayton@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

> -	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
> -		return -EIO;
> +	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb)))) {
> +		ret = -EIO;
> +		goto out;
> +	}

This just seems to add a call to trace_ext4_sync_file_exit for this
case, which seems unrelated to the patch.

>  	if (ret)
> -		return ret;
> +		goto out;
> +

Same here.

>  	/*
>  	 * data=writeback,ordered:
>  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
> @@ -152,7 +155,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		needs_barrier = true;
>  	ret = jbd2_complete_transaction(journal, commit_tid);
>  	if (needs_barrier) {
> -	issue_flush:
> +issue_flush:
>  		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);

And while I much prefer your new label placement it also doesn't
seem to belong into this patch.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
