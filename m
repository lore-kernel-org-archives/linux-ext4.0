From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Do not reserve clusters when fs doesn't support
 extents
Date: Sun, 8 Dec 2013 21:13:59 -0500
Message-ID: <20131209021359.GA27144@thunk.org>
References: <1385638965-14674-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37895 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab3LICOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Dec 2013 21:14:06 -0500
Content-Disposition: inline
In-Reply-To: <1385638965-14674-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 28, 2013 at 12:42:45PM +0100, Jan Kara wrote:
> When filesystem doesn't support extents (like in ext2/3 compatibility
> modes), there is no need to reserve any clusters. Space estimates for
> writing are exact, hole punching doesn't need new metadata, and there
> are no unwritten extents to convert.
> 
> This fixes a problem when filesystem still having some free space when
> accessed with a native ext2/3 driver suddently reports ENOSPC when
> accessed with ext4 driver.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.  Given that distro's are using
CONFIG_EXT4_USE_FOR_EXT23, I'm going to queue this for the stable kernel.

			       	     	- Ted
