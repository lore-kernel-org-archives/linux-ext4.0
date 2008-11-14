From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [RFC PATCH 14/17] super->s_*_blocks_count -> ext2fs_*_blocks_count()
Date: Thu, 13 Nov 2008 22:25:31 -0500
Message-ID: <20081114032531.GI20637@shell>
References: <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <1226461390-5502-12-git-send-email-vaurora@redhat.com> <1226461390-5502-13-git-send-email-vaurora@redhat.com> <1226461390-5502-14-git-send-email-vaurora@redhat.com> <1226461390-5502-15-git-send-email-vaurora@redhat.com> <20081113202441.GY16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYKNDZd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 22:25:33 -0500
Content-Disposition: inline
In-Reply-To: <20081113202441.GY16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:24:41PM -0700, Andreas Dilger wrote:
> 
> Since it isn't yet common to be able to test > 32-bit blocks
> these bugs may go unnoticed for some time.  It would be nice to be able
> to test 64-bit support easily with e2fsprogs.  Maybe truncate file
> to > 16TB in size (abort if underlying filesystem isn't able to do this),
> use "lazy_bg" or equivalent to avoid writing many GB of data into the
> sparse file, then run e2fsck on it after putting some files at the end.
> This could probably be done by the "script" support in "make check".

Unfortunately, ext4 doesn't support a file this big so you'd have to
deliberately put your e2fsprogs tree on XFS or something like that for
this automatic check to actually help - not a terribly common
situation for an e2fsprogs developer. (I'm doing all my testing on
sparse files on XFS, which definitely chafes - nothing wrong with XFS,
just kind of annoying that I can't self-host e2fsprogs development.)

Hummm... Would it work to use LVM to glue together two loopback
devices backed by files that sum to just over 16TB?

-VAL
