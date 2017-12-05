From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2p: fix getflags for link file
Date: Tue, 5 Dec 2017 11:10:10 -0500
Message-ID: <20171205161010.2q2owkepbk6zg2hp@thunk.org>
References: <1512395795-10022-1-git-send-email-wshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sihara@ddn.com
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35826 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdLEQKN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Dec 2017 11:10:13 -0500
Content-Disposition: inline
In-Reply-To: <1512395795-10022-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 04, 2017 at 10:56:35PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Steps to reproduce:
> 
> $ touch a
> $ lsattr -dp a
>  2000 ----------------P a
> $ ln -s a b
> $ lsattr -dp b
> lsattr: Operation not supported While reading flags on b
> 
> Link files should be supported, fix it.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

You can't actually set or get the extended attributes for a symlink;
the *kernel* doesn't support what you seem to be hoping to achieve.
This patch result in fgetflags() following the symlink and opening
whatever file it points at.

	      	      	  	  	   	- Ted
