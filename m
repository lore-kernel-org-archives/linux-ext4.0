From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2 1/3] mke2fs: correct help text for option -G of
 mke2fs
Date: Mon, 23 Jan 2012 11:47:18 -0500
Message-ID: <20120123164718.GB4439@thunk.org>
References: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34112 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2AWSJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 13:09:56 -0500
Content-Disposition: inline
In-Reply-To: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2012 at 07:02:10PM +0800, Yongqiang Yang wrote:
> The option '-G' is used to pass number of groups in a flex_bg, the
> previous help text - 'meta-group-size' - could confuse users with
> meta_bg.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
