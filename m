From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Do not zeroout uninitialized extents beyond i_size
Date: Wed, 28 Apr 2010 11:38:58 +0400
Message-ID: <871ve0qb59.fsf@openvz.org>
References: <1270833748-14381-1-git-send-email-dmonakhov@openvz.org>
	<87och49oly.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42943 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0D1HjD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Apr 2010 03:39:03 -0400
Received: by bwz19 with SMTP id 19so247194bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 28 Apr 2010 00:39:00 -0700 (PDT)
In-Reply-To: <87och49oly.fsf@linux.vnet.ibm.com> (Aneesh Kumar K. V.'s message
	of "Wed, 28 Apr 2010 10:10:09 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> On Fri,  9 Apr 2010 21:22:28 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>> Zerrout trick allow us to optimize cases where it is more reasonable
>> to explicitly zeroout extent and mark it as initialized instead of
>> splitting to several small ones.
>> But this optimization is not acceptable is extent is beyond i_size
>> Because it is not possible to have initialized blocks after i_size.
>> Fsck treat this as incorrect inode size.
>> 
>
> With commit c8d46e41bc744c8fa0092112af3942fcd46c8b18 if we set
> EXT4_EOFBLOCKS_FL we should be able to have blocks beyond i_size.
> May be the zero out path should set the flag instead of doing all these
> changes. Zero-out is already complex with all the ENOSPC related
> consideration. I guess we should try to keep it simple.
For initialized extent beyond i_size? I've check fsck and seems that
is truly possible. So this optimization allow us to avoid some 
bad EIO situations. But we have to rework ext_get_blocks( ,create == 1)
to clear EXT4_EOFBLOCKS_FL if last block of latest_extent is requested.
I'll handle this.
>
> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
