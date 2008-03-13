From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck not fixing all corruptions on the first run?
Date: Thu, 13 Mar 2008 17:47:31 -0400
Message-ID: <20080313214731.GE28728@mit.edu>
References: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de> <20080313205426.GD28728@mit.edu> <alpine.DEB.1.00.0803132219590.7433@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44951 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753822AbYCMVrq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 17:47:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803132219590.7433@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2008 at 10:22:25PM +0100, Christian Kujau wrote:
> On Thu, 13 Mar 2008, Theodore Tso wrote:
>>> http://nerdbynature.de/bits/e2fsprogs.pu/md4.log
>>> http://nerdbynature.de/bits/e2fsprogs.pu/
>>
>> Hmm.  What I really need is *first* e2fsck run, to see what it did.
>
> The md4.log is the first e2fsck run:
>
> 1) mounted fs, noticed error message in dmesg
> 2) umounted fs
> 3) ran e2fsck, right on top of this md4.log file...
>
> The 2nd run is the one after the "/dev/md4: clean" message in md4.log

Oh, right.  Sorry, I missed that.  I think I know what's going on.
The problem is we're not supporting long symlinks which are in extents
format.  That's something which we changed, but we're going to change
back (since we need it to support filesystems with > 2**32 blocks).

I'll make e2fsprogs flexible enough to support both forms of long symlinks.

     	  	    	     	       	       	    - Ted
