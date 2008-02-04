From: Theodore Tso <tytso@mit.edu>
Subject: Re: - disable-ext4.patch removed from -mm tree
Date: Mon, 4 Feb 2008 15:30:29 -0500
Message-ID: <20080204203029.GN18392@mit.edu>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org> <20080203122551.6830370a.akpm@linux-foundation.org> <20080204013626.GE18392@mit.edu> <20080203191540.3cb2660b.akpm@linux-foundation.org> <20080204150044.GK18392@mit.edu> <20080204121131.a6e07705.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53755 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758144AbYBDUbJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 15:31:09 -0500
Content-Disposition: inline
In-Reply-To: <20080204121131.a6e07705.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 04, 2008 at 12:11:31PM -0800, Andrew Morton wrote:
> 
> That patch series is kind of logjammed anyway because it breaks isofs. 
> Last time I discussed this with David he seemed to find this amusing rather
> than an urgent problem.  I'd drop the whole lot if there weren't lots of
> other patches dependent upon them.  Mayeb I can do a selective droppage,
> but I hate going out-of-order, and merging untested patch combinations.
> 

All of the patches which move from using iget() to iget_unlocked()
should in theory (if they are well written) be standalone and not have
any prerequisites, and a good thing to apply in and of themselves.  

So maybe the right thing to do is to push all of them right away, and
then if they all can go in safely w/o breaking filesystems, we can
actually do the deed about removing the iget() interface itself, and
if not, it can wait until 2.6.26.  It's not really that big of a deal
to actually nuke the interface itself, as long as we are gradually
reducing our usage of it....  Or is there some patch which David is
trying to push that desperately depends on iget() going away?

						- Ted
