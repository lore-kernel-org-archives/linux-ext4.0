From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] libquota: fix quota usage compute
Date: Mon, 14 Nov 2011 10:59:44 -0500
Message-ID: <20111114155944.GF7698@thunk.org>
References: <4EB68E65.5080804@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adityakali@google.com, linux-ext4@vger.kernel.org
To: Niu <niu@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38449 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab1KNP7q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 10:59:46 -0500
Content-Disposition: inline
In-Reply-To: <4EB68E65.5080804@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 06, 2011 at 09:40:53PM +0800, Niu wrote:
> In quota_compute_usage(), the space usage should be in bytes but
> not quota block.
> 
> Signed-off-by: Niu Yawei <niu@whamcloud.com>

Thanks, applied.

					- Ted
