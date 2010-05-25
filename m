From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: remove nr_to_write writeback windup.
Date: Tue, 25 May 2010 07:14:14 -0400
Message-ID: <20100525111414.GC8931@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com> <1274784852-30502-6-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab0EYLOO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 07:14:14 -0400
Content-Disposition: inline
In-Reply-To: <1274784852-30502-6-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 08:54:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the background flush code has been fixed, we shouldn't need to
> silently multiply the wbc->nr_to_write to get good writeback. Remove
> that code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ok,


Reviewed-by: Christoph Hellwig <hch@lst.de>

