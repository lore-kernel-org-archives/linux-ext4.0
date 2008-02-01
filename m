From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] make mballoc history a config option
Date: Fri, 01 Feb 2008 15:16:58 -0600
Message-ID: <47A38C4A.9000402@redhat.com>
References: <47A37F85.1050006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYBAVRA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2008 16:17:00 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m11LGxln014356
	for <linux-ext4@vger.kernel.org>; Fri, 1 Feb 2008 16:16:59 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m11LGxib021555
	for <linux-ext4@vger.kernel.org>; Fri, 1 Feb 2008 16:16:59 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m11LGwEf007545
	for <linux-ext4@vger.kernel.org>; Fri, 1 Feb 2008 16:16:59 -0500
In-Reply-To: <47A37F85.1050006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> It's a bit shocking how much this matters to the size of
> ext4_mb_release_inode_pa etc; I've not yet found the 
> reason why.

Oh, well, duh - its' the big 108 byte allocation context on the
stack.... and if it's not used it gets optimized away.

I think it's worth looking at allocating that one.

-Eric
