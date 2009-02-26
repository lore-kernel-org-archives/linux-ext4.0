From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Thu, 26 Feb 2009 18:40:31 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902261805510.29190@vixen.sonytel.be>
References: <49A2705D.9030008@in.ibm.com> <alpine.LRH.2.00.0902251430410.4063@vixen.sonytel.be> <200902260945.41990.markn@au1.ibm.com> <200902261020.34325.markn@au1.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linuxppc-dev@ozlabs.org, Jan Kara <jack@ucw.cz>,
	Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Mark Nelson <markn@au1.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57842 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751972AbZBZRke (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 12:40:34 -0500
In-Reply-To: <200902261020.34325.markn@au1.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 26 Feb 2009, Mark Nelson wrote:
> On Thu, 26 Feb 2009 09:45:41 am Mark Nelson wrote:
> > On Thu, 26 Feb 2009 12:31:20 am Geert Uytterhoeven wrote:
> > > On Wed, 25 Feb 2009, Mark Nelson wrote:
> > > > Does the following patch fix the errors you're seeing? (it appl=
ies the
> > > > same fix as the previous patch but this time to copy_tofrom_use=
r, which
> > > > I updated in a4e22f02f5b6518c1484faea1f88d81802b9feac)
> > >=20
> > > Thanks, but I still get crashes in copy_page_range().
> >=20
> > Hmmm... I'm out of ideas for the moment, but thanks for testing any=
way!
>=20
> If you revert both 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556 and
> a4e22f02f5b6518c1484faea1f88d81802b9feac, does it help? You could als=
o
> try to revert 57dda6ef5bd5b9e60410477ad29e654097e2cca1 just in case I
> need to keep wearing the brown paper bag for a bit longer :)

Still doesn't help.

However, I noticed I never enabled CONFIG_DEBUG_PAGEALLOC before 2.6.29=
-rc5.
So far I tried 2.6.2[5-8], and they all crash with CONFIG_DEBUG_PAGEALL=
OC.
I guess it never actually worked on PS3.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
