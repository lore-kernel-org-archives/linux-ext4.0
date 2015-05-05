From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/35] e2undo: fix memory leaks and tweak the error
 messages somewhat
Date: Tue, 5 May 2015 10:22:24 -0400
Message-ID: <20150505142224.GA9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023526.25243.88182.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45878 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993161AbbEEOWZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:22:25 -0400
Content-Disposition: inline
In-Reply-To: <20150402023526.25243.88182.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:35:26PM -0700, Darrick J. Wong wrote:
> Fix memory leaks and improve the error messages to make it easier
> to figure out why e2undo went wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
