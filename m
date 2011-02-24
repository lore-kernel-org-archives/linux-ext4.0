From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] mballoc: change comments to ac_g_ex
Date: Thu, 24 Feb 2011 14:08:22 -0500
Message-ID: <20110224190822.GX2924@thunk.org>
References: <4D4E2970.8050709@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@google.com>
To: Coly Li <i@coly.li>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48401 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab1BXTIY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 14:08:24 -0500
Content-Disposition: inline
In-Reply-To: <4D4E2970.8050709@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 06, 2011 at 12:54:08PM +0800, Coly Li wrote:
> Current comments to ac_g_ex, the member of struct
> ext4_allocation_context is,
> 	/* goal request (after normalization) */
> This is a little bit confused. In order to make it easier to be
> understood, this patch modify the comments as,
> 	/* goal request (normalized ac_o_ex) */
> which means ac_g_ex is a normalized value of ac_o_ex.
> 
> Signed-off-by: Coly Li <bosong.ly@taobao.com>
> Cc: Alex Tomas <alex@clusterfs.com>
> Cc: Theodore Tso <tytso@google.com>

Added to the ext4 patch queue, thanks.

I used a much simpler patch comment:

ext4: clarify description of ac_g_ex in struct ext4_allocation_context
    
Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Alex Tomas <alex@clusterfs.com>
Cc: Theodore Tso <tytso@google.com>

						- Ted

