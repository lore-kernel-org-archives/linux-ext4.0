From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/25] tests: test writing and recovering 32bit csum_v3
 journals
Date: Thu, 11 Sep 2014 16:59:26 -0400
Message-ID: <20140911205925.GH8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231314.25904.45059.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51988 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaIKU71 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 16:59:27 -0400
Content-Disposition: inline
In-Reply-To: <20140908231314.25904.45059.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:13:14PM -0700, Darrick J. Wong wrote:
> Simple tests for the 32bit journal transaction creation code when
> journal and metadata_csum are enabled.  We test the following:
> 
> (a) writing and replaying transactions with multiple
>     descriptor blocks
> (b) same, but with multiple revoke blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
