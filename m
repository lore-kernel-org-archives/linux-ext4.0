From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/34] misc: move check_plausibility into a separate file
Date: Fri, 19 Sep 2014 18:16:27 -0400
Message-ID: <20140919221627.GS26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221233.13646.56301.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38334 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837AbaISWQd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 18:16:33 -0400
Content-Disposition: inline
In-Reply-To: <20140913221233.13646.56301.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:12:33PM -0700, Darrick J. Wong wrote:
> Move check_plausibility() into a separate file so that various
> programs can use it without having to declare useless global variables
> that the util.c functions seem to require.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
