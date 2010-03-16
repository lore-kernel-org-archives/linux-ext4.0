From: "Frans van de Wiel" <fvdw@fvdw.eu>
Subject: Re: bug in ext3 code causing OOM error on systems with small memory
Date: Tue, 16 Mar 2010 20:50:41 +0100
Message-ID: <A3EB2A214241435BA2367EE2076C2444@FransW7>
References: <84493E34003342289DF1705263D087AC@FransW7> <20100312135736.2f3f5b91.akpm@linux-foundation.org> <20100315184301.GB7744@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <adilger@sun.com>, <linux-ext4@vger.kernel.org>,
	"Mingming Cao" <cmm@us.ibm.com>, "Jan Kara" <jack@suse.cz>
To: "Jan Kara" <jack@suse.cz>,
	"Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from edu-smtp-02.edutel.nl ([88.159.1.222]:33367 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab0CPUIr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Mar 2010 16:08:47 -0400
In-Reply-To: <20100315184301.GB7744@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Jan, Andrew

The patch looks fine to me, if you say using free_blocks is better in the if 
statement I believe you, as said I am not a very experienced C programmer.
I just used "common sense" to locate this loop causing problems on my 
system.
I will sign it off as you requested and double check it in the weekend by 
compiling the kernel again with this patch.

PS there is one thing, think a similar patch is required in balloc.c in 
fs/ext2 as well.
There is the same loop only it does not cause on OOM error but it 
significantly delays the creation of a sub folder (25 seconds  on my disk of 
500 GB, with the patch its done it less then a second)

kind regards, Frans van de Wiel

--------------------------------------------------
From: "Jan Kara" <jack@suse.cz>
Sent: Monday, March 15, 2010 7:43 PM
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Frans van de Wiel" <fvdw@fvdw.eu>; <adilger@sun.com>; 
<linux-ext4@vger.kernel.org>; "Mingming Cao" <cmm@us.ibm.com>; "Jan Kara" 
<jack@suse.cz>
Subject: Re: bug in ext3 code causing OOM error on systems with small memory

>  Hi,
>
> On Fri 12-03-10 13:57:36, Andrew Morton wrote:
>> (cc's added)
>  Thanks for forwarding.
>
>> On Sat, 6 Mar 2010 10:31:07 +0100
>> "Frans van de Wiel" <fvdw@fvdw.eu> wrote:
>>
>> > Dear sirs
>> >
>> > Recently I compiled the linux-2.6.33 kernel for my arm9  based NAS 
>> > using the orion5x mach.
>> > The kernel runs but when creating a sub directory outside the root in a 
>> > big disk ext3 partition (in my case 5000 GB) it caused an OOM error.
>> >
>> > journal_get_undo_access: No memory for committed data
>> > ext3_try_to_allocate_with_rsv: aborting transaction: Out of memory in 
>> > __ext3_journal_get_undo_access
>> >
>> > Now my NAS has a tiny system memory only 16 MB  but it worked fine on 
>> > older kernels like 2.6.12.
>> > I am not an experienced C programmer but I investigated the problem and 
>> > think I found the reason and that it might be a good idea to share this 
>> > with you as it might be useful for others with the same problem and I 
>> > think it will speed up sub directory creation on big partitions.
>> > The problem is also present in etx2 driver but it does not cause an OOM 
>> > as there is no journaling, however it causes a significant delay in 
>> > directory creation.
>> > Creating a sub directory took in my case 25 seconds on a 500 GB disk. 
>> > Thats not acceptable.
>> >
>> >  It took me a while to figure it out why, but it appeared that when 
>> > trying to create a sub directory the driver starts to look for free 
>> > blocks with a block group number that was not suitable (too high). Then 
>> > the routine starts to check all groups one by one to find a suitable 
>> > group. As there are almost 4000 groups on a 500 GB partition that takes 
>> > time and in case of using ext3 the journaling of that action caused an 
>> > out of memory situation. On ext2 it just took a long time to make a sub 
>> > directory (up to 20 seconds or so).
>> >
>> > The error was in the balloc.c file  where there is a routine to 
>> > allocate new blocks.
>> >
>> > By adding printk lines I finally found the place where the problem was. 
>> > After comparing this file with the linux-2.6.12.6 version it appeared 
>> > that in the newer version they deleted a check that caused the loop to 
>> > continue without trying to allocate in cause the group was not 
>> > suitable, so skipping the time and memory intensive part of the loop 
>> > for that group.
>> > I added that again and voila problem solved. Think on more powerful 
>> > system with more memory you will never notice the problem but on the 
>> > NAS with its limited hardware it caused an issue.
>> >
>> > I attached a file showing the part of the balloc.c file with the 
>> > problem and the correction made (the correction is in line 117-120 of 
>> > the attached file in between the lines markes /* fvdw */). I am not a C 
>> > expert and just copied the check from the old version (of course 
>> > adapting variables names to match with the new version). But it seems 
>> > to fix the problem. I checked with printk statements, the adapted 
>> > routine allocates to the same block as without this correction, it only 
>> > skips unnecessary work. maybe you can have a look at it if it its ok 
>> > and will not cause other problems.
>> > The function at line 137 was causing the OOM error when called too many 
>> > times after each other in ext3  and in ext causing the delay of 
>> > creating the directory.
>> >
>> > Hope this information is useful to you. I am not a n experienced C 
>> > progrommar so my bug rapport may be different from your standards sorry 
>> > for this
>> >
>>
>> Thanks.  Here's Frans's patch:
>>
>> --- a/fs/ext3/balloc.c~a
>> +++ a/fs/ext3/balloc.c
>> @@ -1581,6 +1581,8 @@ retry_alloc:
>>  gdp = ext3_get_group_desc(sb, group_no, &gdp_bh);
>>  if (!gdp)
>>  goto io_error;
>> + if (!gdp->bg_free_blocks_count)
>> + continue;
>>  free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
>>  /*
>>  * skip this group if the number of
>  I'd just add a comment why this check is needed but otherwise the patch
> looks fine. Maybe I'd just use free_blocks in the check. I know that
> zero-check works fine even with disk-endian value but still... And I agree
> that the Mingming's patch probably caused the regression.
>  Frans, do you agree with the patch below and can I add you Signed-off-by
> to it (see Documentation/SubmittingPatches)?
>
> Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> ---
>
> From 0e7e5dd29c072fa7afe0a25d64d41682a07d7dff Mon Sep 17 00:00:00 2001
> From: Frans van de Wiel <fvdw@fvdw.eu>
> Date: Mon, 15 Mar 2010 19:29:34 +0100
> Subject: [PATCH] ext3: Avoid loading bitmaps for full groups during block 
> allocation
>
> There is no point in loading bitmap for groups which are completely full.
> This causes noticeable performance problems (and memory pressure) on small
> systems with large full filesystem
> (http://marc.info/?l=linux-ext4&m=126843108314310&w=2).
>
> Jan Kara: Added a comment and changed check to use cpu-endian value.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> fs/ext3/balloc.c |    6 ++++++
> 1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 161da2d..c0980fc 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1583,6 +1583,12 @@ retry_alloc:
>  goto io_error;
>  free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
>  /*
> + * skip this group (and avoid loading bitmap) if there
> + * are no free blocks
> + */
> + if (!free_blocks)
> + continue;
> + /*
>  * skip this group if the number of
>  * free blocks is less than half of the reservation
>  * window size.
> -- 
> 1.6.4.2
> 
