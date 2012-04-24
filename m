From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: cleanup in do_show_debugfs_params
Date: Tue, 24 Apr 2012 14:33:23 -0400
Message-ID: <20120424183323.GF18865@thunk.org>
References: <1334583686-4571-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33783 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab2DXSd1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 14:33:27 -0400
Content-Disposition: inline
In-Reply-To: <1334583686-4571-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 16, 2012 at 09:41:26PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Remove 'out' variable and replace fprintf with printf.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

						- Ted
