From: Darren Hart <dvhart@infradead.org>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 04 Dec 2012 09:43:21 -0800
Message-ID: <50BE3639.7090704@infradead.org>
References: <50B967E2.7090703@infradead.org> <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca> <50B990CB.3080607@infradead.org> <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca> <50BD017F.1070400@infradead.org> <E9A4182B-CEE4-419A-AE6B-F7133766ABC3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61796 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab2LDRnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 12:43:23 -0500
In-Reply-To: <E9A4182B-CEE4-419A-AE6B-F7133766ABC3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 12/04/2012 02:59 AM, Andreas Dilger wrote:
> On 2012-12-03, at 12:46, Darren Hart <dvhart@infradead.org> wrote:
>>
>> It needs symlink as you said, but I can relatively easily migrate my
>> code for that in mke2fs to debugfs.
>>
>> Still needs permissions and such. Is that done with "modify_inode" ? If
>> so, how do I specify the new contents?
> 
> "modify_inode" is not a terribly easy use interface. Probably better to add something like "chmod" and "chown" for debugfs as well. 

I was thinking the same thing.

> 
>> I need to look into how to detect and support hard links.
> 
> I was wondering about that, and hoped you wouldn't need them.  Maybe just keep a list if any files with nlink > 1 as { inode, pathname } as you go, and any inode with mlink > 1 are looked first in the duplicate list and the duplicate inode is hard linked to the original inode. 
>
> Cheers, Andreas

Right, my thoughts as well. Thanks for the confirmation!

I don't know that I need them, but I imagine a complete solution will be
more acceptable than one that fits only our needs. So while we're in
there...

--
Darren
