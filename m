From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Thu, 9 Jun 2011 12:17:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106091212410.4138@dhcp-27-109.brq.redhat.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com> <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com> <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
 <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com> <alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com> <BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com> <BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com> <BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
 <alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com> <BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com> <alpine.DEB.2.02.1106090102590.20783@asgard.lang.hm> <BANLkTimKEL=1+XS59U7GWj6sfU_CCypsWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1187090254-1307614648=:4138"
Cc: david@lang.hm, Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com,
	Arvin Schnell <arvin.schnell@opensuse.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1FIKRl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2011 06:17:41 -0400
In-Reply-To: <BANLkTimKEL=1+XS59U7GWj6sfU_CCypsWA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1187090254-1307614648=:4138
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 9 Jun 2011, Amir G. wrote:

> On Thu, Jun 9, 2011 at 11:13 AM,  <david@lang.hm> wrote:
> > On Thu, 9 Jun 2011, Amir G. wrote:
> >
> >> On Thu, Jun 9, 2011 at 9:50 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> >>>
> >>> On Thu, 9 Jun 2011, Yongqiang Yang wrote:
> >>>
> >>>> On Thu, Jun 9, 2011 at 11:18 AM, Amir G.
> >>>> <amir73il@users.sourceforge.net> wrote:
> >>>>>
> >>>>> On Thu, Jun 9, 2011 at 4:59 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>
> >>>>> wrote:
> >>>
> >>> You see, when it comes to the full fs snapshots I am not convinced that
> >>> it is *very* useful, yes it might have some users, but you can alway
> >>> take the safe way and do lvm snapshots (or better use the new multisnap)
> >>> for backup, without need to modify stable filesystem code.
> >>>
> >>
> >> You think like a developer. Try talking to some sys admins.
> >> Especially ones that worked with Solaris/ZFS or NetApp.
> >> See what they think about snapshots and about the LVM alternative...
> >> Snapshots have addictive qualities. Ones you've used them, you can't
> >> go back to not having them.
> >> Imagine how people used to live before the 'Undo' button and imagine
> >> that your employer forced you to use an editor without an Undo button.
> >> This is the kind of feedback I got from sys admins that moved from Solaris
> >> to Linux.
> >
> > as a sysadmin, it's a _wonderful_ tool to have for any system that has
> > people editing/saving files on directly.
> 
> Thank you david. Finally some positive feedback from the people
> for whom the feature is intended for :-)

No one is arguing about the advantages of snapshots. I think that we are
all clear on this. Snapshots are useful.

> 
> >
> >>
> >>> Also, I do not buy the whole argument of "not have to create separate
> >>> disk
> >>> space for snapshot". It is actually better for sysadmins, because you
> >>> have perfect control on what is going on, how much space is used for
> >>> your snapshots and how much is used by your data. You can always easily
> >>> extend the snapshot volume, or let it die silently when it is too old
> >>> and too big.
> >>>
> >>
> >> Seriously, Lukas, talk to sys admins.
> >> Letting the snapshot die silently is the worst possible thing that a
> >> snapshots
> >> implementation can do (for long lived snapshots).
> >
> > that depends on the site policy.
> >
> > sometimes it is better to loose snapshots than to run out of disk space and
> > halt the system, sometimes you would rather halt the system.
> >
> > the policy of what happens when you run out of space should not be a kernel
> > decision, the desired behavior varies far too much.
> >
> > this includes being able to say things like "I want to always have 10% of my
> > disk allocated to snapshots, but if there's more free space, go ahead and
> > use it, but always keep at least 10% of the disk free so that you don't have
> > to halt new writes while you clear space"
> >
> > or
> >
> > "if you run out of space, try and keep the oldest snapshot and the newest
> > snapshot, delete other snapshots in between before touching either of these"
> >
> 
> I fully agree.
> AFAIK, there is no user space tool to manage snapshots to this level for Linux.
> The only snapshot manager I know about is snapper:
> http://en.opensuse.org/Portal:Snapper, which we are working on adding
> ext4 snapshots support to.
> Snapper does not have the free space based policy to the best of my knowledge,
> but it could be improved to monitor free disk space.
> 
> A tool like that does not need any further kernel changes from
> ext4 and btrfs to implement the policies suggested above.
> However, with LVM snapshots, some of these policies (like use whatever space you
> have free in the filesystem) are simply not possible.

And why is that ? With LVM you can shrink or extent volumes at will, I
do not think this is a problem at all, moreover, you can always add more
drives to resize your existing volumes to.

> 
> 
> >>> How does it actually work on ext4 snapshots ? When you're going to
> >>> rewrite a file, you will never know how much disk space it'll take in
> >>> advance, am I right ? Is the filesystem accounting for the snapshot size
> >>> as well ? or is it hidden ?
> >>
> >> It's not hidden, it's accounted for as a regular file (usually owned by
> >> root).
> >> You need a bit of scripting to gather the disk space used by snapshots
> >> (du).
> >
> > the worst case when you re-write a file is that it will take the full amount
> > of space that the file currently takes (as if you wrote a new copy of the
> > file and some process had a filehandle open on the old copy, preventing the
> > space from being reclaimed, so it's far from being a new problem)
> 
> No. it's a new problem.
> When you have a large db, which does random writes to an exiting db file,
> it does not expect ENOSPC, when updating an existing record or index.
> Only by keeping enough free disk space in the system at all times, can you
> avoid this kind of problems.

You can very well avoid this kind of problems when you separate
filesystem and snapshots, that is what LVM can do easily.

> 
> >
> > see the note above about the need to be able to remove snapshots when you
> > are out of space.
> >
> > since snapshots tend to be small compared to the filesystems they protect
> > (not in all cases, but if you are covering the entire system with one
> > snapshot that would be the way to bet), having the ability to put the
> > snapshot metadata off on a smaller/faster disk would be helpful.

Very easy to do with dm-multisnap.

> 
> Helpful for which workload?
> For reading from snapshots? Yes, that would be faster.
> For writing to the filesystem? I demonstrated that the performance
> overhead is near zero.
> 
> >
> > having the ability to snapshot just specific files/directories would be a
> > killer feature IMHO
> 
> I agree to that, but I don't think the ext4 will be able to provide
> that to the full extent.

And that is for being fs level snapshots a huge drawback.

> 
> >
> > David Lang
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
--8323328-1187090254-1307614648=:4138--
