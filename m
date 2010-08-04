From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] Add batched discard support for ext4
Date: Wed, 4 Aug 2010 16:17:24 +0200
Message-ID: <20100804141724.GB4139@quack.suse.cz>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com>
 <1280929475-12823-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52273 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab0HDORz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 10:17:55 -0400
Content-Disposition: inline
In-Reply-To: <1280929475-12823-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 04-08-10 15:44:35, Lukas Czerner wrote:
> Walk through each allocation group and trim all free extents. It can be
> invoked through TRIM ioctl on the file system. The main idea is to
> provide a way to trim the whole file system if needed, since some SSD's
> may suffer from performance loss after the whole device was filled (it
> does not mean that fs is full!).
> 
> It search fro free extents in each allocation group. When the free
> extent is found, blocks are marked as used in the buddy bitmap and then
> trimmed. Afterwards these blocks are marked as free in per-group buddy
> bitmap.
> 
> Since fstrim is a long operation it is good to have an ability to interrupt
> it by a signal. This was added by Dmitry Monakhov. Thanks Dimitry.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  This patch looks OK as well. Just one question:

> +	ret = sb_issue_discard(sb, discard_block, count);
> +	if (ret == EOPNOTSUPP) {
                   ^^ Here should be -EOPNOTSUPP, or generally a check
that ret < 0 would be better as -EIO or so can be returned as well. The
same comment actually applies for the ext3 patch.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
