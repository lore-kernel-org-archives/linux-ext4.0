From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/35] mke2fs: optionally create undo file
Date: Tue, 5 May 2015 10:37:07 -0400
Message-ID: <20150505143707.GF9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023604.25243.8015.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45909 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993207AbbEEOhH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:37:07 -0400
Content-Disposition: inline
In-Reply-To: <20150402023604.25243.8015.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:36:04PM -0700, Darrick J. Wong wrote:
> Provide the user with an option to create an undo file so that they
> can roll back a failed tuning operation.  Previously, one would be
> created if force_undo was set in the configuration file and a bunch of
> (undocumented) conditions were met.
> 
> v2: Support reopening undo files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
