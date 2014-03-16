From: a3at.mail@gmail.com
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Mon, 17 Mar 2014 00:56:59 +0400
Message-ID: <20140316205659.GC19885@azat>
References: <20140315214029.GA18873@thunk.org>
 <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
 <20140316023841.GA902@thunk.org>
 <CAG5DWog0BDHTh1edtQ+457SmJeL_0MacgZ1gYeNL4sY4yEqZWw@mail.gmail.com>
 <20140316161637.GA19885@azat>
 <20140316184634.GA14162@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42762 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaCPU5S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Mar 2014 16:57:18 -0400
Received: by mail-lb0-f177.google.com with SMTP id z11so3060293lbi.22
        for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 13:57:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140316184634.GA14162@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2014 at 02:46:35PM -0400, tytso@mit.edu wrote:
> On Sun, Mar 16, 2014 at 08:17:13PM +0400, a3at.mail@gmail.com wrote:
> > And no complaints from xfs-tests, and no errors in dmesg.
> > 
> > Could you give me more information about you playground?
> 
> I just reproduced the problem this way.  Starting with the ext4 dev
> branch of the ext4 git tree[1], which should be commit eb3e7abb161ad5,
> I applied your patch, as found in the ext4 patch queue's git tree[2],
> with the name initialize-multi-block-allocator-before-checking-block-descriptors
> 
> I then ran a fairly recent version of xfstests (commit 3948694eb),
> under KVM with the kernel built using the 32-bit x86 architecture,
> with the KVM set up with 4 CPU's, and 2048 megs of memory.  The 20 gig
> partition I used was formatted using "mke2fs -t ext4 -O bigalloc", and
> I used the mount options "-o block_validity" (this enables some
> additional sanity checking).
> 
> The ext4 errors showed up when running xfstests ext4/305 this time
> around.  Please see the attached compressed log file.

Thanks for additional information.

After I tested ext4 dev branch (eb3e7abb161ad5), without any xfs-tests complaints,
I understand what goes wrong, you have not last version of
this patch, the latest is v3.
(Actually you have description from last patch, but not the latest changes.)

I could resend the whole patch if you want to.


$ diff
initialize-multi-block-allocator-before-checking-block-descriptors <(env
GIT_DIR=/src/oss/linux/.git git show
ext4-fix-checking-descriptors-patch)

100,105c102,103
< @@ -4084,21 +4094,13 @@ no_journal:
<       if (err) {
<               ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
<                        "reserved pool", ext4_calculate_resv_clusters(sb));
< -             goto failed_mount4a;
< +             goto failed_mount5;
---
> @@ -4094,14 +4104,6 @@ no_journal:
>               goto failed_mount4a;
108,114d105
<       err = ext4_setup_system_zone(sb);
<       if (err) {
<               ext4_msg(sb, KERN_ERR, "failed to initialize system "
<                        "zone (%d)", err);
< -             goto failed_mount4a;
< -     }
< -
120,123c111,117
<               goto failed_mount5;
<       }
<  
< @@ -4175,11 +4177,8 @@ failed_mount8:
---
> -             goto failed_mount5;
> -     }
> -
>       err = ext4_register_li_request(sb, first_not_zeroed);
>       if (err)
>               goto failed_mount6;
> @@ -4175,9 +4177,6 @@ failed_mount8:
131,132c125
< -failed_mount4a:
< +failed_mount5:
---
>  failed_mount4a:
134,135d126
<       sb->s_root = NULL;
<  failed_mount4:

Thanks.

> 
> Cheers,
> 
> 					- Ted
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> [2] git://repo.or.cz/ext4-patch-queue.git
> 



-- 
Respectfully
Azat Khuzhin
