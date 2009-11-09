From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in	ext4_statfs()
Date: Sun, 08 Nov 2009 21:41:28 -0700
Message-ID: <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com>
References: <4AF4A429.7090507@redhat.com>
 <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com> <20091108214804.GC7592@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62438 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZKIElZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Nov 2009 23:41:25 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nA94fUdG000479
	for <linux-ext4@vger.kernel.org>; Sun, 8 Nov 2009 20:41:30 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KST00900RFUB700@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sun,
 08 Nov 2009 20:41:30 -0800 (PST)
In-reply-to: <20091108214804.GC7592@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-08, at 14:48, Theodore Tso wrote:
> On Fri, Nov 06, 2009 at 05:26:51PM -0700, Andreas Dilger wrote:
>> If the choice is between adding a proper transaction here, or not
>> doing this at all, I'd rather just not do it at all.  Of course, I'd
>> like to work out some kind of compromise, like only updating the
>> superblock when there is already a shadow BH that is being used to
>> write to the journal, or similar.
>
> In practice, the superblock is never going to modified in normal
> operations, unless a resize happens to be happening.

Actually, Eric had a important case where the superblock is modified
is whenever any file is added to the orphan list, so this basically
happens all the time.  When the orphan code was added, it made sense
to put the head of the orphan list on the superblock because it was
updated for every truncate to change the free block counters.

> Since we already force the superblock summary counters to be correct
> during an unmount or file system freeze, we really only need this so
> that it's correct after a file system crash.
>
> I don't think people generally end up calling statfs() all that
> frequently, so it's not clear how much adding a 30 second throttle
> would help.  Maybe we should just not bother trying to update the
> superblock at all on a statfs()?


The reason we added this was for running a read-only e2fsck on a
filesystem without getting spurious errors just because the superblock
summaries were incorrect.  The other alternative is to change e2fsck
so that it doesn't consider just a block/inode summary an error.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

