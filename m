From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Where all does preallocated/extra space hide?
Date: Fri, 09 Oct 2009 09:51:31 -0500
Message-ID: <4ACF4DF3.3030605@redhat.com>
References: <4AC23A17.5020100@redhat.com> <20091008114851.GA22610@skywalker.linux.vnet.ibm.com> <4ACE0BA9.4090607@redhat.com> <20091009052704.GA1457@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267AbZJIOwJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Oct 2009 10:52:09 -0400
In-Reply-To: <20091009052704.GA1457@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Thu, Oct 08, 2009 at 10:56:25AM -0500, Eric Sandeen wrote:
>> Aneesh Kumar K.V wrote:
>>> On Tue, Sep 29, 2009 at 11:47:19AM -0500, Eric Sandeen wrote:
>>>> I was running some of the xfstests enospc tests on ext4, and they were
>>>> failing; in one case, manymanymany small files are made to fill up a
>>>> 100M filesystem.  ext4 stops quite early with -ENOSPC, but after a bit,
>>>> (or after a "sync") we get 40MB free again.  So 40% of the fs space is
>>>> hidden somewhere in preallocation...
>>>>
>>>> I tried calling out to discard group prealloc but that's only a few
>>>> blocks.  I'll go trace through the sync paths to see what all gets
>>>> released, but if anyone knows offhand where the rest of that space is
>>>> hiding, please give me a shout.  :)
>>>>
>>>
>>> preallocation space is discarded by default if we fail a block allocation
>>> ext4_mb_discard_preallocations does that. What might be happening is the
>>> extra meta data blocks that we reserve for making sure we will be able
>>> to properly insert the new extent on block allocation.  I guess we should
>>> force a data allocation when we fail with ENOSPC in ext4_da_writepages
>>> We currently force a journal commit so that the we claim back the blocks
>>> from deleted files. But we can also force block allocation for delayed
>>> allocated inodes so that we free some of the extra meta data we reserved
>>>
>>> -aneesh
>> Yep, I should have followed up, I narrowed it down to just that - the
>> worst-case metadata blocks - 2 metadata blocks for a 20-byte write into
>> an empty file.  :)
>>
>> I'm working on an inode walker to push out delalloc files on enospc.
> 
> 
> Should we do an inode walker ? I guess we should be doing something
> similar to balance_dirty_pages. That will kick in the flusher threads
> which inturn will force the block allocation of dirty inodes. 
> 
> -aneesh 

it'll need to be synchronous to avoid a spurious enospc I think ...
plus, we only want to flush delalloc inodes; flushing everythign would
be needlessly expensive I think... need to think about the right way to
do this.

-Eric
