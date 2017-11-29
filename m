From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Wed, 29 Nov 2017 10:07:39 +0200
Message-ID: <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org> <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org> <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org> <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ashlie Martinez <ashmrtn@utexas.edu>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:36148 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbdK2IHk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Nov 2017 03:07:40 -0500
Received: by mail-yb0-f193.google.com with SMTP id c69so1038694ybf.3
        for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2017 00:07:40 -0800 (PST)
In-Reply-To: <20171129061307.f6hekryi3bppo26y@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 29, 2017 at 8:13 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 28, 2017 at 03:27:47PM -0600, Ashlie Martinez wrote:
>>
>> Unfortunately this timing bug only reproduces on some machines. Xiao
>> and I have been unable to reproduce this bug (I've tried kvm-xfstests,
>> my own kvm VMs, VMs without kvm, VMs with/without virtio drivers, and
>> another bare metal system). generic/456 basically sets up a race
>> condition between a kernel flusher thread and triggering dm-flakey, so
>> I think things like system load, core count, etc. might cause
>> different test results.
>
> Hmm, now I remember the details.  It reproduced reliably on
> gce-xfstests, but I was able to use kvm-xfstests to debug the problem
> (by invocations of debugfs to dump the file system state as I had
> described).  That's because debugfs operates on the buffer cache, and
> before the jbd2 commit, the changes to the inode structure are in the
> buffer cache, but they aren't allowed to be persisted on disk until
> after the journal commit.  And I was using debugfs to dump the inode's
> extent tree (as it exists in the buffer cache) before triggering
> dm-flakey.
>
> Now that we understand what is happening, it should be simple to
> adjust the test so it reliably reproduces, by adding a "sleep 6"
> before _flakey_drop_and_remote.  Since the delayed allocation write
> won't get resolved until 30 seconds after the inode was first dirtied,
> and the default jbd2 timer value is 5 seconds, this should guarantee
> that the jbd2 commit has taken place so that the inode changes made by
> fallocate are persisted onto the journal, while still allowing the
> delayed allocation write to be remain unresolved.
>

Sorry, sleep 6 didn't work for me.
Must be some other subtle detail.
If you could work out how to fix the test to catch the bug in kvm-xfstests
that would be nice.

Better yet, if you can figure out how to configure kvm-xfstests differently
so it catches the bug without modifying g/456 that would be much better,
because I currently cannot use kvm-xfstest to debug ANY of the
dm-log-writes crash test dummies.

Thanks,
Amir.
