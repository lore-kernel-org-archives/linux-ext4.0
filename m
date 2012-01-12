From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Date: Thu, 12 Jan 2012 13:48:41 +1100
Message-ID: <20120112024841.GB2806@dastard>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36286 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab2ALCsp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 21:48:45 -0500
Content-Disposition: inline
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> 
>   Hello,
> 
>   filesystem freezing is currently racy and thus we can end up with dirty data
> on frozen filesystem (see changelog of the first patch for detailed race
> description and proposed fix). This patch series aims at fixing this.

It only fixes the dirty data race (i.e. SB_FREEZE_WRITE). The same
race conditions exist for SB_FREEZE_TRANS on XFS, and so need the
same fix. That race has had one previous attempt at fixing it in
XFS but that's not possible:

b2ce397 Revert "xfs: fix filesystsem freeze race in xfs_trans_alloc"
7a249cf xfs: fix filesystsem freeze race in xfs_trans_alloc

It was looking at that problem earlier today that lead to the
solution Eric proposed. Essentially the method in these patches
needs to replace the xfs specifc m_active_trans counter and delay
during ->fs_freeze to prevent that race condition....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
