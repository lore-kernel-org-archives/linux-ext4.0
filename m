From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Wed, 29 Nov 2017 05:37:49 +0200
Message-ID: <CAOQ4uxi1Bjq45axW3NDxbftwd3-neS5Xg=_9urfBw8Y-=XWn7g@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org> <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org> <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org> <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:37728 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdK2Dhu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Nov 2017 22:37:50 -0500
Received: by mail-yw0-f169.google.com with SMTP id v12so852081ywe.4
        for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2017 19:37:50 -0800 (PST)
In-Reply-To: <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 28, 2017 at 11:27 PM, Ashlie Martinez <ashmrtn@utexas.edu> wrote:
> On Tue, Nov 28, 2017 at 2:45 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Tue, Nov 28, 2017 at 07:04:54AM -0600, Ashlie Martinez wrote:
>>> No biggie, part of the reason this was so hard for me to wrap my head
>>> around is I don't have a physical machine that I can reproduce this on
>>> (and I never got around to getting a GCE instance to test on). Not
>>> being able to poke around a reproducing system makes it a little bit
>>> harder for me to reason about :)
>>
>> This does reproduce easily using kvm-xfstests[1]; using gce-xfstests
>> was not necessary.  That's actually how I debugged it, since kvm
>> starts up in under 5 seconds, while starting up a cloud VM takes a bit
>> longer.  So if you want a quick edit/compile/debug cycle, or if you
>> attach a debugger to the running kernel, using kvm-xfstests is the
>> right tool to use.  99% of the command syntax and test appliance
>> implementation is the same between kvm-xfstests and gce-xfstests.
>
> Unfortunately this timing bug only reproduces on some machines. Xiao
> and I have been unable to reproduce this bug (I've tried kvm-xfstests,
> my own kvm VMs, VMs without kvm, VMs with/without virtio drivers, and
> another bare metal system). generic/456 basically sets up a race
> condition between a kernel flusher thread and triggering dm-flakey, so
> I think things like system load, core count, etc. might cause
> different test results.
>

For what it's worth, I wasn't able to reproduce on my kvm-xfstests machine
either. With 2 cores, virtio over LVM/SSD. Didn't try to play with parameters.

Amir.
