From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd2: fix descriptor block size handling errors with
 journal_csum
Date: Mon, 25 Aug 2014 22:44:24 -0400
Message-ID: <20140826024424.GG11317@thunk.org>
References: <20140815204346.16444.14064.stgit@birch.djwong.org>
 <20140815204359.16444.22808.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48961 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070AbaHZCo0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 22:44:26 -0400
Content-Disposition: inline
In-Reply-To: <20140815204359.16444.22808.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2014 at 01:43:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It turns out that there are some serious problems with the on-disk
> format of journal checksum v2.  The foremost is that the function to
> calculate descriptor tag size returns sizes that are too big.  This
> causes alignment issues on some architectures and is compounded by the
> fact that some parts of jbd2 use the structure size (incorrectly) to
> determine the presence of a 64bit journal instead of checking the
> feature flags.
> 
> Therefore, introduce journal checksum v3, which enlarges the
> descriptor block tag format to allow for full 32-bit checksums of
> journal blocks, fix the journal tag function to return the correct
> sizes, and fix the jbd2 recovery code to use feature flags to
> determine 64bitness.
> 
> Add a few function helpers so we don't have to open-code quite so
> many pieces.
> 
> Switching to a 16-byte block size was found to increase journal size
> overhead by a maximum of 0.1%, to convert a 32-bit journal with no
> checksumming to a 32-bit journal with checksum v3 enabled.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: TR Reardon <thomas_reardon@hotmail.com>

Thanks, applied.

					- Ted
