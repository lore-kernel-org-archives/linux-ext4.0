From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 41/39] mke2fs: warn if enabling metadata_csum on a
 pre-3.18 kernel
Date: Wed, 5 Nov 2014 11:20:14 -0500
Message-ID: <20141105162014.GD27083@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141027233231.GF10057@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40347 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbaKEQUT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Nov 2014 11:20:19 -0500
Content-Disposition: inline
In-Reply-To: <20141027233231.GF10057@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2014 at 04:32:31PM -0700, Darrick J. Wong wrote:
> The metadata_csum feature (really, the journal checksum disk format)
> didn't stabilize until the 3.18 kernel, at which point the companion
> journal_csum feature was turned on by default if metadata_csum was
> enabled.  Therefore, warn the user if they try to create such a
> filesystem on a pre-3.18 kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
