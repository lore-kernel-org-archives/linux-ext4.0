From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Mon, 28 Jan 2008 14:56:33 -0500
Message-ID: <20080128195633.GB20528@mit.edu>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com> <3673.1200975438@turing-police.cc.vt.edu> <20080122070050.GM3180@webber.adilger.int> <20080122144052.GC17804@mit.edu> <20080128193005.GC4032@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valdis.Kletnieks@vt.edu, David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58473 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbYA1T5U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 14:57:20 -0500
Content-Disposition: inline
In-Reply-To: <20080128193005.GC4032@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2008 at 07:30:05PM +0000, Pavel Machek wrote:
> 
> As user pages are always in highmem, this should be easy to decide:
> only send SIGDANGER when highmem is full. (Yes, there are
> inodes/dentries/file descriptors in lowmem, but I doubt apps will
> respond to SIGDANGER by closing files).

Good point; for a system with at least (say) 2GB of memory, that
definitely makes sense.  For a system with less than 768 megs of
memory (how quaint, but it wasn't that long ago this was a lot of
memory :-), there wouldn't *be* any memory in highmem at all....

	       		     	 	- Ted
