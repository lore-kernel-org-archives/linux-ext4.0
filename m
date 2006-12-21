From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext2: skip pages past number of blocks in ext2_find_entry
Date: Thu, 21 Dec 2006 13:11:01 -0600
Message-ID: <458ADC45.3050308@redhat.com>
References: <458AD954.7020904@redhat.com> <20061221110549.bf336c02.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423033AbWLUTLP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Dec 2006 14:11:15 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20061221110549.bf336c02.randy.dunlap@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Randy Dunlap wrote:

> Please don't hide the goto; un-indent 1 tab stop.
Whoops, thanks Randy - it wasn't intentional. :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.19/fs/ext2/dir.c
===================================================================
--- linux-2.6.19.orig/fs/ext2/dir.c
+++ linux-2.6.19/fs/ext2/dir.c
@@ -368,6 +368,14 @@ struct ext2_dir_entry_2 * ext2_find_entr
 		}
 		if (++n >= npages)
 			n = 0;
+		/* next page is past the blocks we've got */
+		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
+			ext2_error(dir->i_sb, __FUNCTION__,
+				"dir %lu size %lld exceeds block count %llu",
+				dir->i_ino, dir->i_size,
+				(unsigned long long)dir->i_blocks);
+			goto out;
+		}
 	} while (n != start);
 out:
 	return NULL;
