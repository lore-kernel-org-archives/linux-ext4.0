From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Wed, 13 May 2009 13:56:56 -0500
Message-ID: <4A0B17F8.3000402@redhat.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512030856.GI21518@mit.edu> <20090512044627.GA6753@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571AbZEMS47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2009 14:56:59 -0400
In-Reply-To: <20090512044627.GA6753@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, May 11, 2009 at 11:08:56PM -0400, Theodore Tso wrote:
>> On Thu, May 07, 2009 at 04:09:29PM +0530, Aneesh Kumar K.V wrote:
>>> ext4_get_blocks_wrap does a block lookup requesting to
>>> allocate new blocks. A lookup of blocks in prealloc area
>>> result in setting the unwritten flag in buffer_head. So
>>> a write to an unwritten extent will cause the buffer_head
>>> to have unwritten and mapped flag set. Clear hte unwritten
>>> buffer_head flag before requesting to allocate blocks.
>>>
>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> I've rewritten the commit changelog to this, which I believe more
>> accurately describes the patch.  Comments, please?
>>
>> ext4: Clear the unwritten buffer_head flag after the extent is initialized
>>
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>>
>> The BH_Unwritten flag indicates that the buffer is allocated on disk
>> but has not been written; that is, the disk was part of a persistent
>> preallocation area.  That flag should only be set when a get_blocks()
>> function is looking up a inode's logical to physical block mapping.
>>
>> When ext4_get_blocks_wrap() is called with create=1, the uninitialized
>> extent is converted into an initialized one, so the BH_Unwritten flag
>> is no longer appropriate.  Hence, we need to make sure the
>> BH_Unwritten is not left set, to avoid the ensuing confusion and
>> hilarty.
>>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
> 
> I think it is good. But one thing missing in the commit message is,
> what happens if we do a write to prealloc space. Since a
> get_block(create = 1) is now split into __get_block(create = 0 )  and
> __get_block(create = 1). That would mean if we pass a buffer head with
> BH_Unwritten cleared we will have
> 
> 
> 1) buffer_head as BH_Unwritten cleared.
> 
> 2) __get_block(create = 0 ) -> Since it is prealloc space we will have
> BH_Unwritten set .

Why do we need to set BH_Unwritten on a !create call at all?

Or maybe another way of asking is, are there any !create callers of
get_block who -want- BH_Unwritten set?

Which is to say, should we just not be setting BH_Unwritten in get_block
in the !create case, ever?

The comment:

 	/*
+	 * The above get_blocks can cause the buffer to be
+	 * marked unwritten. So clear the same.
+	 */
+	clear_buffer_unwritten(bh);

is imho not helpful; to me it says "we -just- set this, so clear it!"
It leaves me scratching my head.

> 3) __get_block(create = 1) -> get the blocks out of prealloc space.
> and retun with BH_Mapped set. 
> 
> That would imply we have BH_Unwritten and BH_Mapped set in the above
> case which is wrong. So we need a BH_Unwritten clear between (2) and
> (3). The patch does the same. May be we need to capture it in commit
> message.

Better in comments, I think.  :)

-Eric

> -aneesh
> 
> 
> 

