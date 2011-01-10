From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: ext3: deleting files doesn't free up space
Date: Mon, 10 Jan 2011 01:07:37 -0500
Message-ID: <18505.1294639657@gamaville.dokosmarshall.org>
References: <AANLkTimwDpUz9GUmx3UutYir0UuoTSAXNzphWeEX9sKh@mail.gmail.com>
Reply-To: nicholas.dokos@hp.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	nicholas.dokos@hp.com
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173011pub.verizon.net ([206.46.173.11]:59986 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1AJGHt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jan 2011 01:07:49 -0500
In-reply-to: Message from Dan Carpenter <error27@gmail.com> of
 "Mon, 10 Jan 2011 08:22:25 +0300."
 <AANLkTimwDpUz9GUmx3UutYir0UuoTSAXNzphWeEX9sKh@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I filled up my partition last night.
> I deleted 5 gigs of movies.
> The "Used" number went down to 125G.
> The "Free" number stayed at 0.
> I rebooted the system but it's still the same.
> 
> $ echo foo > foo
> bash: echo: write error: No space left on device
> 
> $ df .
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda1            136236548 130363620         0 100% /media/old_sys
> 
> $ mount | grep old
> /dev/sda1 on /media/old_sys type ext3 (rw,nosuid,nodev)
> /media/old_sys/home on /home type none (rw,bind)
> 
> This is with 2.6.37-rc5+.  Is there a way to debug this?
> 

I don't think there is anything to debug. ext3 reserves by default 5% of
the space for root's use. You will see "Available" go positive when
"Used" is reduced to below 0.95*136236548 blocks = 129424720 blocks
roughly.  You can check your numbers by running

    dumpe2fs -h /dev/sda1

and checking the "Block count" and "Reserved block count" fields.

You should be able to write to the filesystem as root though, as long
as Used < Total number of blocks. And you can adjust the reserved space
with ``tune2fs -m <N>''.

See e.g https://wiki.archlinux.org/index.php/Ext3_Filesystem_Tips
(the first hit from a Google search for "ext3 reserved").

Nick
