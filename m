From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] FAT: add 'notify' mount option
Date: Wed, 3 Jun 2009 11:59:40 -0700
Message-ID: <20090603115940.bbae3a24.akpm@linux-foundation.org>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	<e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
	<c3bf79be4fd40b767a94d915e0f7e0cdc8f4cc92.1244049681.git.ext-denis.2.karpov@nokia.com>
	<22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed,  3 Jun 2009 18:05:17 +0300
Denis Karpov <ext-denis.2.karpov@nokia.com> wrote:

> Implement FAT fs mount option 'notify'. The effect of this option
> is that a notification is sent to userspace on errors that indicate
> filesystem damage/inconsistency. Generic filesystem corruption
> notification mechnism is used.
> 
> Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
> ---
>  fs/fat/fat.h   |    3 ++-
>  fs/fat/inode.c |    9 ++++++++-
>  fs/fat/misc.c  |    7 +++++++

fatfs mount options are documented in
Documentation/filesystems/vfat.txt, please.

