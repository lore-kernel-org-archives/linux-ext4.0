From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Avoid memory leak of ext4_groupinfo_caches in
 ext4_groupinfo_create_slab.
Date: Mon, 11 Jul 2011 18:37:45 -0400
Message-ID: <20110711223745.GS28763@thunk.org>
References: <1310398016-8104-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44374 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986Ab1GKWhs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 18:37:48 -0400
Content-Disposition: inline
In-Reply-To: <1310398016-8104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 11, 2011 at 11:26:55PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In ext4_groupinfo_create_slab, we create ext4_groupinfo_caches within
> ext4_grpinfo_slab_create_mutex, but set it outside the lock, and there
> does exist some case that we may create it twice and causes a memory
> leak. So set it before we call mutex_unlock.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Applied, with a slightly reworded one-line summary:

    ext4: fix a race which could leak memory in ext4_groupinfo_create_slab()

    	      	     	   	      	     	- Ted
