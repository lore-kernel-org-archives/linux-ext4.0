From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Date: Wed, 10 Sep 2008 07:40:42 -0400
Message-ID: <20080910114042.GA15996@infradead.org>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYIJLko (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 07:40:44 -0400
Content-Disposition: inline
In-Reply-To: <20080910114011.GB3757@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2008 at 02:40:12PM +0300, Kirill A. Shutemov wrote:
> On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
> > On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> > > linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
> > 
> > And who cares?  
> 
> It breaks building pam_mktemp at least.

pam_mktemp should not use <linux/ext2_fs.h>, but rather
<ext2fs/ext2_fs.h>.

