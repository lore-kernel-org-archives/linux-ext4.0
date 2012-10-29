From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sun, 28 Oct 2012 21:09:09 -0500
Message-ID: <508DE545.7030903@redhat.com>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com> <87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org> <87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org> <87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org> <873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org> <87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com> <878varzk56.fsf@spindle.srvr.nix> <508C50BB.2040300@redhat.com> <87390zzjr9.fsf@spindle.srvr.nix> <508C5357.6090204@redhat.com> <09758CEA-74B5-48D0-8075-BB723A2CABBB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Nix <nix@esperi.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384Ab2J2CJR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 22:09:17 -0400
In-Reply-To: <09758CEA-74B5-48D0-8075-BB723A2CABBB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/28/12 12:08 PM, Andreas Dilger wrote:
> On 2012-10-27, at 15:34, Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> wrote:
>> I've been testing with a hacked up devicemapper target which creates
>> a "dirty" snapshot which requires a replay; saves the actual power
>> drop & restore cycle, and I could repro the journal_checksum bug
>> right off.
> 
> Are you using dm-flakey, or something home grown?  I've heard about dm-flakey, but haven't looked into the details to know whether it is actually useful for such testing. 

I just changed DM to not quiesce the fs by hardcoding do_lockfs to "0" in dm_suspend().

>> XFS has an ioctl to make this easy in regression testing, and several
>> tests in xfstests do cover xfs journal recovery.  We need
>> to add such a thing to ext4.  Not being able to programatically
>> test recovery is a problem.
> 
> We have a patch that we used for testing Lustre (and in turn ext4)
> recovery which sits in the block layer and discards writes after a
> trigger is hit. The trigger can be triggered programmatically inside
> the Lustre code, or via ioctl from userspace.
> 
> http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch
> <http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch;h=8c79b40b939fccbdb5c3bc4501ee433e23cc7831;hb=HEAD>
>
>
> 
I'd been thinking of moving our testing over to dm-flakey once we get to a new enough kernel (2.6.38+) and/or when it gets back-ported to RHEL6, since this is the last patch to the core kernel that we need for Lustre.

XFS has XFS_IOC_GOINGDOWN to force recovery on the next mount, and several xfstests to exercise it.

-Eric
 
> Cheers, Andreas

