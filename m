From: Theodore Tso <tytso@mit.edu>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 08:28:58 -0500
Message-ID: <20080218132858.GA12568@mit.edu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218131209.GB21080@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Dilger <adilger@sun.com>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37048 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752488AbYBRN3d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 08:29:33 -0500
Content-Disposition: inline
In-Reply-To: <20080218131209.GB21080@cs181133002.pp.htv.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 03:12:09PM +0200, Adrian Bunk wrote:
> If me resending this old patch collides with something finally getting a 
> user this part of my patch shouldn't be applied now (but you might get 
> it again in 6 months if it's still unused...).
> 
> But generally such conflicts would become visible if "known development 
> trees that are intended for mainline" were in -mm.

It *has* been in -mm, except for periods when akpm has dropped it due
to conflicts due to the "must have an in-tree user" doctrinaire
attitude due to a conflict with the r/o bind patch.

Did you actually try to do a compile test, or only made sure the patch
would apply?  The patch won't collide at application time, but it
would when you compile it....

						- Ted
