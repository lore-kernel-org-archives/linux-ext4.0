From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Mon, 24 Aug 2009 09:21:12 -0400
Message-ID: <87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
References: <20090312092114.GC6949@elf.ucw.cz>
	 <200903121413.04434.rob@landley.net>
	 <20090316122847.GI2405@elf.ucw.cz>
	 <200903161426.24904.rob@landley.net>
	 <20090323104525.GA17969@elf.ucw.cz>
	 <87ljqn82zc.fsf@frosties.localdomain>
	 <20090824093143.GD25591@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:34148 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZHXNVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 09:21:11 -0400
In-Reply-To: <20090824093143.GD25591@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 5:31 AM, Pavel Machek<pavel@ucw.cz> wrote:
>
> Running journaling filesystem such as ext3 over flashdisk or degraded
> RAID array is a bad idea: journaling guarantees no longer apply and
> you will get data corruption on powerfail.
>
> We can't solve it easily, but we should certainly warn the users. I
> actually lost data because I did not understand these limitations...
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/Documentation/filesystems/expectations.txt b/Documentati=
on/filesystems/expectations.txt
> new file mode 100644
> index 0000000..80fa886
> --- /dev/null
> +++ b/Documentation/filesystems/expectations.txt
> @@ -0,0 +1,52 @@
> +Linux block-backed filesystems can only work correctly when several
> +conditions are met in the block layer and below (disks, flash
> +cards). Some of them are obvious ("data on media should not change
> +randomly"), some are less so.
> +
> +Write errors not allowed (NO-WRITE-ERRORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Writes to media never fail. Even if disk returns error condition
> +during write, filesystems can't handle that correctly.
> +
> + =A0 =A0 =A0 Fortunately writes failing are very uncommon on traditi=
onal
> + =A0 =A0 =A0 spinning disks, as they have spare sectors they use whe=
n write
> + =A0 =A0 =A0 fails.
> +
> +Don't cause collateral damage to adjacent sectors on a failed write =
(NO-COLLATERALS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~
> +
> +Unfortunately, cheap USB/SD flash cards I've seen do have this bug,
> +and are thus unsuitable for all filesystems I know.
> +
> + =A0 =A0 =A0 An inherent problem with using flash as a normal block =
device
> + =A0 =A0 =A0 is that the flash erase size is bigger than most filesy=
stem
> + =A0 =A0 =A0 sector sizes. =A0So when you request a write, it may er=
ase and
> + =A0 =A0 =A0 rewrite some 64k, 128k, or even a couple megabytes on t=
he
> + =A0 =A0 =A0 really _big_ ones.
> +
> + =A0 =A0 =A0 If you lose power in the middle of that, filesystem won=
't
> + =A0 =A0 =A0 notice that data in the "sectors" _around_ the one your=
 were
> + =A0 =A0 =A0 trying to write to got trashed.
> +
> + =A0 =A0 =A0 RAID-4/5/6 in degraded mode has same problem.
> +
> +
> +Don't damage the old data on a failed write (ATOMIC-WRITES)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written durin=
g
> +powerfail.
> +
> + =A0 =A0 =A0 Because RAM tends to fail faster than rest of system du=
ring
> + =A0 =A0 =A0 powerfail, special hw killing DMA transfers may be nece=
ssary;
> + =A0 =A0 =A0 otherwise, disks may write garbage during powerfail.
> + =A0 =A0 =A0 This may be quite common on generic PC machines.
> +
> + =A0 =A0 =A0 Note that atomic write is very hard to guarantee for RA=
ID-4/5/6,
> + =A0 =A0 =A0 because it needs to write both changed data, and parity=
, to
> + =A0 =A0 =A0 different disks. (But it will only really show up in de=
graded mode).
> + =A0 =A0 =A0 UPS for RAID array should help.

Can someone clarify if this is true in raid-6 with just a single disk
failure?  I don't see why it would be.

And if not can the above text be changed to reflect raid 4/5 with a
single disk failure and raid 6 with a double disk failure are the
modes that have atomicity problems.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
