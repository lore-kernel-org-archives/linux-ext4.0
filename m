From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [ANNOUNCE] Online Hierarchical Storage Manager (OHSM v1.2)
Date: Tue, 23 Feb 2010 08:32:32 -0500
Message-ID: <87f94c371002230532r19924ed3wd3501b051cc1a7af@mail.gmail.com>
References: <ea11fea31002222148u4abe8235q4bb7ef855044b508@mail.gmail.com>
	 <878wakl8zj.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Manish Katiyar <mkatiyar@gmail.com>,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>,
	kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f177.google.com ([209.85.223.177]:61088 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0BWNcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 08:32:33 -0500
Received: by iwn7 with SMTP id 7so3068169iwn.4
        for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 05:32:32 -0800 (PST)
In-Reply-To: <878wakl8zj.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 23, 2010 at 2:14 AM, Dmitry Monakhov <dmonakhov@openvz.org>=
 wrote:
> Manish Katiyar <mkatiyar@gmail.com> writes:
>
>> Hello all,
>> =A0 =A0We are pleased to announce the first official functional rele=
ase of Online
>> Hierarchical Storage Manager (OHSM v1.2). =A0This is a RFC release a=
nd
>> not yet aimed at mainline inclusion.
>>
>> OHSM is a tool to manage and move data across various class of stora=
ge.
>> It can help users to selectively place and move data across tiers su=
ch
>> as SSD, Raid 10, Raid 6 based on the attributes of the data. OHSM
>> supports background movement of data
>> without any visible change in a files namespace to users and user ap=
plications.
> It does sounds like btrfs multy-device support. Can you please
> what it the differance?

Dmitry,

Per my understanding of btrfs multi-device, ohsm is totally different.

Btrfs multi-device I believe provides functionality similar to DM
(device mapper) and/or mdraid.

Ohsm is about cost effectively managing multiple storage tiers within
a single filesystem and leverages having DM and mdraid available to
build on, but makes no effort to duplicate their functionality.  DM in
particular is a mandatory part of a ohsm environment.

=46or example:

Assume I have an enterprise app that needs 10 TB of storage, but 90%
of the data is of limited use most of the time.  The other 10% is
heavily used and high performance is paramount.  The trouble is that
from time-to-time the designation of the 10% changes as business needs
change.  ie. Normally I really need database abc to be fast, but at
the end of the month I need database xyz to be as fast as possible.

One real world solution without OHSM is to create a SSD raid-1 that
holds the 10%, (1TB), and a SATA raid 6 that holds the less critical
90% (9TB).

Then, as just one example, if I need to accelerate a database for a
few days / weeks I simply move the database tables from the
low-performance file system to the high-performance file system.  And
I see my database speed drastically accelerate.

There are 2 big downsides to the above:

1) The full path name to the database tables will change as they are
moved between file systems, so it is a admin hassle to update
references to the tables as they move around.

2) The tables can not be in use as they are moved, so if I really am
moving a TB of data between sata and SSD that could take some number
of hours where I can't be actively using the files.  A definite
downtime issue.

Now with OHSM, we would build a DM logical volume composed of a sata
raid array and a ssd raid array.  Thus blocks 0-x would be on the sata
array and blocks x-end would be on SSD.

We would then use ohsm to manage which block range was used by the
various files.  The goal being that low-performance files would be
stored on sata devices and files needing high-performance would be
stored on SSD.

And as the performance needs of the files changed, the files could be
moved between the tiers.  The files blocks are moved via
ext4_ioc_move_ext() so the path'ing is not changed and the file can be
open and in use as it is moved.

In a sense we are performing a defrag action on the file where the
destination blocks of the file are in a different storage tier than
the original data blocks.

fyi: One of the ways we track desired storage tier for a file is via
subtrees, thus the interest of ohsm in your subtree implementation.

HTH
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
