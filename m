From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: let ext4_discard_partial_buffers handle
 unaligned range correctly
Date: Mon, 31 Oct 2011 18:12:26 -0400
Message-ID: <20111031221226.GO16825@thunk.org>
References: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
 <1319974203-2625-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49389 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1JaWM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 18:12:27 -0400
Content-Disposition: inline
In-Reply-To: <1319974203-2625-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 30, 2011 at 07:30:03PM +0800, Yongqiang Yang wrote:
> As comment says, we should handle unaligned range rather than aligned
> one.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
