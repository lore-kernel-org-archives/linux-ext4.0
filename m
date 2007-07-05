From: Valerie Henson <val@nmt.edu>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Thu, 5 Jul 2007 00:56:56 -0600
Message-ID: <20070705065656.GC3854@rainbow>
References: <20070629170958.13b7700c@gara> <20070630055125.GC5535@schatzie.adilger.int> <20070630233908.115ec78e@gara> <20070701123054.GC28917@thunk.org> <20070701094833.47035331@gara> <20070702154939.GC4720@thunk.org> <1183385577.3864.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhost.nmt.edu ([129.138.4.52]:49729 "EHLO mailhost.nmt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbXGEG47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jul 2007 02:56:59 -0400
Content-Disposition: inline
In-Reply-To: <1183385577.3864.7.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 02, 2007 at 10:12:57AM -0400, Mingming Cao wrote:
> 
> How about incorporating some of the chunkfs ideas into this BIG_BG or
> extended metablockgroups? The original block group size (128MB) is
> probably too small that would results in many continous inodes. By
> enlarging the size of groups via BIG_BG or extended metablockgroups, we
> could add dirty/clean bit to allow partical/parallel fsck, and something
> like that. Any thoughts on thhis?

We looked into this in the 2006 OLS paper
(http://infohost.nmt.edu/~val/review/ext2fsck.pdf) and concluded that
it's pretty hard to do anything useful on a per-block group basis.
The only metadata that could be checked and repaired on a per-bg basis
are the block group summaries of free/used inodes and free/used
blocks.  So if we had a situation in which the metadata in the block
group was consistent in all ways (link counts, directory entries,
etc.) except that we hadn't updated the bg summary info, then it would
be useful - but I don't think that happens very often.  Anything more
useful than that will require on-disk format changes; at which point
why restrict ourselves to a bit in the block group descriptor?

-VAL
