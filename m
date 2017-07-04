From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] Add largedir feature
Date: Tue, 4 Jul 2017 13:56:17 -0400
Message-ID: <20170704175617.3mhx6koi3tebh72w@thunk.org>
References: <A4690934-D680-4735-AEA6-8BF995990546@dilger.ca>
 <1494094761-19108-1-git-send-email-artem.blagodarenko@seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com, ebiggers3@gmail.com,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46902 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbdGDR4U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Jul 2017 13:56:20 -0400
Content-Disposition: inline
In-Reply-To: <1494094761-19108-1-git-send-email-artem.blagodarenko@seagate.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 06, 2017 at 02:19:21PM -0400, Artem Blagodarenko wrote:
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> 
> This INCOMPAT_LARGEDIR feature allows larger directories to be created
> in ldiskfs, both with directory sizes over 2GB and and a maximum htree
> depth of 3 instead of the current limit of 2. These features are needed
> in order to exceed the current limit of approximately 10M entries in a
> single directory.
> 
> Signed-off-by: Yang Sheng <yang.sheng@intel.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

I'm going to fold the following minor fix-up to this patch before I
send it to Linus.

					- Ted

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f97611171023..5e61e464d71c 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -77,7 +77,14 @@
 
 #define EXT4_RESERVE_TRANS_BLOCKS	12U
 
-#define EXT4_INDEX_EXTRA_TRANS_BLOCKS	8
+/*
+ * Number of credits needed if we need to insert an entry into a
+ * directory.  For each new index block, we need 4 blocks (old index
+ * block, new index block, bitmap block, bg summary).  For normal
+ * htree directories there are 2 levels; if the largedir feature
+ * enabled it's 3 levels.
+ */
+#define EXT4_INDEX_EXTRA_TRANS_BLOCKS	12U
 
 #ifdef CONFIG_QUOTA
 /* Amount of blocks needed for quota update - we know that the structure was
