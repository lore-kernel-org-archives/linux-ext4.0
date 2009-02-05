From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Thu, 5 Feb 2009 08:49:05 -0500
Message-ID: <20090205134905.GL8945@mit.edu>
References: <498AD58B.5000805@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43245 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZBENtL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 08:49:11 -0500
Content-Disposition: inline
In-Reply-To: <498AD58B.5000805@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 01:03:23PM +0100, Thiemo Nagel wrote:
> But there also are cases which are not handled gracefully by bmap() callers.
>
> I've attached a conceptual patch against 2.6.29-rc2 which fixes one case  
> in which invalid block numbers are returned (there might be more) by  
> adding sanity checks to ext4_ext_find_extent(), but before I start  
> looking for further occurences, I'd like to ask whether you think my  
> approach is reasonable.

Yes, it's reasonable; the right thing is not just to jump out to
errout, though, but to call ext4_error() first, since the filesystem is
clearly corrupted, so we want to mark the filesystem as needing to be
fsck'ed, and so if the filesystem is marked "remount readonly" or
"panic" on filesystem errors, that the right thing happens.  We should
also log the device name, inode number and logical block number that
was requested, so that someone who is looking in the console logs can
see what was going on at the time.

As an unrelated patch, might also want to put a check in
fs/ext4/inode.c's ext4_get_branch(), so we can equivalently detect
bogus direct/indirect blocks and flag them with the appropriate
errors. 

						- Ted
