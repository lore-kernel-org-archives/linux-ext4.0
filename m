From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Delayed Extent Tree and Extent Lock Tree
Date: Wed, 1 Feb 2012 10:47:37 -0700
Message-ID: <F538A310-AA89-4D2E-A160-1B5385B0227F@dilger.ca>
References: <4F286C35.8080402@linux.vnet.ibm.com> <4F28E936.20303@tao.ma>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62615 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2BARri (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Feb 2012 12:47:38 -0500
In-Reply-To: <4F28E936.20303@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-01, at 12:26 AM, Tao Ma wrote:
> On 02/01/2012 06:33 AM, Allison Henderson wrote:
>> Hi Yongqiang,
>> 
>> I've have been working on an extent lock implementation that uses an
>> rbtree to keep track of locked extents, and I think I will probably end
>> up with a something similar to the tree that you've already set up for
>> delayed extents.  So I wanted to send a note out to see what folks would
>> think about the idea of merging the two solutions.
>> 
>> If we did this, the tree would get a little more complex in that it
>> would have to keep track of more than just delayed extents. It would
>> have to keep track of all extents and the processes that are waiting on
>> them.  So I guess it would kind of turn into an extent status tree.  I
>> also realize that some folks wanted to see range locks go into /lib as
>> general purpose code so that other filesystems or kernel code could use
>> it too, but the advantage to this approach would be one less tree for
>> ext4 to keep track of.  Any thoughts?
> 
> We (Taobao) are very interested in this stuff and it should benefit
> several of our workload(It is on our todo list for a long time). I guess
> Yongqiang's solution is a little bit limited to the only delayed extent
> case, and your new solution at least has 2 more benefits:
> 1. improve the direct i/o read/write
> 2. speed up the extent search since now we only cache one in
> ei_cached_extent.

Another related usage is to use a tree to track free extents in the
block allocation bitmaps.  We already have a thread starting at mount
time to do itable_init, and it would be possible to have that same
thread read block bitmaps from disk and generate a free extents tree.

That would allow much faster extent allocation without changing the
on-disk format.

Cheers, Andreas





