From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsstress-induced corruption reproduced
Date: Tue, 05 Jan 2010 08:40:49 -0600
Message-ID: <4B434F71.5080708@redhat.com>
References: <E1NQNIB-0006gT-1r@closure.thunk.org> <4B424BE4.3030605@redhat.com> <4B427507.40004@redhat.com> <20100105061728.GA7868@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab0AEOk6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jan 2010 09:40:58 -0500
In-Reply-To: <20100105061728.GA7868@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Jan 04, 2010 at 05:08:55PM -0600, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Theodore Ts'o wrote:
>>>> One of the things which has been annoying me for a while now is a
>>>> hard-to-reproduce xfsqa failure in test #13 (fsstress), which causes the
>>>> a test failure because the file system found to be inconsistent:
>>>>
>>>> Inode NNN, i_blocks is X, should be Y.
>>> Interesting, this apparently has gotten much worse since 2.6.32.
>>>
>>> I wrote an xfstests reproducer, and couldn't hit it on .32; hit it right
>>> off on 2.6.33-rc2.
>>>
>>> Probably should find out why ;) I'll go take a look.
>> commit d21cd8f163ac44b15c465aab7306db931c606908
>> Author: Dmitry Monakhov <dmonakhov@openvz.org>
>> Date:   Thu Dec 10 03:31:45 2009 +0000
>>
>>     ext4: Fix potential quota deadlock
>>
>> seems to be the culprit.
>>
>> (unfortunately this means that the error we saw before is something
>> -else- to be fixed, yet)  Anyway ...
>>
>> This is because we used to do this in ext4_mb_mark_diskspace_used() :
>>
>>         /*
>>          * Now reduce the dirty block count also. Should not go negative
>>          */
>>         if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
>>                 /* release all the reserved blocks if non delalloc */
>>                 percpu_counter_sub(&sbi->s_dirtyblocks_counter,
>> reserv_blks);
>>         else {
>>                 percpu_counter_sub(&sbi->s_dirtyblocks_counter,
>>                                                 ac->ac_b_ex.fe_len);
>>                 /* convert reserved quota blocks to real quota blocks */
>>                 vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
>> 	}
>>
>> i.e. the vfs_dq_claim_block was conditional based on
>> EXT4_MB_DELALLOC_RESERVED... and the testcase did not go that way,
>> because we had already preallocated the blocks.
>>
>> But with the above quota deadlock commit it's not unconditional
>> anymore in ext4_da_update_reserve_space and we always call
>> vfs_dq_claim_block which over-accounts.
>>
> 
> It is still conditional right ? We call ext4_da_update_reserve_space
> only if EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE  is set . That will
> happen only in case of delayed allocation. I guess the problem is
> same as what Ted stated. But i am not sure why we are able to reproduce
> it much easily on 2.6.33-rc2.
> 

Well, I'll take another look.  But back out the above commit and I think
you'll see that it changed things to make it 100% reproducible.

-Eric

