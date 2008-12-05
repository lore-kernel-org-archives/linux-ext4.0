From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v4] ext3, ext4: make i signed in do_split()
Date: Fri, 5 Dec 2008 11:32:01 -0500
Message-ID: <20081205163201.GG1323@mit.edu>
References: <49310E1A.60105@gmail.com> <20081202120751.8b0226ca.akpm@linux-foundation.org> <4935A21A.60509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50317 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752198AbYLEQci (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Dec 2008 11:32:38 -0500
Content-Disposition: inline
In-Reply-To: <4935A21A.60509@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2008 at 10:01:14PM +0100, Roel Kluin wrote:
> Andrew Morton wrote:
> > On Sat, 29 Nov 2008 04:40:42 -0500
> > roel kluin <roel.kluin@gmail.com> wrote:
> > 
> >> unsigned i >= 0 is always true
> 
> >> -	for (i = count-1; i >= 0; i--) {
> >> +	for (i = count-1; i < count; i--) {
> 			break;
> 
> > A local variable called `i' should always have signed type.  In fact,
> > it should have `int' type.
> 
> You are right. although count is unsigned, dx_make_map() returns int, which is
> assigned to count, so this should fit in an int. (If you ack this, make sure to
> get this patch, and not one of the others.)

ACK.  I'll take care of getting this into the patch queue.  I'll
include both the ext3 and ext4 variants, since this one is simple
enough that it's highly unlikely to conflict with anything Andrew
might have in the -mm tree.  This is also much more of a cleanup than
anything else, so I don't think we need to push it until the merge
window.  (I *think* it might be possible for a 2k filesystems and
*very* long filenames we might possibly be able to trigger a
failure but it would be very hard to do, and it's been around for a
very long time without anyone complaining about an actual real-life
problem getting trigger.)

						- Ted
