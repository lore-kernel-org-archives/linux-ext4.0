From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] libquota: quota file read support
Date: Mon, 14 Nov 2011 10:58:41 -0500
Message-ID: <20111114155841.GD7698@thunk.org>
References: <4EB68D67.909@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adityakali@google.com, linux-ext4@vger.kernel.org
To: Niu <niu@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38441 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab1KNP6n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 10:58:43 -0500
Content-Disposition: inline
In-Reply-To: <4EB68D67.909@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 06, 2011 at 09:36:39PM +0800, Niu wrote:
> This patch adds read quota file support, which includes:
> - Improve scan dquot APIs & fix defects in scan dquot functions;
> - Implement quota_file_open();
> - Introduce quota_update_inode() to update usage in old quota file,
>   and keep the limits unchanged.
> 
> Signed-off-by: Niu Yawei <niu@whamcloud.com>

Thanks, applied.

					- Ted
