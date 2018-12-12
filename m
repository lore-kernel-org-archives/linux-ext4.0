Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42518 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbeLLNPV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Dec 2018 08:15:21 -0500
Date: Wed, 12 Dec 2018 14:15:18 +0100
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 00/10] fix coding style for ext2 filesystem
Message-ID: <20181212131518.GE10902@quack2.suse.cz>
References: <20181113000448.16023-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 13-11-18 08:04:38, Chengguang Xu wrote:
> This patch set fixes some coding style warnings which are from
> checkpatch.pl.
> 
> Detail warning/error messages are below:
> 
> WARNING: function definition argument 'struct inode *' should
> also have an identifier name
> 
> WARNING: space prohibited between function name and open
> parenthesis '(' 
> 
> WARNING: line over 80 characters
> 
> ERROR: "foo * bar" should be "foo *bar"

Thanks for the series! I had a look into the patches but I don't think
these whitespace fixes are really worth the churn. Sorry.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
