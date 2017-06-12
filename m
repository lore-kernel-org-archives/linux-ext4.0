From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 14/20] dax: set errors in mapping when writeback fails
Date: Mon, 12 Jun 2017 05:44:01 -0700
Message-ID: <20170612124401.GB18360@infradead.org>
References: <20170612122316.13244-1-jlayton@redhat.com>
 <20170612122316.13244-19-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
	tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
	ross.zwisler@linux.intel.com, corbet@lwn.net,
	Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
	David Sterba <dsterba@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170612122316.13244-19-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 12, 2017 at 08:23:10AM -0400, Jeff Layton wrote:
> For now, only do this when the FS_WB_ERRSEQ flag is set. The
> AS_EIO/AS_ENOSPC flags are not currently cleared in the older code when
> writeback initiation fails, only when we discover an error after waiting
> on writeback to complete, so we only want to do this with errseq_t based
> error handling to prevent seeing duplicate errors on fsync.

Please make sure this doens't stay conditional by the end of the series.
We only have three file systems using dax, and a series should be able
to make them agree on a single interface.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
