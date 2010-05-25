From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] writeback: Add tracing to balance_dirty_pages
Date: Tue, 25 May 2010 07:13:45 -0400
Message-ID: <20100525111345.GB8931@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com> <1274784852-30502-3-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0EYLNp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 07:13:45 -0400
Content-Disposition: inline
In-Reply-To: <1274784852-30502-3-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 08:54:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Tracing high level background writeback events is good, but it doesn't
> give the entire picture. Add IO dispatched by foreground throttling to the
> writeback events.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

