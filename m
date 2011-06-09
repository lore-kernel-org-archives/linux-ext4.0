From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Thu, 9 Jun 2011 08:50:36 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com> <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com> <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
 <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com> <alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com> <BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com> <BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
 <BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1198591031-1307602240=:4138"
Cc: "Amir G." <amir73il@users.sourceforge.net>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab1FIGuu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2011 02:50:50 -0400
In-Reply-To: <BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1198591031-1307602240=:4138
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 9 Jun 2011, Yongqiang Yang wrote:

> On Thu, Jun 9, 2011 at 11:18 AM, Amir G. <amir73il@users.sourceforge.net> wrote:
> > On Thu, Jun 9, 2011 at 4:59 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> >>> But I do understand the difference. And also, when it comes to fs level
> >>> snapshotting I would suspect that it would do something we can not do
> >>> with the current solutions, for example per-file or per-directory snapshots,
> >>> cat ext4 snapshots do that ?
> >> Hi Lukas,
> >>
> >> I noticed that there is no answer to this question in the thread.  I
> >
> > I think I answered this question with No it can't ;-)
> I think this can be implemented easily by chattr and adding check in
> should_snapshot() or should_move_data().
> 
> And I thought Lukas are focusing on if ext4-snapshots can do this
> easily.  So i said YES:-)

Cool, finally something interesting :). So, how it'll work ? Does that
require any format changes again:) ? Can you exclude the whole root and
then selectively pick the directories or files you are interested in ?

How does rollback work with ext4 snapshots ? Can you selectively roll
back one file, or the whole directory subtree even when you're
snapshotting more ?

You see, when it comes to the full fs snapshots I am not convinced that
it is *very* useful, yes it might have some users, but you can alway
take the safe way and do lvm snapshots (or better use the new multisnap)
for backup, without need to modify stable filesystem code.

Also, I do not buy the whole argument of "not have to create separate disk
space for snapshot". It is actually better for sysadmins, because you
have perfect control on what is going on, how much space is used for
your snapshots and how much is used by your data. You can always easily
extend the snapshot volume, or let it die silently when it is too old
and too big.

How does it actually work on ext4 snapshots ? When you're going to
rewrite a file, you will never know how much disk space it'll take in
advance, am I right ? Is the filesystem accounting for the snapshot size
as well ? or is it hidden ?

Thanks!
-Lukas

> 
> >
> >> can give the question the answer that ext4 can snapshot per-file or
> >> per-directory, and can exclude some files or directories from being
> >> snapshotted.
> >>
> >
> > So the full answer is that ext4 snapshot CAN exclude
> > certain files/dirs from snapshot, but this feature is not fully implemented yet
> > (I have it in a dev branch)
> >
> >> --
> >> Best Wishes
> >> Yongqiang Yang
> >>
> >
> 
> 
> 
> 
--8323328-1198591031-1307602240=:4138--
