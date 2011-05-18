From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was: Re:
 dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Wed, 18 May 2011 08:52:27 -0400
Message-ID: <20110518125226.GA19490@redhat.com>
References: <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
 <20110502081308.GC8642@agk-dp.fab.redhat.com>
 <20110502081925.GA11312@infradead.org>
 <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
 <yq1bozl420p.fsf@sermon.lab.mkp.net>
 <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com>
 <yq1tydd2g5h.fsf@sermon.lab.mkp.net>
 <alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com>
 <yq1wri6zel9.fsf@sermon.lab.mkp.net>
 <20110518121631.GC18433@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, sandeen@redhat.com,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com,
	linux-ext4@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab1ERMwl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 08:52:41 -0400
Content-Disposition: inline
In-Reply-To: <20110518121631.GC18433@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18 2011 at  8:16am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hey Martin,
> 
> On Wed, May 04 2011 at 11:10am -0400,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> > 
> > Lukas> Nevertheless there is something weird going on, because even when
> > Lukas> I create striped volume I get this:
> > 
> > Could you please try the following patch? It has a bunch of small tweaks
> > to the discard stack in it. I'll split it up before posting for real but
> > I'd like to know if it fixes your issue...
> 
> Would be ideal to get these fixes staged for 2.6.40.
> 
> Do you intend to split these patches up and post for 2.6.40 inclussion?

Ah, I now see you posted them and Jens picked some up.. thanks

Mike
