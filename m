From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 05 Mar 2007 12:02:59 -0800
Message-ID: <45EC7773.7020603@us.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, nscott@aconex.com,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com, Ulrich Drepper <drepper@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39488 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbXCEUDG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2007 15:03:06 -0500
In-Reply-To: <20070305122742.GA11486@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara wrote:
>>>On Fri, 02 Mar 2007 09:40:54 +1100
>>>Nathan Scott <nscott@aconex.com> wrote:
>>>
>>>
>>>
>>>>On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
>>>>
>>>>
>>>>>On Fri, 2 Mar 2007 00:04:45 +0530
>>>>>"Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>>>This is to give a heads up on few patches that we will be soon coming up
>>>>>>with. These patches implement a new system call sys_fallocate() and a
>>>>>>new inode operation "fallocate", for persistent preallocation. The new
>>>>>>system call, as Andrew suggested, will look like:
>>>>>>
>>>>>>asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
>>>>>
>>>>>...
>>>>>
>>>>>I'd agree with Eric on the "command" flag extension.
>>>>
>>>>Seems like a separate syscall would be better, "command" sounds
>>>>a bit ioctl like, especially if that command is passed into the
>>>>filesystems..
>>>>
>>>
>>>
>>>madvise, fadvise, lseek, etc seem to work OK.
>>>
>>>I get repeatedly traumatised by patch rejects whenever a new syscall gets
>>>added, so I'm biased.
>>>
>>>The advantage of a command flag is that we can add new modes in the future
>>>without causing lots of churn, waiting for arch maintainers to catch up,
>>>potentially adding new compat code, etc.
>>>
>>>Rename it to "mode"? ;)
>>>
>>
>>I am wondering if it is useful to add another mode to advise block 
>>allocation policy? Something like indicating which physical block/block 
>>group to allocate from (goal), and whether ask for strict contigous 
>>blocks. This will help preallocation or reservation to choose the right 
>>blocks for the file.
> 
>   Yes, I also think this would be useful so you can "guide"
> preallocation for things like defragmentation (e.g. preallocate space
> for the file being defragmented and move the file to it).
> 
> 									Honza
Yep, I think it makes sense to use preallocation for defragmentation.
After all both preallocation and defragmentation shall call underlying 
filesystem multiple block allocator to try to allocate a chunk of 
contiguous blocks on disk. ext4 online defrag implementation by Takashi 
already support to choose a "goal" allocation block to guide the ext4 
block allocator to place the defraged file is a specific location.

Passing a little bit more hint to sys_fallocate() (i.e, goal block, 
and/or whether the goal block is important over the size of prealloc 
extent), might make it more useful for the orginial goal (get contigous 
and guranteed blocks) and for defragmentation.

Regards,
Mingming
