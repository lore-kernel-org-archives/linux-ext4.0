From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 21/22] Add support for pmd_faults
Date: Mon, 23 Dec 2013 20:54:33 +0200
Message-ID: <20131223185433.GA18067@node.dhcp.inet.fi>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
 <e944917f571781b46ca4dbb789ae8a86c5166059.1387748521.git.matthew.r.wilcox@intel.com>
 <20131223134113.GA14806@node.dhcp.inet.fi>
 <20131223145031.GB11091@parisc-linux.org>
 <20131223151003.GA15744@node.dhcp.inet.fi>
 <20131223184222.GE11091@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:50546 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3LWSyp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 13:54:45 -0500
Content-Disposition: inline
In-Reply-To: <20131223184222.GE11091@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 11:42:22AM -0700, Matthew Wilcox wrote:
> > Do you know anyone who relay on SIGBUS for correctness?
> 
> Oh, I remember the real reason now.  If we install a PMD that hangs off
> the end of the file then by reading past i_size, we can read the blocks of
> whatever happens to be in storage after the end of the file, which could
> be another file's data.  This doesn't happen for the PTE case because the
> existing code only works for filesystems with a block size == PAGE_SIZE.

I see. It's valid reason. Probably, it's better to add comment there.

-- 
 Kirill A. Shutemov
