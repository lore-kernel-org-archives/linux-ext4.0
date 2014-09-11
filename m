From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/25] tests: test recovery of 32 and 64-bit journals
 with checksum v2
Date: Thu, 11 Sep 2014 16:59:49 -0400
Message-ID: <20140911205949.GJ8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231328.25904.94901.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52001 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbaIKU7u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 16:59:50 -0400
Content-Disposition: inline
In-Reply-To: <20140908231328.25904.94901.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:13:28PM -0700, Darrick J. Wong wrote:
> Add tests to ensure that we know how to recover journals with the
> csum_v2 feature set.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
