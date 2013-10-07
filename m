From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/31] e2p: Fix f[gs]etflags argument size mismatch
Date: Mon, 7 Oct 2013 09:33:04 -0400
Message-ID: <20131007133304.GE4540@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012721.28415.97544.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43081 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab3JGNdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 09:33:06 -0400
Content-Disposition: inline
In-Reply-To: <20131001012721.28415.97544.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:21PM -0700, Darrick J. Wong wrote:

> The EXT2_IOC_[GS]ETFLAGS ioctls take longs as arguments, however
> this code only reserves enough storage for an int.  The kernel
> drivers (so far) don't transfer more than an int but FUSE sees the
> long and assumes that it's ok to write the full size of the long,
> which crashes if sizeof(long) > sizeof(int).

All of the kernel code I was able to audit is treating the
EXT2_IOC_[SG]ETFLAGS ioctls as taking an int, not a long.  So the
defacto definition of [SG]ETFLAGS is that that they take ints, not
longs.  If we make this change which you are proposing, it will cause
problems on big-endian systems where sizeof(long) > sizeof(int) ---
for example, as would be the case on the ppc64 architecture.

I'm not sure what the FUSE problem is?  Can you say more?  Is there
some other way we can work around the problem you are trying to solve?

     	       	      	   	      	      - Ted
