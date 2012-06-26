From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 09:06:54 -0400
Message-ID: <4FE9B3EE.8040701@redhat.com>
References: <4FE8086F.4070506@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Fredrick <fjohnber@zoho.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab2FZNGz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 09:06:55 -0400
In-Reply-To: <4FE8086F.4070506@zoho.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/25/12 2:42 AM, Fredrick wrote:
> Hello Ext4 developers,
> 
> When calling fallocate on ext4 fs, ext4_fallocate does not initialize
> the extents. The extents are allocated only when they are actually
> written. This is causing a problem for us. Our programs create many
> "write only once" files as large as 1G on ext4 very rapidly at times.
> We thought fallocate would solve the problem. But it didnt.

What actual problem is this?  Fallocate does indeed allocate the extents -
it picks real, physical blocks on the disk, and allocates them to the file
in question.  If you map the file, you'll see those blocks.

The only thing it does not do is write data into them, but instead flags
them as unwritten, so that subsequent reads will return zeros.  So when
you say fallocate did not solve "this problem" which problem
do you mean?

> If I change the EXT4_GET_BLOCKS_CREATE_UNINIT_EXT to
> just EXT4_GET_BLOCKS_CREATE in the ext4_map_blocks in the ext4_fallocate call,
> the extents get created in fallocate call itself. This is helping us.
> Now the write throughtput to the disk was close to 98%. When extents were not
> initialized, our disk throughput were only 70%.
> 
> Can this change be made to ext4_fallocate?

Others addressed the serious problems with allowing fallocate to expose
bits of stale user data, but a couple things:

1) Can you describe the workload a bit more?  I'd be interested to know what
kind of workload you have which shows a 30% perf regression converting
unwritten extents.  So you fallocate 1G files, and then write to them how?

2) Are you sure zoho.com customers will be ok with the potential for
data exposure?  It's up to you I suppose to determine whether this is really
a risk, but you need to fully understand the implications of the patches
others have provided.  There are good reasons I and others have resisted
merging them upstream.

-Eric
 
> Thanks,
> Fredrick
