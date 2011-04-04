From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] x86, defconfig: replace ext3 with ext4
Date: Sun, 03 Apr 2011 19:07:59 -0700
Message-ID: <4D9927FF.5010806@xenotime.net>
References: <20110401074548.17629.77638.stgit@localhost6> <20110403132208.GC5141@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:50626 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753592Ab1DDCIA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 22:08:00 -0400
In-Reply-To: <20110403132208.GC5141@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/3/2011 6:22 AM, Jan Kara wrote:
> On Fri 01-04-11 11:45:48, Konstantin Khlebnikov wrote:
>> Replace ext3 with ext4, because now it is a de facto standard file system.
>> And set CONFIG_EXT4_USE_FOR_EXT23=y to use it also for mounting ext2/ext3.
>    I'm sorry but I think it's too early for CONFIG_EXT4_USE_FOR_EXT23 part.

I considered the date of the email and then just ignored it.  ;)

