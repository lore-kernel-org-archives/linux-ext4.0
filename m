From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Fri, 18 Mar 2016 10:20:05 +0100
Message-ID: <20160318092005.GA7152@quack.suse.cz>
References: <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
 <20160313042723.GC29218@thunk.org>
 <20160314073928.GD5213@quack.suse.cz>
 <20160314143635.GM29218@thunk.org>
 <20160315104634.GG17942@quack.suse.cz>
 <20160315144633.GA12352@quack.suse.cz>
 <20160315200951.GA1445@quack.suse.cz>
 <4ec8c36a910942be8d6d4745385f3cce@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbcCRJTl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2016 05:19:41 -0400
Content-Disposition: inline
In-Reply-To: <4ec8c36a910942be8d6d4745385f3cce@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 16-03-16 02:30:13, HUANG Weller (CM/ESW12-CN) wrote:
> 
> > >
> > > OK, I have something - Huang, can you check whether the attached
> > > patches also fix your data exposure issues please? The first patch is
> > > the original fix, patch two is a cleanup, patches 3 and 4 implement
> > > the speedup suggested by Ted. Patches are only lightly tested so far.
> > > I'll run more comprehensive tests later and in particular I want to
> > > check whether the additional complexity actually brings us some
> > > advantage at least for workloads which redirty pages in addition to
> > > writing some new ones using delayed allocation.
> > 
> > OK, there was a bug in patch 3. Attached is a new version of patches 3 and 4.
> > 
> 
> Patches are applied on my kernel. Basically it is working. 
> Power loss test is running now. Need some days to give you test result.

Thank you!

> At same time, Some conflicts need your confirm:

The resolution of the conflicts looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
