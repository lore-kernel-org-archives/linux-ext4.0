From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mk2fs lazy_journal_init option
Date: Tue, 16 Feb 2010 17:11:21 -0600
Message-ID: <4B7B2619.8060106@redhat.com>
References: <13A447AA-31C7-4E02-8752-DFF75EA31C2E@sun.com> <7095A240-FB57-4C33-8EE8-33D88B500319@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <ihara@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114Ab0BPXLZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 18:11:25 -0500
In-Reply-To: <7095A240-FB57-4C33-8EE8-33D88B500319@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-02-10, at 04:44, Andreas Dilger wrote:
>> Attached is a patch to skip zeroing of the journal if the
>> "-E lazy_journal_init" option is given to mke2fs (named to
>> complement the "-E lazy_itable_init" option).  This can
>> speed up format time significantly for large journal devices.
>> There's only a short-term risk of problems with uninitialized
>> journal, until the journal has been overwritten once.
>>
>> Patch has been lightly tested, showing mke2fs times steady
>> at 14s for a 40GB filesystem, regardless of journal size,
>> while previously it took up to 45s for an internal 2GB journal.
> 
> While testing this patch more thoroughly, we uncovered a bug
> in the mke2fs/libext2fs code.  It seems that when running:
> 
> mke2fs -J size=X -O extents /dev/XXX
> 
> for any size > 512 the journal creation time is growing
> exponentially:
> 
> no journal-> 12s
> size=128 ->  14s
> size=256 ->  16s
> size=512 ->  21s
> size=768 -> 143s
> size=1024-> 298s
> size=1280-> 663s
> 
> We wanted originally to use size=4000, but this took so
> long we thought it was hung, and started investigating.
> 
> This happens even without the "-E lazy_itable_init" option.
> Running ltrace on mke2fs shows lots of zero writes (to be
> expected for journal zeroing) followed by a single read
> (completes quickly) and many thousands of memcpy() calls.
> The mke2fs program is completely CPU bound (99.9% user).
> 
> Running with the "-E lazy_itable_init" the writes/reads go
> away, and all that is left is an endless stream of memcpy().
> 
> It seems to loop in ext2fs_block_iterate2->mkjournal_proc()
> forever:
> 
> 426            for (blockcnt = extent.e_lblk, j = 0;
> 427                 j < extent.e_len;
> 428                 blk++, blockcnt++, j++) {
> 429                    new_blk = blk;
> 430                    r = (*ctx.func)(fs, &new_blk, blockcnt,
> 431                                    0, 0, priv_data);
> 

Haven't dug all the way through it but I think this is another
in the saga of blk_t vs. blk64_t.  This seems to fix (?) it:

--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -218,7 +218,7 @@ struct mkjournal_struct {
 };

 static int mkjournal_proc(ext2_filsys  fs,
-                          blk_t        *blocknr,
+                          blk64_t      *blocknr,
                           e2_blkcnt_t  blockcnt,
                           blk_t        ref_block EXT2FS_ATTR((unused)),
                           int          ref_offset EXT2FS_ATTR((unused)),

though I doubt that is correct/complete.

-Eric
