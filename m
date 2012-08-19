From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove duplicated declarations in inode.c
Date: Sun, 19 Aug 2012 18:10:00 -0400
Message-ID: <20120819221000.GA25738@thunk.org>
References: <1338987802-10186-1-git-send-email-gnehzuil.liu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "gnehzuil.liu@gmail.com" <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45728 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2HSWKH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Aug 2012 18:10:07 -0400
Content-Disposition: inline
In-Reply-To: <1338987802-10186-1-git-send-email-gnehzuil.liu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 06, 2012 at 09:03:22PM +0800, gnehzuil.liu@gmail.com wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> in patch cb20d5188366f04d96d2e07b1240cc92170ade40, ext4_set_bh_endio and
> ext4_end_io_buffer_write are declared at the beginning of inode.c file.  So we
> can remove duplicated declarations in this file.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, applied.

					- Ted
