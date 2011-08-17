From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: fake direct I/O mode for data=journal
Date: Wed, 17 Aug 2011 12:50:58 -0400
Message-ID: <20110817165058.GA6901@thunk.org>
References: <20110815180311.GC5948@thunk.org>
 <1313523145-31631-1-git-send-email-tytso@mit.edu>
 <20110817114252.GD9959@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49313 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab1HQQvC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 12:51:02 -0400
Content-Disposition: inline
In-Reply-To: <20110817114252.GD9959@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 17, 2011 at 01:42:52PM +0200, Jan Kara wrote:
>   Strictly speaking this is racy wrt. to fcntl() setting O_DIRECT bit.
> Fixing it is actually quite simple - just provide ext4_noop_direct_IO
> function that will just "return 0" and generic write code will fall
> back to buffered IO automatically. We don't want to use the fallback all
> the time since it incurs overhead of flushing and invalidating the mapping
> so what you did above will catch the common case.

Good point!  Yes, that's a much better way to do it.  Actually
ext4_noop_direct_IO() isn't good enough, since even with data=ordered
or data=journalled, because you can set the 'j' attribute to force the
file to use data journalling.  (This is true in ext3 as well, and I'm
not sure something sane happens if you force a file to be data
journalling and then do direct IO on it when in data=ordered or
data=writeback mode.)

						- Ted
