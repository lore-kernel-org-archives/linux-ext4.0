From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: ignore differing NEEDS_RECOVERY flag on backup
 sbs
Date: Sat, 22 Nov 2008 21:29:07 -0600
Message-ID: <4928CE03.8010003@redhat.com>
References: <49281F18.7080404@redhat.com> <20081122173654.GE3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45104 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbYKWD3L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Nov 2008 22:29:11 -0500
In-Reply-To: <20081122173654.GE3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Nov 22, 2008  09:02 -0600, Eric Sandeen wrote:
>> This is for RH bugzilla 471925 -  Complete scan of filesystems expanded online
>>
>> When we resize online, the primary superblock gets copied to all
>> the backups, and of course since we're mounted the NEEDS_RECOVERY
>> flag is set.  A subsequent fsck will find the backups have the
>> NEEDS_RECOVERY flag set while the primary does not, and this
>> forces a full fsck pass.
>>
>> I think this flag can be safely ignored in the flag comparisons.
> 
> Should we also mask out this flag from the backup superblock copies
> when they are made, or is there an equal chance that the superblock
> has NEEDS_RECOVERY and the backups do not?

I think it might be a good idea (to mask at growfs time) for
completeness.  Is there *ever* any valid reason for a backup superblock
to have this flag set?  Near as I can tell, online growfs is the only
thing that ever sets it, and this "flag match" check is the only thing
that ever tests it.

-Eric
