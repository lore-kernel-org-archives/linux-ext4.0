From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck -D segfaults in pass 3A
Date: Thu, 13 Mar 2008 16:49:49 -0400
Message-ID: <20080313204949.GC28728@mit.edu>
References: <alpine.DEB.1.00.0803132116430.7433@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40503 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753892AbYCMUuC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 16:50:02 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803132116430.7433@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2008 at 09:23:19PM +0100, Christian Kujau wrote:
> After playing around with e2fsck (today's git of the "pu" branch) a bit 
> more, I still cannot use -D on this filesystem. I've tried with earlier 
> version, but it still dumps core in pass 3A (Optimizing directories). I've 
> compiled e2fsprogs with "CFLAGS="-g" ./configure --enable-htree; make", too 
> get a few more results when this happens. 

Yeah, thanks for pointing that out.  Pass3A doesn't deal with
directories stored in extent format yet, and you must have one or more
directories directories in extent format.   So e2fsck -D won't work.

This is a bug; I'll work on getting it fixed.

					- Ted
