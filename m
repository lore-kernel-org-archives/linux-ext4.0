From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfstests: move xfs_io filters to common.filter
Date: Sat, 20 Jun 2009 13:59:16 -0400
Message-ID: <20090620175916.GB3984@infradead.org>
References: <4A370D00.7030309@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbZFTR7O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jun 2009 13:59:14 -0400
Content-Disposition: inline
In-Reply-To: <4A370D00.7030309@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 15, 2009 at 10:09:52PM -0500, Eric Sandeen wrote:
> Move duplicated xfs_io filters to common.filter
> 
> Also fix up 132 output, which was misfiltered due
> to a bug in the filtering.
> 
> Doing this because I need this same filter for the next
> added test.


Ah, nice - common filters for xfs_io output were long overdue.


Reviewed-by: Christoph Hellwig <hch@lst.de>

