From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PARCH 0/1 RFC] e2image: Add support for QCOW2 image format
Date: Mon, 6 Dec 2010 11:27:19 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012061126320.2876@dhcp-lab-213.englab.brq.redhat.com>
References: <1291225309-10750-1-git-send-email-lczerner@redhat.com> <AANLkTinkZeBPxazH3MxKcXhxQ+7P00dfus-1WrAR12bG@mail.gmail.com> <alpine.LFD.2.00.1012020916490.2874@dhcp-lab-213.englab.brq.redhat.com> <AANLkTinf9Ww8hA+i2pxJLwx-zzPdvN-t=UWrEe3CogAm@mail.gmail.com>
 <alpine.LFD.2.00.1012021108500.2874@dhcp-lab-213.englab.brq.redhat.com> <AANLkTim+7exa1D2dsP=r4Lc0JS6MxudSRNcqmHSTcLTC@mail.gmail.com> <alpine.LFD.2.00.1012021203270.2874@dhcp-lab-213.englab.brq.redhat.com> <AANLkTin4_fOg4OQVHDv=MN3zLn6c36Pvb7KB07DgPp+J@mail.gmail.com>
 <AANLkTinmykTQPzHhQQ-gk2wP0XhuqmgY3wZ2Chq2mkgf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	adilger@dilger.ca, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0LFK11 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Dec 2010 05:27:27 -0500
In-Reply-To: <AANLkTinmykTQPzHhQQ-gk2wP0XhuqmgY3wZ2Chq2mkgf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 4 Dec 2010, Amir Goldstein wrote:

> On Thu, Dec 2, 2010 at 2:23 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Thu, Dec 2, 2010 at 1:11 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> >>
> >> You can export just the diff between some snapshots as you mentioned and
> >> then, when installing it on another filesystem the utility doing the job
> >> (e2image probably) would know what to do even without qcow2 snapshots,
> >> since all the data needed are in the image anyway, qcow2 snapshot is just
> >> useless abstraction we do not need in this case.
> >
> > I agree. I was forcing my problem over this solution, trying to squeeze every
> > last drop of coolness from qcow2 snapshots. it doesn't fit in here.
> >
> > Still for the first problem (rollback) I think that qcow2 snapshots can be a
> > perfect and simple solution.
> >
> > e2image starts with exporting filesystem to full qcow2 image, then takes
> > a qcow2 snapshot and proceeds writing blocks modified by latest snapshot
> > and so forth until the oldest snapshot.
> >
> > The resulting qcow2 snapshot list is an inversion of the Ext4 snapshots list
> > and it gives you both the ability to rollback to any older snapshot and to
> > undo all rollbacks by restoring the base image.
> >
> 
> Hi Lukas,
> 
> I think I may have failed to explain my reasoning for using qcow2
> snapshots properly and I understand your confusion.
> 
> Of course, if e2image would produce a full image of the filesystem,
> Ext4 snapshots information would be a part of the information
> encoded in the image.
> 
> For rollback to snapshot application, at some point, either on image
> creation or on image install, the snapshot diff patches
> (which are stored in the snapshot inodes) need to be decoded.
> 
> If the snapshot diffs are decoded on e2image install, there is no need
> for qcow2 snapshots, like you said.
> 
> My suggestion to decode the snapshot diffs on e2image create and to
> store them in qcow2 snapshots format
> has 2 advantages over decoding on e2image install:
> 
> 1. Should we want to implement create of snapshot image using e2image
> -x <snapid>,
> the easiest implementation would involve creating a full filesystem image
> and then applying snapshot diffs on top of it. With this implementation,
> we can get the full filesystem image and an image of every snapshot on the way
> to <snapid> with no extra cost, if we just start a qcow2 snapshot before
> applying every snapshot diff.
> 
> 2. At the moment, the only way to access next3 snapshots is to mount
> the filesystem
> and then mount the snapshot via a loop device. Now if there is a
> problem to mount the filesystem
> the snapshots are not accessible as well, which is a shame if you want
> to backup some data
> before attempting to fix the filesystem.
> Using the qcow2 exported image (with snapshots converted to qcow2
> snapshots), it is possible
> to mount every one of the snapshots, directly from the qcow2 image,
> and recover some files,
> without the need to rollback the entire filesystem.
> 
> When the qcow2 infrastructure is ready, I will rebase my e2fsprogs
> snapshot patches,
> implement e2image -x and consult you about using qcow2 snapshots.

Fair enough :).

-Lukas

> 
> Cheers,
> Amir.
> 
