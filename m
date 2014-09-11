From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/25] tests: test e2fsck recovery with broken commit
 blocks
Date: Thu, 11 Sep 2014 17:04:39 -0400
Message-ID: <20140911210439.GM8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231348.25904.68480.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52032 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbaIKVEl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 17:04:41 -0400
Content-Disposition: inline
In-Reply-To: <20140908231348.25904.68480.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:13:48PM -0700, Darrick J. Wong wrote:
> Test e2fsck' recovery of commit blocks with (a) only a corrupt
> checksum and (b) an obviously incorrect tid.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

				- Ted
