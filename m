From: Theodore Tso <tytso@mit.edu>
Subject: Re: one way to dmesg
Date: Thu, 5 Nov 2009 10:02:50 -0500
Message-ID: <20091105150250.GL6510@mit.edu>
References: <1257344804.2852.11.camel@zwerg> <87f94c370911040718k766d910fr23342c82d4632faa@mail.gmail.com> <1257348551.2091.1.camel@mini> <87f94c370911040746k49dce1f6ge8591f7714b8b19d@mail.gmail.com> <1257350354.2091.9.camel@mini>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>, linux-ext4@vger.kernel.org
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46445 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZKEPCu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2009 10:02:50 -0500
Content-Disposition: inline
In-Reply-To: <1257350354.2091.9.camel@mini>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 04, 2009 at 04:59:14PM +0100, Alexey Fisher wrote:
> 
> Great, look really nice :)
> but this is not all what i mean.
> For example fs specific messages: EXT4-fs blabla, if you look to source
> you'll see "EXT3 FS" "EXT II FS" (fat is worse), if you need to grep it
> will be nightmare. It seems like ext4 is mostly up to date, ext2/3 need
> some work. Are there any work on this?

What problem are you trying to solve?

Is it just an aesthetics thing?  Is there a specific scenario where
you need some kind of extra functionality?  If so, what is it?

There's some question about whether parsing dmesg is the best way to
get information about error/event reporting.  See the following
presentation from this year's Plumber's conference for a set of
ruminations on this issue:

http://linuxplumbersconf.org/2009/slides/Andi-Kleen-plumbers-error.pdf

						- Ted
