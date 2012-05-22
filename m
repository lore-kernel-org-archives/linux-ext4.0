From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix 64-bit journal support
Date: Tue, 22 May 2012 13:01:07 -0400
Message-ID: <20120522170107.GA6352@thunk.org>
References: <E1SWe75-0007rd-TQ@tytso-glaptop.cam.corp.google.com>
 <4FBBAFCB.2080106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56210 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab2EVRBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 May 2012 13:01:12 -0400
Content-Disposition: inline
In-Reply-To: <4FBBAFCB.2080106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 22, 2012 at 10:24:59AM -0500, Eric Sandeen wrote:
> 
> How do you decide between using "unsigned long long" and "blk64_t" below?
> 

Consistency more than anything else.  At least at one point
e2fsck/recovery.c was supposed to be identical to the kernel's
fs/jbd2/recovery.c, and so that meant we tried to use avoid using both
kernel-specific idioms that would be hard to replicate in userspace
(but we do quite a bit of that; see e2fsck/jfs_user.h) as well as
userspace-specific idioms/typedefs that don't work well in the kernel
context.  Over time the two have drifted apart, and a good future
project would be to try to bring them closer together so that bugs in
one are more likely to be correctly fixed in the other.

The other headache is with %llu in printf strings.  One of the
problems with using blk64_t is that we don't know whether it's an
unsigned int or an unsigned long or an unsigned long long, and that
causes all sorts of warnings with respect to printf format strings.
We *can* fix it via a cast to an unsigned long long and using %llu,
but it makes the code quite ugly.

So it's a bit simpler to use %llu and just use unsigned long long,
since we don't support any platform where long long is 128 bits, and
on pretty much all Linux systems, long long is pretty consistently 64
bits.  I wouldn't do this on anything that was an on-disk
representation, of course, but in this case I figured it was easier
just to use an "unsigned long long" in the struct buffer_head in
jfs_user.h, and then I made everything consistent with that.

	    	       	    	       		  - Ted
