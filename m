From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Add stack I/O manager.
Date: Mon, 21 May 2007 15:57:26 +0530
Message-ID: <4651740E.6090704@linux.vnet.ibm.com>
References: <11786983382211-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <d286e4520f717821cf2363ff3c71a9fff5ecad2f.1178698029.git.aneesh.kumar@linux.vnet.ibm.com> <20070519033100.GB8654@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:48669 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbXEUK1l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 06:27:41 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4LATH0C8282206
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 20:29:17 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4LAV85b160080
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 20:31:08 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4LARaX3011450
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 20:27:36 +1000
In-Reply-To: <20070519033100.GB8654@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Wed, May 09, 2007 at 01:42:17PM +0530, Aneesh Kumar K.V wrote:
>> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>
>> This I/O manager helps in stacking different I/O managers.
>> For example one can stack the undo I/O manager on top
>> of Unix I/O manager to achieve the undo functionality.
> 
> This is probably more generality than is strictly necessary; and the
> place where the excess generality gets messy is the fact that you make
> the stacking layer responsible for calling all of the io manager's
> open routines (which is still a FIXME).  So I would flush the stack_io
> layer entirely.


Can't we address the FIXME by calling the respective close routine in 
the failure case.

One thing i didn't like with the stack_io was, we will be opening the 
device at each stacked I/O manager layer; which i also think is okey 
provided we expect to use these I/O managers independently

> 
> What I would recommend as the fast and dirty approach.  Basically, ape
> the approach used by test_io layer _exactly_, except instead of using
> a global variable test_io_backing_manager, you provide a function
> which sets the static variable, undo_io_backing_manager.  This
> variable is used only by the subsequent call to the ->open method,
> which just like test_io simply passes the name down to the backing
> manager specified in the static variable.  Then just make the undo_io
> manager work the way test_io does, where does its thing, and then it
> calls the appropriate function in its private->real io_channel.
> Basically, make undo_io responsible for calling the next io_manager
> down in the chain, This is workable because we don't need to
> initialize the tdb file until we first try to write to the io_channel,
> and ext2fs_open() only needs to do read operations, so we can set the
> tdb filename via an optoin after ext2fs_open() returns.
> 

One thing i was confused about was the usage of read_blk, write_blk etc 
pointers in test_private_data. With respect to undo I/O manager do i 
need to provide them ?. If we really need them, then i was thinking a 
generic stacking layer as i send in the patches would be better. That 
means any pluggable functionality that we achieve right now by setting
test_io_cb_read_blk etc will be implemented as a I/O manager that does 
the particular task. Later we stack all these I/O manager to get the 
full functionality.

-aneesh
