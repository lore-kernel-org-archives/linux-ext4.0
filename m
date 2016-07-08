From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] ext4: add project quota mount options
Date: Fri, 8 Jul 2016 12:36:56 +0900
Message-ID: <CAP9B-Qm_fuw3rNGyc4068YADbOisjVm=35=siChgks4=v62qtw@mail.gmail.com>
References: <1467875386-28092-1-git-send-email-wangshilong1991@gmail.com>
 <b7ac32ea-b70d-0dc1-4b3e-f4f47dbad737@redhat.com> <20160708031002.GF19871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
	Wang Shilong <wshilong@ddn.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35834 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbcGHDg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2016 23:36:59 -0400
Received: by mail-lf0-f66.google.com with SMTP id w130so2922131lfd.2
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jul 2016 20:36:58 -0700 (PDT)
In-Reply-To: <20160708031002.GF19871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 8, 2016 at 12:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 07, 2016 at 11:06:10AM -0500, Eric Sandeen wrote:
>> > add prjquota, prjjquota, offprjjquota mount options
>> > for project quota.
>> >
>> > These kind of mount options are used for old
>> > quota design, and we can use quotas like these
>> > way:
>> >
>> >  # mkfs.ext4 /dev/sda
>> >  # mount /dev/sda -o prjquota /mnt/test
>> >  # quotacheck -p /mnt/test
>> >  # quotaon /mnt/test
>> >
>> > This new mount options are also useful to unify
>> > some generic tests for xfs and ext4.
>

<...SNIP...>


>
> Yes, for the sake of those poor, unfortunate souls who have to support
> RHEL 6 (really, you couldn't pay me enough :-), it probably makes
> sense to support the legacy style quota system using either the
> usrquota/grpquota mount options, and so it makes sense for xfstests to
> user the old-style aquota.user files that can be messed with by
> confused userspace utilities, and which are dog-slow to check becuase
> a separate quotacheck run is required.
>
> But RHEL 6 doesn't have project quota, and so I don't see any reason
> to try to support the legacy quota setup for project quota.  Yes, we
> still want to test the quotatools VFS interfaces, and that means using
> quotatools binaries --- but it doesn't follow from that choice that we
> have to support the ancient ways of storing the quota files as
> user-visible files, or using the ancient mount options which are just
> horrible hacks to keep the old enterprise linux initscripts from
> breaking.
>
> Does this make sense?


I do agree with your point here, but the problem is as you can see come
from xfstests arguments from Dave Chinner.

I don't think currently users will try to old interface with project quota.
But as your request, i think you need some tests for project quota...

I think it make sense to add a test for lsattr/chattr interface for ext4,
whatever it can be moved to ext4 or generic.


Thanks,
Shilong



>
>                                                         - Ted
