From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] exclude_bitmap and uninit_bg features
Date: Fri, 15 Apr 2011 03:54:05 +0200
Message-ID: <BANLkTik5x9nPgw7a_LhHxEpP8RuAce-n5Q@mail.gmail.com>
References: <BANLkTimmRQtOiH2iunJczQOhxkB4uoCJ2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52968 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1DOByH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 21:54:07 -0400
Received: by eyx24 with SMTP id 24so621746eyx.19
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 18:54:05 -0700 (PDT)
In-Reply-To: <BANLkTimmRQtOiH2iunJczQOhxkB4uoCJ2g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 13, 2011 at 9:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Hi Ted,
>
> I have been exploring the possibility to make exclude bitmap a compat feature
> and I think I have come to a dead end with ext4_init_block_bitmap().
>
> On old kernels, this function will disregard the exclude bitmap block and leave
> it free in the block bitmap.
>
> So that leaves us with the less attractive option to make it rocompat,
> which leads to the following dilemma:
> Once exclude bitmap is allocated by new mkfs or added by new tune2fs,
> the fs can no longer be mounted by an older kernel.
> How can we solve that problem?
>
> We could use 2 features:
> EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP /* exclude bitmap is allocated */
> EXT4_FEATURE_RO_COMPAT_UNINIT_EXCLUDE /* uninit_bg and exclude_bitmap are set */

I am being silly.
There is no need for the helper uninit_exclude rocompat feature,
because I already
have the rocomat has_snapshot feature, so I can init all bitmaps when
removing it,
to keep the exclude bitmap protected.

>
> New mkfs can allocate exclude bitmaps for uninit groups and set the 2
> features by default.
> tune2fs -O ^uninit_exclude can init all groups and remove the rocompat feature,
> making the fs available for old kernels, while keeping the exclude
> bitmap intact.
>
> Does that make sense to you?
>

So I have a new, yet simpler, deployment strategy.
For the next release of e2fsprogs:
- mke2fs -o has_snapshot will explicitly allocate exclude bitmap and big journal
- setting/clearing of exclude_bitmap/has_snapshot features by tune2fs
will not be allowed

ext4 with has_snapshot feature will be mountable read-write by new
kernels with the
CONFIG_EXT4_FS_SNAPSHOT config option enabled and will be mountable
read-only by old kernels and when config option is disabled.

This avoid all backward compatibility issues and will assure that no one tries
to enable an experimental feature on his root fs.

This also reduces the e2fsprogs patches to tune2fs.

For a future release of e2fsprogs:
- setting the exclude_bitmap/has_snapshot features by tune2fs will be allowed
- clearing the exclude_bitmap feature will not be allowed
- clearing the has_snapshot feature will init all block bitmaps,
uninit all exclude bitmaps and discard all snapshots

Please approve my plan and I will carry on to submit the reduced set
of e2fsporgs patches.

Thanks,
Amir.
