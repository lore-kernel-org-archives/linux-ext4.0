From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH 3/3] tune2fs: update journal super block when changing
 UUID for fs.
Date: Thu, 10 Jul 2014 10:03:06 +0400
Message-ID: <20140710060306.GW4622@azat>
References: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com>
 <1404852082-1550-4-git-send-email-a3at.mail@gmail.com>
 <F7FBA430-6337-40C9-BCD0-22503131FD3E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40382 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaGJGDJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 02:03:09 -0400
Received: by mail-lb0-f169.google.com with SMTP id l4so5719186lbv.14
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jul 2014 23:03:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <F7FBA430-6337-40C9-BCD0-22503131FD3E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 09, 2014 at 02:38:19PM -0600, Andreas Dilger wrote:
> 
> On Jul 8, 2014, at 2:41 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> 
> > Using -U option you can change the UUID for fs, however it will not work
> > for journal device, since it have a copy of this UUID inside jsb (i.e.
> > journal super block). So copy UUID on change into that block.
> > 
> > Here is the initial thread:
> > http://comments.gmane.org/gmane.comp.file-systems.ext4/44532
> > 
> > You can reproduce this by executing following commands:
> > $ fallocate -l100M /tmp/dev
> > $ fallocate -l100M /tmp/journal
> > $ sudo /sbin/losetup /dev/loop1 /tmp/dev
> > $ sudo /sbin/losetup /dev/loop0 /tmp/journal
> > $ mke2fs -O journal_dev /tmp/journal
> > $ tune2fs -U da1f2ed0-60f6-aaaa-92fd-738701418523 /tmp/journal
> > $ sudo mke2fs -t ext4 -J device=/dev/loop0 /dev/loop1
> > $ dumpe2fs -h /tmp/dev | fgrep UUID
> > dumpe2fs 1.43-WIP (18-May-2014)
> > Filesystem UUID:          8a776be9-12eb-411f-8e88-b873575ecfb6
> > Journal UUID:             e3d02151-e776-4865-af25-aecb7291e8e5
> > $ sudo e2fsck /dev/vdc
> > e2fsck 1.43-WIP (18-May-2014)
> > External journal does not support this filesystem
> > 
> > /dev/loop1: ********** WARNING: Filesystem still has errors **********
> > 
> > Reported-by: Chin Tzung Cheng <chintzung@gmail.com>
> > Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
> 
> It may be that the reverse problem also exists - if the UUID is changed
> on the filesystem, it probably is not updated in the journal "users" list?
> I'm not sure either way, but it is worthwhile to check.

You are right, it will not update the 'Journal users' field, there is no
code for U_flag in tune2fs for this (I also test it).
But to make patch clean I need more time, I will send it later.

> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks!


-- 
Respectfully
Azat Khuzhin
