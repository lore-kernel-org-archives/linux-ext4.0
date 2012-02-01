From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Delayed Extent Tree and Extent Lock Tree
Date: Wed, 01 Feb 2012 15:04:25 -0700
Message-ID: <4F29B6E9.3060008@linux.vnet.ibm.com>
References: <4F286C35.8080402@linux.vnet.ibm.com> <4F28E936.20303@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43080 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab2BAWGB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Feb 2012 17:06:01 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 1 Feb 2012 17:06:00 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id B78FE6E8054
	for <linux-ext4@vger.kernel.org>; Wed,  1 Feb 2012 17:05:45 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q11M4TiH229422
	for <linux-ext4@vger.kernel.org>; Wed, 1 Feb 2012 17:04:29 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q11M4RAA013020
	for <linux-ext4@vger.kernel.org>; Wed, 1 Feb 2012 17:04:28 -0500
In-Reply-To: <4F28E936.20303@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/01/2012 12:26 AM, Tao Ma wrote:
> Hi Allison,
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
> We (Taobao) are very interested in this stuff and it should benefit
> several of our workload(It is on our todo list for a long time). I guess
> Yongqiang's solution is a little bit limited to the only delayed extent
> case, and your new solution at least has 2 more benefits:
> 1. improve the direct i/o read/write
> 2. speed up the extent search since now we only cache one in
> ei_cached_extent.
>
> So please go ahead with your new solution. btw, do you have any timeline
> for it? We are glad to provide any help if needed.
>
> Thanks
> Tao
>

Thx all for the feed back, it sounds like there will be a lot of 
benefits to extending Yongqiang's delayed extent tree, so I will work on 
a solution based on that patch set.  Unfortunately though, I cannot give 
a time frame for this work item at the moment.  There are currently some 
other business needs that may take priority over this one, and until 
those have been decided, I cannot make any promises at this point in 
time.  But I will work as quickly as I can with it since it is currently 
on my plate, and I will keep folks updated.  At the moment, feed back 
and guidance is most helpful to me.  Also, since the delayed extent 
solution is now a dependency for my solution, anything to help get that 
reviewed and merged would help me too.  Yongqiang, does the set still 
need review?  I think I recall Ted saying it was still on his list of 
things to look at.  Im sure I will give it some good exercise here too. 
  Thx all for your help!  :)

Allison Henderson

