From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Date: Thu, 02 Apr 2009 17:18:39 +0200
Message-ID: <49D4D74F.1020904@ph.tum.de>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com> <20090401225351.GA22621@orion> <20090402055356.GC10642@mit.edu> <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com> <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com> <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com> <49D4BDF2.2070102@ph.tum.de> <20090402145436.GF10642@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:53095 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbZDBPSn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2009 11:18:43 -0400
In-Reply-To: <20090402145436.GF10642@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Apr 02, 2009 at 03:30:26PM +0200, Thiemo Nagel wrote:
>> When I added the block range checks, initially I was assuming that
>> when EXTENTS_FL is not set, the inode->i_data *always* contains
>> references to further blocks.  Ted showed me wrong and added the condition
>>
>> 	ISREG() || ISDIR() || ( ISLNK() && !is_fast_symlink() )
>>
>> before that assumption can be made.  But maybe we need some further
>> restraints?
> 
> It's a endian-problem; we're missing le32_to_cpu() in that patch.
> Sparc is big-endian. 

Sorry for that.

Thiemo

---
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 98e289a..ec3555d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -377,11 +377,11 @@ static int __ext4_check_blockref(const char 
*function, struct inode *inode,
         unsigned int maxblocks = 
ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es);
         unsigned int *bref = p;
         while (bref < p+max) {
-               if (unlikely(*bref >= maxblocks)) {
+               if (unlikely(le32_to_cpu(*bref) >= maxblocks)) {
                         ext4_error(inode->i_sb, function,
                                    "block reference %u >= max (%u) "
                                    "in inode #%lu, offset=%d",
-                                  *bref, maxblocks,
+                                  le32_to_cpu(*bref), maxblocks,
                                    inode->i_ino, (int)(bref-p));
                         return -EIO;
                 }
