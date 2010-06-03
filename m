From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Do not zeroout uninitialized extents beyond i_size
Date: Thu, 03 Jun 2010 12:32:09 +0400
Message-ID: <87mxvc1ppy.fsf@openvz.org>
References: <1270833748-14381-1-git-send-email-dmonakhov@openvz.org>
	<87och49oly.fsf@linux.vnet.ibm.com> <871ve0qb59.fsf@openvz.org>
	<87d3whuus0.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59363 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab0FCIcR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 04:32:17 -0400
Received: by fxm8 with SMTP id 8so2499303fxm.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jun 2010 01:32:16 -0700 (PDT)
In-Reply-To: <87d3whuus0.fsf@linux.vnet.ibm.com> (Aneesh Kumar K. V.'s message
	of "Thu, 27 May 2010 22:49:43 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> On Wed, 28 Apr 2010 11:38:58 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>> "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> writes:
>> 
>> > On Fri,  9 Apr 2010 21:22:28 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>> >> Zerrout trick allow us to optimize cases where it is more reasonable
>> >> to explicitly zeroout extent and mark it as initialized instead of
>> >> splitting to several small ones.
>> >> But this optimization is not acceptable is extent is beyond i_size
>> >> Because it is not possible to have initialized blocks after i_size.
>> >> Fsck treat this as incorrect inode size.
>> >> 
>> >
>> > With commit c8d46e41bc744c8fa0092112af3942fcd46c8b18 if we set
>> > EXT4_EOFBLOCKS_FL we should be able to have blocks beyond i_size.
>> > May be the zero out path should set the flag instead of doing all these
>> > changes. Zero-out is already complex with all the ENOSPC related
>> > consideration. I guess we should try to keep it simple.
>> For initialized extent beyond i_size? I've check fsck and seems that
>> is truly possible. So this optimization allow us to avoid some 
>> bad EIO situations. But we have to rework ext_get_blocks( ,create == 1)
>> to clear EXT4_EOFBLOCKS_FL if last block of latest_extent is requested.
>> I'll handle this.
>> >
>
>
> I thought this patch is going to reworked to use EOFBLOCKS_FL. But i see
> Ted sent a pull request with the this patch. Did I miss something ?
Sorry for a long replay.
As far as i can see EXT4_EOFBLOCKS_FL flag is now allowed for
uninitialized extents only in e2fslib. So we have to change e2fslib
first and then revert the kernel zeroout restriction logic.
