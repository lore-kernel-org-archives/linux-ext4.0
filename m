From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: zero out blocks of freed user data for operation a virtual machine
   environment
Date: Mon, 25 May 2009 17:19:06 -0400
Message-ID: <4A1B0B4A.8050706@tmr.com>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Thomas Glanzmann <thomas@glanzmann.de>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:57425 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZEYVT3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 17:19:29 -0400
In-Reply-To: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thomas Glanzmann wrote:
> Hello Ted,
> I would like to know if there is already a mount option or feature in
> ext3/ext4 that automatically overwrites freed blocks with zeros? If this
> is not the case I would like to know if you would consider a patch for
> upstream? I'm asking this because I currently do some research work on
> data deduplication in virtual machine environments and corresponding
> backups. It would be a huge space saver if there is such a feature
> because todays and tomorrows backup tools for virtual machine
> environments work on the block layer (VMware Consolidated Backup, VMware
> Data Recovery, and NetApp Snapshots). This is not only true for backup
> tools but also for running Virtual machines. The case that this future
> addresses is the following: A huge file is downloaded and later delted.
> The backup and datadeduplication that is operating on the block level
> can't identify the block as unused. This results in backing up the
> amount of the data that was previously allocated by the file and as such
> introduces an performance overhead. If you're interested in real live
> data, I'm able to provide them.
> 
> If you don't intend to have such an optional feature in ext3/ext4 I
> would like to know if you know a tool that makes it possible to zero out
> unused blocks?
> 
Treating blocks as unused due to content seems a bad idea, if you want them to 
be unused look for references to TRIM, if you want this for security look at 
shred. And if you are interested in backing sparse files I believe that the tar 
"-S" option will do what you want or provide code you can use to start writing 
what you want.

I don't think this is a good solution to the problem that unused space is not 
accounted as you wish it would be. Most filesystems have a bitmap to track this 
already, a handle on that would be more generally useful.

Deleting files is slow enough, identifying unused storage by content is 1950s 
thinking, and also ignores the fact that new drives often don't come zeroed, and 
would behave badly unless you manually zeroed the unused portions.

I doubt this is the optimal solution, since you would have to read the zeros to 
see if they were present, making backup smaller but no faster than just doing a 
copy.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
