From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Mon, 25 Oct 2010 14:43:01 -0500
Message-ID: <4CC5DDC5.7080003@redhat.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com> <4CC45318.3080002@ddn.com> <4CC45590.80608@redhat.com> <4CC45BFB.4010403@ddn.com> <4CC46241.8070107@redhat.com> <2D4557FB-DE12-43C3-A277-EE4DD82F0BFF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Bernd Schubert <bschubert@ddn.com>, "Ted Ts'o" <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab0JYTnV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 15:43:21 -0400
In-Reply-To: <2D4557FB-DE12-43C3-A277-EE4DD82F0BFF@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-10-25, at 00:43, Ric Wheeler wrote:
>> On 10/24/2010 12:16 PM, Bernd Schubert wrote:
>>> ... sometimes the error state is only set *after* mounting the
>>> filesystem, so difficult to script it.  And as I also wrote,
>>> running e2fsck from that script and to do a complete fs check is
>>> not appropriate, as that might simply time out.  Again not Lustre
>>> specific. So after some discussion, the proposed solution is to
>>> add a "journal recovery only" option to e2fsck and to do that
>>> before the mount. I will add that to the 'lustre_server' agent
>>> (which is part of Lustre now), but leave it to someone else to
>>> that for the 'Filesystem' agent script (I'm not using that script
>>> myself and IMHO it is already too complex, as it tries to support
>>> all filesystems - shell code is ideal anymore then).
>> Why not simply have your script attempt to mount the file system?
>> If it succeeds, it will replay the journal. If it fails, you will
>> need to fall back to the long fsck which is unavoidable.
> 
> I don't really agree with this.  The whole reason for having the
> error flag in the superblock and ALWAYS running e2fsck at mount time
> to replay the journal is that e2fsck should be done before mounting
> the filesystem.

Wait, why?  Why did we run with a journal if an IO error causes us
to require a fack prior to next mount?

> I really dislike the reiserfs/XFS model where a filesystem is mounted
> and fsck is not run in advance, and then if there is a serious error
> in the filesystem this needs to be detected by the kernel, the
> filesystem unmounted, e2fsck started, and the filesystem remounted...
> That's just backward.

I must be missing something.  We run with a proper, carefully designed
journal on properly configured storage so that the journal + filesystem
is always consistent.

fsck is needed when that carefully configured storage munges something
on disk, or when there's a bug in the code that corrupted the filesystem,
but certainly not just because you happened to unmount a while back and
now wish to remount...

Now, extN has this feature of recording fs errors in the superblock,
but I'm not sure we distinguish between "errors which require a fsck"
and others?

Anyway your characterization of xfs is wrong, IMHO, it's:

Mount (possibly replaying the journal) because all should be well,
we have faith in our hardware and our software.
If during runtime the fs encounters a severe metadata error, it will
shut down, and this is your cue to unmount and run xfs_repair, then
remount.  Doesn't seem backwards to me.  ;)  Requiring that fsck
prior to the first mount makes no sense for a journaling fs.

However, Bernd's issue is probably an issue in general with XFS
as well (which doesn't record error state on-disk) - how to quickly
know whether the filesystem you're about to mount in a cluster has
a -known- integrity issue from a previous mount and really does
require a fsck.

For XFS, you have to have monitored the previous mount, I guess,
and watched for any errors the kernel threw when it encountered them.

For extN we record it in the SB, but that record may only be
in the as-yet-unplayed journal, where the tools can't see it until
it's replayed by a mount or by a full fsck.

-Eric

>> We spend a lot of time and testing to make sure that ext* can be
>> shot at any point and come back after a storage outage and still
>> mount.
> 
> Sure, it can still mount, but the only thing it might be able to do
> is detect the error and remount the filesystem read-only or panic...
> That's why e2fsck should ALWAYS be run BEFORE the filesystem is
> mounted.
> 
> Bernd's issue (the part that I agree with) is that the error may only
> be recorded in the journal, not in the ext3 superblock, and there is
> no easy way to detect this from userspace.  Allowing e2fsck to only
> replay the journal is useful this problem.  Another similar issue is
> that if tune2fs is run on an unmounted filesystem that hasn't had a
> journal replay, then it may modify the superblock, but journal replay
> will clobber this.  There are other similar issues.
> 
> Cheers, Andreas -- Andreas Dilger Lustre Technical Lead Oracle
> Corporation Canada Inc.
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-ext4" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

