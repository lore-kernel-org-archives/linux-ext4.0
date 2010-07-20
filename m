From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCHES/RFC v1.0.12] e2fsprogs: Next3 patch series
Date: Tue, 20 Jul 2010 18:57:26 +0300
Message-ID: <AANLkTinlL0YEiDGWw0qjyYYzR31D_DBKQxFczSu4UYt6@mail.gmail.com>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40474 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0GTP53 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:57:29 -0400
Received: by gwj18 with SMTP id 18so2718721gwj.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:57:28 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 20, 2010 at 6:16 PM, Amir Goldstein wrote:
> Hi guys,
>
> The following patches apply and tested on e2fsprogs master branch (on July 20).
>
> Please help me review and push these patches upstream.
>
> Thanks,
> Amir.
>
> [PATCH 01/12] e2fsprogs: Next3 on-disk format changes
> [PATCH 02/12] e2fsprogs: Create a big journal for Next3
> [PATCH 03/12] e2fsprogs: Create/check exclude inode for Next3
> [PATCH 04/12] e2fsprogs: Next3 snapshot control with chattr/lsattr -X
> [PATCH 05/12] e2fsprogs: Avoid offline modifications to a file system with snapshots
> [PATCH 06/12] e2fsprogs: Cleanup Next3 snapshot list when removing has_snapshot feature
> [PATCH 07/12] e2fsprogs: Check Next3 exclude bitmap on fsck
> [PATCH 08/12] e2fsprogs: Check Next3 snapshot list on fsck
> [PATCH 09/12] e2fsprogs: Delete all snapshots on fsck -x
> [PATCH 10/12] e2fsprogs: Map maximum filesystem size with a single snapshot file
> [PATCH 11/12] e2fsprogs: Dump Next3 message buffer on fsck
> [PATCH 12/12] e2fsprogs: Migrate old to new on-disk format
>
>
>

Hi Jan,

I saw you are now an official maintainer of ext3
and you were also the only one to pick up the ext3_forget() bug fix I posted.

So I thought it is worth a shot to ask you personally if you will have
time to review my Next3 patches.

In fact, the posted patches are only the small patches to e2fsprogs.
The more challenging job is the review of the Next3 snapshot patches,
which apply on top of ext3 (or rather a forked branch of ext3 called next3).
They are available for download at
http://sourceforge.net/projects/next3/files/Latest%20patch%20series
but I can also post them to the list if you like (about 40 medium size patches).

Ted and Andreas have looked at some of the previous e2fsprogs patches
I posted a while back
and Ted has already merged a part of the the first patch (on-disk
format) to the master branch.
I hope they will have time to look at these new patches.

Thanks,
Amir.
