From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 20:58:23 +0200
Message-ID: <87y741k65s.fsf@frosties.localdomain>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<87ej5ugcn2.fsf@frosties.localdomain> <20080716091846.44174452@ichigo>
	<877ibl97jy.fsf@frosties.localdomain> <20080716110242.7cffffa5@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:52268 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbYGPS7h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 14:59:37 -0400
In-Reply-To: <20080716110242.7cffffa5@ichigo> (Jose R. Santos's message of
	"Wed, 16 Jul 2008 11:02:42 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Jose R. Santos" <jrs@us.ibm.com> writes:

> On Wed, 16 Jul 2008 17:23:45 +0200
> Goswin von Brederlow <goswin-v-b@web.de> wrote:
>> /*
>>  * Set the fs block count
>>  */
>> void ext2fs_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
>> {
>>         super->s_blocks_count = blk;
>>         if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
>>            super->s_blocks_count_hi = (__u64) blk >> 32;
>> }
>> 
>> EXT4_FEATURE_INCOMPAT_64BIT is not set so the upper bits just get
>> ignored.
>> 
>> MfG
>>         Goswin
>> 
>> PS: Should functions that chop off upper bits like that make sure they
>> are 0?
>
> I think this is something that need to be cheched at fsck since having
> these be non-zero on a non-64-bit FS should be pointing to file system
> corruption.  Not sure if its something that need to be done every time
> we set a value on the lower bit only though.

I ment checking the blk64_t blk < 2^32. And yes then the function has
to return an error code EINVAL.

But they should be zeroed out as well in the superblock just in case.

> We could add error code here but that means that the users of the
> routine need to handle the error code.  Determining now if we need to
> return errcode_t here now would avoid the need to change the API later.
>
> Ted.  Any comment on this one?
>
> -JRS

MfG
        Goswin
