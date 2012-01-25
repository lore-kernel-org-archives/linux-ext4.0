From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests: mount other filesystems with selinux
 context as well
Date: Wed, 25 Jan 2012 16:14:38 -0500
Message-ID: <20120125211438.GA11821@infradead.org>
References: <4ECD3262.105@redhat.com>
 <20111128110228.GC13766@infradead.org>
 <4F1862FC.1050401@sandeen.net>
 <20120124174500.GB9853@infradead.org>
 <4F20700B.8060307@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54800
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182Ab2AYVOk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jan 2012 16:14:40 -0500
Content-Disposition: inline
In-Reply-To: <4F20700B.8060307@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 25, 2012 at 03:11:39PM -0600, Eric Sandeen wrote:
> For some reason, non-xfs filesystems aren't getting mounted with
> the selinux context; perhaps because none of the xattr tests used
> to work on anything but xfs?
> 
> Anyway, 062 fails for extN unless we mount with the fs-wide
> context.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> ps: eparis says this should work for NFS as well, let's go for
> it and if infrequently tested filesystems have trouble we can
> exclude them as necessary.

Verifying that assumption isn't hard, please do it.

