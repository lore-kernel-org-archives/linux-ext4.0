From: Mel Gorman <mgorman@suse.de>
Subject: Re: [patch 5/5] Btrfs: pass __GFP_WRITE for buffered write page
 allocations
Date: Mon, 3 Oct 2011 12:25:13 +0100
Message-ID: <20111003112513.GB5011@suse.de>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
 <1317367044-475-6-git-send-email-jweiner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@redhat.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Shaohua Li <shaohua.li@intel.com>, xfs@oss.sgi.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Johannes Weiner <jweiner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1JCLZS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 07:25:18 -0400
Content-Disposition: inline
In-Reply-To: <1317367044-475-6-git-send-email-jweiner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 09:17:24AM +0200, Johannes Weiner wrote:
> Tell the page allocator that pages allocated for a buffered write are
> expected to become dirty soon.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
