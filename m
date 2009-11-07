From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in ext4_statfs()
Date: Fri, 06 Nov 2009 19:08:48 -0600
Message-ID: <4AF4C8A0.2050705@redhat.com>
References: <4AF4A429.7090507@redhat.com> <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbZKGBIr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 20:08:47 -0500
In-Reply-To: <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2009-11-06, at 15:33, Eric Sandeen wrote:
>> commit a71ce8c6c9bf269b192f352ea555217815cf027e updated 
>> ext4_statfs() to update the on-disk superblock counters, but
>> modified this buffer directly without any journaling of the change.
>> This is one of the accesses that was causing the crc errors in
>> journal replay as seen in kernel.org bugzilla #14354.
>> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com> ---

...

> I admit to being the instigator of this change.
> 
> The intention is that we want to update the on-disk superblock
> block/inode counters from the per-cpu data periodically, since they
> are never updated anymore (only the group summaries are updated, to
> avoid contention). However, this isn't critical work, since it is
> only useful for read-only e2fsck not reporting spurious errors on the
> filesystem and dumpe2fs/debugfs having some chance at reporting a
> reasonable value for the filesystem space usage.
> 
> Starting a transaction as part of statfs is really counter-productive
> to making that code efficient, which was the whole point of the
> original patch to remove the per-call "overhead" calculation.
> 
> The intention was that the in-memory superblock would be updated 
> whenever statfs is called (this doesn't cost anything, since we've
> already computed the value for statfs), and if the superblock is
> written to disk for some other reason they will go along for the
> ride.
> 
> If the choice is between adding a proper transaction here, or not
> doing this at all, I'd rather just not do it at all.  Of course, I'd
> like to work out some kind of compromise, like only updating the
> superblock when there is already a shadow BH that is being used to
> write to the journal, or similar.
> 
> If there is a desire to keep a transaction here and update the
> superblock counters, it _definitely_ doesn't need to be done on every
> statfs, but at most once every 30 seconds or whatever.

You know, I think I thought about all that, and I wrote the patch anyway 
somehow; blame a late friday evening for that one.  :)

I'll think of a better route to take.

Thanks,
-Eric
