From: david@lang.hm
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Thu, 9 Jun 2011 01:13:20 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1106090102590.20783@asgard.lang.hm>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com> <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com> <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
 <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com> <alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com> <BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com> <BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com> <BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
 <alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com> <BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:52027 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1FIINe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2011 04:13:34 -0400
In-Reply-To: <BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 9 Jun 2011, Amir G. wrote:

> On Thu, Jun 9, 2011 at 9:50 AM, Lukas Czerner <lczerner@redhat.com> wrote:
>> On Thu, 9 Jun 2011, Yongqiang Yang wrote:
>>
>>> On Thu, Jun 9, 2011 at 11:18 AM, Amir G. <amir73il@users.sourceforge.net> wrote:
>>>> On Thu, Jun 9, 2011 at 4:59 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>>
>> You see, when it comes to the full fs snapshots I am not convinced that
>> it is *very* useful, yes it might have some users, but you can alway
>> take the safe way and do lvm snapshots (or better use the new multisnap)
>> for backup, without need to modify stable filesystem code.
>>
>
> You think like a developer. Try talking to some sys admins.
> Especially ones that worked with Solaris/ZFS or NetApp.
> See what they think about snapshots and about the LVM alternative...
> Snapshots have addictive qualities. Ones you've used them, you can't
> go back to not having them.
> Imagine how people used to live before the 'Undo' button and imagine
> that your employer forced you to use an editor without an Undo button.
> This is the kind of feedback I got from sys admins that moved from Solaris
> to Linux.

as a sysadmin, it's a _wonderful_ tool to have for any system that has 
people editing/saving files on directly.

>
>> Also, I do not buy the whole argument of "not have to create separate disk
>> space for snapshot". It is actually better for sysadmins, because you
>> have perfect control on what is going on, how much space is used for
>> your snapshots and how much is used by your data. You can always easily
>> extend the snapshot volume, or let it die silently when it is too old
>> and too big.
>>
>
> Seriously, Lukas, talk to sys admins.
> Letting the snapshot die silently is the worst possible thing that a snapshots
> implementation can do (for long lived snapshots).

that depends on the site policy.

sometimes it is better to loose snapshots than to run out of disk space 
and halt the system, sometimes you would rather halt the system.

the policy of what happens when you run out of space should not be a 
kernel decision, the desired behavior varies far too much.

this includes being able to say things like "I want to always have 10% of 
my disk allocated to snapshots, but if there's more free space, go ahead 
and use it, but always keep at least 10% of the disk free so that you 
don't have to halt new writes while you clear space"

or

"if you run out of space, try and keep the oldest snapshot and the newest 
snapshot, delete other snapshots in between before touching either of 
these"

>> How does it actually work on ext4 snapshots ? When you're going to
>> rewrite a file, you will never know how much disk space it'll take in
>> advance, am I right ? Is the filesystem accounting for the snapshot size
>> as well ? or is it hidden ?
>
> It's not hidden, it's accounted for as a regular file (usually owned by root).
> You need a bit of scripting to gather the disk space used by snapshots (du).

the worst case when you re-write a file is that it will take the full 
amount of space that the file currently takes (as if you wrote a new copy 
of the file and some process had a filehandle open on the old copy, 
preventing the space from being reclaimed, so it's far from being a new 
problem)

see the note above about the need to be able to remove snapshots when you 
are out of space.

since snapshots tend to be small compared to the filesystems they protect 
(not in all cases, but if you are covering the entire system with one 
snapshot that would be the way to bet), having the ability to put the 
snapshot metadata off on a smaller/faster disk would be helpful.

having the ability to snapshot just specific files/directories would be a 
killer feature IMHO

David Lang
