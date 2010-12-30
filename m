From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Add error check in ext4_mkdir()
Date: Thu, 30 Dec 2010 08:30:49 -0500
Message-ID: <20101230133049.GN10149@thunk.org>
References: <1289906292-8906-1-git-send-email-namhyung@gmail.com>
 <1289906392-8964-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52829 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0L3Na5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Dec 2010 08:30:57 -0500
Content-Disposition: inline
In-Reply-To: <1289906392-8964-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 08:19:52PM +0900, Namhyung Kim wrote:
> Check return value of ext4_journal_get_write_access,
> ext4_journal_dirty_metadata and ext4_mark_inode_dirty. Move brelse()
> under 'out_stop' to release bh properly in case of journal error.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, added to the ext4 patch tree.

						- Ted
