From: Theodore Tso <tytso@mit.edu>
Subject: Re: Add
	ext4__allow_read-only_mounts_with_corrupted_block_group_checksums
	patch
Date: Fri, 18 Jul 2008 08:59:36 -0400
Message-ID: <20080718125936.GG11221@mit.edu>
References: <3.0.6.32.20080715193126.0242c9a0@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37728 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752155AbYGRM7i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 08:59:38 -0400
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080715193126.0242c9a0@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2008 at 07:31:26PM +0000, Gary Hawco wrote:
> 
> Just recompiled 2.6.26 with the newest snapshot (15-July 2008/2310GMT).
> uninit_bg had been enabled.

I also just realized that while I had pushed the commit with the
patch, I had forgotten to include
ext4__allow_read-only_mounts_with_corrupted_block_group_checksums in
the series file.  Doh!

I just pushed out a series file which includes this, although that one
also is rebased against 2.6.26-git6 and removed all of the files from
the stable portion of the queue (since Linus has accepted them for the
merge window).

If you add 

   ext4__allow_read-only_mounts_with_corrupted_block_group_checksums

to the end of your series file, then the patch will actually be
applied.  :-)

Oops, and sorry for not noticing this sooner.

						- Ted
