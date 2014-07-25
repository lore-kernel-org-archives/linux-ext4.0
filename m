From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Fri, 25 Jul 2014 19:44:07 +0800
Message-ID: <53D24307.6050903@fnarfbargle.com>
References: <53CBA75B.2030102@fnarfbargle.com> <53CC66DA.2080804@fnarfbargle.com> <20140725081312.GO6397@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([103.4.17.7]:34747 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaGYLoL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 07:44:11 -0400
In-Reply-To: <20140725081312.GO6397@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 25/07/14 16:13, Azat Khuzhin wrote:
> On Mon, Jul 21, 2014 at 09:03:22AM +0800, Brad Campbell wrote:
>> On 20/07/14 19:26, Brad Campbell wrote:
>> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
>> last_start 5781865048
>
> blocks_per_group=32768 (u32)
> extra_groups=131072 (u32)
> b*e=4294967296 # overflow
>
> Could you try attached patched? (I will add appropriate message letter)
> It is totally untested and shouldn't break anything, *but* I strongly
> recommend you to have a backup before running it.
> You could also wait until somebody else review it.
>
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index a8af969..98ce10a 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -2479,7 +2479,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
>                  extra_grps = ext2fs_div64_ceil(remainder,
>                                                 EXT2_BLOCKS_PER_GROUP(fs->super));
>
> -               data_blocks += extra_grps * EXT2_BLOCKS_PER_GROUP(fs->super);
> +               data_blocks += (unsigned long long)extra_grps *
> +                       EXT2_BLOCKS_PER_GROUP(fs->super);
>
>                  /* ok we have to account for the last group */
>                  overhead = calc_group_overhead(fs, groups-1, old_desc_blocks);
>
>

G'day Azat,

Appreciate you taking a look at this and I see where you are going with it.

While I have a backup of _all_ critical data on that array, I don't have 
20TB of spare space to back up the remainder so if you don't mind I'd 
like to wait for a review prior to letting it loose on the array.

Regards,
Brad
