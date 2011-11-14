From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libquota: fix get_dq()
Date: Mon, 14 Nov 2011 11:56:55 -0500
Message-ID: <20111114165655.GG7698@thunk.org>
References: <4EBCB11A.8000203@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adityakali@google.com, linux-ext4@vger.kernel.org
To: Niu <niu@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47995 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab1KNQ47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 11:56:59 -0500
Content-Disposition: inline
In-Reply-To: <4EBCB11A.8000203@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 11, 2011 at 01:22:34PM +0800, Niu wrote:
> Hi, Aditya
> 
> This one more fix based on your new quota patches.
> 
> From f3f4de997890a0c50d7c8143d9046dcab93cda5d Mon Sep 17 00:00:00 2001
> From: Niu Yawei <niu@whamcloud.com>
> Date: Fri, 11 Nov 2011 01:11:59 +0800
> Subject: [PATCH] libquota: fix get_dq()
> 
> The dq_id should be set on newly created dqout.
> 
> Signed-off-by: Niu Yawei <niu@whamcloud.com>

Applied, thanks.

						- Ted
