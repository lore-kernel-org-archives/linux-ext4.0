From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 16:51:25 +0200
Message-ID: <20061023145125.GD19623@atrey.karlin.mff.cuni.cz>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:17055 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S964902AbWJWOug (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Oct 2006 10:50:36 -0400
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3vembnlwz.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> >>>>> Theodore Tso (TT) writes:
> 
>  TT> On Mon, Oct 23, 2006 at 02:27:10PM +0200, Jan Kara wrote:
>  >> Hello,
>  >> 
>  >> I've written a simple patch implementing ext3 ioctl for file
>  >> relocation. Basically you call ioctl on a file, give it list of blocks
>  >> and it relocates the file into given blocks (provided they are still
>  >> free). The idea is to use it as a kernel part of ext3 online
>  >> defragmenter (or generally disk access optimizer). 
> 
> isn't that a kernel responsbility to find/allocate target blocks?
> wouldn't it better to specify desirable target group and minimal
> acceptable chunk of free blocks?
  Kernel definitely allocates those blocks (because it's the only
reasonably race-free way). The problem of finding those blocks is a bit
harder - it may be quite complicated decision where to put the file
(also given, that sometimes you may need to "shift away" some file to
make space for some other one). Also what I'm aiming for is, that
userspace defragmenter could be fed some "access patterns" and it
optimizes layout of several files to speedup startup (i.e. blocks of
those several files would be interleaved so that their sequence is close
to the one seen during start-up).

								Honza
