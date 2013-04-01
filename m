From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: undegister es_shrinker if mount failed
Date: Mon, 1 Apr 2013 10:49:55 -0400
Message-ID: <20130401144955.GA4731@thunk.org>
References: <1363969123-16852-1-git-send-email-dmonakhov@openvz.org>
 <1363969123-16852-3-git-send-email-dmonakhov@openvz.org>
 <514D1412.1090405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	jack@suse.cz, wenqing.lz@taobao.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57791 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491Ab3DAOuF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 10:50:05 -0400
Content-Disposition: inline
In-Reply-To: <514D1412.1090405@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> From 596eee1f5caf23084d9b43c47b327206bd8c7ee5 Mon Sep 17 00:00:00 2001
> From: Zheng Liu <wenqing.lz@taobao.com>
> Date: Sat, 23 Mar 2013 10:26:55 +0800
> Subject: [PATCH] register es shrinker before initializing per-cpu counters
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

I've merged this change into the version of Dmitry's patch which is in
the ext4 tree.

						- Ted
