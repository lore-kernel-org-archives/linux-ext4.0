From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v8 17/18] xfs: minimal conversion to errseq_t writeback
 error reporting
Date: Fri, 30 Jun 2017 12:45:54 -0400
Message-ID: <1498841154.4689.1.camel@redhat.com>
References: <20170629131954.28733-1-jlayton@kernel.org>
	 <20170629131954.28733-18-jlayton@kernel.org>
	 <20170629141235.GB17251@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@ZenIV.linux.org.uk>,  Jan Kara <jack@suse.cz>, tytso@mit.edu,
 axboe@kernel.dk, mawilcox@microsoft.com,  ross.zwisler@linux.intel.com,
 corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
 David Sterba <dsterba@suse.com>, "Darrick J . Wong"
 <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu
 Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Liu Bo
 <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, jlayton@kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170629141235.GB17251@infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2017-06-29 at 07:12 -0700, Christoph Hellwig wrote:
> Nice and simple, this looks great!
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks! I think this turned out to be a lot cleaner too.

For filesystems that use filemap_write_and_wait_range today this now
becomes a pretty straight conversion to file_write_and_wait_range -- one
liner patches for the most part.

I've started rolling patches to do that, but now I'm wondering...

Should I aim to do that with an individual patch for each fs, or is it
better to do a swath of them all at once in a single patch here?
-- 
Jeff Layton <jlayton@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
