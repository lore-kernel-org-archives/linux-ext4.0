From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] ext4: Fix memory leak in ext4_init_new_dir
Date: Fri, 11 Jan 2013 10:30:43 +0000
Message-ID: <20130111103043.GM13304@suse.de>
References: <20130111100639.GA3302@suse.de>
 <50EFE581.3070309@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Theodore Ts'o <tytso@mit.edu>, Tao Ma <boyu.mt@taobao.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3AKKap (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2013 05:30:45 -0500
Content-Disposition: inline
In-Reply-To: <50EFE581.3070309@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2013 at 06:12:17PM +0800, Tao Ma wrote:
> Hi Mel,
> 
> Thanks for the report.
> 
> This bug is already spotted by Guo Chao and the patch has been accepted
> by Ted already.
> 

Ah grand, I see now that it was merged for 3.8-rc3. Thanks for the heads up.

-- 
Mel Gorman
SUSE Labs
