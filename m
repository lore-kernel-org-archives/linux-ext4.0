From: Darren Hart <dvhart@infradead.org>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 04 Dec 2012 09:46:06 -0800
Message-ID: <50BE36DE.6030300@infradead.org>
References: <50B967E2.7090703@infradead.org> <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca> <50B990CB.3080607@infradead.org> <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca> <50BD017F.1070400@infradead.org> <20121204152231.GG29083@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26614 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab2LDRqJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 12:46:09 -0500
In-Reply-To: <20121204152231.GG29083@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 12/04/2012 07:22 AM, Theodore Ts'o wrote:
> On Mon, Dec 03, 2012 at 11:46:07AM -0800, Darren Hart wrote:
>>> Maybe Ted can confirm whether that is true or not.  At least I recall
>>> that the block allocator inside libext2fs was horrible, and creating
>>> large files was problematic.
>>
>> Ted, can you confirm?
> 
> The block allocator inside libext2fs is primitive; it will find the
> first free block and use it.  It should be OK for populating large
> flash devices for file system images stored on flash devices (where
> seeks don't matter so block group placement isn't a big deal), and
> especially for fixed root file system images which are mounted
> read-only and which tend to be updated only once in a while (i.e., in
> the cases of Android system updates), and so you don't really care
> about aligning file writes to eMMC erase blocks.
> 
> It could certainly be made better, and for people who were trying to
> use libext2fs with FUSE targetting hard drives, there are ample
> opportunities for improvements.....
> 


I think what I'm reading here is that if you care about having a
filesystem that makes hardware specific optimizations, you're better off
mounting the device and copying the filesystem over. In that case, plan
on needing root access.


> Creating large files shouldn't be a problem (unless what you mean is
> ext4 huge files ala the huge file feature where the number of 512
> blocks exceeds 2**32, in which case you should probably test that case
> if you care about it), and it certainly will create extents-based
> files.

Great, sounds like this approach is still viable. Thanks Ted!

--
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
