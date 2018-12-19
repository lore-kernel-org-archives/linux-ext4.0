Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:16606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727356AbeLSEr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 23:47:26 -0500
Subject: Re: [PATCH 2/2] ext4: clean up group state test macros with predicate
 functions
To: Andreas Dilger <adilger@dilger.ca>
References: <1545134401-104523-1-git-send-email-yi.zhang@huawei.com>
 <1545134401-104523-2-git-send-email-yi.zhang@huawei.com>
 <1095F3A1-32A9-42A7-BE1C-40A7212015D0@dilger.ca>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Wang Shilong <wshilong@ddn.com>,
        Miao Xie <miaoxie@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <0173dff1-127d-96d8-cd70-e94935e6230c@huawei.com>
Date: Wed, 19 Dec 2018 12:47:10 +0800
MIME-Version: 1.0
In-Reply-To: <1095F3A1-32A9-42A7-BE1C-40A7212015D0@dilger.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2018/12/19 3:51, Andreas Dilger Wrote:
> On Dec 18, 2018, at 5:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>
>> Create separate predicate functions to test/set/clear/test_and_set
>> bb_state flags in ext4_group_info like features testing, and then
>> replace all old macros and the places where we use
>> EXT4_GROUP_INFO_XXX_BIT directly.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>> +#define EXT4_MB_GROUP_STATE_FUNCS(name, statename)			\
>> +static inline int ext4_mb_grp_##name(struct ext4_group_info *grp)	\
>> +{									\
>> +	return test_bit(EXT4_GROUP_INFO_##statename##_BIT,		\
>> +			&(grp->bb_state));				\
>> +}									\
>> +static inline void ext4_mb_grp_set_##name(struct ext4_group_info *grp)	\
>> +{									\
>> +	set_bit(EXT4_GROUP_INFO_##statename##_BIT, &(grp->bb_state));	\
>> +}									\
>> +static inline void ext4_mb_grp_clear_##name(struct ext4_group_info *grp)\
>> +{									\
>> +	clear_bit(EXT4_GROUP_INFO_##statename##_BIT, &(grp->bb_state));	\
>> +}									\
>> +static inline int ext4_mb_grp_test_and_set_##name(struct ext4_group_info *grp) \
>> +{									\
>> +	return test_and_set_bit(EXT4_GROUP_INFO_##statename##_BIT,	\
>> +				&(grp->bb_state));			\
>> +}
>> +
>> +EXT4_MB_GROUP_STATE_FUNCS(need_init, NEED_INIT)
>> +EXT4_MB_GROUP_STATE_FUNCS(trimmed, WAS_TRIMMED)
>> +EXT4_MB_GROUP_STATE_FUNCS(bbitmap_corrupt, BBITMAP_CORRUPT)
>> +EXT4_MB_GROUP_STATE_FUNCS(ibitmap_corrupt, IBITMAP_CORRUPT)
> 
> One problem with macros like this that internally expand to multiple
> functions is that there is now nowhere in this code where, for example,
> the declaration of ext4_mb_grp_test_and_set_bbitmap_corrupt() can be
> found.  That makes it hard to understand the code, because tags for this
> function name will not work, and even a grep through the entire code for
> this string will not show the function implementation, only users.  One
> would have to search for only the "ext4_mb_grp_test_and_set" part, or
> "ext4_mb_grp_clear" to find the above macros.
> 
> If such macros-that-generate-functions are being used, my preference is
> that at least a comment block is added that spells out the full function
> names, so that at least a grep will find them, like:
> 
> /*
>  * These macros implement the following functions:
>  * - ext4_mb_grp_need_init(), ext4_mb_grp_test_and_set_need_init(),
>  *   ext4_mb_grp_set_need_init(), ext4_mb_grp_clear_need_init()
>  * - ...
>  * - ...
>  */
> 
> Yes, this is a bit cumbersome the rare times a new function is added, but
> it really makes the code easier to understand in the future, without forcing
> a cut-and-paste of the body of each function.  I don't know how many times
> I've had to search for commonly-used functions like buffer_uptodate() or
> buffer_dirty() in the code without being able to find them easily.
> 

Thanks for your comments. Indeed, I also had the same hard time as you said.
I am not so sure why we have been using these maco functions for ext4 features
and ext4_inode_info bit flags. But I think it's still worth to unify them.

I will add the comment block as your suggested and post the second version,
BTW, I read the commit 3f61c0cc706 "ext4: add prototypes for macro-generated
functions" you posted, it's also a good choice.

Thanks,
Yi.
