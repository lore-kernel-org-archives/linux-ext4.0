From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 11:30:36 -0600
Message-ID: <20070729173035.GU5992@schatzie.adilger.int>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <20070728195114.GA5952@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:55476 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXG2Rai (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2007 13:30:38 -0400
Content-Disposition: inline
In-Reply-To: <20070728195114.GA5952@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 28, 2007  20:51 +0100, Christoph Hellwig wrote:
> That doesn't mean I want to arge against Alex's code although I'd of
> course be more happy if we could actually shared code between multiple
> filesystems.
> 
> Of ourse the code in it's current form should not go into mpage.c but
> rather into ext4 so that it doesn't bloat the kernel for everyone.

Sigh, we HAVE a patch that was only adding delalloc to ext4, but it
was rejected because "that functionality should go into the VFS".
Since the performance improvement of delalloc is quite large, we'd
like to get this into the kernel one way or another.  Can we make a
decision if the ext4-specific delalloc is acceptable?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
