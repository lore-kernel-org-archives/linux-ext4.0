From: tytso@mit.edu
Subject: Re: [PATCH, RFC 2/2] ext4: Convert callers of ext4_get_blocks() to
 use ext4_map_blocks()
Date: Tue, 4 May 2010 11:42:51 -0400
Message-ID: <20100504154251.GA6344@thunk.org>
References: <1272927081-12694-1-git-send-email-tytso@mit.edu>
 <1272927081-12694-2-git-send-email-tytso@mit.edu>
 <878w80htis.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41817 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab0EDPm4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 May 2010 11:42:56 -0400
Content-Disposition: inline
In-Reply-To: <878w80htis.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 04, 2010 at 03:34:59PM +0530, Aneesh Kumar K. V wrote:
> 
> bh flags are not set here. This check should be based on map.m_flags.

Good catch, thanks.

> Only thing i am worried about is we were modifying bh_flags in all
> possible confusing ways. We may want to make sure we get the update
> correct. I am still going through the patch after applying it to the
> tree. So may take more time to look at the full changeset.

I'm concerned about that as well; in fact I'm not sure what we had
before was completely correct, and I *still* have trouble reasoning
about how all the flags work and why we do some of the things that we
do based on how the flags are set --- and that scares me.

XFS doesn't jump through *nearly* as many hoops as we do --- and given
XFS's reputation for complexity, that's saying a lot! --- and I
suspect some of the things we do are mandated by the fs/buffer.c and
fs/direct_io.c, the latter of which does some very strange and
unnatural things with buffer_heads --- and some of the things we do
are based on our own, ext4-specific logic and how we route state
through the many layers of callback functions.  I think I've figured
some of this out, but it's gotten very crufty over the course of
ext4's development.

One of the reasons I had for doing this cleanup, in addition to
reducing stack usage (which I have measured as around 120 bytes or so
on an 32-bit system, and I'm sure it's got to be more on a 64-bit
system) was to make explicit how we were modifying the bh_flags.  At
least now we can grep for EXT4_MAP_* and see on the places where we
were mucking with things.

						- Ted
