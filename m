From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 16/22] block: convert to errseq_t based writeback
 error tracking
Date: Tue, 20 Jun 2017 05:35:44 -0700
Message-ID: <20170620123544.GC19781@infradead.org>
References: <20170616193427.13955-1-jlayton@redhat.com>
 <20170616193427.13955-17-jlayton@redhat.com>
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
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170616193427.13955-17-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

>  	error = filemap_write_and_wait_range(filp->f_mapping, start, end);
>  	if (error)
> -		return error;
> +		goto out;
>  
>  	/*
>  	 * There is no need to serialise calls to blkdev_issue_flush with
> @@ -640,6 +640,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
>  	if (error == -EOPNOTSUPP)
>  		error = 0;
>  
> +out:
> +	wberr = filemap_report_wb_err(filp);
> +	if (!error)
> +		error = wberr;

Just curious: what's the reason filemap_write_and_wait_range couldn't
query for the error using filemap_report_wb_err internally?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
