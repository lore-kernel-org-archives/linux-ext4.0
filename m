From: hao dong <hao.bigrat@gmail.com>
Subject: Re: [Patch] e2fsprogs: add e2view tool to display file system blocks usage
Date: Mon, 24 Jan 2011 17:12:29 +0800
Message-ID: <AANLkTimS8CUGO8S=_b9YOFB-7a=-7poz3NiNf8CeYm97@mail.gmail.com>
References: <1295840763-17123-1-git-send-email-sanbai@taobao.com>
	<6871A0E1-954C-48C2-A432-A1F831DCD92F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54584 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1AXJM3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jan 2011 04:12:29 -0500
Received: by iwn9 with SMTP id 9so3763522iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 01:12:29 -0800 (PST)
In-Reply-To: <6871A0E1-954C-48C2-A432-A1F831DCD92F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/1/24 Andreas Dilger <adilger@dilger.ca>
>
> On 2011-01-23, at 20:46, Robin Dong wrote:
> > Having a view of blocks usage of block group descriptors, block/inode bitmaps, inode table, block pointer blocks, extents .etc, can help users in many cases,
> > 1) Make estimation on how many memory might be occupied as buffer cache or page cache.
> > 2) For some specific workload, is a file system is well formatted for block usage, e.g. whether there are never-be-used blocks allocated for inode table.
> > 3) If there is a chance to allocated meta data from non-seek-cost device like SSD as a meta-data device, first of all user should know how many meta data blocks are allocated/used on the file system.
> >
> > Therefore a tool to collect block usage information and display in a clear view is necessary. This patch is a first effort to provide such a tool which is called e2view so far.
>
> Much of this information is available via "dumpe2fs -h" already, though perhaps a more clear summary of the total block usage could be added to dumpe2fs.
>
> Instead, perhaps a better summary for the e2freefrag tool would be good, which also prints out a histogram of free blocks in the filesystem.
>
> I'd personally rather avoid adding another tool to print information like this, and just make one of the existing tools print it.

Thank you for your suggestions.
In my opinion, the main purpose of e2freefrag tool is to print FREE
blocks information, not used block.
Is it a better choice that I add a flag "-m" for dumpe2fs to display
the usage of meta data ?
