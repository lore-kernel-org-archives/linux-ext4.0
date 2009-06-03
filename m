From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] EXT2: add 'notify' mount option
Date: Wed, 3 Jun 2009 12:00:30 -0700
Message-ID: <20090603120030.f37f4d1d.akpm@linux-foundation.org>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	<e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
	<c3bf79be4fd40b767a94d915e0f7e0cdc8f4cc92.1244049681.git.ext-denis.2.karpov@nokia.com>
	<22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
	<60607de38c1ebbd1ba1cb33d85f1dcdec77f3c61.1244049681.git.ext-denis.2.karpov@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbZFCTA5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 15:00:57 -0400
In-Reply-To: <60607de38c1ebbd1ba1cb33d85f1dcdec77f3c61.1244049681.git.ext-denis.2.karpov@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed,  3 Jun 2009 18:05:18 +0300
Denis Karpov <ext-denis.2.karpov@nokia.com> wrote:

> Implement EXT2 fs mount option 'notify'. The effect of this option
> is that a notification is sent to userspace on errors that indicate
> filesystem damage/inconsistency. Generic filesystem corruption
> notification mechnism is used.
> 
> Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
> ---
>  fs/ext2/super.c         |   15 ++++++++++++++-
>  include/linux/ext2_fs.h |    2 +-

Please document the mount option in Documentation/filesystems/ext2.txt.
