From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 11175] New: ext3 BUG in add_dirent_to_buf+0x6c/0x269
Date: Wed, 30 Jul 2008 00:03:48 -0400
Message-ID: <20080730040348.GA8956@mit.edu>
References: <bug-11175-27@http.bugzilla.kernel.org/> <20080729171207.d88728cf.akpm@linux-foundation.org> <20080730024856.GE29748@mit.edu> <488FDA0A.5020408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	kernel.bugzilla@asheesh.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48211 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbYG3EEb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 00:04:31 -0400
Content-Disposition: inline
In-Reply-To: <488FDA0A.5020408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:03:38PM -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > Hmm... disassembling the code, it's pretty clear the problem is here
> > in do_split(), around line 1208:
> > 
> > 	map = (struct dx_map_entry *) (data2 + blocksize);
> > 	count = dx_make_map ((struct ext3_dir_entry_2 *) data1,
> > 			     blocksize, hinfo, map);
> > 	map -= count;
> > 	dx_sort_map (map, count);
> > 	/* Split the existing block in the middle, size-wise */
> > 	size = 0;
> > 	move = 0;
> > 	for (i = count-1; i >= 0; i--) {
> > 		/* is more than half of this entry in 2nd half of the block? */
> > 		if (size + map[i].size/2 > blocksize/2)  <====
> 
> You sure this isn't our old friend
> https://bugzilla.redhat.com/show_bug.cgi?id=451068 ?
> 
> which version of gcc compiled this?

As we discussed on IRC, I think you're theory is dead on.  %ecx is at
the very end of the page-2, which would correspond to
map[count-1].size.  And size (%esi) is zero, which rules out my scenario.

This very much looks like a GCC bug.  Asheesh, can you confirm which
version of GCC you used to build your kernel?

Longer term, do_split() was coded in a very non-robust fashion.
Looking at do_split(), it was pretty easy to imagine corrupted
directory blocks that might force count to be 0 (causing the for loop
to do something insane, since i is unsigned), and adding some checks
to make sure that the split variable is neither 0 nor equal to count
might also be a really good idea.

					- Ted
