From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/8] Clean up ext4's block free code paths
Date: Sun, 22 Nov 2009 21:53:16 -0600
Message-ID: <4B0A072C.5000305@redhat.com>
References: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbZKWDxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Nov 2009 22:53:16 -0500
In-Reply-To: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> This patch series cleans up functions involved with freeing blocks.  It
> removes functions that are only called by a single caller and folds them
> into their caller, and makes the code a little easier to read.  It also
> reduces ext4's code foot print slightly (by 136 bytes).  
> 
> Finally, it fixes a bug in the extents migration function, which was
> missing calls to ext4_forget() when it frees the indirect blocks after
> converting an inode to using extents.  This avoids potential file system
> corruption after a crash while converting an entire filesystem to use
> extents via "chattr -R +e /mntpt".

Have you double-checked stack usage before & after the series, just
in case all the folding-in increased some stack footprints?

Probably ok, but worth a double-check.

-Eric

> 						- Ted
> 
> Theodore Ts'o (8):
>   ext4: move ext4_forget() to ext4_jbd2.c
>   ext4: fold ext4_journal_revoke() into ext4_forget()
>   ext4: fold ext4_journal_forget() into ext4_forget()
>   ext4: fold ext4_free_blocks() and ext4_mb_free_blocks()
>   ext4: call ext4_forget() from ext4_free_blocks()
>   ext4: print i_mode in octal in ext4 tracepoints
>   ext4: add check for wraparound in ext4_data_block_valid()
>   ext4: use ext4_data_block_valid() in ext4_free_blocks()
> 
>  fs/ext4/balloc.c            |   38 --------------
>  fs/ext4/block_validity.c    |    1 +
>  fs/ext4/ext4.h              |   15 +++--
>  fs/ext4/ext4_jbd2.c         |   82 ++++++++++++++++++++++---------
>  fs/ext4/ext4_jbd2.h         |   23 +++------
>  fs/ext4/extents.c           |   24 +++------
>  fs/ext4/inode.c             |  116 +++++++++++--------------------------------
>  fs/ext4/mballoc.c           |   61 ++++++++++++++++++-----
>  fs/ext4/migrate.c           |   23 ++++++---
>  fs/ext4/xattr.c             |    8 ++-
>  include/trace/events/ext4.h |   24 +++++----
>  11 files changed, 198 insertions(+), 217 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

