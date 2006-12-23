From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] delayed allocation for ext4
Date: Sat, 23 Dec 2006 22:09:57 +0300
Message-ID: <m3zm9etomy.fsf@bzzz.home.net>
References: <m37iwjwumf.fsf@bzzz.home.net>
	<20061223033123.GL44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppp85-141-207-24.pppoe.mtu-net.ru ([85.141.207.24]:60414 "EHLO
	gw.home.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753677AbWLWTKJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Dec 2006 14:10:09 -0500
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061223033123.GL44411608@melbourne.sgi.com> (David Chinner's
	message of "Sat\, 23 Dec 2006 14\:31\:23 +1100")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Good day,

>>>>> David Chinner (DC) writes:

 DC> So that mean's we'll have 2 separate mechanisms for marking
 DC> pages as delalloc. XFS uses the BH_delay flag to indicate
 DC> that a buffer (block) attached to the page is using delalloc.

well, for blocksize=pagesize we can save 56 bytes on every page.

 DC> FWIW, how does this mechanism deal with block size < page size?
 DC> Don't you have to track delalloc on a block basis rather than
 DC> a page basis?

I'm still thinking how better to deal with that w/o much code duplication.

 DC> Ah, that's why you can get away with a page flag - you've ignored
 DC> the partial page delay state problem. Any plans to use the
 DC> existing method in the future so we will be able to use ext4 delalloc
 DC> on machines with a page size larger than 4k?

what do you mean by "exsiting"? BH_delay?


thanks, Alex
