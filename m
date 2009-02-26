From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: EXT4-fs: group descriptors corrupted!
Date: Wed, 25 Feb 2009 18:23:25 -0600
Message-ID: <49A5E0FD.7010809@cox.net>
References: <49A5AC83.1020009@cox.net> <20090225213046.GF1363@mit.edu> <49A5BC63.9030104@cox.net> <20090225231853.GG1363@mit.edu> <49A5D74D.9030309@cox.net> <20090226000541.GC3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux-Ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao101.cox.net ([68.230.240.7]:62573 "EHLO
	eastrmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZBZAX3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 19:23:29 -0500
In-Reply-To: <20090226000541.GC3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/25/2009 06:05 PM, Andreas Dilger wrote:
> On Feb 25, 2009  17:42 -0600, Ron Johnson wrote:
>> On 02/25/2009 05:18 PM, Theodore Tso wrote:
>>> Now let's take a look at your dumpe2fs output.  In your case, we see
>>> the following:
>>>
>>> Filesystem created:       Thu Jan 22 19:33:20 2009
>>> Last mount time:          Fri Jan 23 16:23:58 2009
>>> Last write time:          Sun Feb 22 02:31:02 2009
>>> Mount count:              1
>>> Maximum mount count:      24
>>> Last checked:             Fri Jan 23 16:19:49 2009
>>> Check interval:           15552000 (6 months)
>>> Next check after:         Wed Jul 22 17:19:49 2009
>>>
>>> and it's the same on both the primary and backup (dumpe2fs -o
>>> superblock=32768).  The question is how the heck did *that* happen?
>>> As I mentioned, the kernel doesn't even have code to touch the backup
>>> superblock.
> 
> Except online resizing?  It HAS to update the backup superblocks,
> otherwise if the primary gets corrupted the backup will not have
> the right total blocks count and anything beyond the old blocks
> count might be lost...
> 
>>> Does that the "last write" timestamp suggest anything to you?  What
>>> was happening on the system at or around Sun Feb 22 02:31:02 2009?
>>> Maybe if we can localize this down to what userspace program caused
>>> the problem, it'll be a hint.
>> That's about 10 hours before I rebooted the machine, middle of a  
>> Saturday night...
> 
> Please take time zones into account also.
> 
>> I performed a rather large apt-get upgrade at around 01:30, but that  
>> would have only touched /, not my "big data" directory. ~/Documents  is 
>> symlinked into /data/big/Documents, so I might have been editing an OOo 
>> document, or copying a YouTube file to it, but nothing pops into mind.
> 
> This might have happened AFTER your reboot, by e2fsck or similar?

Since I'm at -0600, that would have been Sat Feb 21 20:31:02 2009 
CST, and I'd have been watching TV, or some such.  *Maybe* dumping a 
movie to disk from DVD with mplayer.

-- 
Ron Johnson, Jr.
Jefferson LA  USA

The feeling of disgust at seeing a human female in a Relationship
with a chimp male is Homininphobia, and you should be ashamed of
yourself.
