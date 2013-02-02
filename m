From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fix race in ext4_mb_add_n_trim()
Date: Fri, 1 Feb 2013 21:32:28 -0500
Message-ID: <20130202023228.GA22080@thunk.org>
References: <50EA669E.1030008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, yawei.niu@intel.com,
	Alex Zhuravlev <bzzz@whamcloud.com>
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46575 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab3BBCcd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2013 21:32:33 -0500
Content-Disposition: inline
In-Reply-To: <50EA669E.1030008@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 06, 2013 at 08:09:34PM -0000, Niu Yawei wrote:
> >From 020243735e97f327ecba729ec05d4e3facdddc78 Mon Sep 17 00:00:00 2001
> From: Niu Yawei <niu@whamcloud.com>
> Date: Mon, 7 Jan 2013 01:03:26 -0500
> Subject: [PATCH] Fix race in ext4_mb_add_n_trim()
> 
> In ext4_mb_add_n_trim(), lg_prealloc_lock should be taken when
> changing the lg_prealloc_list.
> 
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>

Applied, thanks!

						- Ted
