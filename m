From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 04/20] fs: check for writeback errors after syncing
 out buffers in generic_file_fsync
Date: Mon, 24 Apr 2017 08:23:35 -0700
Message-ID: <20170424152335.GD9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-5-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-mm@kvack.org,
	jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org,
	linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org,
	dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org,
	ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com,
	viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com,
	tytso@mit.edu, axboe@kernel.dk
To: Jeff Layton <jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-5-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

>  out:
>  	inode_unlock(inode);
> -	return ret;
> +	err = filemap_check_errors(inode->i_mapping);
> +	return ret ? : err;

Can you spell out the whole unary operation instead of this weird GCC
extension?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
