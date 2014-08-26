From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add supported file attributes to ext4.5
 manpage
Date: Mon, 25 Aug 2014 21:02:40 -0400
Message-ID: <20140826010240.GA11317@thunk.org>
References: <53F4E2CA.80004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48833 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbaHZBCm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 21:02:42 -0400
Content-Disposition: inline
In-Reply-To: <53F4E2CA.80004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2014 at 01:02:50PM -0500, Eric Sandeen wrote:
> The chattr(1) manpage now refers users to filesystem-specific
> manpages for details on supported attributes, so add those to
> ext4.5.
> 
> I've left out oddities like being able to set the compressed
> or no-tail-packing flags, or setting data journaling on ext2.
> 
> That behavior seems like a bug, not a feature.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied to the maint branch.

					- Ted
