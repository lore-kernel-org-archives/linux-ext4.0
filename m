From: David Jander <david@protonic.nl>
Subject: Re: Question about data integrity on SD cards
Date: Tue, 15 Jul 2014 09:09:36 +0200
Message-ID: <20140715090936.44531046@archvile>
References: <53BD32D5.3000804@kelvatek.com>
	<alpine.LFD.2.00.1407091444140.2128@localhost.localdomain>
	<53BD4251.3070501@kelvatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Grzegorz Sikorski <g.sikorski@kelvatek.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from protonic.xs4all.nl ([83.163.252.89]:8442 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbaGOHJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2014 03:09:19 -0400
In-Reply-To: <53BD4251.3070501@kelvatek.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 09 Jul 2014 14:23:29 +0100
Grzegorz Sikorski <g.sikorski@kelvatek.com> wrote:

> We are using 2.6.37 version and we may have some issues with underlyi=
ng=20
> mmc-host driver. We also tested our setup on newer kernels as well as=
=20
> different media with similar results, but I was not involved in these=
=20
> tests, so cannot give any details straight away.
>=20
> But my main question was partially answered by you. I just need a=20
> confirmation that design of our system should in general be OK, as we=
=20
> may expect random power downs occasionally. So do you think it is=20
> possible (in general) to build embedded system with SQLite3 database =
on=20
> EXT4 filesystem on SD card that is not fragile on unexpected power=20
> sequence? Do you know what type of SD card would be recommended in th=
is=20
> case? Are our mounting options fine?

Sorry for the late reaction. In case you still wonder, no. It is not po=
ssible
to do this with common (COTS) SD cards in general. Due to their nature,=
 SD
cards can corrupt even data that is not being written to when power is
interrupted during a write (or read) action. There is no filesystem tha=
t can
protect you from that.

And btw, the thread Luk=C3=A1=C5=A1 mentioned is about a bug in ext4, n=
ot really about
problems with SD cards.

If you need robust flash storage, please look at MMC 4.41+ enhanced mod=
e and
"reliable-write" functionality. Without these two functions combined, i=
t is
not possible to do what you want to do. I have not seen (non embedded) =
MMC
cards (in actual SD/MMC-card format) that support version 4.41 or newer=
 of the
(e)MMC standard, but it may be possible that someone makes them.... tha=
t might be
a solution for your problem.

Best regards,

--=20
David Jander
Protonic Holland.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
