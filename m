From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v6 12/20] fs: add a new fstype flag to indicate how
 writeback errors are tracked
Date: Tue, 13 Jun 2017 06:24:32 -0400
Message-ID: <1497349472.5762.1.camel@redhat.com>
References: <20170612122316.13244-1-jlayton@redhat.com>
	 <20170612122316.13244-15-jlayton@redhat.com>
	 <20170612124513.GC18360@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@ZenIV.linux.org.uk>,  Jan Kara <jack@suse.cz>, tytso@mit.edu,
 axboe@kernel.dk, mawilcox@microsoft.com,  ross.zwisler@linux.intel.com,
 corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
 David Sterba <dsterba@suse.com>, "Darrick J . Wong"
 <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,  linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
  linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170612124513.GC18360@infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2017-06-12 at 05:45 -0700, Christoph Hellwig wrote:
> On Mon, Jun 12, 2017 at 08:23:06AM -0400, Jeff Layton wrote:
> > Add a new FS_WB_ERRSEQ flag to the fstype. Later patches will set and
> > key off of that to decide what behavior should be used.
> 
> Please invert this so that only file systems that keep the old semantics
> need a flag.


That's definitely what I want for the endgame here. My plan was to add
this flag for now, and then eventually reverse it (or drop it) once all
or most filesystems are converted.

We can do it that way from the get-go if you like. It'll mean tossing in
 a patch add this flag to all filesystems that have an fsync operation
and that use the pagecache, and then gradually remove it from them as we
convert them.

Which method do you prefer?
-- 
Jeff Layton <jlayton@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
