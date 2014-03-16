From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Sun, 16 Mar 2014 18:10:12 +0400
Message-ID: <CAG5DWog0BDHTh1edtQ+457SmJeL_0MacgZ1gYeNL4sY4yEqZWw@mail.gmail.com>
References: <20140315214029.GA18873@thunk.org>
	<CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
	<20140316023841.GA902@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:45562 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaCPORr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Mar 2014 10:17:47 -0400
Received: by mail-qg0-f48.google.com with SMTP id j107so13501368qga.7
        for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 07:17:46 -0700 (PDT)
In-Reply-To: <20140316023841.GA902@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2014 at 6:38 AM,  <tytso@mit.edu> wrote:
> On Sun, Mar 16, 2014 at 03:54:34AM +0400, Azat Khuzhin wrote:
>>
>> Thanks Ted, I'll take a look.
>> Are you talking about xfs-tests failures?
>
> Yes, the kernel is complaining that the file system looks corrupt.
> The xfstest generic/001 is the easist one to trigger it:
>
> generic/001 18s ...     [17:35:49][   26.793766] EXT4-fs error (device vde): ext4_mb_generate_buddy:756: group 1, 32763 clusters in bitmap, 32764
> in gd; block bitmap corrupt.
>  [17:36:09] 20s
> [   39.636943] EXT4-fs (vde): warning: mounting fs with errors, running e2fsck is recommended
>
> I this was using a freshly generated file system using a 20 GiB test
> partition, formatted using:
>
>            mke2fs -t ext4 -O bigalloc /dev/vde
>
> Dropping the patch made the error go away.

Hi Ted,

I just checked with the last upstream commit d8ec26d7f8287 + patch,
and xfs tests haven't fallen
I even update xfstests, still nothing.

/src/xfstests # git describe
linux-v3.8-336-g3948694

/src/xfstests # ./run_generic.sh
mke2fs 1.42.8 (20-Jun-2013)
/dev/sdb1 is mounted; will not make a filesystem here!
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 debian-virtual-2-6-39 3.13.0+
MKFS_OPTIONS  -- /dev/sdc1
MOUNT_OPTIONS -- -O bigalloc /dev/sdc1 /xfs-playground/scratch

generic/001 2s ... 2s
Ran: generic/001
Passed all 1 tests

# uname -r
3.13.0+

Maybe I need more recent kernel?

>
> Cheers,
>
>                                         - Ted



-- 
Respectfully
Azat Khuzhin
