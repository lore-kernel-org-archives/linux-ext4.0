From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs 1.42-WIP busted on big endian
Date: Tue, 8 Nov 2011 15:28:09 -0500
Message-ID: <20111108202809.GO24234@thunk.org>
References: <4EB958E5.3080604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37566 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1KHU2L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Nov 2011 15:28:11 -0500
Content-Disposition: inline
In-Reply-To: <4EB958E5.3080604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 08, 2011 at 10:29:25AM -0600, Eric Sandeen wrote:
> This was noted in commit ccc7cf032852dd5c84b227bafb481b1d158e2b5e:
> 
> 
> commit ccc7cf032852dd5c84b227bafb481b1d158e2b5e
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Fri Jul 30 18:41:47 2010 -0400
> 
>     libext2fs: fix obvious big-endian bugs introduced by 64-bit changes
>     
>     These patches fix obvious bone-headed mistakes, so e2fsprogs will now
>     build and mostly work on powerpc.  The m_meta_bg, u_mke2fs, and
>     u_tune2fs tests are still failing, however, so there's still work to do...
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> but not fixed yet.  Just a heads up, when contemplating a 1.42
> release.  I will try to find some time to look into it, but it's not
> a simple regression, something must have gone wrong in the bowls of
> 64-bitness.

Um, thanks for reminding me!  I'll try to schedule time to look at
them later in this week, but if you get a chance ahead of me, let me
know if you make any progress.

One of the other things on my todo list is I noticed that apparently I
accidently broke the shared library ABI for the e2tools package, and
I need to figure out what I need to fix up so that e2tools doesn't
have to be recompiled.

						- Ted

       
