From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC v2] ext4: Don't send extra barrier during fsync if there
	are no dirty pages.
Date: Fri, 6 Aug 2010 00:04:24 -0700
Message-ID: <20100806070424.GD2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ke
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50341 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0HFHE1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 03:04:27 -0400
Content-Disposition: inline
In-Reply-To: <20100805164504.GI2901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 05, 2010 at 12:45:04PM -0400, Ted Ts'o wrote:
> P.S.  If it wasn't clear, I'm still in favor of trying to coordinate
> barriers across the whole file system, since that is much more likely
> to help use cases that arise in real life.

Ok.  I have a rough sketch of a patch to do that, and I was going to send it
out today, but the test machine caught on fire while I was hammering it with
the fsync tests one last time and ... yeah.  I'm fairly sure the patch didn't
cause the fire, but I'll check anyway after I finish cleaning up.

"[PATCH] ext4: Don't set my machine ablaze with barrier requests" :P

(The patch did seem to cut barrier requests counts by about 20% though the
impact on performance was pretty small.)

--D
