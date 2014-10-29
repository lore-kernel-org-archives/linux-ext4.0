From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: enable journal checksum when metadata checksum
 feature enabled
Date: Tue, 28 Oct 2014 21:58:28 -0400
Message-ID: <20141029015828.GB23469@thunk.org>
References: <20141028011916.30103.50751.stgit@birch.djwong.org>
 <20141028011922.30103.65942.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49746 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaJ2B6d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2014 21:58:33 -0400
Content-Disposition: inline
In-Reply-To: <20141028011922.30103.65942.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2014 at 06:19:22PM -0700, Darrick J. Wong wrote:
> If metadata checksumming is turned on for the FS, we need to tell the
> journal to use checksumming too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
