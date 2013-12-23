From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v4 21/22] Add support for pmd_faults
Date: Mon, 23 Dec 2013 11:42:22 -0700
Message-ID: <20131223184222.GE11091@parisc-linux.org>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com> <e944917f571781b46ca4dbb789ae8a86c5166059.1387748521.git.matthew.r.wilcox@intel.com> <20131223134113.GA14806@node.dhcp.inet.fi> <20131223145031.GB11091@parisc-linux.org> <20131223151003.GA15744@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56230 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3LWSmY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 13:42:24 -0500
Content-Disposition: inline
In-Reply-To: <20131223151003.GA15744@node.dhcp.inet.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 05:10:03PM +0200, Kirill A. Shutemov wrote:
> On Mon, Dec 23, 2013 at 07:50:31AM -0700, Matthew Wilcox wrote:
> > On Mon, Dec 23, 2013 at 03:41:13PM +0200, Kirill A. Shutemov wrote:
> > > > +	/* Fall back to PTEs if we're going to COW */
> > > > +	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
> > > > +		return VM_FAULT_FALLBACK;
> > > 
> > > Why?
> > 
> > If somebody mmaps a file with MAP_PRIVATE and changes a single byte, I
> > think we should allocate a single page to hold that change, not a PMD's
> > worth of pages.
> 
> We try allocate new huge page in the same situation for AnonTHP. I don't
> see a reason why not to do the same here. It would be much harder (if
> possible) to collapse small page into a huge one later.

OK, I'll look at what AnonTHP does here.  There may be good reasons to
do it differently, but in the absence of data, we should probably handle
the two cases the same.

> > > > +	if ((pgoff | PG_PMD_COLOUR) >= size)
> > > > +		return VM_FAULT_FALLBACK;
> > > 
> > > I don't think it's necessary to fallback in this case.
> > > Do you care about SIGBUS behaviour or what?
> > 
> > I'm looking to preserve the same behaviour we see with PTE mappings.  I mean,
> > it's supposed to be _transparent_ huge pages, right?
> 
> We can't be totally transparent. At least from performance point of view.
> 
> The question is whether it's critical to preserve SIGBUS beheviour. I
> would prefer to map last page in mapping with huge pages too, if it's
> possible.
> 
> Do you know anyone who relay on SIGBUS for correctness?

Oh, I remember the real reason now.  If we install a PMD that hangs off
the end of the file then by reading past i_size, we can read the blocks of
whatever happens to be in storage after the end of the file, which could
be another file's data.  This doesn't happen for the PTE case because the
existing code only works for filesystems with a block size == PAGE_SIZE.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
