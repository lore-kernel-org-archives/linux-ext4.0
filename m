From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Wed, 30 Jun 2010 09:21:04 -0400
Message-ID: <4C2B44C0.3090002@redhat.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab0F3NVM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 09:21:12 -0400
In-Reply-To: <20100630124832.GA1333@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/30/2010 08:48 AM, tytso@mit.edu wrote:
> On Tue, May 04, 2010 at 11:45:53AM -0400, Christoph Hellwig wrote:
>> On Tue, May 04, 2010 at 10:16:37AM -0400, Ric Wheeler wrote:
>>> Checking per inode is actually incorrect - we do not want to short cut
>>> the need to flush the target storage device's write cache just because a
>>> specific file has no dirty pages.  If a power hit occurs, having sent
>>> the pages from to the storage device is not sufficient.
>>
>> As long as we're only using the information for fsync doing it per inode
>> is the correct thing.  We only want to flush the cache if the inode
>> (data or metadata) is dirty in some way.  Note that this includes writes
>> via O_DIRECT which are quite different to track - I've not found the
>> original patch in my mbox so I can't comment if this is done right.
>
> I agree.
>
> I wonder if it's worthwhile to think about a new system call which
> allows users to provide an array of fd's which are collectively should
> be fsync'ed out at the same time.  Otherwise, we end up issuing
> multiple barrier operations in cases where the application needs to
> do:
>
> 	fsync(control_fd);
> 	fsync(data_fd);
>
> 						- Ted

The problem with not issuing a cache flush when you have dirty meta data or data 
is that it does not have any tie to the state of the volatile write cache of the 
target storage device.

We do need to have fsync() issue the cache flush command even when there is no 
dirty state for the inode in our local page cache in order to flush data that 
was pushed out/cleaned and not followed by a flush.

It would definitely be *very* useful to have an array of fd's that all need 
fsync()'ed at home time....

Ric

