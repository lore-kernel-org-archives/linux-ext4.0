From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Date: Tue, 22 Apr 2014 02:16:20 -0700
Message-ID: <20140422091620.GA4980@infradead.org>
References: <20140421204023.GB960@wallace>
 <20140422062816.GB31337@infradead.org>
 <20140422091443.GG15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Whitney <enwlinux@gmail.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaDVJQX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2014 05:16:23 -0400
Content-Disposition: inline
In-Reply-To: <20140422091443.GG15995@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 22, 2014 at 07:14:43PM +1000, Dave Chinner wrote:
> I don't really care either way, as long as all the checks are done
> consistently. Send a patch to change them all... :)

My flink test already avoids the wrapper :)

So how about we stop adding them for now at least.
