From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Enable quota enforcement based on mount options
Date: Mon, 5 Sep 2016 23:09:07 -0400
Message-ID: <20160906030907.f6r2rksdibza76ho@thunk.org>
References: <1468841157-8083-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46642 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753583AbcIFDJZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 23:09:25 -0400
Content-Disposition: inline
In-Reply-To: <1468841157-8083-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2016 at 01:25:57PM +0200, Jan Kara wrote:
> When quota information is stored in quota files, we enable only quota
> accounting on mount and enforcement is enabled only in response to
> Q_QUOTAON quotactl. To make ext4 behavior consistent with XFS, we add a
> possibility to enable quota enforcement on mount by specifying
> corresponding quota mount option (usrquota, grpquota, prjquota).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
