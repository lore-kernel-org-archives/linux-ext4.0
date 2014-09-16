From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Best way to pin a page in ext4?
Date: Tue, 16 Sep 2014 14:56:39 -0400
Message-ID: <20140916185639.GM6205@thunk.org>
References: <20140915185102.0944158037A@closure.thunk.org>
 <36321733-F488-49E3-8733-C6758F83DFA1@dilger.ca>
 <20140916180759.GI6205@thunk.org>
 <alpine.DEB.2.11.1409161330480.21297@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-mm <linux-mm@kvack.org>,
	linux-ext4@vger.kernel.org, hughd@google.com,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409161330480.21297@gentwo.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 16, 2014 at 01:34:37PM -0500, Christoph Lameter wrote:
> On Tue, 16 Sep 2014, Theodore Ts'o wrote:
> 
> > > It doesn't seem unreasonable to just grab an extra refcount on the pages
> > > when they are first loaded.
> >
> > Well yes, but using mlock_vma_page() would be a bit more efficient,
> > and technically, more correct than simply elevating the refcount.
> 
> mlocked pages can be affected by page migration. They are not
> pinned since POSIX only says that the pages must stay in memory. So the OS
> is free to move them around physical memory.

And indeed, that would be a better reason to use mlock_vma_page()
rather than elevating the refcount; we just need the page to stay in
memory.  If the mm system needs to move the page around to coalesce
for hugepages, or some such, that's fine.

(And so the subject line in my original post is wrong; apologies, I'm
a fs developer, not a mm developer, and so I used the wrong
terminology.)

Cheers,

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
