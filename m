From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from
 grab_cache_page_write_begin()
Date: Wed, 28 Sep 2011 15:02:25 +0900
Message-ID: <20110928060225.GD14561@barrios-desktop>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
 <1316526315-16801-4-git-send-email-jweiner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Johannes Weiner <jweiner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41034 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1I1GCi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 02:02:38 -0400
Content-Disposition: inline
In-Reply-To: <1316526315-16801-4-git-send-email-jweiner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 20, 2011 at 03:45:14PM +0200, Johannes Weiner wrote:
> Tell the page allocator that pages allocated through
> grab_cache_page_write_begin() are expected to become dirty soon.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
Minchan Kim
