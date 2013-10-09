From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/31] e2fsck: Teach EA refcounting code to handle 48bit
 block addresses
Date: Wed, 9 Oct 2013 14:53:39 -0700
Message-ID: <20131009215339.GK6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012818.28415.49000.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310071717550.1975@localhost.localdomain>
 <20131007183743.GB6860@birch.djwong.org>
 <20131008160105.GH17896@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21760 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3JIVxs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Oct 2013 17:53:48 -0400
Content-Disposition: inline
In-Reply-To: <20131008160105.GH17896@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 08, 2013 at 12:01:05PM -0400, Theodore Ts'o wrote:
> On Mon, Oct 07, 2013 at 11:37:43AM -0700, Darrick J. Wong wrote:
> > > I am not sure if we really need count, size and cursor to be blk_t
> > > let alone blk64_t. It's a bit misleading because AFAICT those
> > > variable does not represent block numbers at all. Maybe it should be
> > > changed to something less confusing, preferably matching the actual
> > > xattr implementation ?
> > 
> > Oops, I got a little too s/blk_t/blk64_t/ happy there.  Those could be __u32, I
> > think.  Or unsigned long.
> 
> __u32 should be fine, yes.  Could you send me an updated patch?

Yes, I will.  Are you planning to push e2fsprogs git to kernel.org/github soon?

I also now have eight more patches to fix various bigalloc and metadata_csum
related bugs in resize2fs.

--D

> 
> Thanks,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
