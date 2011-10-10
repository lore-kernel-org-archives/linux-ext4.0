From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "- 8" in EXT2_MAX_BLOCKS_PER_GROUP
Date: Mon, 10 Oct 2011 15:34:13 -0500
Message-ID: <4E9356C5.1070605@redhat.com>
References: <4E931453.3010002@redhat.com> <4E933CD0.4050003@redhat.com> <20111010201151.GM12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab1JJUeQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 16:34:16 -0400
In-Reply-To: <20111010201151.GM12447@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/10/11 3:11 PM, Darrick J. Wong wrote:
> On Mon, Oct 10, 2011 at 01:43:28PM -0500, Eric Sandeen wrote:
>> On 10/10/11 10:50 AM, Eric Sandeen wrote:
>>> When looking at the maximal filesystem size issue, I found myself
>>> wondering what the "- 8" is in here, it's not commented
>>> or documented anywhere:
>>>
>>> #define EXT2_MAX_BLOCKS_PER_GROUP(s)    (((1 << 16) - 8) *      \
>>>                                           (EXT2_CLUSTER_SIZE(s) / \
>>>                                            EXT2_BLOCK_SIZE(s)))
>>>
>>>
>>> (pre-bigalloc, it was just ((1 << 16) - 8) )
>>>
>>> Anyone know?
>>
>> Ah, Darrick pointed out
>>
>> http://osdir.com/ml/file-systems.ext2.devel/2006-03/msg00032.html
>>
>> So it would have been - 1, to not overflow __u16, but since we have
>> multiples of 8, we get - 8.
>>
>> But now we have bg_free_blocks_count_hi, giving us 32 bits of counter.
>> With EXT4_FEATURE_INCOMPAT_64BIT, MAX_BLOCKS_PER_GROUP should grow, no?
> 
> As far as I know, each group contains a block bitmap that is exactly 1 block
> long, and block can be no longer than 4096 bytes in length.  Therefore, a group
> can have no more than 4096 * 8 = 32768 blocks, correct?  To get more we'd have
> to allow blocks larger than 4K (mkfs won't allow that) or change the disk
> format to allow multi-block block bitmaps.
> 
> Unless of course a block bitmap can be the size of a cluster.... which afaict
> is not the case.

You are right:

        if (fs_param.s_blocks_per_group) {
                if (fs_param.s_blocks_per_group < 256 ||
                    fs_param.s_blocks_per_group > 8 * (unsigned) blocksize) {
                        com_err(program_name, 0,
                                _("blocks per group count out of range"));

So I guess 64k blocks on ia64 or ppc64 would get us up to 512k blocks per group.

but then MAX_BLOCKS_PER_GROUP limits us to less than that, at least for now.

So still not sure what bg_free_blocks_count_hi does for us.

-Eric

> --D

