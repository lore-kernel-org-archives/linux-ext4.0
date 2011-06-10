From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Fri, 10 Jun 2011 11:00:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106101044350.4502@dhcp-27-109.brq.redhat.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com> <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com> <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
 <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com> <alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com> <BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com> <BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com> <BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
 <alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com> <BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com> <alpine.LFD.2.00.1106091012030.4138@dhcp-27-109.brq.redhat.com> <BANLkTin0RKZbDmB1movombH9o4HDpTnvFw@mail.gmail.com>
 <alpine.LFD.2.00.1106091443370.4138@dhcp-27-109.brq.redhat.com> <BANLkTinEJ6235sPNz_f92nfN0ac4qSnHtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab1FJJf3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jun 2011 05:35:29 -0400
In-Reply-To: <BANLkTinEJ6235sPNz_f92nfN0ac4qSnHtw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 10 Jun 2011, Amir G. wrote:

--snip--
> >
> >>
> >>
> >> >
> >> > Granted, I have to take a look at the multisnap code, to see what it can
> >> > do and compare it with ext4 snapshots, because really, if it is good
> >> > enough and you will be able to do snapshotting backups as you do with
> >> > your approach, I do not see the reason why to complicate our life in
> >> > ext4.
> >> >
> >>
> >> I don't know how you intend to determine if dm-multisnap is 'good enough'.
> >> I don't claim to have the capability myself to determine if ext4 snapshots
> >> are 'good enough'.
> >> I just try to present the technical differences between the 3 solutions
> >> (LVM,ext4,btrfs) and claim that each have their advantages and disadvantages
> >> over others.
> >> I wish more sys admins and end users would provide feedback, though I don't
> >> know how many of them are following LKML.
> >
> > I do. When it can do long lived snapshots without any obvious headaches
> > it is good enough. Your only contra argument was that lvm snapshotting
> > is slow, which is not that big argument now when we have multisnap
> > almost ready. I am not even talking about features, because clearly
> > mutlisnap has superset of the features that ext4 does - no I am not
> > counting per-file or per-directory snapshotting because clearly those
> > are just hacks and it was not designed that way.
> >
> 
> Hi Lukas,
> 
> I am very glad to have you as my reviewer and critic :-)
> I am saying that with all honesty, because I know that you are impartial
> and have no anti-ext4 agenda.
> 
> LVM multisnap does look like a big leap forward, but you should not
> be blinded by the promised feature, before you inspect the implementation,
> the same as you are doing to ext4 snapshots now...
> 
> I could suggest that you put your root fs on a QCOW2 file exported as NBD.
> That would give you both thin provisioning and snapshots, but you know
> perfectly well, that this is not a 'good enough' solution.
> I'm not saying that LVM is comparable to QCOW2 virtual volume.
> I'm just saying we (included myself) should carefully examine the alternatives
> before make a ruling against one of them.
> 
> Amir.
> 

Hi Amir,

that is why I spoke with several dm people and all of them had the same
opinion. When you are not using the advantage of being at fs level,
there is no reason to have shapshoting at this level.

And no, I am not blinded. I am trying to understand why is multisnap a
huge win everyone is saying, so I already asked ejt to step in and
give us an overview on how dm-multisnap works and why is it better
than the old implementation. Also I am trying it myslef, and so far
it works quite well. I might have some numbers later.

Thanks!
-Lukas
