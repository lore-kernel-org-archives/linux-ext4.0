From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Tue, 28 Nov 2017 15:27:47 -0600
Message-ID: <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org> <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org> <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:43172 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752418AbdK1V1t (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Nov 2017 16:27:49 -0500
Received: by mail-ua0-f194.google.com with SMTP id e10so1642244uah.10
        for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2017 13:27:48 -0800 (PST)
In-Reply-To: <20171128204525.ijpis74t75f4bbsc@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 28, 2017 at 2:45 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 28, 2017 at 07:04:54AM -0600, Ashlie Martinez wrote:
>> No biggie, part of the reason this was so hard for me to wrap my head
>> around is I don't have a physical machine that I can reproduce this on
>> (and I never got around to getting a GCE instance to test on). Not
>> being able to poke around a reproducing system makes it a little bit
>> harder for me to reason about :)
>
> This does reproduce easily using kvm-xfstests[1]; using gce-xfstests
> was not necessary.  That's actually how I debugged it, since kvm
> starts up in under 5 seconds, while starting up a cloud VM takes a bit
> longer.  So if you want a quick edit/compile/debug cycle, or if you
> attach a debugger to the running kernel, using kvm-xfstests is the
> right tool to use.  99% of the command syntax and test appliance
> implementation is the same between kvm-xfstests and gce-xfstests.

Unfortunately this timing bug only reproduces on some machines. Xiao
and I have been unable to reproduce this bug (I've tried kvm-xfstests,
my own kvm VMs, VMs without kvm, VMs with/without virtio drivers, and
another bare metal system). generic/456 basically sets up a race
condition between a kernel flusher thread and triggering dm-flakey, so
I think things like system load, core count, etc. might cause
different test results.

>
> [1] https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
>
> I've been trying to promote the use of kvm-xfstests for researchers
> who are interested in doing file system work.  So if you can help
> promote {kvm,gce}-xfstests amongst your fellow students and
> professors, that would be great!
>
>
> You can run the reproducer automatically via "kvm-xfstests -c 4k
> generic/456".  But you can also run "kvm-xfstests shell", and then run
> the following commands;
>
> kvm-xfstests# export FSTESTSET=generic/456
> kvm-xfstests# ./runtests.sh
>
> You can then edit the test script to add debugging commands; it can be
> found in /root/xfstests/tests/generic/456 and then rerun the tests
> using the "./runtests.sh" script.
>
> Sorry, the only editor available is /bin/ed.  If you want to use some
> other editor, and are willing to build your own test-appliance VM
> image instead of just downloading the rebuilt test applinace image,
> you can add it to the xfstests-packages file in the
> kvm-xfstests/test-appliance directory, and generate your own test
> appliance.  See [2] for more details.
>
> [2] https://github.com/tytso/xfstests-bld/blob/master/Documentation/building-rootfs.md
>
> This is actually how I figured out what was happening; I added
> commands such as "debugfs -R 'stat <11>'" so I could see was going on
> with the file system before the _flakey_drop_and_remount statement,
> and then varied the number of operations in the fsx operations to
> replay list.
>
> Regards,
>
>                                                 - Ted
