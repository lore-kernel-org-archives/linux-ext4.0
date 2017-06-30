From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 17/18] xfs: minimal conversion to errseq_t writeback
 error reporting
Date: Fri, 30 Jun 2017 09:49:59 -0700
Message-ID: <20170630164959.GA2395@infradead.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
 <20170629131954.28733-18-jlayton@kernel.org>
 <20170629141235.GB17251@infradead.org>
 <1498841154.4689.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, jlayton@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
	tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
	ross.zwisler@linux.intel.com, corbet@lwn.net,
	Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
	David Sterba <dsterba@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>,
	Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1498841154.4689.1.camel@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 30, 2017 at 12:45:54PM -0400, Jeff Layton wrote:
> Should I aim to do that with an individual patch for each fs, or is it
> better to do a swath of them all at once in a single patch here?

I'd be perfectly happy with one big patch for all the trivial
conversions.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
