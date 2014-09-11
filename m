From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/25] tests: write and replay blocks with the old
 journal checksum
Date: Thu, 11 Sep 2014 16:59:37 -0400
Message-ID: <20140911205937.GI8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231322.25904.61980.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51994 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaIKU7j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 16:59:39 -0400
Content-Disposition: inline
In-Reply-To: <20140908231322.25904.61980.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:13:22PM -0700, Darrick J. Wong wrote:
> Test that we can write and replay transactions with the old journal
> checksum algorithm.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

				- Ted
