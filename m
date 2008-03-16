From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] jbd: correctly unescape journal data blocks
Date: Sun, 16 Mar 2008 08:29:20 +0800
Message-ID: <20080316002920.GW3542@webber.adilger.int>
References: <1205606985-22645-1-git-send-email-duaneg@dghda.com>
 <1205606985-22645-2-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36559 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYCPA3y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 20:29:54 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2G0TqiB009939
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 17:29:52 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXS00F01RQ6GV00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 15 Mar 2008 17:29:52 -0700 (PDT)
In-reply-to: <1205606985-22645-2-git-send-email-duaneg@dghda.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 15, 2008  18:49 +0000, Duane Griffin wrote:
> Fix a long-standing typo (predating git) that will cause data corruption
> if a journal data block needs unescaping. At the moment the wrong buffer
> head's data is being unescaped.
> 
> To test this case mount a filesystem with data=journal, start creating
> and deleting a bunch of files containing only JFS_MAGIC_NUMBER (0xc03b3998),
> then pull the plug on the device. Without this patch the files will contain
> zeros instead of the correct data after recovery.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>  fs/jbd/recovery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
> index 2b8edf4..43bc5e5 100644
> --- a/fs/jbd/recovery.c
> +++ b/fs/jbd/recovery.c
> @@ -478,7 +478,7 @@ static int do_one_pass(journal_t *journal,
>  					memcpy(nbh->b_data, obh->b_data,
>  							journal->j_blocksize);
>  					if (flags & JFS_FLAG_ESCAPE) {
> -						*((__be32 *)bh->b_data) =
> +						*((__be32 *)nbh->b_data) =
>  						cpu_to_be32(JFS_MAGIC_NUMBER);
>  					}

Note that this would also affect filesystems larger than ~12TB, where
JFS_MAGIC_NUMBER might be the first block number in an ext2/3 indirect
block.  That would cause the indirect block to be zapped and file data
in the whole block would suddenly become zero.  Even worse if this is
the first block in a double-indirect or triple-indirect block, where
4MB or 16GB of the file data would suddenly become a hole.  Unlikely,
but with enough monkeys it would be hit.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

