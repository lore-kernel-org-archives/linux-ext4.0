From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Mon, 25 Oct 2010 08:54:34 -0400
Message-ID: <4CC57E0A.9070502@redhat.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com> <4CC45318.3080002@ddn.com> <4CC45590.80608@redhat.com> <4CC45BFB.4010403@ddn.com> <4CC46241.8070107@redhat.com> <2D4557FB-DE12-43C3-A277-EE4DD82F0BFF@oracle.com> <4CC56DEE.8020306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
	Bernd Schubert <bschubert@ddn.com>, "Ted Ts'o" <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0JYMyt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 08:54:49 -0400
In-Reply-To: <4CC56DEE.8020306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  On 10/25/2010 07:45 AM, Ric Wheeler wrote:
>  On 10/25/2010 06:14 AM, Andreas Dilger wrote:
>> On 2010-10-25, at 00:43, Ric Wheeler wrote:
>>> On 10/24/2010 12:16 PM, Bernd Schubert wrote:
>>>> ... sometimes the error state is only set *after* mounting the filesystem,
>>>> so difficult to script it.  And as I also wrote, running e2fsck from that
>>>> script and to do a complete fs check is not appropriate, as that might
>>>> simply time out.  Again not Lustre specific. So after some discussion,
>>>> the proposed solution is to add a "journal recovery only" option to e2fsck
>>>> and to do that before the mount. I will add that to the 'lustre_server'
>>>> agent (which is part of Lustre now), but leave it to someone else to that
>>>> for the 'Filesystem' agent script (I'm not using that script myself and
>>>> IMHO it is already too complex, as it tries to support all filesystems -
>>>>   shell code is ideal anymore then).
>>> Why not simply have your script attempt to mount the file system? If it 
>>> succeeds, it will replay the journal. If it fails, you will need to fall 
>>> back to the long fsck which is unavoidable.
>> I don't really agree with this.  The whole reason for having the error flag 
>> in the superblock and ALWAYS running e2fsck at mount time to replay the 
>> journal is that e2fsck should be done before mounting the filesystem.
>>
>> I really dislike the reiserfs/XFS model where a filesystem is mounted and 
>> fsck is not run in advance, and then if there is a serious error in the 
>> filesystem this needs to be detected by the kernel, the filesystem unmounted, 
>> e2fsck started, and the filesystem remounted...  That's just backward.
>>
>
> Even if you disagree with the model, that would seem to solve the issue for 
> Bernd without having to make a change in the utilities.
>
> Thanks!
>
> Ric
>
>>> We spend a lot of time and testing to make sure that ext* can be shot at any 
>>> point and come back after a storage outage and still mount.
>> Sure, it can still mount, but the only thing it might be able to do is detect 
>> the error and remount the filesystem read-only or panic...  That's why e2fsck 
>> should ALWAYS be run BEFORE the filesystem is mounted.
>>
>> Bernd's issue (the part that I agree with) is that the error may only be 
>> recorded in the journal, not in the ext3 superblock, and there is no easy way 
>> to detect this from userspace.  Allowing e2fsck to only replay the journal is 
>> useful this problem.  Another similar issue is that if tune2fs is run on an 
>> unmounted filesystem that hasn't had a journal replay, then it may modify the 
>> superblock, but journal replay will clobber this.  There are other similar 
>> issues.
>>
>> Cheers, Andreas
>> -- 
>> Andreas Dilger
>> Lustre Technical Lead
>> Oracle Corporation Canada Inc.
>>
>

One more thought here is that effectively the xfs model of mount before fsck is 
basically just doing the journal replay - if you need to repair the file system, 
it will fail to mount. If not, you are done.

For HA fail over, what Bernd is proposing is effectively equivalent:

(1) Replay the journal without doing a full fsck which is the same as the mount 
for XFS

(2) See if the journal replay failed (i.e., set the error flag) which is the 
same as seeing if the mount succeeded

(3) If error, you need to do a full, time consuming fsck for either

(4) If no error in (2), you need to mount the file system for ext4 (xfs is 
already done at this stage)

Aside from putting the journal replay into a magic fsck flag, I really do not 
see that you are saving any complexity.  In fact, for this case, you add step (4).

Regards,

Ric

