From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] add  fallocate/punch_hole vs AIO/DIO stress test
Date: Thu, 27 Sep 2012 11:07:49 +1000
Message-ID: <20120927010749.GG15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
 <1348496601-32637-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, hch@lst.de
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:61892 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab2I0BIY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 21:08:24 -0400
Content-Disposition: inline
In-Reply-To: <1348496601-32637-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2012 at 06:23:20PM +0400, Dmitry Monakhov wrote:
> Run  DIO, fallocate and punch_hole threads on a common file in parallel.
> If race exist old dio request may rewrite punched block after it was
> allocated to another file, we will catch that by verifying blocks content.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Same comments as for the previous patch.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
