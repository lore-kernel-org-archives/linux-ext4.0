From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsprogs: make ext2fs_free() to set the pointer to
 NULL
Date: Thu, 20 Feb 2014 12:05:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402201200450.2245@localhost.localdomain>
References: <1392810496-9090-1-git-send-email-lczerner@redhat.com> <20140219175713.GA21436@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaBTLFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 06:05:49 -0500
In-Reply-To: <20140219175713.GA21436@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 19 Feb 2014, Theodore Ts'o wrote:

> Date: Wed, 19 Feb 2014 12:57:14 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] e2fsprogs: make ext2fs_free() to set the pointer to NULL
> 
> On Wed, Feb 19, 2014 at 12:48:16PM +0100, Lukas Czerner wrote:
> > Currently someone uses ext2fs_free() to free the ext2_filsys structure,
> > he is also responsible to set the pointer to that structure to NULL,
> > because ext2fs_free() is not able to do that.
> > 
> > This however is in contrast with ext2fs_free_mem() which requires as an
> > argument pointer to the pointer and it will in fact set the pointer to
> > NULL for us. This is probably the reason why majority of places where we
> > use ext2fs_free() does not set the pointer to NULL afterwards.
> > 
> > Fix this by changing function ext2fs_free() so that it'll require
> > pointer to the ext2_filsys as an argument and will be able to set the
> > pointer to NULL for us.
> > 
> > I do not currently have any way to trigger the issue in recent
> > e2fsprogs. Part of the reason is that there are some fixes which just
> > obfuscates the real problem (for example
> > 7ff040f30f0ff3bf5e2c832da3cb577e00a52d60) and the other part might be
> > just coincidence.
> > 
> > I was however able to reproduce this with e2fsprogs 1.42.9 using the
> > image in bug https://bugzilla.redhat.com/show_bug.cgi?id=997982. With
> > this patch it fixes it. However I am not sure why it got fixed in the
> > recent e2fsprogs since git bisect lands into the merge commit - however
> > I think it's just a coincidence rather than targeted fix.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> This results in an ABI change, so if there are any userspace programs
> which are linked against the libext2fs shared library, it would break.
> 
> So we have two choices:
> 
> 1) Audit all of the callers of ext2fs_freefs to see if it's necessary
> to clear the pointer.  If the pointer is about to be overwritten, or
> it's on a stack-allocated variable that will disappear as soon as you
> return, it's not a problem.  Given that your patch had to change every
> single ext2fs_free() call stack, it's relatively easy to make sure we
> don't miss any.  :-)
> 
> 2)  Define a new ext2fs_freefs2() which takes the changed interface.
> 
> I'm not entirely convinced that (2) is worth it, but certainly (1)
> would be a good thing to do.

I though that having the solution (2) would save us future problems
that is why I went this one. But If you really think it's not worth it,
I am fine with the (1) as well.

I'll send a patch.

Thanks!
-Lukas

> 
> It may be that the problem you couldn't replicate in the latest
> version of e2fsprogs was one that was fixed either when I did my
> periodic valgrind test runs, or as a result of reviewing all of the
> coverity warnings.
> 
> Cheers,
> 
> 							- Ted
> 
> 
