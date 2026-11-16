Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794858161;
	b=wrVwP3SbDLTuHlXDCrxJi++iEDARACJENC/8nEEkrAq/1/Er3RBj0yr5SR+MgM10BCsl
	 kwiK9mRl3pdTiu7+2LjL6saVyO/DbHYLAszWraakJy4NNvi9aEutDzE3DF2lzZBg7uIsF
	 /5i5uunfMFmjqkmLTsgndGiI8ihDiqGS5N5HFlWE5Fb6/DN4TI6nrJXXxy/ehUAhEuvd9
	 IN5P4Qw4FacQDUPMgP5WaxCjfSGyqA3GMROLS60jBbyLtdj3bkcfP4KHy6wKBa4pfM+7X
	 wmriDyqg6j7SCE0YFOnUEe7rlH+/Odu6uU7IJoSZsicrNLd/Iu3kWsvnthGxIcAoUiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794858161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type;
	bh=A+Yr2XORKrMlfKOwOgAS3OinaLOonWQV/X+ZaYguV9k=;
	b=UK8isAjj1BOnvjOyCMOjDCevGi0512bQkPt831TwZRjpqIxFD39S4FAWb+4oBkAacsus
	 NCDghbpzJQPEzgDVCCzlmKuw79puMwapuNUi5p9K3ty+m2TBesRU2HYV+TQNLiLuT0pez
	 RV+n7qifVSAt+cLkDJJHBhmQAQb2EEnVxR8kG9XUV3lvvucXxBNmhDVikvSq7yA5l4c0R
	 tWC95INLqQUOmnpncKiB/4ZFmEKB8XcfUCOq9NAReFoWRjtZ+wubLnkgBxKmVcAGzpMi/
	 dyJjsq79UF/WYjwn25gije4IpT2qEaiPmO1Z7k/pAW1sDOH4MDkiQajyqcrr4lEZSRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p7lDgriX;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957FE606A33B
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 19:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 957FE606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p7lDgriX
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b3af93b85cso35033a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 11:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794858160; x=1795462960; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A+Yr2XORKrMlfKOwOgAS3OinaLOonWQV/X+ZaYguV9k=;
        b=p7lDgriXQTz9QWmlH5TRq2lbd9C0FZpgWz3xMBFPxk85Je0zFaLsg2yJud9hx+jQng
         GTU9YHAs24J3nt8B5z1xz8Rw9cAMgNEptHldF5Qi7Su3htmgFvegiwtZpC8qGwJhZO6s
         a93r4rQpydjWjZVxyn52wASUNFM/TCsWlVe8bEVZPk/XCv4aWfjE67wLjMStaIwJquuM
         56SrHOSZB4LS272MxTtX9+oKMLd4KPeQHC9784Hea+0Nx/CLzG9l3LCIkQgDxCCGmGyQ
         Br/WZLU0MTnNmOq0eraNtbjJ1MdtDnMuG2O+58eU7iZi/u2anwO2RAnXI7hqrELIE3DW
         bTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858160; x=1795462960;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=A+Yr2XORKrMlfKOwOgAS3OinaLOonWQV/X+ZaYguV9k=;
        b=f4drV67zhyzVAelQVlWtRWW0IHOon2sD/zQqyssydhPwvDuAzZqM78ApZNcJqAiXjh
         xZfl6jJs0nGv+r1jqrdNIfF5NPYRonUSJ+6OtSUTfH3MUZc3CeslDf5NqNTAF1n5sb2t
         2rn5+GMcgIZJyrdbktK1VFaQ+WMerIzsK1Hofd03R877Px2RpIp3aHOhI0okOMCtM7zg
         StfxDwHiOcUla8JhlL8iFqWT4PLKJ/1qrHtCF1RLkfylwfQwoglv+6TvBIXWgoBBElDr
         7KObuo2xIAVeu6Yw1DB+z66Bi0mc2fVA4VySuPuzxonveBe+c1A3uarrYeaJMzLrZw/I
         +7xg==
X-Forwarded-Encrypted: i=1; AL+hErFL1ITR6gZOF7oSb+LAp228697FLecu1gV6AwpnYZ88kL2HZYmVySIC25L/XpH8ETEtJprWUZX7VFSQ@vger.kernel.org
X-Gm-Message-State: APuU4Z8J9BIfAaFMIMPAZdt0NZ0Okg+alQXZRghPIN/vsYy5FGu6Y9iK
	tWWG3JCHBdx7pENDwzmx5vgLKWJPplF0cjNfWOHY5cU6iWALk5jA7wjG
X-Gm-Gg: AZFdTZeO6DJlOV4h4UCRBXt0mP8XN6eYmMWxF2zXdsaIB5iMlOfBfQ7MgtKE+TKqCkr
	rM8YPZRAtu+Sl/WLmRKM5b3Mup1PMH4Uiz8LTy3hX9RZ88wzvF85Gr6aZZzO768RUTxNwiGvqZ3
	Vxrqm2R7GCybQc5Ou89nz9V6GEc01s7zvfUgT+tSe2tRwhMxPvPC9CZR15CcnnJdYn/wf8SfMRO
	LVX8atG3vtwtt5ihv8nrKr5+ghjx1NNJQfdjyU2XEt+SHqzzzbSTmjYHz0Qjvt7Z+m1HXk/Cs4m
	wykuvxg3flJRglfRUAF4TpUZ2SFuAoF/WccM0HHtPhIYnZuQsVY6EkrXG5zPWRxXNxhoMR/XdXI
	wKzjpDKtfpfYDI1TUNmn7DpiKyZk3EqjrTaV4CyIygBO/cn9TrS6OkMcn/2UakQZlWjyeqxWyn+
	2rCpv4XtMhVq0cH+WTPjM4XZ6WOUdUVfQbdbZpLy3xyiteSuTznvKO7CNA8vT5y65tr/Pci7r0C
	ejKO6DSdICBAfqgBI1LTQ3eHMywQncUwuzhF/z1MBzcI5NwOF43fr86CnLjVVVVz1hsils=
X-Received: by 2002:a17:90b:3b82:b0:3b0:e388:d9da with SMTP id 98e67ed59e1d1-3b1b0a46733mr12274238a91.29.1794858159668;
        Mon, 16 Nov 2026 11:42:39 -0800 (PST)
Received: from [172.21.0.2] (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abd063e8sm576431a91.8.2026.11.16.11.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 11:42:38 -0800 (PST)
Date: Mon, 16 Nov 2026 11:42:38 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [BUG] ext4: ext4_htree_fill_tree() reads '..' outside the dx root
 block when '.' has a bad rec_len
Message-ID: <179485814813.2717208.11773019866458970526@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8252047072062630808=="

--===============8252047072062630808==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Ted, Andreas,

While testing v7.4-rc3 with an LLM-guided test generator that we are
developing as a research prototype, we found that getdents64() on an
htree directory whose dx root '.' entry has a corrupted rec_len makes
ext4_htree_fill_tree() read the '..' entry from far outside the
directory block:

  BUG: KASAN: slab-use-after-free in ext4_htree_fill_tree+0xad8/0xb50
  Read of size 1 at addr ff11000013189002 by task test/107
  Call Trace:
   <TASK>
   ext4_htree_fill_tree+0xad8/0xb50
   ext4_readdir+0x18de/0x2e00
   iterate_dir+0x1b7/0x640
   __x64_sys_getdents64+0x128/0x230
   do_syscall_64+0x116/0x630
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  The buggy address belongs to the object at ff11000013189000
   which belongs to the cache names_cache of size 192

Other runs reported slab-out-of-bounds reads in ext4_htree_fill_tree()
and in ext4_htree_store_dirent(), when it copies the name. The object
KASAN names is unrelated memory that happens to lie where the read
lands.

ext4_htree_fill_tree() emits '.' and '..' from the htree root block
without validating them:

	de = (struct ext4_dir_entry_2 *) frames[0].bh->b_data;
	de = ext4_next_entry(de, dir->i_sb->s_blocksize);
	tmp_str.name = de->name;
	tmp_str.len = de->name_len;
	err = ext4_htree_store_dirent(dir_file, 2, 0, de, &tmp_str);

dx_probe() checks the dx_root_info fields but not the '.' entry, so with
a '.' rec_len of 65532 on a 4 KiB block, '..' is taken from 64 KiB past
the block. The linear readdir path rejects the same block ("bad entry in
directory: directory entry overrun - offset=0, inode=12, rec_len=65532,
size=4096").

Rejecting the dx root in dx_probe() when the '.' rec_len is not
ext4_dir_rec_len(1, NULL), which is what the dx_root layout assumes,
makes the problem go away here: the reproducer ran three times without a
report, dx_probe() reports the corrupt directory, and readdir falls back
to the linear path, which reports the bad entry. Checking '..' with
ext4_check_dir_entry() before using it would be another way.

The reproducer needs root, since it mounts an image. It takes a 32 MiB
image made with "mkfs.ext4 -q -F", clears the metadata_csum feature so
the dx root checksums are not checked, and creates htree directories.
Then it sets the '.' rec_len of their dx root blocks to large values,
remounts, and calls getdents64() on each directory. On an x86_64 QEMU
guest with 2 vCPUs and KASAN (gcc 13.3, config attached), it triggers in
every run (4 of 4).

Checked against v7.4-rc3 (aebb72744764). We found no earlier report on
syzbot or on linux-ext4; the closest is the report of 2026-11-10 about
the hash trailer in ext4_inlinedir_to_tree(), which is a different path.

The reproducer (repro.c) and the kernel config are attached.

Thanks,
Kyuwon Cho

--===============8252047072062630808==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="repro.c"
MIME-Version: 1.0

// Reproducer for the ext4_htree_fill_tree '..' dot-dotdot sibling of bc4b7b0414c3.
//
// The dx root block's '.' entry has rec_len 12 and '..' follows at b_data + rec_len('.').
// ext4_htree_fill_tree reads '..' with no ext4_check_dir_entry and no bounds check. This program
// makes the on-disk '.' rec_len of several htree directories large (0xFFFC, so '..' starts at
// block offset 65532, far past a 1 KiB or 4 KiB block) and then calls getdents64 on each one.
// The first getdents reads inode/name_len/name at that offset, outside the buffer_head data.
//
// Steps (syscalls and loop ioctls only):
//  1. copy the image (argv[1], default /files/e4.img; make it with
//     "truncate -s 32M e4.img && mkfs.ext4 -q -F e4.img") to /tmp, clear the metadata_csum ro_compat bit so the
//     dx root checksum is not verified, and attach it to a loop device;
//  2. mount ext4, create NDIRS htree directories with NFILES entries each;
//  3. umount, find each directory's dx root by its '.' entry (inode, rec_len 12, name "."),
//     and patch rec_len;
//  4. remount and getdents64 each directory.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/sysmacros.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#define LOOP_SET_FD 0x4C00
#define LOOP_CLR_FD 0x4C01
#define IMG "/tmp/e4.img"
#define MNT "/tmp/mnt"
#define NDIRS 6
#define NFILES 150
#define SB_FEATURE_RO_COMPAT (1024 + 0x64)
#define RO_COMPAT_METADATA_CSUM 0x0400

static const char *image;

static const uint16_t offs[NDIRS] = {65532, 61440, 49152, 40960, 32768, 20480};
static char loopdev[64] = "/dev/loop0";

static void die(const char *m)
{
	printf("repro: %s: %s\n", m, strerror(errno));
	fflush(stdout);
	exit(1);
}

static void setup_loopdev(void)
{
	struct stat st;

	if (stat("/dev/loop0", &st) == 0)
		return;
	if (mknod("/tmp/loop0", S_IFBLK | 0600, makedev(7, 0)) != 0)
		die("mknod loop0");
	strcpy(loopdev, "/tmp/loop0");
}

static int attach(int imgfd)
{
	int lfd = open(loopdev, O_RDWR);

	if (lfd < 0)
		die("open loop");
	if (ioctl(lfd, LOOP_SET_FD, imgfd) != 0)
		die("LOOP_SET_FD");
	return lfd;
}

static void detach(int lfd)
{
	ioctl(lfd, LOOP_CLR_FD, 0);
	close(lfd);
}

static void copy_image(void)
{
	int src = open(image, O_RDONLY), dst;
	char buf[65536];
	ssize_t n;

	if (src < 0)
		die("open image");
	dst = open(IMG, O_RDWR | O_CREAT | O_TRUNC, 0600);
	if (dst < 0)
		die("create " IMG);
	while ((n = read(src, buf, sizeof(buf))) > 0)
		if (write(dst, buf, n) != n)
			die("write image copy");
	close(src);
	close(dst);
}

static void clear_metadata_csum(void)
{
	int fd = open(IMG, O_RDWR);
	uint32_t f;

	if (fd < 0)
		die("open image rw");
	if (pread(fd, &f, 4, SB_FEATURE_RO_COMPAT) != 4)
		die("read ro_compat");
	printf("repro: ro_compat before %#x\n", f);
	f &= ~RO_COMPAT_METADATA_CSUM;
	if (pwrite(fd, &f, 4, SB_FEATURE_RO_COMPAT) != 4)
		die("write ro_compat");
	close(fd);
}

static void mount_fs(int lfd)
{
	(void)lfd;
	if (mount(loopdev, MNT, "ext4", 0, NULL) != 0)
		die("mount ext4");
}

static void create_dirs(uint32_t ino[NDIRS])
{
	char p[256], name[256];
	struct stat st;
	int d, f, fd;

	for (d = 0; d < NDIRS; d++) {
		snprintf(p, sizeof(p), MNT "/d%d", d);
		if (mkdir(p, 0755) != 0)
			die("mkdir");
		for (f = 0; f < NFILES; f++) {
			snprintf(name, sizeof(name),
				 MNT "/d%d/htree_entry_name_padding_%04d", d, f);
			fd = open(name, O_CREAT | O_WRONLY, 0644);
			if (fd < 0)
				die("create entry");
			close(fd);
		}
		if (stat(p, &st) != 0)
			die("stat dir");
		ino[d] = (uint32_t)st.st_ino;
		printf("repro: dir d%d ino %u\n", d, ino[d]);
	}
	sync();
}

static int patch_dx_roots(uint32_t ino[NDIRS])
{
	int fd = open(IMG, O_RDWR);
	off_t sz;
	uint8_t *buf;
	int d, patched = 0;
	off_t i;

	if (fd < 0)
		die("open image for patch");
	sz = lseek(fd, 0, SEEK_END);
	buf = malloc(sz);
	if (!buf || pread(fd, buf, sz, 0) != sz)
		die("read image");
	for (d = 0; d < NDIRS; d++) {
		int hits = 0;
		off_t hits_at[8];

		for (i = 0; i + 12 + 10 <= sz; i++) {
			uint8_t pat[9];

			pat[0] = ino[d] & 0xff;
			pat[1] = (ino[d] >> 8) & 0xff;
			pat[2] = (ino[d] >> 16) & 0xff;
			pat[3] = (ino[d] >> 24) & 0xff;
			pat[4] = 0x0c; pat[5] = 0x00;	/* rec_len 12 */
			pat[6] = 0x01; pat[7] = 0x02;	/* name_len 1, EXT4_FT_DIR */
			pat[8] = '.';
			if (memcmp(buf + i, pat, 9) != 0)
				continue;
			/* '..' must follow at +12 with name_len 2 */
			if (buf[i + 12 + 6] != 2 || buf[i + 12 + 8] != '.' ||
			    buf[i + 12 + 9] != '.')
				continue;
			if (hits < 8)
				hits_at[hits] = i;
			hits++;
		}
		/* The journal keeps old copies of the dx root block too; patch every copy. */
		if (hits == 0) {
			printf("repro: d%d no dx root found\n", d);
			continue;
		}
		{
			uint16_t v = offs[d];
			int k;

			for (k = 0; k < hits && k < 8; k++) {
				if (pwrite(fd, &v, 2, hits_at[k] + 4) != 2)
					die("patch rec_len");
				printf("repro: d%d dx root copy %d at image byte %lld, '.' rec_len -> %u\n",
				       d, k, (long long)hits_at[k], offs[d]);
			}
			patched++;
		}
	}
	free(buf);
	fsync(fd);
	close(fd);
	return patched;
}

static void getdents_all(void)
{
	char name[256], buf[32768];
	int d;

	for (d = 0; d < NDIRS; d++) {
		int fd;
		long n;

		snprintf(name, sizeof(name), MNT "/d%d", d);
		fd = open(name, O_RDONLY | O_DIRECTORY);
		if (fd < 0)
			die("open dir");
		printf("repro: getdents d%d\n", d);
		fflush(stdout);
		n = syscall(SYS_getdents64, fd, buf, sizeof(buf));
		printf("repro: getdents d%d returned %ld\n", d, n);
		fflush(stdout);
		close(fd);
	}
}

int main(int argc, char **argv)
{
	image = argc > 1 ? argv[1] : "/files/e4.img";
	uint32_t ino[NDIRS];
	int imgfd, lfd, patched;

	mkdir("/tmp", 0777);
	setup_loopdev();
	copy_image();
	clear_metadata_csum();

	imgfd = open(IMG, O_RDWR);
	if (imgfd < 0)
		die("open image");
	lfd = attach(imgfd);
	if (mkdir(MNT, 0755) != 0 && errno != EEXIST)
		die("mkdir mnt");
	mount_fs(lfd);
	create_dirs(ino);
	if (umount2(MNT, 0) != 0)
		die("umount");
	detach(lfd);
	close(imgfd);

	patched = patch_dx_roots(ino);
	printf("repro: patched %d dx roots\n", patched);
	fflush(stdout);

	imgfd = open(IMG, O_RDWR);
	if (imgfd < 0)
		die("reopen image");
	lfd = attach(imgfd);
	mount_fs(lfd);
	getdents_all();
	umount2(MNT, 0);
	detach(lfd);
	close(imgfd);
	printf("repro: done\n");
	return 0;
}

--===============8252047072062630808==
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="config.gz"
MIME-Version: 1.0

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

--===============8252047072062630808==--
