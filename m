From: Jim Meyering <jim@meyering.net>
Subject: Re: bug#8411: due to missing sync even on 2.6.39, cp fails to copy an odd file
Date: Sun, 03 Apr 2011 12:15:17 +0200
Message-ID: <87wrjbd4ju.fsf@rho.meyering.net>
References: <87fwq0gay0.fsf@rho.meyering.net>
	<4D9724AC.2070009@draigBrady.com> <8739m0g3u7.fsf@rho.meyering.net>
	<87d3l4edb1.fsf@rho.meyering.net> <20110402230005.GL21075@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	8411@debbugs.gnu.org, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:36965 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab1DCKP1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Apr 2011 06:15:27 -0400
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 1881F940280
	for <linux-ext4@vger.kernel.org>; Sun,  3 Apr 2011 12:15:19 +0200 (CEST)
In-Reply-To: <20110402230005.GL21075@thunk.org> (Ted Ts'o's message of "Sat, 2
	Apr 2011 19:00:05 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
> On Sat, Apr 02, 2011 at 08:08:34PM +0200, Jim Meyering wrote:
>> From 0a6d128d0d17c1604245f1caafe6af73584a0bb8 Mon Sep 17 00:00:00 2001
>> From: Jim Meyering <meyering@redhat.com>
>> Date: Sat, 2 Apr 2011 19:59:30 +0200
>> Subject: [PATCH] copy: require fiemap sync also for 2.6.38 and 2.6.39 kernels
>>
>> * src/extent-scan.c (extent_need_sync): Require sync also for 2.6.38
>> and 2.6.39.  Without this, part of the cp/fiemap-empty test would fail
>> both on F15-to-be and rawhide.  For discussion and details, see:
>> http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/22190
>
> FYI, the following fix has been merged into mainline, which should fix
> the problem for 2.6.39 once it is finally released, at least for ext4.
> It was merged right before Linus released 2.6.39-rc1.  I'm assuming
> that Rawhide released a pre-2.6.39-rc1 kernel in the middle of the
> merge window.
>
> Some distro's will informally, but incorrectly, refer to such a
> release as "2.6.39-rc0".  I prefer the more technically correct
> 2.6.38-git18 (which is the first git tag in the Linux git repo which
> contained the patch below, as of March 25, 2011).  Unfortunately, RPM
> doesn't understand that 2.6.38-rc1 sorts before 2.6.38, while
> 2.6.38-git17 sorts *after* 2.6.38.  (Hence the incorrect, but
> convenient, use of 2.6.39-rc0.)

Right.  Rawhide's 2.6.39-0.rc0.git11.0.fc16.x86_64 kernel
is from March 22.

Good.  That means we needn't condemn 2.6.39.
This sort of uname-based kernel check is precisely
why we should minimize use of -rcN named kernels,
but if it affects only rawhide (and that only briefly),
I won't complain too loudly.
