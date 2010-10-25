From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous mount: IO failure
Date: Mon, 25 Oct 2010 18:14:03 +0800
Message-ID: <2D4557FB-DE12-43C3-A277-EE4DD82F0BFF@oracle.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com> <4CC45318.3080002@ddn.com> <4CC45590.80608@redhat.com> <4CC45BFB.4010403@ddn.com> <4CC46241.8070107@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Bernd Schubert <bschubert@ddn.com>, "Ted Ts'o" <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:37987 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0JYKOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 06:14:53 -0400
In-Reply-To: <4CC46241.8070107@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-25, at 00:43, Ric Wheeler wrote:
> On 10/24/2010 12:16 PM, Bernd Schubert wrote:
>> 
>> ... sometimes the error state is only set *after* mounting the filesystem,
>> so difficult to script it.  And as I also wrote, running e2fsck from that
>> script and to do a complete fs check is not appropriate, as that might
>> simply time out.  Again not Lustre specific. So after some discussion,
>> the proposed solution is to add a "journal recovery only" option to e2fsck
>> and to do that before the mount. I will add that to the 'lustre_server'
>> agent (which is part of Lustre now), but leave it to someone else to that
>> for the 'Filesystem' agent script (I'm not using that script myself and
>> IMHO it is already too complex, as it tries to support all filesystems -
>>  shell code is ideal anymore then).
> 
> Why not simply have your script attempt to mount the file system? If it succeeds, it will replay the journal. If it fails, you will need to fall back to the long fsck which is unavoidable.

I don't really agree with this.  The whole reason for having the error flag in the superblock and ALWAYS running e2fsck at mount time to replay the journal is that e2fsck should be done before mounting the filesystem.

I really dislike the reiserfs/XFS model where a filesystem is mounted and fsck is not run in advance, and then if there is a serious error in the filesystem this needs to be detected by the kernel, the filesystem unmounted, e2fsck started, and the filesystem remounted...  That's just backward.

> We spend a lot of time and testing to make sure that ext* can be shot at any point and come back after a storage outage and still mount.

Sure, it can still mount, but the only thing it might be able to do is detect the error and remount the filesystem read-only or panic...  That's why e2fsck should ALWAYS be run BEFORE the filesystem is mounted.

Bernd's issue (the part that I agree with) is that the error may only be recorded in the journal, not in the ext3 superblock, and there is no easy way to detect this from userspace.  Allowing e2fsck to only replay the journal is useful this problem.  Another similar issue is that if tune2fs is run on an unmounted filesystem that hasn't had a journal replay, then it may modify the superblock, but journal replay will clobber this.  There are other similar issues.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

