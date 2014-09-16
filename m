From: Christoph Lameter <cl@linux.com>
Subject: Re: Best way to pin a page in ext4?
Date: Tue, 16 Sep 2014 13:34:37 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1409161330480.21297@gentwo.org>
References: <20140915185102.0944158037A@closure.thunk.org> <36321733-F488-49E3-8733-C6758F83DFA1@dilger.ca> <20140916180759.GI6205@thunk.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@dilger.ca>, linux-mm <linux-mm@kvack.org>,
    linux-ext4@vger.kernel.org, hughd@google.com,
    Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140916180759.GI6205@thunk.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 16 Sep 2014, Theodore Ts'o wrote:

> > It doesn't seem unreasonable to just grab an extra refcount on the pages
> > when they are first loaded.
>
> Well yes, but using mlock_vma_page() would be a bit more efficient,
> and technically, more correct than simply elevating the refcount.

mlocked pages can be affected by page migration. They are not
pinned since POSIX only says that the pages must stay in memory. So the OS
is free to move them around physical memory.

Pinned pages have an elevated refcount. Note also Peter Zijlstra's
recent work on pinned pages.

https://lkml.org/lkml/2014/5/26/345

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
