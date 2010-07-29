From: Chris Frost <chris@frostnet.net>
Subject: Re: [PATCH] mke2fs.8.in: correct the sign of a block-size
 constraint.
Date: Wed, 28 Jul 2010 21:11:09 -0700
Message-ID: <20100729041108.GA6251@pooh.frostnet.net>
References: <20100724220124.GO4032@pooh.frostnet.net>
 <4C4BC3DB.5000008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from owl.frostnet.net ([205.134.225.164]:45347 "EHLO
	owl.frostnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0G2ELX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jul 2010 00:11:23 -0400
Content-Disposition: inline
In-Reply-To: <4C4BC3DB.5000008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 24, 2010 at 11:55:55PM -0500, Eric Sandeen wrote:
> wow I didn't even know that behavior existed.
> 
> How about "If block-size is preceded by a negative sign ("-"), then mke2fs 
> will use heuristics to determine the appropriate block size, with the 
> constraint that the block size will be at least block-size bytes."

I think this is more readable; thanks!

-- 
Chris Frost
http://www.frostnet.net/chris/
