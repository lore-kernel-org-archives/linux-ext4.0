From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfs: Remove unused variable in
 xfs_qm_scall_quotaon()
Date: Wed, 12 Nov 2014 10:23:33 +1100
Message-ID: <20141111232333.GU28565@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
 <1415739865-2438-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36032 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbaKKXX6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2014 18:23:58 -0500
Content-Disposition: inline
In-Reply-To: <1415739865-2438-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 11, 2014 at 10:04:16PM +0100, Jan Kara wrote:
> sbflags variable in xfs_qm_scall_quotaon() was practically unused (we
> only set it to constant at one place and used it elsewhere). Remove it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I have patches in my queue that change the superblock logging
quite a bit and remove the functionality you're changing in this
patch, so eventually you'll be able to drop this patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
