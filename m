From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/35] resize2fs: optionally create undo file
Date: Tue, 5 May 2015 10:36:42 -0400
Message-ID: <20150505143642.GD9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023552.25243.21329.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45901 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993203AbbEEOgm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:36:42 -0400
Content-Disposition: inline
In-Reply-To: <20150402023552.25243.21329.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:35:52PM -0700, Darrick J. Wong wrote:
> Provide the user with an option to create an undo file so that they
> can roll back a failed resize operation.
> 
> v2: Allow reopening of undo files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

				- Ted
