From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext3 : Remove redundant condition in
	ext3_free_blocks_sb()
Date: Sat, 31 May 2008 20:05:27 +0100
Message-ID: <20080531190527.GG28946@ZenIV.linux.org.uk>
References: <ea11fea30805311156q7488714ftf8b0b8b8cea85b76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43862 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbYEaTF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 May 2008 15:05:29 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30805311156q7488714ftf8b0b8b8cea85b76@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 12:26:41AM +0530, Manish Katiyar wrote:
> For two unsigned values the check "block+count < block"  is always
> false. Thus the below patch removes that condition.

Really?  Always?

	unsigned block = 1;
	unsigned count = ~0U;

What will be the value and type of block + count?  What will be the
value of block + count < block?
