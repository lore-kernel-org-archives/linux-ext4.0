From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: lock i_mutex for fallocate?
Date: Thu, 01 Sep 2011 10:47:31 -0700
Message-ID: <4E5FC533.1060409@linux.vnet.ibm.com>
References: <4E5ED2D5.8040302@linux.vnet.ibm.com> <20110901073146.GA17100@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54435 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab1IARsz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Sep 2011 13:48:55 -0400
In-Reply-To: <20110901073146.GA17100@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/01/2011 12:31 AM, Christoph Hellwig wrote:
> On Wed, Aug 31, 2011 at 05:33:25PM -0700, Allison Henderson wrote:
>> Hi All,
>>
>> In ext4 punch hole, we realized that the punch hole operation needs
>> to be done under i_mutex just like truncate.  i_mutex for truncate
>> is held in the vfs layer, so we dont need to lock it at the file
>> system layer, but vfs does not lock i_mutex for fallocate.  We can
>> lock i_mutex for fallocate at the fs layer, but question was raised
>> then: should i_mutex for fallocate be held in the vfs layer instead?
>> I do not know if other file systems need i_mutex to be locked for
>> fallocate, or if they might be locking it already, so I am doing
>> some investigating on this idea, and also the appropriate use of
>> i_mutex in general.  Can someone provide some insight this topic?
>
> Don't do it.
>
> i_mutex is already overloaded, and this does not fit into any
> of the somewhat reasonable uses cases for it, which are:
>
>   a) for directories the VFS uses it to protect the tree topology
>   b) for regular files all generic I/O code currently uses it to
>      serialize writers.
>   c) the VFS uses it around truncate, and setxattr updates
>   d) filesystems abuse it for internal metadata in various places
>
> As you can see right now we do not hold it over any file operation,
> and I'm absolutely against adding that.  I'd rather untange the
> current uses, specificly:
>
>   - push synchronization of setattr into the filesystems
>   - push synchronization of xattr write operations into the filesystems
>   - move the read/write synchronization to a separate shared/exclusive
>     lock like it's already done in XFS, and like Lukas proposed for
>     ext4.  This fixes the Posix compliance corner cases about reads
>     beeing atomic vs writes, simplifies direct I/O locking a lot,
>     and allows for more parallel direct I/O support like XFS supports.
>   - try to get rid of the abuses inside filesystems as much as possible.
>

Alrighty, this helps explain things!  Thx all for the feedback!  :)
