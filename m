From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/9] filefrag: accommodate holes when calculating
 expected values
Date: Sat, 5 Mar 2016 21:41:00 -0500
Message-ID: <20160306024100.GG10297@thunk.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
 <20160213223804.25381.9378.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36744 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbcCFClI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2016 21:41:08 -0500
Content-Disposition: inline
In-Reply-To: <20160213223804.25381.9378.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 13, 2016 at 02:38:04PM -0800, Darrick J. Wong wrote:
> Currently, filefrag's "expected physical block" column expects extent
> records to be physically adjacent regardless of the amount of logical
> block space between the two records.  This means that if we punch a
> hole in a file, we get reports like this:
> 
> ext:   logical_offset:   physical_offset: length:  expected: flags:
> 4:     4096..    8343:   57376..  61623:   4248:
> 5:     8345..   10313:   61625..  63593:   1969:   61624:
> 
> Notice how it expects 8345 to map to 61624, and scores this against
> the fragmentation of the file.  Flagging this as "unexpected" is
> incorrect because the gap in the logical mapping is exactly the same
> size as the gap in the physical extents.
> 
> Furthermore, this particular mapping leaves the door open to the
> optimal mapping -- if a write to block 8344 causes it to be mapped to
> 61624, the entire range 4096-10313 can be mapped with a single extent.
> Until that happens, there's no way to combine extents 4 and 5 because
> of the gap in the logical mapping at block 8344.
> 
> Therefore, tweak the extent report to account for holes.
> 
> v2: Make it work for extents crossing FIEMAP calls, and clean up the
> FIBMAP version to report correct expected values.
> 
> v3: Don't count physically but not logically contiguous extents
> in the fragmentation summary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
