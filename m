From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix ncheck program output
Date: Wed, 13 Dec 2017 11:20:26 -0500
Message-ID: <20171213162026.gww44yyyfqb34mvx@thunk.org>
References: <1510210774-4251-1-git-send-email-wshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, qian@ddn.com
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41030 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752292AbdLMQU3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Dec 2017 11:20:29 -0500
Content-Disposition: inline
In-Reply-To: <1510210774-4251-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 09, 2017 at 03:59:34PM +0900, Wang Shilong wrote:
> From: Qian Yingjin <qian@ddn.com>
> 
> Fix the bug that print the inode number not the program name
> when reporting bad inode name during checking in ncheck.
> Minor bug fix: it should reduce iw->inodes_left when found
> matched inode number.
> 
> Signed-off-by: Qian Yingjin <qian@ddn.com>

Applied, thanks.

					- Ted
