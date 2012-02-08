From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 2/2] ext3: Don't update ctime in ext3_splice_branch()
Date: Wed, 08 Feb 2012 17:36:45 +0900
Message-ID: <4F32341D.6080803@sx.jp.nec.com>
References: <4F2657BD.8030208@sx.jp.nec.com> <20120130175217.GA7827@quack.suse.cz> <4F28F021.8030904@sx.jp.nec.com> <20120201104633.GA16714@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51391 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2BHIjc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Feb 2012 03:39:32 -0500
In-Reply-To: <20120201104633.GA16714@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/02/01 19:46, Jan Kara wrote:
> On Wed 01-02-12 16:56:17, Kazuya Mio wrote:
>> 2012/01/31 2:52, Jan Kara wrote:
>>>   Thanks for the patches.  This is true for ordinary writes but not true
>>> when you write via mmap. We call file_update_time() during page fault so
>>> ctime won't be completely wrong but still we should update it after block
>>> is allocated during writeback to reflect that new block is allocated to
>>> the inode.
>>
>> Should we update ctime whenever a block is allocated?
>    Since ctime should be updated whenever inode is changed, and allocating
> block updates i_blocks (via dquot_alloc_block()), we should update ctime.
>
>> If so, ordinary write in ext4 with indirect block mapping has the same problem
>> due to the following patch, right?
>> http://marc.info/?l=linux-ext4&m=124505184027078&w=4
>    It's kind of the same problem. But things are more complicated by the
> fact that ext4 also does delayed allocation so, as changelog of the patch
> you reference says, it's kind of unexpected from users to see ctime
> suddently update when VM decides to do writeout triggering block
> allocation. I'd think updating ctime is a correct (although unexpected)
> thing to do but I can understand Ted's position as well and he's ext4
> maintainer :).

I see. But I think we don't need to update ctime every time at this point.
ext3 doesn't support nanosecond timestamp, so it is wasteful to update ctime
whenever we allocate one block. How about the following patch?

http://patchwork.ozlabs.org/patch/140073/

The result of my measurement shows that the above patch can reduce the number of
calling ext3_mark_inode_dirty() almost the same as the previous one.

Regards,
Kazuya Mio
