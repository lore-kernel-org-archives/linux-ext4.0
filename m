From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/47] tests: fix test scripts that don't work on
 non-Linux systems.
Date: Fri, 7 Nov 2014 20:55:02 -0500
Message-ID: <20141108015502.GA25485@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215049.883.24332.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46054 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbaKHBzG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Nov 2014 20:55:06 -0500
Content-Disposition: inline
In-Reply-To: <20141107215049.883.24332.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:50:49PM -0800, Darrick J. Wong wrote:
> Fix various tests that break on non-Linux systems; in particular,
> sed -i doesn't work the same on all platforms; and try to keep the
> GNU getopt-isms out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
