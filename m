From: "norritt" <norritt@t-online.de>
Subject: Re: Ongoing data reorganization/defragmentation?
Date: Thu, 13 Sep 2012 14:54:27 +0200
Message-ID: <5051D783.4000300@cube.nornet.local>
References: <5050BA08.80709@bytefortress.de> <alpine.LFD.2.00.1209121411410.2222@new-host-2>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: norritt@t-online.de
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:36589 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab2IMMzU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 08:55:20 -0400
In-Reply-To: <alpine.LFD.2.00.1209121411410.2222@new-host-2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12.09.2012 20:15, Luk=E1=9A Czerner wrote:
> On Wed, 12 Sep 2012, norritt@t-online.de wrote:
>
>  From what I've found out it's a good idea to:
> - mount with noatime, discard (if drive supports trim)
> The -o discard option might be tricky since some devices still
> handles it quite badly and you can experience big performance drops
> (http://people.redhat.com/lczerner/discard/ although it is somewhat
> outdated already). But you might to try to see yourself if it does
> not hurt your performance.
>
> The other option would be to use batched discard with fstrim (see
> fstrim from util-linux) and run it once per (day, week, month).
>
> Thanks!
> -Lukas
>

Hi  Luk=E1=9A,
thank you for pointing out the performance issue with the discard mount=
=20
option, I hadn't read about that yet. As far is I know I'm using a quit=
e=20
special SSD (SanDisk, with a SanDisk controller), where most other SSDs=
=20
on the market seem to be based on Marvell, Sandforce or Indilinx=20
controllers. I saw that you were using SSDs from various vendors for=20
your benchmarking tests. Was a model with SanDisk controller among the=20
drives you tested? Would postmark data about disks with SanDisk=20
controller be of interest to you?

Regards Nor
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
