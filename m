From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 25/35] copyin: fix error handling
Date: Tue, 5 May 2015 10:51:27 -0400
Message-ID: <20150505145127.GL9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023646.25243.8264.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45943 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993254AbbEEOv1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:51:27 -0400
Content-Disposition: inline
In-Reply-To: <20150402023646.25243.8264.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:36:46PM -0700, Darrick J. Wong wrote:
> Save errno (in retval) before doing anything else, because the
> "anything else" (usually com_err()) can call library functions, which
> will reset errno.
> 
> Fix the error messages to use the message catalog, and don't _ever_
> print an error without providing context.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
