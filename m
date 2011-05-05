From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure?
 [was: Re: dm snapshot: ignore discards issued to the snapshot-origin
 target]
Date: Thu, 5 May 2011 12:48:41 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105051248110.3760@dhcp-27-109.brq.redhat.com>
References: <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com> <20110502081925.GA11312@infradead.org> <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
 <yq1bozl420p.fsf@sermon.lab.mkp.net> <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com> <yq1tydd2g5h.fsf@sermon.lab.mkp.net> <alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com> <yq1sjsuzebu.fsf@sermon.lab.mkp.net>
 <20110505083344.GA1114@nb.net.home>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-61399738-1304592526=:3760"
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1EEKs7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 06:48:59 -0400
In-Reply-To: <20110505083344.GA1114@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-61399738-1304592526=:3760
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 5 May 2011, Karel Zak wrote:

> On Wed, May 04, 2011 at 11:16:05AM -0400, Martin K. Petersen wrote:
> > >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> > 
> > I got tired of poking around in sysfs to find the discard topology.
> > Here's a patch against lsblk that adds a -D option to present this
> > information in a human-readable form:
> 
> Applied, thanks.
> 
> > # lsblk -D
> > NAME                  DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
> > sda                          0        0B       0B         0
> > └─sda1                       0        0B       0B         0
> > sdb                          0      512B       2G         1
> > └─sdb1                       0      512B       2G         1
> 
> I have a question, 2.6.35 on my ThinkPad, non-SSD disk:
> 
> NAME                   DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
> sda                           0        0B       0B         0
> ├─sda1               4294935040        0B       0B         0
> ├─sda2               4188038656        0B       0B         0
> ├─sda3               1346205184        0B       0B         0
> ├─sda4               3231165440        0B       0B         0
> ├─sda5               4188006400        0B       0B         0
> │ └─kzak-home (dm-0)          0        0B       0B         0
> └─sda6               2035725312        0B       0B         0
> 
> 
> Does is make sense? The DISC-ALN is non-zero but DISC-GRAN is zero.
> 
> Note that cat /sys/block/sda/sda*/discard_alignment returns the same
> numbers.
> 
>     Karel
> 
> 

That is fixed by the kernel patch posted above :)

-Lukas
--8323328-61399738-1304592526=:3760--
