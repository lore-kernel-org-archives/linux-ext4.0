From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 27/35] contrib: script to create minified ext4 image from
 a directory
Date: Tue, 5 May 2015 10:52:41 -0400
Message-ID: <20150505145241.GN9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023700.25243.63491.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45952 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993262AbbEEOwm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:52:42 -0400
Content-Disposition: inline
In-Reply-To: <20150402023700.25243.63491.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:37:00PM -0700, Darrick J. Wong wrote:
> The dir2fs script converts a directory into a minimized ext4 filesystem.
> FS creation parameters are tweaked to reduce as much FS overhead as
> possible, and to leave as few unused blocks and inodes as possible.
> Given that mke2fs -d lays out files linearly from the beginning of the
> FS, using resize2fs -M is not as horrible as it usually is.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
