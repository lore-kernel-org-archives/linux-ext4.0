From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix build w/o quota
Date: Wed, 23 Oct 2013 11:29:06 -0500
Message-ID: <5267F952.5040402@redhat.com>
References: <52615CC0.7010007@redhat.com> <20131023125147.GA31449@orion.maiolino.org> <20131023152251.GC21448@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab3JWQ3K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 12:29:10 -0400
In-Reply-To: <20131023152251.GC21448@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/23/13 10:22 AM, Theodore Ts'o wrote:
> On Wed, Oct 23, 2013 at 10:51:48AM -0200, Carlos Maiolino wrote:
>> Hey Eric,
>>
>> I did a test here building the e2fsprogs -next tree without quota support and I
>> didn't have any problems configuring and compiling it. Can you share the test
>> you did and failed?
>>
> 
> I've been able to replicate the problem. You may need to rm -rf your
> build directory and then run from scratch to see it.

yes, make clean doesn't remove it, even git clean doesn't; it's in
.gitignore (why?)

> Sorry for not responding sooner; I'm in Edinburgh this week and in
> conference mode.

no problem, I guess that's why I asked :)

> The reason why we have continud building libquota even when libsupport
> is not defined is because the plan is to rename libquota to libsupport
> once 1.42.x is released.  Libquota/libsupport is desinged to never be
> built as a shared library, and the idea is to move things like
> e2fsck/profile.c which is used by e2fsck and mke2fs, into libsupport.
> The rational for that is that the functions in libquota are already
> horribly e2fsprogs specific and aren't really set up to be usable as a
> generic quota support library.  So we might as well make it be a
> standardized place for internal support functions used by multiple
> e2fsprogs programs.
> 
> I'll try to find a fix that minimizes deltas between the maint branch
> and the next branch.

Maybe just revert part of "quota: fix disabling quota, add quota tests" ?

Did that actually do more good than harm?

-Eric

> Cheers,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

