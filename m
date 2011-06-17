From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 06/11 RESEND] e4defrag: Allow user who has read+write access to defrag
Date: Fri, 17 Jun 2011 03:10:33 -0600
Message-ID: <38089875-FB69-479A-9424-1AC477975AD1@dilger.ca>
References: <4DF852F8.2020208@sx.jp.nec.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:11783 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab1FQJKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 05:10:38 -0400
In-Reply-To: <4DF852F8.2020208@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-15, at 12:36 AM, Kazuya Mio wrote:
> Anyone who has read+write access can defrag the file for this fix.
> Currently, non-root user needs owner authority to defrag the file. But non-root
> user who is not owner might have read+write access.

I was looking at this code, and doing any kind of permission checking in
userspace makes no sense.  Anyone could download the code and recompile
it without this check, so it is clear that all permission checking has
to happen in the kernel.

I agree that anyone with read+write access to the file can corrupt it,
just as badly as if they wrote garbage into the file, so it seems this
should be enough permission to also run defragmentation on the file.
It is good that you have removed these checks.

> @@ -466,6 +465,7 @@ static int check_free_size(int fd, const char *file,
> 	ext4_fsblk_t	free_blk_count;
> 	struct statfs64	fsbuf;
> +	uid_t		current_uid = getuid();
> 
> 	if (fstatfs64(fd, &fsbuf) < 0) {
> 		if (mode_flag & DETAIL) {

This one last usage is also incorrect.  It assumes that ROOT_UID is the
only one that can access the "reserved" space in the filesystem.  In fact,
it is possible to set s_def_resuid and s_def_resgid in the superblock to
allow anyone with that UID or GID to access the reserved space.

Cheers, Andreas





