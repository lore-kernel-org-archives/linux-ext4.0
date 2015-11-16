From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] libext2fs: fix block-mapped file punch
Date: Mon, 16 Nov 2015 14:11:50 -0500
Message-ID: <20151116191150.GA3434@thunk.org>
References: <1447463429-5966-1-git-send-email-andreas.dilger@intel.com>
 <1447463429-5966-3-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33983 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbbKPTMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2015 14:12:32 -0500
Content-Disposition: inline
In-Reply-To: <1447463429-5966-3-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 13, 2015 at 06:10:28PM -0700, Andreas Dilger wrote:
> If ext2fs_punch() is called with "end = ~0U" (which is natural from
> a programming POV) it tries to compute "count" based on "start" and
> "end", but doesn't quite get it right.

I don't object to ext2fs_punch handling 32-bit overflows correctly if
it is being called on an indirect mapped file (where the logical block
numbers are limited to 2**32).  But it would be good if the patch
description actually said that.  Also, arguably this is still a bug in
the caller, which should use ~0ULL to mean the end of the file.

> Fix ext2fs_punch() if "end" is anywhere beyond the 2^32 block limit
> so that the 32-bit calculations don't overflow.  Pass "count=~0"
> in this case, and also handle that explicitly in ext2_punch_ind().
> Since ext2_punch_ind() is itself a public function, so it makes
> sense to fix this in both places.

Um, ext2_punch_ind() is a static function....

> @@ -119,6 +119,9 @@ static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,

Cheers,

					- Ted
