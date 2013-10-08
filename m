From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/31] e2fsck: Teach EA refcounting code to handle 48bit
 block addresses
Date: Tue, 8 Oct 2013 12:01:05 -0400
Message-ID: <20131008160105.GH17896@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012818.28415.49000.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310071717550.1975@localhost.localdomain>
 <20131007183743.GB6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43697 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab3JHQBY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Oct 2013 12:01:24 -0400
Content-Disposition: inline
In-Reply-To: <20131007183743.GB6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 11:37:43AM -0700, Darrick J. Wong wrote:
> > I am not sure if we really need count, size and cursor to be blk_t
> > let alone blk64_t. It's a bit misleading because AFAICT those
> > variable does not represent block numbers at all. Maybe it should be
> > changed to something less confusing, preferably matching the actual
> > xattr implementation ?
> 
> Oops, I got a little too s/blk_t/blk64_t/ happy there.  Those could be __u32, I
> think.  Or unsigned long.

__u32 should be fine, yes.  Could you send me an updated patch?

Thanks,

						- Ted
