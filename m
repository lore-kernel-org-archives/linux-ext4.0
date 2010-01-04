From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsstress-induced corruption reproduced
Date: Mon, 04 Jan 2010 17:08:55 -0600
Message-ID: <4B427507.40004@redhat.com>
References: <E1NQNIB-0006gT-1r@closure.thunk.org> <4B424BE4.3030605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0ADXI5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jan 2010 18:08:57 -0500
In-Reply-To: <4B424BE4.3030605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Theodore Ts'o wrote:
>> One of the things which has been annoying me for a while now is a
>> hard-to-reproduce xfsqa failure in test #13 (fsstress), which causes the
>> a test failure because the file system found to be inconsistent:
>>
>> Inode NNN, i_blocks is X, should be Y.
> 
> Interesting, this apparently has gotten much worse since 2.6.32.
> 
> I wrote an xfstests reproducer, and couldn't hit it on .32; hit it right
> off on 2.6.33-rc2.
> 
> Probably should find out why ;) I'll go take a look.

commit d21cd8f163ac44b15c465aab7306db931c606908
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Thu Dec 10 03:31:45 2009 +0000

    ext4: Fix potential quota deadlock

seems to be the culprit.

(unfortunately this means that the error we saw before is something
-else- to be fixed, yet)  Anyway ...

This is because we used to do this in ext4_mb_mark_diskspace_used() :

        /*
         * Now reduce the dirty block count also. Should not go negative
         */
        if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
                /* release all the reserved blocks if non delalloc */
                percpu_counter_sub(&sbi->s_dirtyblocks_counter,
reserv_blks);
        else {
                percpu_counter_sub(&sbi->s_dirtyblocks_counter,
                                                ac->ac_b_ex.fe_len);
                /* convert reserved quota blocks to real quota blocks */
                vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
	}

i.e. the vfs_dq_claim_block was conditional based on
EXT4_MB_DELALLOC_RESERVED... and the testcase did not go that way,
because we had already preallocated the blocks.

But with the above quota deadlock commit it's not unconditional
anymore in ext4_da_update_reserve_space and we always call
vfs_dq_claim_block which over-accounts.

Of course with the above commit, we have no allocation context in
ext4_da_update_reserve_space... that's all long gone so we can't key
on that anymore.

However, I think the following change will fix it; I'll run it through
xfstests later on and be sure nothing else regresses.

-Eric

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5352db1..28cd8d8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1257,9 +1257,10 @@ int ext4_get_blocks(handle_t *handle, struct
inode *inode, sector_t block,
         * if the caller is from delayed allocation writeout path
         * we have already reserved fs blocks for allocation
         * let the underlying get_block() function know to
-        * avoid double accounting
+        * avoid double accounting.  Ditto for prealloc blocks.
         */
-       if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
+       if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ||
+           flags & EXT4_GET_BLOCKS_UNINIT_EXT)
                EXT4_I(inode)->i_delalloc_reserved_flag = 1;
        /*
         * We need to check for EXT4 here because migrate

-Eric

> -Eric
> 
>> I finally reproduced it; the problem happens when we fallocate() a
>> region of the file which we had recently written, and which is still in
>> the page cache marked as delayed allocation blocks.  When we finally
>> write those blocks out, since they are marked BH_Delay,
>> ext4_get_blocks() calls ext4_da_update_reserve_space(), which ends up
>> bumping i_blocks a second time and charging the blocks against the
>> user's quota a second time.  Oops.
>>
>> Fortunately the fsck problem is one that will be fixed with a preen (and
>> if quota is enabled, a quotacheck), so it's not super serious, but we
>> should fix it when we have a chance.  If anyone has time to look at it,
>> please let me know.  Otherwise, I'll put it on my todo list.  I don't
>> consider seriously urgent since the case is highly unlikely to occur in
>> real life, and it doesn't have any security implications; the worst an
>> attacker could do is end up charging excesss quota to herself.
>>
>> I've included a simple reproduction case below; if you run this program,
>> it will create a file "test-file" in the current working directory which
>> will appear to be 32k, even though it is really only 16k long, and if
>> you then unmount the test file system and run e2fsck -p on it, you will get
>> the error message:
>>
>> Inode XXX, i_blocks is 64, should be 32.  FIXED.
>>
>> 	       	     	    	     	     - Ted
>>
>> #define _GNU_SOURCE
>>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #include <string.h>
>> #include <sys/types.h>
>> #include <fcntl.h>
>> #include <fcntl.h>
>>
>> #define BUFSIZE 1024
>>
>> int main(int argc, char **argv)
>> {
>> 	int	i, fd, ret;
>> 	char	buf[BUFSIZE];
>>
>> 	fd = open("test-file", O_RDWR|O_CREAT|O_TRUNC, 0644);
>> 	if (fd < 0) {
>> 		perror("open");
>> 		exit(1);
>> 	}
>> 	memset(&buf, 0, BUFSIZE);
>> 	for (i=0; i < 16; i++) {
>> 		ret = write(fd, &buf, BUFSIZE);
>> 		if (ret < 0) {
>> 			perror("write");
>> 			exit(1);
>> 		}
>> 		if (ret != BUFSIZE) {
>> 			fprintf(stderr, "Write return expected %d, got %d\n",
>> 				BUFSIZE, ret);
>> 			exit(1);
>> 		}
>> 	}
>> 	ret = fallocate(fd, 0, 0, 16384);
>> 	if (ret < 0) {
>> 		perror("fallocate");
>> 		exit(1);
>> 	}
>> 	ret = fsync(fd);
>> 	if (ret < 0) {
>> 		perror("fsync");
>> 		exit(1);
>> 	}
>> 	ret = close(fd);
>> 	if (ret < 0) {
>> 		perror("close");
>> 		exit(1);
>> 	}
>> 	exit(0);
>> }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

