From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/24] e2fsck: don't offer to recreate the journal if
 fsck is aborting due to bad block bitmaps
Date: Tue, 22 Jul 2014 13:58:12 -0400
Message-ID: <20140722175812.GJ25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225256.31374.91713.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50562 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaGVUea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:34:30 -0400
Content-Disposition: inline
In-Reply-To: <20140718225256.31374.91713.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:52:56PM -0700, Darrick J. Wong wrote:
> If e2fsck knows the bitmaps are bad at the exit (probably because they
> were bad at the start and have not been fixed), don't offer to
> recreate the journal because doing so causes e2fsck to abort a second
> time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
