From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add another fallocate test to 214
Date: Wed, 6 Jan 2010 11:49:44 -0500
Message-ID: <20100106164944.GA20137@infradead.org>
References: <4B427731.9080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0AFQtq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 11:49:46 -0500
Content-Disposition: inline
In-Reply-To: <4B427731.9080801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 04, 2010 at 05:18:09PM -0600, Eric Sandeen wrote:
> ext4 had a regression where it double-accounted used blocks
> if you fallocated on top of delalloc blocks.  Ted sent a
> c program to exploit it (see "fsstress-induced corruption reproduced"
> on linux-ext4 on 12/31/2009) and it's trivial to do the same thing
> within the xfstests framework using xfs_io.
> 
> This also changes the handcrafted xfs_io tests to use the
> _require_xfs_io_falloc helper, not sure how that got missed.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

