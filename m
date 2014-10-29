From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] Subject: [PATCH] ext4: disallow changing
 journal_csum option during remount
Date: Tue, 28 Oct 2014 22:20:14 -0400
Message-ID: <20141029022014.GC23469@thunk.org>
References: <20141028011916.30103.50751.stgit@birch.djwong.org>
 <20141028011929.30103.67158.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49764 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaJ2CUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2014 22:20:23 -0400
Content-Disposition: inline
In-Reply-To: <20141028011929.30103.67158.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2014 at 06:19:29PM -0700, Darrick J. Wong wrote:
> ext4 does not permit changing the metadata or journal checksum feature
> flag while mounted.  Until we decide to support that, don't allow a
> remount to change the journal_csum flag (right now we silently fail to
> change anything).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
