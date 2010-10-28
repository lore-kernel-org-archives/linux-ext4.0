From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [GIT PULL] ext4 update for 2.6.37
Date: Thu, 28 Oct 2010 09:50:39 +0200
Message-ID: <20101028075038.GC1580@arch.trippelsdorf.de>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 28, 2010 at 12:52:07AM -0400, Theodore Ts'o wrote:
> Hi Linus,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> or
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git upstream-merge
> 
> the merge is somewhat complex, since there's been a lot of work going on
> in parallel with discard and zeroout changes, as well as the change
> block_prepare_write/__block_write_begin.  The changes pass the xfstests
> regression test suite, using both 1k and 4k block sizes --- both before
> the upstream merge (the for_linus branch) and after doing a trial merge
> with the head of your tree as of Wednesday evening (the upstream-merge
> branch).

This misses a trivial ifdef wrapper in fs/ext4/super.c for
!CONFIG_EXT4_FS_XATTR configurations. Something like this:

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0348ce0..5f82585 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4773,9 +4773,12 @@ static int __init ext4_init_fs(void)
 	if (err)
 		goto out3;
 
+#ifdef CONFIG_EXT4_FS_XATTR
 	err = ext4_init_xattr();
+#endif
 	if (err)
 		goto out2;
+
 	err = init_inodecache();
 	if (err)
 		goto out1;
-- 
Markus
