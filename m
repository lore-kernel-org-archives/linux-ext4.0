From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE 	restricts
 block allocation
Date: Fri, 16 Oct 2009 15:47:35 +0900
Message-ID: <4AD81707.3030405@sx.jp.nec.com>
References: <4A409168.3020404@rs.jp.nec.com>	 <20090623231950.GN31668@webber.adilger.int>	 <4A7BCCD8.1070500@rs.jp.nec.com> <87f94c370908091118l4e0923feyf36eb2a067a3f948@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61374 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZJPGuF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 02:50:05 -0400
In-Reply-To: <87f94c370908091118l4e0923feyf36eb2a067a3f948@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Greg,
I'm sorry for the late reply.

2009/08/10 3:18, Greg Freemyer wrote:
> Akira-san,
> 
> I joined the project ohsm team a couple weeks ago and we hope to use
> your patches / features to build on.  Below is our feedback as relates
> to ohsm as well as my personal feedback.
> 
[snip]
>> > Ioctl interfaces are as follows.
>> >
>> > a. EXT4_IOC_BALLOC_CONTROL (Set or clear balloc restriction)
>> >
>> >     EXT4_IOC_BALLOC_CONTROL
>> >        _IOW('f', 16, struct ext4_balloc_control balloc_control)
>> >
>> >     struct ext4_balloc_control {
>> >       __u64 start; /* start physical block offset balloc rest */
>> >       __u64 len;   /* block length */
>> >       __u32 flags; /* set or clear */
>> >     }
>> >
>> >    "flags" can be set following 2 types.
>> >    - SET_BALLOC_RESTRICTION
>> >        Set blocks in range to the balloc restriction list.
>> >    - CLR_BALLOC_RESTRICTION
>> >        Clear blocks from the balloc restriction list.
> 
> ohsm will be an in kernel user of the above, so we hope a kernel API
> is also provided.  I assume that would be a simple export and
> documenting it in Documentation/filesystems/ext4.
> 

When we implement this ioctl, we will consider about a kernel API.
However, we have no plan to make the kernel API.

Also we consider the documenting after we decide the specific of the
implementation.

> It seems you need to add 3 flags to the above:
> mandatory - Have a future block allocate request return ENO_SPACE_PA
> if the blocks cannot be found within the restricted range.
> advisory - Attempt future block allocate requests from the restricted
> range, but use entire unrestricted block range if that fails.
> mandatory_with_fallback - Not Implemented - If block allocate from
> restricted range fails, fallback to an alternate block range.  API and
> implementation details not yet agreed on.

I'm worried that you misunderstand about the restriction PA.
If you set a restriction PA, a block allocation cannot allocate
blocks into there. Setting a block range that is allocated first
is the role of the inode PA.

> 
[snip]
> 
>> > b. EXT4_IOC_ADD_PREALLOC (Add inode preferred range)
>> >
>> >     EXT4_IOC_ADD_PREALLOC _IOW('f', 18, struct ext4_balloc_control)
>> >
>> >     struct ext4_balloc_control {
>> >       __u64 start; /* start physical block offset */
>> >       __u64 len;   /* block length */
>> >       __u32 flags;  /* create and add mode for inode PA  */
>> >     }
>> >
>> >    "flags" must include one of the following create modes
>> >    (MANDATORY or ADVISORY).  In addition, one of the control modes also must
>> >    be set (REPLACER_INODE_PREALLOC or ADD_INODE_PREALLOC).
>> >     Create modes:
>> >     - MANDATORY
>> >         Find free extent which satisfies "start" and "len" completely.
>> >     - ADVISORY
>> >         Try to find free extent from "start" and "len" blocks.
>> >     Control modes:
>> >     - REPLACE_INODE_PREALLOC
>> >         Remove existed inode PA first, and then add specified range to
>> >         the inode PA list newly.
>> >     - ADD_INODE_PREALLOC
>> >         Add specified range to the inode PA list.
>> >
>> >     e.g.  flag = MANDATORY | ADD_INODE_PREALLOC
>> >           Find free extent which fulfills the requirements completely,
>> >           and if succeed, add this extent to the inode PA.
> 
> I am unsure how the above relates to EXT4_IOC_BALLOC_CONTROL.  It
> appears to be totally independent which I don't think is a good idea.
> Nor do I understand the use case of the advisory flag and
> add_inode_prealloc flag.
> 
> I would prefer if the above API were simplified to:
> 
> b. EXT4_IOC_RESET_PREALLOC (Ensure inode prealloc range is withing
> preferred block alloc range)
> 
>     EXT4_IOC_ADD_PREALLOC _IOW('f', 18, struct ext4_balloc_control)
> 
>     struct ext4_balloc_control {
>       __u32 flags;  /* Currently unused  */
>     }
> 
> Find appropriate free prealloc block extent within range set of inode
> via EXT4_IOC_BALLOC_CONTROL.
> 
> If unable to do so, a preallock block is set via the default logic and
> a error is returned to show that the prealloc block is not within the
> restricted block range.
> 
> This seems far simpler to code, understand, and use.
> 

In advisory mode of the inode PA, the ioctl tries to get the inode PA
that satisfies "start" and "len" completely. If it fails, the ioctl
gets an inode PA from somewhere. Your suggestion seems like this mode.
However, the mandatory mode of the inode PA is necessary for e4defrag,
so struct ext4_balloc_control has flag field that can be set two modes.

In ADD_INODE_PREALLOC mode of the inode PA, the ioctl appends an inode PA
without any changing of existed inode PAs. With hindsight, this flag
is not necessary for e4defrag, so I will remove the flags
ADD_INODE_PREALLOC and REPLACE_INODE_PREALLOC.

Regards,
Kazuya Mio

