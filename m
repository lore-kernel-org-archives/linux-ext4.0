From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and	discard
Date: Tue, 19 Jun 2012 11:28:56 -0400
Message-ID: <20120619152856.GB7225@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
 <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
 <20120619141933.GC10637@thunk.org>
 <20120619144316.GD14208@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: device-mapper development <dm-devel@redhat.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Spelic <spelic@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab2FSP3G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 11:29:06 -0400
Content-Disposition: inline
In-Reply-To: <20120619144316.GD14208@agk-dp.fab.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19 2012 at 10:43am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Tue, Jun 19, 2012 at 10:19:33AM -0400, Ted Ts'o wrote:
> > One of the things which would be nice to be able to easily set up is a
> > configuration where we get the benefits of thin provisioning with
> > respect to snapshost, but where the underlying block device used by
> > the file system is contiguous.  
> 
> We're tracking this requirement (for lvm2) here:
>   https://bugzilla.redhat.com/show_bug.cgi?id=814737

That is an lvm2 BZ but there is further kernel work needed.

It should be noted that the "external origin" feature was added to the
thinp target with this commit: 
http://git.kernel.org/linus/2dd9c257fbc243aa76ee6d

It is start, but external origin is kept read-only and any writes
trigger allocation of new blocks within the thin-pool.

We've talked some about the desire to have a fully provisioned volume
that only starts to get fragmented once snapshots are taken.  The idea
is to move the origin into the data volume, via mapping, rather than
copying:

Dec 14 10:37:08 <ejt> we then build a data dev that consists of a linear mapping to that origin
Dec 14 10:37:12 <ejt> plus some extra stuff
Dec 14 10:37:23 <ejt> (the additonal free space for snapshots)
Dec 14 10:37:49 <ejt> we then prepare thinp metadata with a mapping to that origin
