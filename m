From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on block group allocation
Date: Fri, 1 May 2009 00:39:40 -0400
Message-ID: <20090501043940.GD7275@mit.edu>
References: <20090427021411.GA9059@mit.edu> <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com> <20090427224052.GC22104@mit.edu> <20090429191646.GF14264@mit.edu> <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com> <20090429193744.GA17797@mit.edu> <6601abe90904291321u3f13d8b0p88b9a9eba5bc03a1@mail.gmail.com> <20090429212043.GB24749@mit.edu> <20090429215032.GC24749@mit.edu> <6601abe90904291529o5aaab638i73bd34c1a6d54c74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46429 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZEAEjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2009 00:39:42 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90904291529o5aaab638i73bd34c1a6d54c74@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 03:29:55PM -0700, Curt Wohlgemuth wrote:
> Yes, we have this patch.  I'm not sure if we have the "1 or 2" bug
> fixes you refer to above; do you have commits for these?

b5451f7b  ext4: Fix potential inode allocation soft lockup in Orlov allocator
6b82f3cb  ext4: really print the find_group_flex fallback warning only once
7d39db14  ext4: Use struct flex_groups to calculate get_orlov_stats()
9f24e420  ext4: Use atomic_t's in struct flex_groups

						- Ted
