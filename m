From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv1, RFC 00/33] ext4: support of huge pages
Date: Wed, 27 Jul 2016 13:33:35 +0300
Message-ID: <20160727103335.GE11776@node.shutemov.name>
References: <1469493335-3622-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20160726172938.GA9284@thunk.org>
 <20160726191212.GA11776@node.shutemov.name>
 <20160727091723.GG6860@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160727091723.GG6860@quack2.suse.cz>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 27, 2016 at 11:17:23AM +0200, Jan Kara wrote:
> On Tue 26-07-16 22:12:12, Kirill A. Shutemov wrote:
> > On Tue, Jul 26, 2016 at 01:29:38PM -0400, Theodore Ts'o wrote:
> > > On Tue, Jul 26, 2016 at 03:35:02AM +0300, Kirill A. Shutemov wrote:
> > > > Here's the first version of my patchset which intended to bring huge pages
> > > > to ext4. It's not yet ready for applying or serious use, but good enough
> > > > to show the approach.
> > > 
> > > Thanks.  The major issues I noticed when doing a quick scan of the
> > > patches you've already mentioned here.  I'll try to take a closer look
> > > in the next week or so when I have time.
> > 
> > Thanks.
> > 
> > > One random question --- in the huge=always approach, how much
> > > additional work would be needed to support file systems with a 64k
> > > block size on a system with 4k pages?
> > 
> > I think it's totally different story.
> > 
> > Here I have block size smaller than page size and it's not new to the
> > filesystem -- similar to 1k block size with 4k page size. So I was able to
> > re-use most of infrastructure to handle the situation.
> > 
> > Block size bigger than page size is backward task. I don't think I know
> > enough to understand how hard it would be. I guess not easy. :)
> 
> I think Ted wanted to ask: When you always have huge pages in page cache,
> block size of 64k is smaller than the page size of the page cache so there
> are chances it could work. Or is there anything which still exposes the
> fact that actual pages are 4k even in huge=always case?

As usual with THP, if we failed to allocate huge page, we fallback to 4k
pages. It's normal situation to have both huge and small pages in the same
radix tree.

I guess you can get work 64k blocks with 4k pages if you *always* allocate
order-4 pages for page cache of the filesystem. But I don't think it's
sustainable. It's significant pressure on buddy allocator and compaction.

I guess the right approach would a mechanism to scatter one block to
multiple order-0 pages. At least for fallback.

-- 
 Kirill A. Shutemov
