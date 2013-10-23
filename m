From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Fix noquota build
Date: Wed, 23 Oct 2013 11:55:06 -0500
Message-ID: <5267FF6A.9010303@redhat.com>
References: <5267F952.5040402@redhat.com> <1382547188-30578-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3JWQzK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 12:55:10 -0400
In-Reply-To: <1382547188-30578-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/23/13 11:53 AM, Theodore Ts'o wrote:
> We need to build libquota even if the quota code is disabled.  This
> fixes a build regression introduced by commit 43075b42bd: 'quota: fix
> disabling quota, add quota tests".
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Should work.  Thanks Ted.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(if you want to push it out, I'll do a coverity scan so we
can make sure we're not going backwards there, too; this bug
has been preventing those for the past week or so).

-Eric

> ---
>  Makefile.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile.in b/Makefile.in
> index 95cbf1b..ef79482 100644
> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -26,7 +26,7 @@ export CHECK_CMD
>  @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
>  @UUID_CMT@UUID_LIB_SUBDIR= lib/uuid
>  @BLKID_CMT@BLKID_LIB_SUBDIR= lib/blkid
> -@QUOTA_CMT@QUOTA_LIB_SUBDIR= lib/quota
> +QUOTA_LIB_SUBDIR= lib/quota
>  
>  LIB_SUBDIRS=lib/et lib/ss lib/e2p $(UUID_LIB_SUBDIR) lib/ext2fs $(BLKID_LIB_SUBDIR) $(QUOTA_LIB_SUBDIR) intl
>  PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
> 

