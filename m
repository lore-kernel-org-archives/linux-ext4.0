From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/25] misc: don't return ENOMEM if we run out of disk
 space
Date: Thu, 11 Sep 2014 12:43:23 -0400
Message-ID: <20140911164323.GK26178@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231155.25904.55767.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51447 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbaIKQnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 12:43:25 -0400
Content-Disposition: inline
In-Reply-To: <20140908231155.25904.55767.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:11:55PM -0700, Darrick J. Wong wrote:
> If there aren't enough blocks in the FS to allocate all of the
> hugefiles, return ENOSPC, not ENOMEM.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
