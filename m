From: Theodore Tso <tytso@mit.edu>
Subject: Re: - disable-ext4.patch removed from -mm tree
Date: Mon, 4 Feb 2008 10:00:44 -0500
Message-ID: <20080204150044.GK18392@mit.edu>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org> <20080203122551.6830370a.akpm@linux-foundation.org> <20080204013626.GE18392@mit.edu> <20080203191540.3cb2660b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39164 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943AbYBDPBT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 10:01:19 -0500
Content-Disposition: inline
In-Reply-To: <20080203191540.3cb2660b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 03, 2008 at 07:15:40PM -0800, Andrew Morton wrote:
> On Sun, 3 Feb 2008 20:36:26 -0500 Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Sun, Feb 03, 2008 at 12:25:51PM -0800, Andrew Morton wrote:
> > > When I merge David's iget coversion patches this will instead wreck the
> > > ext4 patchset.
> > 
> > That's ok, it shouldn't be hard for me to fix this up.  How quickly
> > will you be able to merge David's iget converstion patches?
> 
> They're about 1,000 patches back.

OK, if you're not planning on pushing David's changes to Linus right
away, what if I pull in David's

	iget-stop-ext4-from-using-iget-and-read_inode-try.patch 

and push it plus some other ext4 bug fixes directly to Linus, and let
you know when that has happened so you can drop David's patch from
your queue?

David's changes to ext4 can be applied standalone without the rest of
his series, so it would be safe to push that to Linus independently
and in advance of the rest of his series.  That should also help
reduce the number of inter-patch queue dependencies.

Regards,

       	       	      	      	  - Ted
