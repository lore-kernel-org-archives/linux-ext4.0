From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Tue, 06 Sep 2011 11:44:45 -0500
Message-ID: <4E664DFD.80308@redhat.com>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com> <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1IFR3s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 13:29:48 -0400
In-Reply-To: <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/6/11 11:37 AM, Christian Kujau wrote:
> On Tue, 6 Sep 2011 at 11:17, Eric Sandeen wrote:
>> It's probably not a bug or flaw; orphan inodes can occur for legitimate
>> reasons (fs goes down while someone is holding open an unlinked file),
> 
> The filesystem is being constantly accessed by an application, holding at 
> least one file open (readonly). And then there is this mechanism trying to 
> remount the filesystem rw and then ro again every day. I guess this equals
> the scenario of "fs goes down (remount!) while someone is holding open a 
> file"?

well, no - "goes down" means "crashed or lost power"

>> Did you happen to also get a message like this on the original mount?
>>                 ext4_msg(sb, KERN_ERR, "write access "
>>                         "unavailable, skipping orphan cleanup");
> 
> I think I've seen this message before, but I'm nore sure where and it's 
> not in the logs of this particular system.
> 
>> See also commit: 
>>
>> commit ead6596b9e776ac32d82f7d1931d7638e6d4a7bd
>> Author: Eric Sandeen <sandeen@redhat.com>
>> Date:   Sat Feb 10 01:46:08 2007 -0800
>>
>>     [PATCH] ext4: refuse ro to rw remount of fs with orphan inodes
> 
> Yes, I've seen this commit when I was searching where this message came
> from. And I think I understand now why this is happening, but 
> still...if I may ask: can't this be handled more elegantly? Do other 
> filesystems have the same problem?

well, as the commit said, it'd be nice to handle it in remount, yes... :(

> Right now the procedure is to pause the application, stop the nfs exports,
> unmount, fsck, mount, start nfs exports and resume the application. And
> every few days/weeks this has to be repeated, "just because" these daily
> remounts occur (which are the main reason for this, I suppose).

well, seems like you need to get to the root cause of the unprocessed
orphan inodes.

I don't yet have my post-vacation thinking cap back on... does cycling
rw/ro/rw/ro with open & unlinked files cause an orphan inode situation?

-Eric

> Thanks for replying,
> Christian.

