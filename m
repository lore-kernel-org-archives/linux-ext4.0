From: Ian Nartowicz <claws@nartowicz.co.uk>
Subject: Re: [RFC][PATCH] ext4: handle fast symlink properly with =?utf-8?b?aW5saW5lX2RhdGE=?=
Date: Thu, 13 Feb 2014 17:05:03 +0000 (UTC)
Message-ID: <loom.20140213T180233-750@post.gmane.org>
References: <1392275237-6998-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45481 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaBMRF3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Feb 2014 12:05:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1WDzj5-0000qV-15
	for linux-ext4@vger.kernel.org; Thu, 13 Feb 2014 18:05:27 +0100
Received: from cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com ([81.103.170.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 13 Feb 2014 18:05:27 +0100
Received: from claws by cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 13 Feb 2014 18:05:27 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zheng Liu <gnehzuil.liu <at> gmail.com> writes:

> 
> From: Zheng Liu <wenqing.lz <at> taobao.com>
> 
> This commit tries to fix a bug that we can't read fast symlink properly.
> The following script can hit the bug.
> 

> Hi all,
> 
> I am not sure whether or not we need to enable inline_data for a fast
> symlink inode.  Obviously, it brings a benefit that after enabling
> inline_data feature for a fast symlink we can get more space to store
> the path.  But it seems that the original patch doesn't want to do this
> Another solution for fixing this bug is to disable inline_data for a
> fast symlink.  Any comment?
> 
> Thanks,
> 						- Zheng

I compiled a kernel with this patch and the long symlinks work OK now.  fsck
still complains, of course.

Seems like a fairly rare case, but is there any real downside to supporting it?

--ian

