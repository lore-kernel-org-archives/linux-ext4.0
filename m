From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Large EAs
Date: Wed, 26 Nov 2008 01:54:39 -0500
Message-ID: <20081126065439.GA27490@mit.edu>
References: <1226954173.3972.70.camel@localhost> <20081126044138.GD1410@mit.edu> <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <Kalpak.Shah@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, Andreas Dilger <adilger@sun.com>
To: Kalpak Shah <kalpak.shah@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47588 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750696AbYKZGyo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 01:54:44 -0500
Content-Disposition: inline
In-Reply-To: <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 11:30:32AM +0530, Kalpak Shah wrote:
> On Wed, Nov 26, 2008 at 10:11 AM, Theodore Tso <tytso@mit.edu> wrote:
> > Sorry for not reviewing this patch earlier, but looking at the disk
> > format, I wonder if it's really necessary to allocate an inode for
> > each EA.  Given that we have a fixed inode table, if the user creates
> > a large number of 2k EA's (on a 4k filesystem) or 512 byte EA's (on a
> > 1k) filesystem, this could easily burn a huge number of inodes,
> > causing users to run out.
> >
> > We don't actually *need* to use an inode;
> 
> One of the reasons we need to use an inode is that orphan EA inodes
> can be linked into lost+found. If we just use an extent tree, I am not
> sure how e2fsck can find out orphan EAs.

It's already the case that if we have an orphaned EA block, we'll lose
it.  The question is whether it's important to keep a large EA if it
gets orphaned, especially given that there are already plenty ways
that we can lose EA's (i.e., ftp, tar, NFSv3, etc.).  So if someone is
going to store a multi-megabyte EA, and we lose it because the inode
it was attached to gets destroyed, or the inode gets corrupted to the
point where we can't find the root of the EA tree --- the question is
--- will we care?  It's similar to losing the high-level node in the
EA tree, we lose all the leaf nodes below it.  It can happen, but in
that case the user will just have to restore the entire file from
backup. I'd argue that losing the EA tree would be the same sort of
thing.

I can see the argument on the other side, where if someone attaches a
multi-megabyte EA to a file, that it might be important enough to be
worth saving.  OTOH I'm not at all sure we would want to encourage
such a thing!

							- Ted
