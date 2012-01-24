From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: mount other filesystems with selinux context
 as well
Date: Tue, 24 Jan 2012 12:45:00 -0500
Message-ID: <20120124174500.GB9853@infradead.org>
References: <4ECD3262.105@redhat.com>
 <20111128110228.GC13766@infradead.org>
 <4F1862FC.1050401@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49258
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167Ab2AXRpC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jan 2012 12:45:02 -0500
Content-Disposition: inline
In-Reply-To: <4F1862FC.1050401@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 19, 2012 at 12:37:48PM -0600, Eric Sandeen wrote:
> > shouldn't the "export SELINUX_MOUNT_OPTIONS" simply move to common code?
> 
> I wasn't sure if nfs would grok it.

I don't think it does - selinux needs special handling for filesystems
that do not support xattrs.

