From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH] fix return value for mb_cache_shrink_fn when nr_to_scan > 0
Date: Tue, 20 Jul 2010 18:34:46 +0200
Message-ID: <201007201834.46593.agruen@suse.de>
References: <4C425273.5000702@gmail.com> <201007192039.06670.agruen@suse.de> <4C45BD34.8030905@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-mm@kvack.org, "linux-ext4" <linux-ext4@vger.kernel.org>,
	"kernel-janitors" <kernel-janitors@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>,
	"Wang Sheng-Hui" <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0GTQet (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jul 2010 12:34:49 -0400
In-Reply-To: <4C45BD34.8030905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 20 July 2010 17:13:56 Eric Sandeen wrote:
> I think the logic in the mbcache shrinker is fine.

Indeed yes, I got confused, sorry.

On Sunday 18 July 2010 08:36:59 Wang Sheng-Hui wrote:
> I regenerated the patch. Please check it.

Sheng-Hui, the mb_cache_lru_list list is now accessed without holding 
mb_cache_spinlock.

Thanks,
Andreas
