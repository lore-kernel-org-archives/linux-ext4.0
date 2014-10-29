From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: remove extent status procfs files if journal
 load fails
Date: Tue, 28 Oct 2014 22:20:26 -0400
Message-ID: <20141029022026.GD23469@thunk.org>
References: <20141028011916.30103.50751.stgit@birch.djwong.org>
 <20141028011935.30103.59038.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49768 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaJ2CU1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2014 22:20:27 -0400
Content-Disposition: inline
In-Reply-To: <20141028011935.30103.59038.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2014 at 06:19:35PM -0700, Darrick J. Wong wrote:
> If we can't load the journal, remove the procfs files for the extent
> status information file to avoid leaking resources.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
