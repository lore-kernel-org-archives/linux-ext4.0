From: Jim Meyering <jim@meyering.net>
Subject: Re: bug#8411: due to missing sync even on 2.6.39, cp fails to copy an odd file
Date: Sat, 02 Apr 2011 20:08:34 +0200
Message-ID: <87d3l4edb1.fsf@rho.meyering.net>
References: <87fwq0gay0.fsf@rho.meyering.net>
	<4D9724AC.2070009@draigBrady.com> <8739m0g3u7.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: 8411@debbugs.gnu.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:60490 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab1DBSIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 14:08:43 -0400
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 011F6940145
	for <linux-ext4@vger.kernel.org>; Sat,  2 Apr 2011 20:08:36 +0200 (CEST)
In-Reply-To: <8739m0g3u7.fsf@rho.meyering.net> (Jim Meyering's message of
	"Sat, 02 Apr 2011 15:50:08 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jim Meyering wrote:
> P=E1draig Brady wrote:
>> On 02/04/11 12:16, Jim Meyering wrote:
>>> Hi P=E1draig,
>>> As of this change,
>>>
>>>     copy: with fiemap copy, only sync when needed
>>>     http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=3Df69=
876e55
>>>
>>> fiemap copy with extents beyond EOF can fail on ext4 even with
>>> Fedora 15 (2.6.38) and rawhide's 2.6.39 kernel.
>>>
>>> Here we construct an odd file.  First, preallocate 10MB of space,
>>> and then write 5KiB of random data into the beginning of that:
>>>
>>>     $ fallocate -l 10000000 -n k
>>>     $ dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullbl=
ock of=3Dk
>>>
>>> However, when we try to copy "k", we get a file, "k2" of the
>>> expected size, but with only NUL bytes for contents:
>>
>> So the extent info is not updated until sync(),
>> which means cp will consider the "unwritten" extent
>> as NUL data and not bother to read it :(
>>
>> I guess this is a corner case that was missed
>> in the fixups for ext4 (and btrfs?) in 2.6.38 for this?
>> I've copied ext4 devs for clarification.
>> I.E. if you do this:
>>
>>   fallocate -l 10000000 -n k
>>   dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock o=
f=3Dk
>>   filefrag -v k
>>
>> Do you get all extents still unwritten.
>> I do on my 2.6.35.11-83.fc14.i686 kernel, but I expected that.
>
> Right.  The new extent remains unwritten until after a sync
> with ext4 on both Fedora 15 and rawhide kernels.

Here's the quick band-aid I'll push tomorrow.
I'll welcome a better fix, but this, at least,
lets "make check" pass once again.

=46rom 0a6d128d0d17c1604245f1caafe6af73584a0bb8 Mon Sep 17 00:00:00 200=
1
=46rom: Jim Meyering <meyering@redhat.com>
Date: Sat, 2 Apr 2011 19:59:30 +0200
Subject: [PATCH] copy: require fiemap sync also for 2.6.38 and 2.6.39 k=
ernels

* src/extent-scan.c (extent_need_sync): Require sync also for 2.6.38
and 2.6.39.  Without this, part of the cp/fiemap-empty test would fail
both on F15-to-be and rawhide.  For discussion and details, see:
http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/22190
---
 src/extent-scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/extent-scan.c b/src/extent-scan.c
index 4ddf46e..752de85 100644
--- a/src/extent-scan.c
+++ b/src/extent-scan.c
@@ -31,7 +31,7 @@
 # include "fiemap.h"
 #endif

-/* Work around Linux kernel issues on BTRFS and EXT4 before 2.6.38.
+/* Work around Linux kernel issues on BTRFS and EXT4 before 2.6.40.
    FIXME: remove in 2013, or whenever we're pretty confident
    that the offending, unpatched kernels are no longer in use.  */
 static bool
@@ -50,7 +50,7 @@ extent_need_sync (void)
            unsigned long val;
            if (xstrtoul (name.release + 4, NULL, 10, &val, NULL) =3D=3D=
 LONGINT_OK)
              {
-               if (val < 38)
+               if (val < 40)
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
