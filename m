From: Aditya Kali <adityakali@google.com>
Subject: Re: linux-next: build failure after merge of the ext4 tree
Date: Mon, 9 Jul 2012 18:48:02 -0700
Message-ID: <CAGr1F2EB=BR+GSq34TYB+QE+3FNwzvBwBemYPpPu+=wENQf-ZA@mail.gmail.com>
References: <20120710112312.099a2f602cd6aea90226732c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Johann Lombardi <johann@whamcloud.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, wfg@linux.intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61724 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2GJBsY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2012 21:48:24 -0400
Received: by lbbgm6 with SMTP id gm6so21278320lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 Jul 2012 18:48:22 -0700 (PDT)
In-Reply-To: <20120710112312.099a2f602cd6aea90226732c@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for the trouble. The following patch should fix the build.


From: Aditya Kali <adityakali@google.com>
Date: Mon, 9 Jul 2012 18:42:28 -0700
Subject: [PATCH] ext4: Fix compilation error for ext4_enable_quotas

ext4_enable_quotas should only be called under CONFIG_QUOTA
block.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9b87c3..e4b79fc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4734,6 +4734,7 @@ static int ext4_remount(struct super_block *sb,
int *flags, char *data)
 	if (enable_quota) {
 		if (sb_any_quota_suspended(sb))
 			dquot_resume(sb, -1);
+#ifdef CONFIG_QUOTA
 		else if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 			err = ext4_enable_quotas(sb);
@@ -4742,6 +4743,7 @@ static int ext4_remount(struct super_block *sb,
int *flags, char *data)
 				goto restore_opts;
 			}
 		}
+#endif
 	}

 	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
-- 
1.7.7.3


On Mon, Jul 9, 2012 at 6:23 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Ted,
>
> After merging the ext4 tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/ext4/super.c: In function 'ext4_remount':
> fs/ext4/super.c:4739:4: error: implicit declaration of function 'ext4_enable_quotas' [-Werror=implicit-function-declaration]
>
> Caused by commit 182bb8fec8f5 ("ext4: make quota as first class supported
> feature").  The quota code needs to be protected by CONFIG_QUOTA.
>
> I have used the ext4 tree from next-20120709 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 

Aditya
