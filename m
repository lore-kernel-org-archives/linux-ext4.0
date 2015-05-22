From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unused block group, but all blocks not free?
Date: Thu, 21 May 2015 22:28:38 -0400
Message-ID: <20150522022837.GC2750@thunk.org>
References: <555BDEF4.1020704@ubuntu.com>
 <20150520151007.GK2871@thunk.org>
 <555CA52F.3010109@ubuntu.com>
 <20150520163148.GA23989@thunk.org>
 <555D0541.1000804@ubuntu.com>
 <20150521235940.GB2750@thunk.org>
 <555E7371.9060207@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51665 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbbEVC2l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 May 2015 22:28:41 -0400
Content-Disposition: inline
In-Reply-To: <555E7371.9060207@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 21, 2015 at 08:08:17PM -0400, Phillip Susi wrote:
> 
> I wonder though, why I didn't see these problems the last time I used
> e2defrag, which was probably 2 years ago and was on a filesystem with
> a resize inode, and flex_bg and uninitialized bitmaps.  At the time it
> seemed that uninitialized bitmaps were not used on groups with blocks
> used for these sorts of things.  I guess that must also be a more
> recent change.

The change was that for uninitialized block bitmaps, dumpe2fs used to
display incorrect information (that is, it would claim all of the
blocks were free, even though in fact that was not true).

People complained this wasn't actually accurate, so what we are
currently doing is considered more correct(tm).

	  	   	      	   - Ted
