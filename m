From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: EXT4-fs: group descriptors corrupted!
Date: Wed, 25 Feb 2009 15:47:15 -0600
Message-ID: <49A5BC63.9030104@cox.net>
References: <49A5AC83.1020009@cox.net> <20090225213046.GF1363@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux-Ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtai112.cox.net ([68.230.240.31]:61778 "EHLO
	eastrmmtai112.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZBYWwI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 17:52:08 -0500
Received: from eastrmimpo03.cox.net ([68.1.16.126])
          by eastrmmtao105.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090225214716.CPGG4139.eastrmmtao105.cox.net@eastrmimpo03.cox.net>
          for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 16:47:16 -0500
Received: from [192.168.1.10] (haggis.homelan [192.168.1.10])
	by haggis.homelan (Postfix) with ESMTP id 73BB787CF9
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 15:47:15 -0600 (CST)
In-Reply-To: <20090225213046.GF1363@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/25/2009 03:30 PM, Theodore Tso wrote:
> On Wed, Feb 25, 2009 at 02:39:31PM -0600, Ron Johnson wrote:
>> These are the relevant Debian Sid package versions:
>> e2fsprogs                1.41.3-1
>> linux-source-2.6.28      2.6.28-2~snapshot.12850
>>
>> Since I built the fs with extents enabled, I am hesitant to run fsck on 
>> it because I've read that it doesn't yet support extents.
>>
>> As you can see from the dmesg snippets, one of my ext4 file systems  
>> mounted perfectly.  The one that didn't is an lvm2 "array", which seems 
>> to be consistent.
> 
> E2fsck 1.41.3 does actually have extent support, but let's not be too
> hasty to run e2fsck just yet.
> 
> Can you send me the output of "dumpe2fs -o superblock=32768
> /dev/main_huge_vg/main_huge_lv" and see how it compares to the
> dumpe2fs of your primary superblock?

# dumpe2fs -f -o superblock=32768 /dev/main_huge_vg/main_huge_lv | 
head -n800 > main_huge_lv.dump.sb32768.txt
dumpe2fs 1.41.3 (12-Oct-2008)
ext2fs_read_bb_inode: Invalid argument

http://members.cox.net/ron.l.johnson/main_huge_lv.dump.sb32768.txt

> It looks like your block group descriptors were totally scribbled
> upon.

There system cleanly shut down.  (Or, at least, I didn't notice 
anything obviously wrong.)

>        How and why it happened, I'm not sure.  But before we do
> anything else, let's check out the backup descriptors and make sure
> they are sane.

-- 
Ron Johnson, Jr.
Jefferson LA  USA

The feeling of disgust at seeing a human female in a Relationship
with a chimp male is Homininphobia, and you should be ashamed of
yourself.
