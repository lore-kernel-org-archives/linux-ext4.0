From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Date: Tue, 25 May 2010 07:13:26 -0400
Message-ID: <20100525111326.GA8931@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com> <1274784852-30502-2-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab0EYLN1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 07:13:27 -0400
Content-Disposition: inline
In-Reply-To: <1274784852-30502-2-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +#define CREATE_TRACE_POINTS
> +#include <trace/events/writeback.h>

It might be worth to add a comment why this is in an unusal place.

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
