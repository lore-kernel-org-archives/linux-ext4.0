From: Jim Meyering <jim@meyering.net>
Subject: Re: bug#8411: due to missing sync even on 2.6.39, cp fails to copy an odd file
Date: Sun, 03 Apr 2011 12:26:55 +0200
Message-ID: <87r59jd40g.fsf@rho.meyering.net>
References: <87fwq0gay0.fsf@rho.meyering.net>
	<4D9724AC.2070009@draigBrady.com> <8739m0g3u7.fsf@rho.meyering.net>
	<87d3l4edb1.fsf@rho.meyering.net> <20110402230005.GL21075@thunk.org>
	<4D9847F5.8030804@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Ts'o <tytso@mit.edu>, 8411@debbugs.gnu.org,
	linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52910 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1DCK1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 06:27:04 -0400
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 9B1EB9402D5
	for <linux-ext4@vger.kernel.org>; Sun,  3 Apr 2011 12:26:57 +0200 (CEST)
In-Reply-To: <4D9847F5.8030804@draigBrady.com> (=?iso-8859-1?Q?=22P=E1drai?=
 =?iso-8859-1?Q?g?= Brady"'s message of
	"Sun, 03 Apr 2011 11:12:05 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

P=E1draig Brady wrote:

> On 03/04/11 00:00, Ted Ts'o wrote:
>> On Sat, Apr 02, 2011 at 08:08:34PM +0200, Jim Meyering wrote:
>>> From 0a6d128d0d17c1604245f1caafe6af73584a0bb8 Mon Sep 17 00:00:00 2=
001
>>> From: Jim Meyering <meyering@redhat.com>
>>> Date: Sat, 2 Apr 2011 19:59:30 +0200
>>> Subject: [PATCH] copy: require fiemap sync also for 2.6.38 and 2.6.=
39 kernels
>>>
>>> * src/extent-scan.c (extent_need_sync): Require sync also for 2.6.3=
8
>>> and 2.6.39.  Without this, part of the cp/fiemap-empty test would f=
ail
>>> both on F15-to-be and rawhide.  For discussion and details, see:
>>> http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/22190
>>
>> FYI, the following fix has been merged into mainline, which should f=
ix
>> the problem for 2.6.39 once it is finally released, at least for ext=
4.
>> It was merged right before Linus released 2.6.39-rc1.  I'm assuming
>> that Rawhide released a pre-2.6.39-rc1 kernel in the middle of the
>> merge window.
>
> So this fix is not in 2.6.38?
> It was committed before 2.6.38-rc6 was released,
> and I would have thought it appropriate for 2.6.38 :(
> Anyway I guess that we now have to assume that there
> can be 2.6.38 kernels in the wild with this issue,
> even if the stable branch does get the fix soon.

Yes, this is unfortunate.  But it's just an optimization,
so probably not a big deal for anyone.  I haven't measured
the performance difference.  Have you?

If it's a problem, I suppose once we've seen that most major distros
have patched their 2.6.38, we can turn off the sync also for 2.6.38
kernels.

> As for 2.6.39, I guess we can assume it's OK,
> and ignore the rawhide aberration for a while.

Yes.  I've adjusted and pushed this:

=46rom 1c3654cb1fb0d8f3c422c766028d0783a40f4a42 Mon Sep 17 00:00:00 200=
1
=46rom: Jim Meyering <meyering@redhat.com>
Date: Sat, 2 Apr 2011 19:59:30 +0200
Subject: [PATCH] copy: require fiemap sync also for 2.6.38 kernels

* src/extent-scan.c (extent_need_sync): Require sync also for 2.6.38.
Without this, part of the cp/fiemap-empty test would fail both on
=4615-to-be (2.6.38.1-6.fc15.x86_64) and rawhide.  For details, see
http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/22190
---
 src/extent-scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/extent-scan.c b/src/extent-scan.c
index c0a5de6..d84746c 100644
--- a/src/extent-scan.c
+++ b/src/extent-scan.c
@@ -31,7 +31,7 @@
 # include "fiemap.h"
 #endif

-/* Work around Linux kernel issues on BTRFS and EXT4 before 2.6.38.
+/* Work around Linux kernel issues on BTRFS and EXT4 before 2.6.39.
    FIXME: remove in 2013, or whenever we're pretty confident
    that the offending, unpatched kernels are no longer in use.  */
 static bool
@@ -50,7 +50,7 @@ extent_need_sync (void)
            unsigned long val;
            if (xstrtoul (name.release + 4, NULL, 10, &val, NULL) =3D=3D=
 LONGINT_OK)
              {
-               if (val < 38)
+               if (val < 39)
                  need_sync =3D 1;
              }
         }
--
1.7.4.2.662.gcbd0
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
