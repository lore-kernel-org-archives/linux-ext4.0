From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3 v3] ext4: split ext4_file_write into buffered IO and
 direct IO
Date: Mon, 9 Jul 2012 10:44:27 -0400
Message-ID: <20120709144427.GC3649@thunk.org>
References: <1341152506-32649-1-git-send-email-wenqing.lz@taobao.com>
 <1341152506-32649-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>,
	Eric Sandeen <sandeen@redhat.com>,
	Robin Dong <hao.bigrat@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38022 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab2GIOoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 10:44:38 -0400
Content-Disposition: inline
In-Reply-To: <1341152506-32649-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 01, 2012 at 10:21:44PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> ext4_file_dio_write is defined in order to split buffered IO and
> direct IO in ext4.  This patch just refactor some stuff in write path.
> 
> CC: Tao Ma <tm@tao.ma>
> CC: Eric Sandeen <sandeen@redhat.com>
> CC: Robin Dong <hao.bigrat@gmail.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

						 -Ted
