From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Mon, 09 May 2011 14:59:29 +0200
Message-ID: <1304945969.11788.14.camel@heisenberg.scientia.net>
References: <031c613316176c32f09748706a086be2@imap.dd24.net>
	 <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>
	 <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>
	 <20110509120608.GK4122@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw01.dd24.net ([193.46.215.41]:43659 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1EIM72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 08:59:28 -0400
In-Reply-To: <20110509120608.GK4122@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2011-05-09 at 14:06 +0200, Jan Kara wrote:
> Actually, contents of the files should be generally OK
> because mkfs overwrites only inodes. So you have lost some files and
> directories but once you have a file, it should be OK.
This is really some good news!! :-)
Are you sure with that? And wouldn't mean, that inodes are always
located at the same block locations?


> > It's not that I wanna blame others (I mean being stupid is my fault), but
> > e2fsprogs' mkfs is really missing a check whether any known
> > filesystem/partition type/container (luks, lvm, mdadm, etc.) is already on
> > device (and a -force switch),... IIRC xfsprogs already do this more or
> > less.
>   Yes, that would be reasonable although it might break some people's
> scripts. But probably worth it anyway.
IMHO the breakage is really justified then :-)

Especially as some of those scripts might actually do their own checks
for some filesystems, but perhaps completely forget about other
containter types (partitions, LUKS, mdadm, etc. etc.)


Cheers,
Chris.
