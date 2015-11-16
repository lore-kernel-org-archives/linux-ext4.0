From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] libext2fs: fix block-mapped file punch
Date: Mon, 16 Nov 2015 07:04:28 -0500
Message-ID: <20151116120428.GC29432@thunk.org>
References: <1447463429-5966-1-git-send-email-andreas.dilger@intel.com>
 <1447463429-5966-3-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33966 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbbKPTIY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2015 14:08:24 -0500
Content-Disposition: inline
In-Reply-To: <1447463429-5966-3-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 13, 2015 at 06:10:28PM -0700, Andreas Dilger wrote:
> If ext2fs_punch() is called with "end = ~0U" (which is natural from
> a programming POV) it tries to compute "count" based on "start" and
> "end", but doesn't quite get it right.

You should make clear that this only applies in the case where we are
punching on an indirect block mapped file.  I read this and alarm
bells started going off since end is a blk64_t, and we can't do this
for extent-mapped files.

> Pass "count=~0"
> in this case, and also handle that explicitly in ext2_punch_ind().
> Since ext2_punch_ind() is itself a public function, so it makes
> sense to fix this in both places.

Um, ext2fs_punch()_ind is *not* a public function.

						- Ted
