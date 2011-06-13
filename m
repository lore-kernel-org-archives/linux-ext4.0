From: Joe Thornber <thornber@redhat.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Mon, 13 Jun 2011 09:50:55 +0100
Message-ID: <20110613085054.GA4580@ubuntu>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
 <BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
 <BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
 <alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
 <20110610101142.GA10144@ubuntu>
 <BANLkTi=0N7QXRvFgjHUJXBi0x=668ahXXA@mail.gmail.com>
 <20110611073517.GB2517@ubuntu>
 <BANLkTi=THJi8Z2RTdfGgox4NH8hEGiN37A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab1FMIv1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 04:51:27 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=THJi8Z2RTdfGgox4NH8hEGiN37A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 11, 2011 at 12:58:26PM +0300, Amir G. wrote:
> I meant _readonly_ snapshots of a _writable_ _external_ origin,
> which is what ext4 snapshots provides.
> All snapshots are chained on a list that points to the origin and
> only the latest (active) snapshot metadata get updated on origin writes.
> When older snapshots lookup return -ENODATA, you go up the list
> to the newer snapshot and up to the origin.
> 
> Those _incremental_ snapshots cannot be _writable_, because older
> snapshots may implicitly share blocks with newer snapshots, but it should
> be possible to make _writable_ clones of these snapshots.
> Not sure what the implications are for deleting snapshots, because I am
> not familiar with all the implementation details of multisnap.

I deliberately ruled out chaining schemes like this because I want to
support large numbers of snapshots.  I believe Daniel Phillips
described a chaining scheme a while ago, and someone else implemented
it last year.  From a cursory glance through the code they posted on
dm-devel, it appeared to need a large in memory hash table to cache
all those chained lookups.

- Joe
