From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: speed up the max extent depth api call
Date: Mon, 15 Dec 2014 12:29:21 -0500
Message-ID: <20141215172921.GA21646@thunk.org>
References: <20141215063745.GA5368@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57191 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaLOR3Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 12:29:25 -0500
Content-Disposition: inline
In-Reply-To: <20141215063745.GA5368@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 14, 2014 at 10:37:45PM -0800, Darrick J. Wong wrote:
> The maximum extent tree depth really only depends on the filesystem
> block size, so cache the last result if possible.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
