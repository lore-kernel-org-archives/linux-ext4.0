From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 11 Aug 2014 14:32:58 -0400
Message-ID: <20140811183258.GF6553@thunk.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
 <20140811062415.GG15431@thunk.org>
 <20140811063120.GB2808@birch.djwong.org>
 <20140811143423.GB3506@thunk.org>
 <20140811180509.GE2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54983 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbaHKSdA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 14:33:00 -0400
Content-Disposition: inline
In-Reply-To: <20140811180509.GE2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 11:05:09AM -0700, Darrick J. Wong wrote:
> 
> Using the bitmap turns out to be pretty quick (~130us to start RA for 4 groups
> vs. ~70us per group if I issue the RA directly).  Each fadvise call seems to
> cost us ~1ms, so I'll keep using the bitmap to minimize the number of fadvise
> calls, since it's also a lot less code.

4 groups?  Since the default flex_bg size is 16 block groups, I would
have expected that you would want to start RA every 16 groups.

(And BTW, I've been wondering whether we should increase the flex_bg
size for bigger file systems.  By the time we get to 4TB disks, Having
a flex_bg every 2GB seems a little small.)

						- Ted
