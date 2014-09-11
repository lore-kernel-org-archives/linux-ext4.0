From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/25] tests: test e2fsck recovery of corrupt revoke
 blocks
Date: Thu, 11 Sep 2014 17:04:28 -0400
Message-ID: <20140911210428.GL8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231341.25904.75703.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52025 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbaIKVEa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 17:04:30 -0400
Content-Disposition: inline
In-Reply-To: <20140908231341.25904.75703.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:13:41PM -0700, Darrick J. Wong wrote:
> Test e2fsck' ability to deal with (a) revoke blocks with a bad
> checksum and (b) revoke blocks with an obviously bad block number.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

				- Ted
