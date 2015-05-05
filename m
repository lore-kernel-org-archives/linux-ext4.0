From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/35] undo-io: use a bitmap to track what we've already
 written
Date: Tue, 5 May 2015 10:21:45 -0400
Message-ID: <20150505142145.GD12468@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023519.25243.93058.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45875 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993159AbbEEOVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:21:45 -0400
Content-Disposition: inline
In-Reply-To: <20150402023519.25243.93058.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:35:19PM -0700, Darrick J. Wong wrote:
> It's really inefficient to (ab)use the TDB key store as a bitmap to
> find out if we've already written a block to the undo file, because
> the tdb code is reads the database key btree disk blocks for *every*
> query.  Changing that logic to a bitmap reduces overhead by a large
> margin -- the overhead of using undo_io while converting a 2TB FS to
> metadata_csum is reduced from 55 minutes to 45.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
