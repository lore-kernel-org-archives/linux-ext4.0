From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: fix project quota accounting without quota limits
 enabled.
Date: Tue, 5 Jul 2016 21:34:09 -0400
Message-ID: <20160706013409.GL15193@thunk.org>
References: <1467701890-14687-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lixi@ddn.com, sihara@ddn.com,
	wshilong@ddn.com
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45656 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbcGFBeU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jul 2016 21:34:20 -0400
Content-Disposition: inline
In-Reply-To: <1467701890-14687-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 05, 2016 at 03:58:10PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Steps to reproduce:
>   #mkfs.ext4 /dev/sda4 -O quota,project
>   #mount /dev/sda4 /mnt/test
>   #touch /mnt/test/file
>   #chattr -p 123 /mnt/test/file
>   #quota -v -P 123
> 
> Problems is we should always transfer quota accounting whatver
> quota limits enabled.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Thanks, applied.

					- Ted
