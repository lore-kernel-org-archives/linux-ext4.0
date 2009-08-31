From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Mon, 31 Aug 2009 10:49:28 -0700
Message-ID: <4807377b0908311049id9a2167r937bc8447c2b3546__45697.3500353799$1251741511$gmane$org@mail.gmail.com>
References: <20090824212518.GF29763@elf.ucw.cz> <4A947682.2010204@redhat.com>
	 <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>
	 <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
	 <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu>
	 <20090830075135.GA1874@ucw.cz> <20090830152023.GB23828@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f188.google.com ([209.85.211.188]:52281 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZHaR4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 13:56:53 -0400
In-Reply-To: <20090830152023.GB23828@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 30, 2009 at 8:20 AM, Theodore Tso<tytso@mit.edu> wrote:
> So we *do* have the warning light; the problem is that just as some
> people may not realize that "check brakes" means, "YOU COULD DIE",
> some people may not realize that "hard drive failure; RAID array
> degraded" could mean, "YOU COULD LOSE DATA".
>
> Fortunately, for software RAID, this is easily solved; if you are so
> concerned, why don't you submit a patch to mdadm adjusting the e-mail
> sent to the system administrator when the array is in a degraded
> state, such that it states, "YOU COULD LOSE DATA". =A0I would gently
> suggest to you this would be ***far*** more effective that a patch to
> kernel documentation.

In the case of a degraded array, could the kernel be more proactive
(or maybe even mdadm) and have the filesystem remount itself withOUT
journalling enabled? =A0This seems on the surface to be possible, but I
don't know the internal particulars that might prevent/allow it.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
