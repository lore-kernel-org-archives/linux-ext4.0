From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/21] e2fuzz: fix build problems on macosx and i386 linux
Date: Sun, 10 Aug 2014 18:16:17 -0400
Message-ID: <20140810221617.GM15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010504.2611.14307.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53422 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHJWQU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:16:20 -0400
Content-Disposition: inline
In-Reply-To: <20140805010504.2611.14307.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:05:04PM -0700, Darrick J. Wong wrote:
> Fix clang warnings about forgotten header files, dead code, and pwrite
> support on OS X.  The unistd.h inclusion also fixes a parameter
> truncation bug on i386.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
