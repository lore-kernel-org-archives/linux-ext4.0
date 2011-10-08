From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: MMP: fix error message rate-limiting logic
 in kmmpd
Date: Sat, 8 Oct 2011 17:25:19 -0400
Message-ID: <20111008212519.GO7948@thunk.org>
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com>
 <1317339500-4341-1-git-send-email-nikitas_angelinas@xyratex.com>
 <1317339500-4341-3-git-send-email-nikitas_angelinas@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, adilger@whamcloud.com,
	johann@whamcloud.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, nikitas_angelinas@xyratex.com,
	andrew_perepechko@xyratex.com
To: Nikitas Angelinas <nikitasangelinas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54794 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab1JHVZT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 17:25:19 -0400
Content-Disposition: inline
In-Reply-To: <1317339500-4341-3-git-send-email-nikitas_angelinas@xyratex.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 12:38:20AM +0100, Nikitas Angelinas wrote:
> Current logic would print an error message only once, and then
> 'failed_writes' would stay at 1. Rework the loop to increment
> 'failed_writes' and print the error message every s_mmp_update_interval
> * 60 seconds, as intended according to the comment.
> 
> Perhaps it would be better to reset 'failed_writes' to 0 on every
> successful write, such that new errors are noticed sooner, but maybe in
> the interest of efficiency it would be best not to add an operation on
> every kmmpd thread run?
> 
> Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
> Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
> Acked-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
