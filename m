From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V3] mke2fs: prevent creation of filesystem with
 unsupported revision
Date: Fri, 4 Jul 2014 15:32:06 -0400
Message-ID: <20140704193206.GC11103@thunk.org>
References: <5362A6A2.7040504@redhat.com>
 <5362B105.9080702@redhat.com>
 <5362CC14.2070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Frank Sorenson <fsorenso@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45707 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbaGDTcJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 15:32:09 -0400
Content-Disposition: inline
In-Reply-To: <5362CC14.2070902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 05:35:00PM -0500, Eric Sandeen wrote:
> From: Frank Sorenson <fsorenso@redhat.com>
> 
> It's a bit strange to accept revision levels higher than
> the code creating the filesystem can understand, so don't
> allow it.
> 
> At least the kernel will mount the fs readonly if it's too
> high, but no other utility will touch it, so you can't
> fix the error.
> 
> Just reject anything > EXT2_MAX_SUPP_REV at mkfs time.
> 
> Signed-off-by: Frank Sorenson <fsorenso@redhat.com>
> [sandeen@redhat.com: Add more verbose commit log]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
