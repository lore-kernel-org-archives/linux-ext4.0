From: Tao Ma <tm@tao.ma>
Subject: Re: Delayed Extent Tree and Extent Lock Tree
Date: Wed, 01 Feb 2012 15:26:46 +0800
Message-ID: <4F28E936.20303@tao.ma>
References: <4F286C35.8080402@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48013 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753486Ab2BAH0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Feb 2012 02:26:49 -0500
In-Reply-To: <4F286C35.8080402@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Allison,
On 02/01/2012 06:33 AM, Allison Henderson wrote:
> Hi Yongqiang,
> 
> I've have been working on an extent lock implementation that uses an
> rbtree to keep track of locked extents, and I think I will probably end
> up with a something similar to the tree that you've already set up for
> delayed extents.  So I wanted to send a note out to see what folks would
> think about the idea of merging the two solutions.
> 
> If we did this, the tree would get a little more complex in that it
> would have to keep track of more than just delayed extents. It would
> have to keep track of all extents and the processes that are waiting on
> them.  So I guess it would kind of turn into an extent status tree.  I
> also realize that some folks wanted to see range locks go into /lib as
> general purpose code so that other filesystems or kernel code could use
> it too, but the advantage to this approach would be one less tree for
> ext4 to keep track of.  Any thoughts?
We (Taobao) are very interested in this stuff and it should benefit
several of our workload(It is on our todo list for a long time). I guess
Yongqiang's solution is a little bit limited to the only delayed extent
case, and your new solution at least has 2 more benefits:
1. improve the direct i/o read/write
2. speed up the extent search since now we only cache one in
ei_cached_extent.

So please go ahead with your new solution. btw, do you have any timeline
for it? We are glad to provide any help if needed.

Thanks
Tao
