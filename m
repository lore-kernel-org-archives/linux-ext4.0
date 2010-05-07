From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: status of MMP?
Date: Fri, 7 May 2010 15:29:59 -0400
Message-ID: <08039B58-D2C3-495B-AA24-036E4D390611@oracle.com>
References: <201005052330.49491.bs_lists@aakef.fastmail.fm> <87zl0b21ki.fsf@basil.nowhere.org> <4BE42E6B.90405@ddn.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andi Kleen <andi@halobates.de>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Bernd Schubert <bschubert@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:53544 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab0EGTau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 15:30:50 -0400
In-Reply-To: <4BE42E6B.90405@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-05-07, at 11:14, Bernd Schubert wrote:
> On 05/07/2010 05:06 PM, Andi Kleen wrote:
>> Bernd Schubert <bs_lists@aakef.fastmail.fm> writes:
>>> Lustres ldiskfs already has MMP support for several years and I would like to know what is the blocker for ext4? Updating the MMP patches for ext4-git 
>>> should be fairly simple.
>> 
>> AFAIK simply nobody has done the work and submitted it.
>> 
>> Simply adding it would break LVM snapshots though, so there's a 
>> compatibility issue.
> 
> Well, firstly, you are not forced to enable MMP. And then, I don't
> understand what should be the issue with MMP. We use snapshots + ldiskfs
> + MMP all the time.

The MMP thread is not started on a device that is mounted read-only, which should be the case for all snapshots.  The snapshot is a logically different block device, so even if it were changed to be read-write that would be fine since the MMP thread would prevent shared access to THAT block device, not the original block device.

> I have a basic understanding how the MMP code works, but not as thorough
> as the Orcacle Lustre team. Andreas, would you mind if I post updated
> patches here?

No objection at all - it's one of the things I've been meaning to do for a while, but haven't gotten around to.  It has been in widespread use at a number of sites and has been working well.  It definitely isn't something that we would want to enable by default, since it would prevent disks from spinning down and would add some background IO overhead.  For environments with SAN or multi-port storage (e.g. HA servers) it is an important safety check that can prevent massive data corruption.

In Lustre bugzilla bug 22375 is a version that has been updated for the 2.6.32 kernel, so that is probably the best one to start with and I'd be surprised if much needs to change to land it upstream.  The e2fsprogs support is in the Lustre e2fsprogs against 1.41.10 and should really be landed upstream before or at the same time as the kernel.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

