From: David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 1/9] ext4: Add -DDEBUG to Makefile
Date: Fri, 16 Mar 2012 09:03:57 -0700
Message-ID: <4F63646D.1040700@cavium.com>
References: <cover.1331856299.git.joe@perches.com> <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18979 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab2CPQD6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Mar 2012 12:03:58 -0400
In-Reply-To: <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/15/2012 05:07 PM, Joe Perches wrote:
> Add -DDEBUG to enable future use of pr_debug.
> No changes to objects as no DEBUG uses currently exist.
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   fs/ext4/Makefile |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
> index 56fd8f86..617a5d8 100644
> --- a/fs/ext4/Makefile
> +++ b/fs/ext4/Makefile
> @@ -2,6 +2,8 @@
>   # Makefile for the linux ext4-filesystem routines.
>   #
>
> +ccflags-$(CONFIG_EXT4_FS) := -DDEBUG

In many other susbsystems/drivers, the definition of DEBUG is gated by a 
separate Kconfig symbol used to select debugging just for that 
susbsystem/driver (see CONFIG_MMC_DEBUG for example).

Why aren't you doing the same here?

David Daney
