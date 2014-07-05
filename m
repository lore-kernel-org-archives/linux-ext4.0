From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 V2] e2fsprogs: revise and extend chattr(1) and chattr
 usage()
Date: Fri, 4 Jul 2014 23:05:27 -0400
Message-ID: <20140705030527.GF11103@thunk.org>
References: <53A36F0E.6090105@redhat.com>
 <53A37129.2040409@redhat.com>
 <53A44679.4020001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46302 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbaGEDF2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 23:05:28 -0400
Content-Disposition: inline
In-Reply-To: <53A44679.4020001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 20, 2014 at 09:34:33AM -0500, Eric Sandeen wrote:
> The chattr(1) manpage and chattr usage() output were missing some flags.
> 
> Add those, and make some other minor cosmetic fixes.
> 
> (I've left out the 'B' (EXT2_COMPRBLK_FL) flag, because
> it's not actually used anywhere, and I can't figure out
> how it differs from 'c' (EXT2_COMPR_FL))
> 
> Also, because the matrix of filesystems & flags is quite large,
> refer to filesystem-specific manpages for detailed discussion
> of flags supported by those filesystems, rather than trying to
> cover it all in this manpage.  I'll send those manpage
> updates to the appropriate lists a bit later.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
