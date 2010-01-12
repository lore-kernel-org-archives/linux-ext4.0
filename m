From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
	option
Date: Tue, 12 Jan 2010 11:47:48 -0500
Message-ID: <20100112164748.GA26895@infradead.org>
References: <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com> <20100112124600.GA7151@infradead.org> <4B4C7297.5030905@redhat.com> <20100112163828.GA14633@infradead.org> <4B4CA6A9.3030401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Michal Novotny <minovotn@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0ALQrt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 11:47:49 -0500
Content-Disposition: inline
In-Reply-To: <4B4CA6A9.3030401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 12, 2010 at 05:43:21PM +0100, Michal Novotny wrote:
> So, do you think the problem is in the Xen backend drivers and to make  
> it working right in Xen the driver fix is needed?

Yes, the Xen blkback driver just submits I/O directly without using
the right interfaces to force cache coherency.  It might be relatively
easy to hack a call in to flush all caches when it starts up, but given
how it bypasses all abstractions it's almost impossible to give full
coherency as if using the normal block device interfaces.

