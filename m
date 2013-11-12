From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: return non-zero st_blocks for inline data
Date: Mon, 11 Nov 2013 22:44:35 -0500
Message-ID: <20131112034435.GB30281@thunk.org>
References: <1383734552-12991-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57034 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab3KLMna (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Nov 2013 07:43:30 -0500
Content-Disposition: inline
In-Reply-To: <1383734552-12991-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 06, 2013 at 03:42:32AM -0700, Andreas Dilger wrote:
> Return a non-zero st_blocks to userspace for statfs() and friends.
> Some versions of tar will assume that files with st_blocks == 0
> do not contain any data and will skip reading them entirely.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Applied, thanks.

					- Ted
