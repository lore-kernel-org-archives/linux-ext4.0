From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 update
Date: Thu, 25 Oct 2007 16:44:21 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0710251643120.30120@woody.linux-foundation.org>
References: <E1Ii0UI-0007TW-IM@closure.thunk.org>
 <alpine.LFD.0.999.0710170857490.26902@woody.linux-foundation.org>
 <20071025163113.491a4461.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbXJYXoa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 19:44:30 -0400
In-Reply-To: <20071025163113.491a4461.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Thu, 25 Oct 2007, Andrew Morton wrote:
> 
> There shouldn't have been conflicts here - if there were I wouldn't have
> sent those patches.  Unless there were things in the ext4 pull which
> weren't present in the ext4 quilt tree which I included in 2.6.23-mm1?

Well, you merge your patch-series by patching.

You should have noticed by now that GNU patch in particular will happily 
apply a patch whether it conflicts or not. So it's entirely possible that 
it didn't conflict for you, but applied cleanly and sanely.

		Linus
