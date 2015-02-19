From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Allocate entire range in zero range
Date: Thu, 19 Feb 2015 06:31:00 -0500 (EST)
Message-ID: <1187673811.14968384.1424345460001.JavaMail.zimbra@redhat.com>
References: <1424278168-13711-1-git-send-email-lczerner@redhat.com> <20150219004935.GR4251@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:52207 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbBSLbC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Feb 2015 06:31:02 -0500
In-Reply-To: <20150219004935.GR4251@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dave,

yes I am planning to send a regression test for this case as well.

Thanks!
-Lukas

----- Original Message -----
From: "Dave Chinner" <david@fromorbit.com>
To: "Lukas Czerner" <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org
Sent: Thursday, February 19, 2015 1:49:35 AM
Subject: Re: [PATCH] ext4: Allocate entire range in zero range

On Wed, Feb 18, 2015 at 05:49:28PM +0100, Lukas Czerner wrote:
> Currently there is a bug in zero range code which causes zero range
> calls to only allocate block aligned portion of the range, while
> ignoring the rest in some cases.
> 
> In some cases, namely if the end of the range is past isize, we do
> attempt to preallocate the last nonaligned block. However this might
> cause kernel to BUG() in some carefully designed zero range requests on
> setups where page size > block size.

Is there a regression test you could write to exercise these casesi
in future?


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
