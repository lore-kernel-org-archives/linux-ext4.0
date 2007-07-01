From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Sun, 1 Jul 2007 08:30:54 -0400
Message-ID: <20070701123054.GC28917@thunk.org>
References: <20070629170958.13b7700c@gara> <20070630055125.GC5535@schatzie.adilger.int> <20070630233908.115ec78e@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50729 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbXGAMa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2007 08:30:59 -0400
Content-Disposition: inline
In-Reply-To: <20070630233908.115ec78e@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 30, 2007 at 11:39:08PM -0500, Jose R. Santos wrote:
> On Sat, 30 Jun 2007 01:51:25 -0400
> Andreas Dilger <adilger@clusterfs.com> wrote:
> > I don't think there is actually any fundamental difference between these
> > proposals.  The reality is that we cannot change the semantics of the
> > META_BG flag at this point, since both e2fsprogs and ext3/ext4 in the
> > kernel understand META_BG to mean only "group descriptor backups are
> > in groups {0, 1, last} of the metagroup" and nothing else.
> 
> Agree.  I call it extended META_BG for lack of a better name, but a new
> feature flag will be required.

It was the intention that META_BG include allowing the bitmap and
inode tables to range anywhere outside of the block group, but that
never got coded.  It would be confusing though if we relaxed it
withotu adding a feature bit, and I agree that we might as well use
overload the BIG_BG group to indicate this feature.

The fact that BIG_BG requires contiguous blocks for the bitmaps when
they exceed blocksize*8 blocks still concerns me a minor amount, and
given the hopeful inclusion of kernel patches that allow blocksize >
pagesize.  Furthermore, I still wonder whether we will want to make
blockgroups that much bigger (since reducing the allocation groups is
not necessarily a smart thing; we will need to do some benchmarks with
filesystem aging to see how this affects antifragmentation efforts),
but the complexity engenered by adding BIG_BG isn't that bad (again,
my only concern is with the contiguous bitmap blocks requirements).

						- Ted
