From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] default max mount count to unused
Date: Fri, 22 Jan 2010 12:02:14 -0500
Message-ID: <4B59DA16.3060906@redhat.com>
References: <4B5785A5.2010505@redhat.com> <20100122012929.GA21263@thunk.org> <4B591D80.6010309@redhat.com> <4B7FFE9D-F110-408D-B432-7D20AEBD4689@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, tytso@mit.edu,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab0AVRCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 12:02:00 -0500
In-Reply-To: <4B7FFE9D-F110-408D-B432-7D20AEBD4689@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/22/2010 03:09 AM, Andreas Dilger wrote:
> On 2010-01-21, at 20:37, Eric Sandeen wrote:
>> That sounds fine, as do mke2fs.conf hooks, as does a nice shipped script
>> to do background checking of snapshots.
>>
>> But I still don't know why "You mounted your fs 20 times" is a good
>> proxy for "you had better check for corruption now."  Have we so
>> little faith?  :)
>
>
> I've thought for quite a while that 20 mounts is too often, but I'm 
> reluctant to turn it off completely.  I wouldn't object to increasing 
> it to 60 or 80.
>
> At one time there was a patch that checked the state of the filesystem 
> at mount time and only incremented only 1/5 of the time (randomly) if 
> it was unmounted cleanly (not dirty, or not in recovery), but every 
> time if it crashed.  The reasoning was that systems which crashed are 
> more likely to have memory corruption or software bugs, and ones that 
> shut down cleanly are less likely to have such problems.
>

I do like the snapshot idea, but also think that we need something will 
not introduce random (potentially multi-hour or multi-day) fsck runs 
after an otherwise clean reboot.

If we hit this with a combination of:

Reboot time:
     (1) Try to mount the file system
     (1) on mount failure, fsck the failed file system

While up and running, do a periodic check with the snapshot trick.

I think that would balance the fear that we have of creeping corruption 
(or at least severe corruption) against the need to be speedy when 
rebooting....

ric

