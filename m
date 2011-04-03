From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: bug#8411: due to missing sync even on 2.6.39, cp fails to copy
 an odd file
Date: Sun, 03 Apr 2011 11:12:05 +0100
Message-ID: <4D9847F5.8030804@draigBrady.com>
References: <87fwq0gay0.fsf@rho.meyering.net> <4D9724AC.2070009@draigBrady.com> <8739m0g3u7.fsf@rho.meyering.net> <87d3l4edb1.fsf@rho.meyering.net> <20110402230005.GL21075@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jim Meyering <jim@meyering.net>, 8411@debbugs.gnu.org,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:10267 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750874Ab1DCKMv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 06:12:51 -0400
In-Reply-To: <20110402230005.GL21075@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/04/11 00:00, Ted Ts'o wrote:
> On Sat, Apr 02, 2011 at 08:08:34PM +0200, Jim Meyering wrote:
>> From 0a6d128d0d17c1604245f1caafe6af73584a0bb8 Mon Sep 17 00:00:00 20=
01
>> From: Jim Meyering <meyering@redhat.com>
>> Date: Sat, 2 Apr 2011 19:59:30 +0200
>> Subject: [PATCH] copy: require fiemap sync also for 2.6.38 and 2.6.3=
9 kernels
>>
>> * src/extent-scan.c (extent_need_sync): Require sync also for 2.6.38
>> and 2.6.39.  Without this, part of the cp/fiemap-empty test would fa=
il
>> both on F15-to-be and rawhide.  For discussion and details, see:
>> http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/22190
>=20
> FYI, the following fix has been merged into mainline, which should fi=
x
> the problem for 2.6.39 once it is finally released, at least for ext4=
=2E
> It was merged right before Linus released 2.6.39-rc1.  I'm assuming
> that Rawhide released a pre-2.6.39-rc1 kernel in the middle of the
> merge window.

So this fix is not in 2.6.38?
It was committed before 2.6.38-rc6 was released,
and I would have thought it appropriate for 2.6.38 :(
Anyway I guess that we now have to assume that there
can be 2.6.38 kernels in the wild with this issue,
even if the stable branch does get the fix soon.

As for 2.6.39, I guess we can assume it's OK,
and ignore the rawhide aberration for a while.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
