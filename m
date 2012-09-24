From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] ext4: check free block counters in
 ext4_mb_find_by_goal
Date: Sun, 23 Sep 2012 23:11:37 -0400
Message-ID: <20120924031137.GA2129@thunk.org>
References: <1346937415-2866-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52104 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab2IYSd0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 14:33:26 -0400
Content-Disposition: inline
In-Reply-To: <1346937415-2866-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 06, 2012 at 09:16:54PM +0800, Yongqiang Yang wrote:
> Free block counters should be checked before doing allocation.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
