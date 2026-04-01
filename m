Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749D344D85;
	Wed,  1 Apr 2026 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775081331; cv=none; b=G/6XnhvwCi6xqmGBsHMXvmHq3rbsstXZeD8EnEEm6Ay/gqbzYk/YpfwIQP/2RWZxTrh6yTFzf8uVFEVCObUpEuFz3i7qOdVlqdazyaJQ0M32miyX+dgcaXcCyn/1CLDkmuRa9kMmqUfbHmZPvduUrz/LYMv0NFyCd4ccXnHixYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775081331; c=relaxed/simple;
	bh=zwPY88dG0zvoXZ6euWOlBqEbGJHP7i0uE9pDhYWhB8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nATTDRuL60M65MSQUgsa147nE7uBv5g1WosM9WPxUcMwNBNzYsArTB7Rsmg/Lj1BOUHBsCR5yzALfgwSpicUnLZdrcFEo/K73+Oodhun4Zfum+JHxWZyA/ob8Z4Pnv+jfIzYltZCra5sxfs+kaTZPm8o0CPFl3oL909+Ae1CuWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 3FC55233AB;
	Thu,  2 Apr 2026 01:08:38 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@osdl.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH 0/2] ext2: fix WARN_ON in drop_nlink() triggered by corrupt images
Date: Thu,  2 Apr 2026 01:08:35 +0300
Message-Id: <20260401220837.2424925-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

A crafted ext2 image can contain a directory entry pointing to an inode
whose on-disk i_links_count is zero. ext2 mounts such an image without
error. Any subsequent syscall that decrements i_nlink on that inode
triggers WARN_ON inside drop_nlink() in fs/inode.c.

These patches prevent the warning by validating i_nlink before decrementing
it in ext2_unlink() and ext2_rename(), reporting the corruption via
ext2_error() instead.

The issues were found by Linux Verification Center (linuxtesting.org)
with Syzkaller.

Vasiliy Kovalev (2):
  ext2: validate i_nlink before decrement in ext2_unlink()
  ext2: guard against zero i_nlink on new_inode in ext2_rename()

 fs/ext2/namei.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- [Reproducer for PATCH 1/2: ext2_unlink] ---

#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/loop.h>

#ifndef __NR_memfd_create
#define __NR_memfd_create 319
#endif

static unsigned long long procid;

static void sleep_ms(uint64_t ms)
{
	usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
	struct timespec ts;
	if (clock_gettime(CLOCK_MONOTONIC, &ts))
	exit(1);
	return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static void use_temporary_dir(void)
{
	char tmpdir_template[] =3D "./syzkaller.XXXXXX";
	char* tmpdir =3D mkdtemp(tmpdir_template);
	if (!tmpdir)
	exit(1);
	if (chmod(tmpdir, 0777))
	exit(1);
	if (chdir(tmpdir))
	exit(1);
}

static bool write_file(const char* file, const char* what, ...)
{
	char buf[1024];
	va_list args;
	va_start(args, what);
	vsnprintf(buf, sizeof(buf), what, args);
	va_end(args);
	buf[sizeof(buf) - 1] =3D 0;
	int len =3D strlen(buf);
	int fd =3D open(file, O_WRONLY | O_CLOEXEC);
	if (fd =3D=3D -1)
		return false;
	if (write(fd, buf, len) !=3D len) {
		int err =3D errno;
		close(fd);
		errno =3D err;
		return false;
	}
	close(fd);
	return true;
}

#define MAXBITS 15
#define MAXLCODES 286
#define MAXDCODES 30
#define MAXCODES (MAXLCODES + MAXDCODES)
#define FIXLCODES 288

struct puff_state {
	unsigned char* out;
	unsigned long outlen;
	unsigned long outcnt;
	const unsigned char* in;
	unsigned long inlen;
	unsigned long incnt;
	int bitbuf;
	int bitcnt;
	jmp_buf env;
};
static int puff_bits(struct puff_state* s, int need)
{
	long val =3D s->bitbuf;
	while (s->bitcnt < need) {
		if (s->incnt =3D=3D s->inlen)
			longjmp(s->env, 1);
		val |=3D (long)(s->in[s->incnt++]) << s->bitcnt;
		s->bitcnt +=3D 8;
	}
	s->bitbuf =3D (int)(val >> need);
	s->bitcnt -=3D need;
	return (int)(val & ((1L << need) - 1));
}
static int puff_stored(struct puff_state* s)
{
	s->bitbuf =3D 0;
	s->bitcnt =3D 0;
	if (s->incnt + 4 > s->inlen)
		return 2;
	unsigned len =3D s->in[s->incnt++];
	len |=3D s->in[s->incnt++] << 8;
	if (s->in[s->incnt++] !=3D (~len & 0xff) ||
	    s->in[s->incnt++] !=3D ((~len >> 8) & 0xff))
		return -2;
	if (s->incnt + len > s->inlen)
		return 2;
	if (s->outcnt + len > s->outlen)
		return 1;
	for (; len--; s->outcnt++, s->incnt++) {
		if (s->in[s->incnt])
			s->out[s->outcnt] =3D s->in[s->incnt];
	}
	return 0;
}
struct puff_huffman {
	short* count;
	short* symbol;
};
static int puff_decode(struct puff_state* s, const struct puff_huffman* h)
{
	int first =3D 0;
	int index =3D 0;
	int bitbuf =3D s->bitbuf;
	int left =3D s->bitcnt;
	int code =3D first =3D index =3D 0;
	int len =3D 1;
	short* next =3D h->count + 1;
	while (1) {
		while (left--) {
			code |=3D bitbuf & 1;
			bitbuf >>=3D 1;
			int count =3D *next++;
			if (code - count < first) {
				s->bitbuf =3D bitbuf;
				s->bitcnt =3D (s->bitcnt - len) & 7;
				return h->symbol[index + (code - first)];
			}
			index +=3D count;
			first +=3D count;
			first <<=3D 1;
			code <<=3D 1;
			len++;
		}
		left =3D (MAXBITS + 1) - len;
		if (left =3D=3D 0)
			break;
		if (s->incnt =3D=3D s->inlen)
			longjmp(s->env, 1);
		bitbuf =3D s->in[s->incnt++];
		if (left > 8)
			left =3D 8;
	}
	return -10;
}
static int puff_construct(struct puff_huffman* h, const short* length, int =
n)
{
	int len;
	for (len =3D 0; len <=3D MAXBITS; len++)
		h->count[len] =3D 0;
	int symbol;
	for (symbol =3D 0; symbol < n; symbol++)
		(h->count[length[symbol]])++;
	if (h->count[0] =3D=3D n)
		return 0;
	int left =3D 1;
	for (len =3D 1; len <=3D MAXBITS; len++) {
		left <<=3D 1;
		left -=3D h->count[len];
		if (left < 0)
			return left;
	}
	short offs[MAXBITS + 1];
	offs[1] =3D 0;
	for (len =3D 1; len < MAXBITS; len++)
		offs[len + 1] =3D offs[len] + h->count[len];
	for (symbol =3D 0; symbol < n; symbol++)
		if (length[symbol] !=3D 0)
			h->symbol[offs[length[symbol]]++] =3D symbol;
	return left;
}
static int puff_codes(struct puff_state* s,
		      const struct puff_huffman* lencode,
		      const struct puff_huffman* distcode)
{
	static const short lens[29] =3D {
				       3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
				       35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258};
	static const short lext[29] =3D {
				       0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
				       3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0};
	static const short dists[30] =3D {
					1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
					257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
					8193, 12289, 16385, 24577};
	static const short dext[30] =3D {
				       0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
				       7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
				       12, 12, 13, 13};
	int symbol;
	do {
		symbol =3D puff_decode(s, lencode);
		if (symbol < 0)
			return symbol;
		if (symbol < 256) {
			if (s->outcnt =3D=3D s->outlen)
				return 1;
			if (symbol)
				s->out[s->outcnt] =3D symbol;
			s->outcnt++;
		} else if (symbol > 256) {
			symbol -=3D 257;
			if (symbol >=3D 29)
				return -10;
			int len =3D lens[symbol] + puff_bits(s, lext[symbol]);
			symbol =3D puff_decode(s, distcode);
			if (symbol < 0)
				return symbol;
			unsigned dist =3D dists[symbol] + puff_bits(s, dext[symbol]);
			if (dist > s->outcnt)
				return -11;
			if (s->outcnt + len > s->outlen)
				return 1;
			while (len--) {
				if (dist <=3D s->outcnt && s->out[s->outcnt - dist])
					s->out[s->outcnt] =3D s->out[s->outcnt - dist];
				s->outcnt++;
			}
		}
	} while (symbol !=3D 256);
	return 0;
}
static int puff_fixed(struct puff_state* s)
{
	static int virgin =3D 1;
	static short lencnt[MAXBITS + 1], lensym[FIXLCODES];
	static short distcnt[MAXBITS + 1], distsym[MAXDCODES];
	static struct puff_huffman lencode, distcode;
	if (virgin) {
		lencode.count =3D lencnt;
		lencode.symbol =3D lensym;
		distcode.count =3D distcnt;
		distcode.symbol =3D distsym;
		short lengths[FIXLCODES];
		int symbol;
		for (symbol =3D 0; symbol < 144; symbol++)
			lengths[symbol] =3D 8;
		for (; symbol < 256; symbol++)
			lengths[symbol] =3D 9;
		for (; symbol < 280; symbol++)
			lengths[symbol] =3D 7;
		for (; symbol < FIXLCODES; symbol++)
			lengths[symbol] =3D 8;
		puff_construct(&lencode, lengths, FIXLCODES);
		for (symbol =3D 0; symbol < MAXDCODES; symbol++)
			lengths[symbol] =3D 5;
		puff_construct(&distcode, lengths, MAXDCODES);
		virgin =3D 0;
	}
	return puff_codes(s, &lencode, &distcode);
}
static int puff_dynamic(struct puff_state* s)
{
	static const short order[19] =3D
	    {16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15};
	int nlen =3D puff_bits(s, 5) + 257;
	int ndist =3D puff_bits(s, 5) + 1;
	int ncode =3D puff_bits(s, 4) + 4;
	if (nlen > MAXLCODES || ndist > MAXDCODES)
		return -3;
	short lengths[MAXCODES];
	int index;
	for (index =3D 0; index < ncode; index++)
		lengths[order[index]] =3D puff_bits(s, 3);
	for (; index < 19; index++)
		lengths[order[index]] =3D 0;
	short lencnt[MAXBITS + 1], lensym[MAXLCODES];
	struct puff_huffman lencode =3D {lencnt, lensym};
	int err =3D puff_construct(&lencode, lengths, 19);
	if (err !=3D 0)
		return -4;
	index =3D 0;
	while (index < nlen + ndist) {
		int symbol;
		int len;
		symbol =3D puff_decode(s, &lencode);
		if (symbol < 0)
			return symbol;
		if (symbol < 16)
			lengths[index++] =3D symbol;
		else {
			len =3D 0;
			if (symbol =3D=3D 16) {
				if (index =3D=3D 0)
					return -5;
				len =3D lengths[index - 1];
				symbol =3D 3 + puff_bits(s, 2);
			} else if (symbol =3D=3D 17)
				symbol =3D 3 + puff_bits(s, 3);
			else
				symbol =3D 11 + puff_bits(s, 7);
			if (index + symbol > nlen + ndist)
				return -6;
			while (symbol--)
				lengths[index++] =3D len;
		}
	}
	if (lengths[256] =3D=3D 0)
		return -9;
	err =3D puff_construct(&lencode, lengths, nlen);
	if (err && (err < 0 || nlen !=3D lencode.count[0] + lencode.count[1]))
		return -7;
	short distcnt[MAXBITS + 1], distsym[MAXDCODES];
	struct puff_huffman distcode =3D {distcnt, distsym};
	err =3D puff_construct(&distcode, lengths + nlen, ndist);
	if (err && (err < 0 || ndist !=3D distcode.count[0] + distcode.count[1]))
		return -8;
	return puff_codes(s, &lencode, &distcode);
}
static int puff(
    unsigned char* dest,
    unsigned long* destlen,
    const unsigned char* source,
    unsigned long sourcelen)
{
	struct puff_state s =3D {
	    .out =3D dest,
	    .outlen =3D *destlen,
	    .outcnt =3D 0,
	    .in =3D source,
	    .inlen =3D sourcelen,
	    .incnt =3D 0,
	    .bitbuf =3D 0,
	    .bitcnt =3D 0,
	};
	int err;
	if (setjmp(s.env) !=3D 0)
		err =3D 2;
	else {
		int last;
		do {
			last =3D puff_bits(&s, 1);
			int type =3D puff_bits(&s, 2);
			err =3D type =3D=3D 0 ? puff_stored(&s) : (type =3D=3D 1 ? puff_fixed(&s=
) : (type =3D=3D 2 ? puff_dynamic(&s) : -1));
			if (err !=3D 0)
				break;
		} while (!last);
	}
	*destlen =3D s.outcnt;
	return err;
}

#define ZLIB_HEADER_WIDTH 2

static int puff_zlib_to_file(const unsigned char* source, unsigned long sou=
rcelen, int dest_fd)
{
	if (sourcelen < ZLIB_HEADER_WIDTH)
		return 0;
	source +=3D ZLIB_HEADER_WIDTH;
	sourcelen -=3D ZLIB_HEADER_WIDTH;
	const unsigned long max_destlen =3D 132 << 20;
	void* ret =3D mmap(0, max_destlen, PROT_WRITE | PROT_READ, MAP_PRIVATE | M=
AP_ANON, -1, 0);
	if (ret =3D=3D MAP_FAILED)
		return -1;
	unsigned char* dest =3D (unsigned char*)ret;
	unsigned long destlen =3D max_destlen;
	int err =3D puff(dest, &destlen, source, sourcelen);
	if (err) {
		munmap(dest, max_destlen);
		errno =3D -err;
		return -1;
	}
	if (write(dest_fd, dest, destlen) !=3D (ssize_t)destlen) {
		munmap(dest, max_destlen);
		return -1;
	}
	return munmap(dest, max_destlen);
}

static int setup_loop_device(unsigned char* data, unsigned long size, const=
 char* loopname, int* loopfd_p)
{
	int err =3D 0, loopfd =3D -1;
	int memfd =3D syscall(__NR_memfd_create, "syzkaller", 0);
	if (memfd =3D=3D -1) {
		err =3D errno;
		goto error;
	}
	if (puff_zlib_to_file(data, size, memfd)) {
		err =3D errno;
		goto error_close_memfd;
	}
	loopfd =3D open(loopname, O_RDWR);
	if (loopfd =3D=3D -1) {
		err =3D errno;
		goto error_close_memfd;
	}
	if (ioctl(loopfd, LOOP_SET_FD, memfd)) {
		if (errno !=3D EBUSY) {
			err =3D errno;
			goto error_close_loop;
		}
		ioctl(loopfd, LOOP_CLR_FD, 0);
		usleep(1000);
		if (ioctl(loopfd, LOOP_SET_FD, memfd)) {
			err =3D errno;
			goto error_close_loop;
		}
	}
	close(memfd);
	*loopfd_p =3D loopfd;
	return 0;

error_close_loop:
	close(loopfd);
error_close_memfd:
	close(memfd);
error:
	errno =3D err;
	return -1;
}

static void reset_loop_device(const char* loopname)
{
	int loopfd =3D open(loopname, O_RDWR);
	if (loopfd =3D=3D -1) {
		return;
	}
	if (ioctl(loopfd, LOOP_CLR_FD, 0)) {
	}
	close(loopfd);
}

static long syz_mount_image(
    volatile long fsarg,
    volatile long dir,
    volatile long flags,
    volatile long optsarg,
    volatile long change_dir,
    volatile unsigned long size,
    volatile long image)
{
	unsigned char* data =3D (unsigned char*)image;
	int res =3D -1, err =3D 0, need_loop_device =3D !!size;
	char* mount_opts =3D (char*)optsarg;
	char* target =3D (char*)dir;
	char* fs =3D (char*)fsarg;
	char* source =3D NULL;
	char loopname[64];
	if (need_loop_device) {
		int loopfd;
		memset(loopname, 0, sizeof(loopname));
		snprintf(loopname, sizeof(loopname), "/dev/loop%llu", procid);
		if (setup_loop_device(data, size, loopname, &loopfd) =3D=3D -1)
			return -1;
		close(loopfd);
		source =3D loopname;
	}
	mkdir(target, 0777);
	char opts[256];
	memset(opts, 0, sizeof(opts));
	if (strlen(mount_opts) > (sizeof(opts) - 32)) {
	}
	strncpy(opts, mount_opts, sizeof(opts) - 32);
	if (strcmp(fs, "iso9660") =3D=3D 0) {
		flags |=3D MS_RDONLY;
	} else if (strncmp(fs, "ext", 3) =3D=3D 0) {
		bool has_remount_ro =3D false;
		char* remount_ro_start =3D strstr(opts, "errors=3Dremount-ro");
		if (remount_ro_start !=3D NULL) {
			char after =3D *(remount_ro_start + strlen("errors=3Dremount-ro"));
			char before =3D remount_ro_start =3D=3D opts ? '\0' : *(remount_ro_start=
 - 1);
			has_remount_ro =3D ((before =3D=3D '\0' || before =3D=3D ',') && (after =
=3D=3D '\0' || after =3D=3D ','));
		}
		if (strstr(opts, "errors=3Dpanic") || !has_remount_ro)
			strcat(opts, ",errors=3Dcontinue");
	} else if (strcmp(fs, "xfs") =3D=3D 0) {
		strcat(opts, ",nouuid");
	} else if (strncmp(fs, "gfs2", 4) =3D=3D 0 && (strstr(opts, "errors=3Dpani=
c") || strstr(opts, "debug"))) {
		strcat(opts, ",errors=3Dwithdraw");
	}
	res =3D mount(source, target, fs, flags, opts);
	if (res =3D=3D -1) {
		err =3D errno;
		goto error_clear_loop;
	}
	res =3D open(target, O_RDONLY | O_DIRECTORY);
	if (res =3D=3D -1) {
		err =3D errno;
		goto error_clear_loop;
	}
	if (change_dir) {
		res =3D chdir(target);
		if (res =3D=3D -1) {
			err =3D errno;
		}
	}

error_clear_loop:
	if (need_loop_device)
		reset_loop_device(loopname);
	errno =3D err;
	return res;
}

#define FS_IOC_SETFLAGS _IOW('f', 2, long)
static void remove_dir(const char* dir)
{
	int iter =3D 0;
	DIR* dp =3D 0;
	const int umount_flags =3D MNT_FORCE | UMOUNT_NOFOLLOW;

retry:
		while (umount2(dir, umount_flags) =3D=3D 0) {
		}
	dp =3D opendir(dir);
	if (dp =3D=3D NULL) {
		if (errno =3D=3D EMFILE) {
	exit(1);
		}
	exit(1);
	}
	struct dirent* ep =3D 0;
	while ((ep =3D readdir(dp))) {
		if (strcmp(ep->d_name, ".") =3D=3D 0 || strcmp(ep->d_name, "..") =3D=3D 0)
			continue;
		char filename[FILENAME_MAX];
		snprintf(filename, sizeof(filename), "%s/%s", dir, ep->d_name);
			while (umount2(filename, umount_flags) =3D=3D 0) {
			}
		struct stat st;
		if (lstat(filename, &st))
	exit(1);
		if (S_ISDIR(st.st_mode)) {
			remove_dir(filename);
			continue;
		}
		int i;
		for (i =3D 0;; i++) {
			if (unlink(filename) =3D=3D 0)
				break;
			if (errno =3D=3D EPERM) {
				int fd =3D open(filename, O_RDONLY);
				if (fd !=3D -1) {
					long flags =3D 0;
					if (ioctl(fd, FS_IOC_SETFLAGS, &flags) =3D=3D 0) {
					}
					close(fd);
					continue;
				}
			}
			if (errno =3D=3D EROFS) {
				break;
			}
			if (errno !=3D EBUSY || i > 100)
	exit(1);
				if (umount2(filename, umount_flags))
	exit(1);
		}
	}
	closedir(dp);
	for (int i =3D 0;; i++) {
		if (rmdir(dir) =3D=3D 0)
			break;
		if (i < 100) {
			if (errno =3D=3D EPERM) {
				int fd =3D open(dir, O_RDONLY);
				if (fd !=3D -1) {
					long flags =3D 0;
					if (ioctl(fd, FS_IOC_SETFLAGS, &flags) =3D=3D 0) {
					}
					close(fd);
					continue;
				}
			}
			if (errno =3D=3D EROFS) {
				break;
			}
			if (errno =3D=3D EBUSY) {
					if (umount2(dir, umount_flags))
	exit(1);
				continue;
			}
			if (errno =3D=3D ENOTEMPTY) {
				if (iter < 100) {
					iter++;
					goto retry;
				}
			}
		}
	exit(1);
	}
}

static void kill_and_wait(int pid, int* status)
{
	kill(-pid, SIGKILL);
	kill(pid, SIGKILL);
	for (int i =3D 0; i < 100; i++) {
		if (waitpid(-1, status, WNOHANG | __WALL) =3D=3D pid)
			return;
		usleep(1000);
	}
	DIR* dir =3D opendir("/sys/fs/fuse/connections");
	if (dir) {
		for (;;) {
			struct dirent* ent =3D readdir(dir);
			if (!ent)
				break;
			if (strcmp(ent->d_name, ".") =3D=3D 0 || strcmp(ent->d_name, "..") =3D=
=3D 0)
				continue;
			char abort[300];
			snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort", ent-=
>d_name);
			int fd =3D open(abort, O_WRONLY);
			if (fd =3D=3D -1) {
				continue;
			}
			if (write(fd, abort, 1) < 0) {
			}
			close(fd);
		}
		closedir(dir);
	} else {
	}
	while (waitpid(-1, status, __WALL) !=3D pid) {
	}
}

static void reset_loop()
{
	char buf[64];
	snprintf(buf, sizeof(buf), "/dev/loop%llu", procid);
	int loopfd =3D open(buf, O_RDWR);
	if (loopfd !=3D -1) {
		ioctl(loopfd, LOOP_CLR_FD, 0);
		close(loopfd);
	}
}

static void setup_test()
{
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
	setpgrp();
	write_file("/proc/self/oom_score_adj", "1000");
	if (symlink("/dev/binderfs", "./binderfs")) {
	}
}

#define USLEEP_FORKED_CHILD (3 * 50 *1000)

static long handle_clone_ret(long ret)
{
	if (ret !=3D 0) {
		return ret;
	}
	usleep(USLEEP_FORKED_CHILD);
	syscall(__NR_exit, 0);
	while (1) {
	}
}

static long syz_clone(volatile long flags, volatile long stack, volatile lo=
ng stack_len,
		      volatile long ptid, volatile long ctid, volatile long tls)
{
	long sp =3D (stack + stack_len) & ~15;
	long ret =3D (long)syscall(__NR_clone, flags & ~CLONE_VM, sp, ptid, ctid, =
tls);
	return handle_clone_ret(ret);
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
	int iter =3D 0;
	for (;; iter++) {
		char cwdbuf[32];
		sprintf(cwdbuf, "./%d", iter);
		if (mkdir(cwdbuf, 0777))
	exit(1);
		reset_loop();
		int pid =3D fork();
		if (pid < 0)
	exit(1);
		if (pid =3D=3D 0) {
			if (chdir(cwdbuf))
	exit(1);
			setup_test();
			execute_one();
			exit(0);
		}
		int status =3D 0;
		uint64_t start =3D current_time_ms();
		for (;;) {
			sleep_ms(10);
			if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) =3D=3D pid)
				break;
			if (current_time_ms() - start < 5000)
				continue;
			kill_and_wait(pid, &status);
			break;
		}
		remove_dir(cwdbuf);
	}
}

void execute_one(void)
{
		if (write(1, "executing program\n", sizeof("executing program\n") - 1)) {}
memcpy((void*)0x200000000240, "ext2\000", 5);
memcpy((void*)0x200000000440, "./file1\000", 8);
*(uint8_t*)0x200000000480 =3D 0;
memcpy((void*)0x2000000008c0, "\x78\x9c\xec\xdc\x4f\x68\x1c\x55\x18\x00\xf0=
\x6f\x66\xbb\xd5\xb6\x89\xa9\x6d\xfd\x57\x95\x16\x14\x2a\x88\xf9\xab\x98\x9=
b\x54\xef\x0a\x56\xc1\x6b\x30\x9b\xb6\x74\xdb\x48\x12\xa9\x09\xb4\xd8\xb3\x=
e2\x21\x08\x0a\x9e\xf4\xec\xa1\x37\xf1\xa6\x37\x2f\x1e\x04\x0f\x82\x17\x0f\=
x05\x41\x28\xf6\xe0\xc1\xff\x2b\xb3\x33\xb3\xa6\xe9\x6e\x68\x93\xdd\xae\x76=
\x7e\x3f\x98\xdd\xf7\x66\x66\xf9\xde\xcb\xf2\x4d\xde\x7c\x64\x12\x40\x65\x1=
d\xcd\x5e\x92\x88\x91\x88\xf8\x3e\x22\xc6\xf2\xee\xf5\x27\x1c\xcd\xdf\xd6\x=
67\x2e\x9f\xca\xb6\x24\x5a\xad\x13\x3f\x27\xed\xf3\x2e\xce\x5c\x3e\x55\x9e\=
x5a\x7e\x6e\x5f\x44\xbc\x1d\x11\x77\x47\xc4\x81\x88\xa8\x75\x89\xbb\xbc\xba=
\x76\x66\xae\xd9\x6c\x2c\x15\xfd\x89\x95\xb3\x6f\x4c\x2c\xaf\xae\x3d\x75\xf=
a\xec\xdc\xc9\xc6\xc9\xc6\xb9\xa9\x99\x67\x9f\x9e\x9c\x7d\x66\x72\x76\xb6\x=
6f\x73\xbd\xfa\xe5\xbb\xaf\xc5\x2b\x2f\x4d\xbf\x77\xe4\x87\x4f\x5e\xf8\xfc\=
xe0\x85\x6c\xbc\x23\xc5\xb1\x8d\xf3\xe8\xa7\xa4\xc7\xfe\x07\x07\x11\x6c\x88=
\xf6\x0c\x7b\x00\x6c\x4b\x96\x9b\xbb\x22\xa2\xde\xce\xff\xb1\xa8\xb5\x7b\x4=
0\x15\xb4\x5a\xad\x23\x5b\x1f\x06\xee\x5c\x89\x24\x87\x8a\x2a\x7f\xd1\x67\x=
f7\xbf\xe5\x76\x7b\x56\x1e\xb9\xab\xc7\xf3\x1b\x90\x8b\x45\x6d\x61\xbd\x13\=
x7f\x57\xa4\xc5\x39\x75\xf7\x97\xc0\x00\x7c\x91\x5d\x7f\x26\xbb\x5d\xff\xd2=
\xeb\x6a\x74\x7b\x8b\xba\xe6\x48\x44\x8c\x46\xc4\x3d\x45\xad\x74\x7f\x44\xd=
c\x5b\xd4\x39\x0f\x46\xc4\xa1\x88\xb8\xef\x16\xe2\x97\xd7\xbf\xf5\x1b\xae\x=
7f\x69\xe7\xfa\x57\x8b\x88\xfb\x77\x30\xc7\x77\x9a\xd7\xae\xf4\x8c\x7f\x69\=
x34\x0e\x77\x8d\x9f\x74\x2a\x41\x49\x76\x23\x18\x11\x0f\x6c\x33\xfe\x67\xcf=
\x5d\xf8\xaa\xd7\xb1\xd6\xc7\x11\xc7\xa2\x7b\xfc\xd8\x10\x7f\x8b\xfa\xf0\xc=
4\xc2\xe9\x66\x63\x32\x7f\xed\x1a\xe3\xf9\x57\x17\xbe\xee\x3d\xff\xfc\xbb\x=
bd\x21\xfe\x86\xa2\x75\x6d\x87\xf5\xda\x2b\x7b\x5e\x8e\xbf\xb6\x88\xff\xc4\=
x63\xdd\xbf\xff\x03\xc5\x39\xd9\xfc\xff\x8e\x88\xdf\x22\xe2\xf7\x88\xf8\x23=
\x22\xfe\x8c\x88\x87\x22\xe2\x70\x44\x3c\x1c\x11\x8f\x6c\x11\xff\xf8\x37\xd=
f\x2e\xf6\x3a\x96\xc5\x9f\xef\xf1\xf3\x4f\x37\xc4\x7f\x74\x3b\x13\x2f\x9c\x=
ff\xf1\xd3\x4b\x3b\xf8\x38\x00\xd0\x67\x69\x7b\x4d\x9b\xa4\xe3\x9d\x76\x9a\=
x8e\x8f\xe7\x6b\xdd\x43\xb1\x37\x6d\x2e\x2e\xaf\x3c\xb9\xb0\xf8\xe6\xb9\xf9=
\x7c\xed\xbb\x3f\xea\x69\xb9\xd2\xca\xd7\xbf\xf5\x24\xeb\x4f\x15\x6b\xe1\xb=
2\x3f\xbd\xa9\x3f\x53\xac\x93\xdf\xaf\xed\x69\xf7\xc7\x5f\x5f\x6c\xce\x0f\x=
7b\xf2\x50\x71\xfb\x36\xe5\xff\x2f\xb5\x3c\xff\x81\x8a\xf0\x27\x3f\x50\x5d\=
xf2\x1f\xaa\x4b\xfe\x43\x75\xc9\x7f\xa8\x2e\xf9\x0f\xd5\x25\xff\xa1\xba\xe4=
\x3f\x54\x97\xfc\x87\xea\x92\xff\x50\x5d\xf2\x1f\xaa\xeb\xe6\xf2\x7f\xf7\xc=
0\xc7\x01\xdc\x56\x23\x3d\x9e\xff\x19\xdd\xf0\xec\xce\x64\xf1\xbc\xfb\x77\x=
b5\xfa\x5d\xe5\xb3\x3e\xc0\xff\x5f\x63\xa9\xf3\x9f\x78\x37\x35\x86\x3d\x32\=
x60\xd0\xfe\x4d\xfa\x61\x8f\x04\x00\x00\x00\x00\xe8\xb7\x5e\xd5\xff\x7e\x36=
\x86\x3d\x47\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80=
\x5b\x93\xfe\x94\x44\x44\xb6\x1d\x1b\x7b\x7c\x64\xf3\xd1\xdd\xc9\xaf\xb5\xf=
6\x7b\x44\x9c\xff\xe8\xc4\x07\x6f\xcd\xad\xac\x2c\x4d\x65\xfb\xaf\x75\xf6\x=
af\x7c\x58\xec\x9f\x1e\xc6\xf8\x81\x9b\x55\xe6\x69\x99\xc7\x40\x75\x2d\xaf\=
xae\x9d\x99\x6b\x36\x1b\x4b\x1a\xfd\x68\xbc\xf8\xdf\x18\x86\xc6\x9d\xd2\xa8=
\xc7\x60\x43\xfc\x13\x00\x00\xff\xff\x52\x90\x78\x22", 999);
syz_mount_image(/*fs=3D*/0x200000000240, /*dir=3D*/0x200000000440, /*flags=
=3D*/0, /*opts=3D*/0x200000000480, /*chdir=3D*/1, /*size=3D*/0x3e7, /*img=
=3D*/0x2000000008c0);
syz_clone(/*flags=3D*/0, /*stack=3D*/0, /*stack_len=3D*/0, /*parentid=3D*/0=
, /*childtid=3D*/0, /*tls=3D*/0);

}
int main(void)
{
		syscall(__NR_mmap, /*addr=3D*/0x1ffffffff000ul, /*len=3D*/0x1000ul, /*pro=
t=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul, /*fd=3D*/=
(intptr_t)-1, /*offset=3D*/0ul);
	syscall(__NR_mmap, /*addr=3D*/0x200000000000ul, /*len=3D*/0x1000000ul, /*p=
rot=3DPROT_WRITE|PROT_READ|PROT_EXEC*/7ul, /*flags=3DMAP_FIXED|MAP_ANONYMOU=
S|MAP_PRIVATE*/0x32ul, /*fd=3D*/(intptr_t)-1, /*offset=3D*/0ul);
	syscall(__NR_mmap, /*addr=3D*/0x200001000000ul, /*len=3D*/0x1000ul, /*prot=
=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul, /*fd=3D*/(=
intptr_t)-1, /*offset=3D*/0ul);
	const char* reason;
	(void)reason;
			use_temporary_dir();
			loop();
	return 0;
}

--- [Reproducer for PATCH 2/2: ext2_rename] ---

#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/loop.h>

#ifndef __NR_memfd_create
#define __NR_memfd_create 319
#endif

static unsigned long long procid;

static void sleep_ms(uint64_t ms)
{
	usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
	struct timespec ts;
	if (clock_gettime(CLOCK_MONOTONIC, &ts))
	exit(1);
	return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static bool write_file(const char* file, const char* what, ...)
{
	char buf[1024];
	va_list args;
	va_start(args, what);
	vsnprintf(buf, sizeof(buf), what, args);
	va_end(args);
	buf[sizeof(buf) - 1] =3D 0;
	int len =3D strlen(buf);
	int fd =3D open(file, O_WRONLY | O_CLOEXEC);
	if (fd =3D=3D -1)
		return false;
	if (write(fd, buf, len) !=3D len) {
		int err =3D errno;
		close(fd);
		errno =3D err;
		return false;
	}
	close(fd);
	return true;
}

#define MAXBITS 15
#define MAXLCODES 286
#define MAXDCODES 30
#define MAXCODES (MAXLCODES + MAXDCODES)
#define FIXLCODES 288

struct puff_state {
	unsigned char* out;
	unsigned long outlen;
	unsigned long outcnt;
	const unsigned char* in;
	unsigned long inlen;
	unsigned long incnt;
	int bitbuf;
	int bitcnt;
	jmp_buf env;
};
static int puff_bits(struct puff_state* s, int need)
{
	long val =3D s->bitbuf;
	while (s->bitcnt < need) {
		if (s->incnt =3D=3D s->inlen)
			longjmp(s->env, 1);
		val |=3D (long)(s->in[s->incnt++]) << s->bitcnt;
		s->bitcnt +=3D 8;
	}
	s->bitbuf =3D (int)(val >> need);
	s->bitcnt -=3D need;
	return (int)(val & ((1L << need) - 1));
}
static int puff_stored(struct puff_state* s)
{
	s->bitbuf =3D 0;
	s->bitcnt =3D 0;
	if (s->incnt + 4 > s->inlen)
		return 2;
	unsigned len =3D s->in[s->incnt++];
	len |=3D s->in[s->incnt++] << 8;
	if (s->in[s->incnt++] !=3D (~len & 0xff) ||
	    s->in[s->incnt++] !=3D ((~len >> 8) & 0xff))
		return -2;
	if (s->incnt + len > s->inlen)
		return 2;
	if (s->outcnt + len > s->outlen)
		return 1;
	for (; len--; s->outcnt++, s->incnt++) {
		if (s->in[s->incnt])
			s->out[s->outcnt] =3D s->in[s->incnt];
	}
	return 0;
}
struct puff_huffman {
	short* count;
	short* symbol;
};
static int puff_decode(struct puff_state* s, const struct puff_huffman* h)
{
	int first =3D 0;
	int index =3D 0;
	int bitbuf =3D s->bitbuf;
	int left =3D s->bitcnt;
	int code =3D first =3D index =3D 0;
	int len =3D 1;
	short* next =3D h->count + 1;
	while (1) {
		while (left--) {
			code |=3D bitbuf & 1;
			bitbuf >>=3D 1;
			int count =3D *next++;
			if (code - count < first) {
				s->bitbuf =3D bitbuf;
				s->bitcnt =3D (s->bitcnt - len) & 7;
				return h->symbol[index + (code - first)];
			}
			index +=3D count;
			first +=3D count;
			first <<=3D 1;
			code <<=3D 1;
			len++;
		}
		left =3D (MAXBITS + 1) - len;
		if (left =3D=3D 0)
			break;
		if (s->incnt =3D=3D s->inlen)
			longjmp(s->env, 1);
		bitbuf =3D s->in[s->incnt++];
		if (left > 8)
			left =3D 8;
	}
	return -10;
}
static int puff_construct(struct puff_huffman* h, const short* length, int =
n)
{
	int len;
	for (len =3D 0; len <=3D MAXBITS; len++)
		h->count[len] =3D 0;
	int symbol;
	for (symbol =3D 0; symbol < n; symbol++)
		(h->count[length[symbol]])++;
	if (h->count[0] =3D=3D n)
		return 0;
	int left =3D 1;
	for (len =3D 1; len <=3D MAXBITS; len++) {
		left <<=3D 1;
		left -=3D h->count[len];
		if (left < 0)
			return left;
	}
	short offs[MAXBITS + 1];
	offs[1] =3D 0;
	for (len =3D 1; len < MAXBITS; len++)
		offs[len + 1] =3D offs[len] + h->count[len];
	for (symbol =3D 0; symbol < n; symbol++)
		if (length[symbol] !=3D 0)
			h->symbol[offs[length[symbol]]++] =3D symbol;
	return left;
}
static int puff_codes(struct puff_state* s,
		      const struct puff_huffman* lencode,
		      const struct puff_huffman* distcode)
{
	static const short lens[29] =3D {
				       3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
				       35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258};
	static const short lext[29] =3D {
				       0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
				       3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0};
	static const short dists[30] =3D {
					1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
					257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
					8193, 12289, 16385, 24577};
	static const short dext[30] =3D {
				       0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
				       7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
				       12, 12, 13, 13};
	int symbol;
	do {
		symbol =3D puff_decode(s, lencode);
		if (symbol < 0)
			return symbol;
		if (symbol < 256) {
			if (s->outcnt =3D=3D s->outlen)
				return 1;
			if (symbol)
				s->out[s->outcnt] =3D symbol;
			s->outcnt++;
		} else if (symbol > 256) {
			symbol -=3D 257;
			if (symbol >=3D 29)
				return -10;
			int len =3D lens[symbol] + puff_bits(s, lext[symbol]);
			symbol =3D puff_decode(s, distcode);
			if (symbol < 0)
				return symbol;
			unsigned dist =3D dists[symbol] + puff_bits(s, dext[symbol]);
			if (dist > s->outcnt)
				return -11;
			if (s->outcnt + len > s->outlen)
				return 1;
			while (len--) {
				if (dist <=3D s->outcnt && s->out[s->outcnt - dist])
					s->out[s->outcnt] =3D s->out[s->outcnt - dist];
				s->outcnt++;
			}
		}
	} while (symbol !=3D 256);
	return 0;
}
static int puff_fixed(struct puff_state* s)
{
	static int virgin =3D 1;
	static short lencnt[MAXBITS + 1], lensym[FIXLCODES];
	static short distcnt[MAXBITS + 1], distsym[MAXDCODES];
	static struct puff_huffman lencode, distcode;
	if (virgin) {
		lencode.count =3D lencnt;
		lencode.symbol =3D lensym;
		distcode.count =3D distcnt;
		distcode.symbol =3D distsym;
		short lengths[FIXLCODES];
		int symbol;
		for (symbol =3D 0; symbol < 144; symbol++)
			lengths[symbol] =3D 8;
		for (; symbol < 256; symbol++)
			lengths[symbol] =3D 9;
		for (; symbol < 280; symbol++)
			lengths[symbol] =3D 7;
		for (; symbol < FIXLCODES; symbol++)
			lengths[symbol] =3D 8;
		puff_construct(&lencode, lengths, FIXLCODES);
		for (symbol =3D 0; symbol < MAXDCODES; symbol++)
			lengths[symbol] =3D 5;
		puff_construct(&distcode, lengths, MAXDCODES);
		virgin =3D 0;
	}
	return puff_codes(s, &lencode, &distcode);
}
static int puff_dynamic(struct puff_state* s)
{
	static const short order[19] =3D
	    {16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15};
	int nlen =3D puff_bits(s, 5) + 257;
	int ndist =3D puff_bits(s, 5) + 1;
	int ncode =3D puff_bits(s, 4) + 4;
	if (nlen > MAXLCODES || ndist > MAXDCODES)
		return -3;
	short lengths[MAXCODES];
	int index;
	for (index =3D 0; index < ncode; index++)
		lengths[order[index]] =3D puff_bits(s, 3);
	for (; index < 19; index++)
		lengths[order[index]] =3D 0;
	short lencnt[MAXBITS + 1], lensym[MAXLCODES];
	struct puff_huffman lencode =3D {lencnt, lensym};
	int err =3D puff_construct(&lencode, lengths, 19);
	if (err !=3D 0)
		return -4;
	index =3D 0;
	while (index < nlen + ndist) {
		int symbol;
		int len;
		symbol =3D puff_decode(s, &lencode);
		if (symbol < 0)
			return symbol;
		if (symbol < 16)
			lengths[index++] =3D symbol;
		else {
			len =3D 0;
			if (symbol =3D=3D 16) {
				if (index =3D=3D 0)
					return -5;
				len =3D lengths[index - 1];
				symbol =3D 3 + puff_bits(s, 2);
			} else if (symbol =3D=3D 17)
				symbol =3D 3 + puff_bits(s, 3);
			else
				symbol =3D 11 + puff_bits(s, 7);
			if (index + symbol > nlen + ndist)
				return -6;
			while (symbol--)
				lengths[index++] =3D len;
		}
	}
	if (lengths[256] =3D=3D 0)
		return -9;
	err =3D puff_construct(&lencode, lengths, nlen);
	if (err && (err < 0 || nlen !=3D lencode.count[0] + lencode.count[1]))
		return -7;
	short distcnt[MAXBITS + 1], distsym[MAXDCODES];
	struct puff_huffman distcode =3D {distcnt, distsym};
	err =3D puff_construct(&distcode, lengths + nlen, ndist);
	if (err && (err < 0 || ndist !=3D distcode.count[0] + distcode.count[1]))
		return -8;
	return puff_codes(s, &lencode, &distcode);
}
static int puff(
    unsigned char* dest,
    unsigned long* destlen,
    const unsigned char* source,
    unsigned long sourcelen)
{
	struct puff_state s =3D {
	    .out =3D dest,
	    .outlen =3D *destlen,
	    .outcnt =3D 0,
	    .in =3D source,
	    .inlen =3D sourcelen,
	    .incnt =3D 0,
	    .bitbuf =3D 0,
	    .bitcnt =3D 0,
	};
	int err;
	if (setjmp(s.env) !=3D 0)
		err =3D 2;
	else {
		int last;
		do {
			last =3D puff_bits(&s, 1);
			int type =3D puff_bits(&s, 2);
			err =3D type =3D=3D 0 ? puff_stored(&s) : (type =3D=3D 1 ? puff_fixed(&s=
) : (type =3D=3D 2 ? puff_dynamic(&s) : -1));
			if (err !=3D 0)
				break;
		} while (!last);
	}
	*destlen =3D s.outcnt;
	return err;
}

#define ZLIB_HEADER_WIDTH 2

static int puff_zlib_to_file(const unsigned char* source, unsigned long sou=
rcelen, int dest_fd)
{
	if (sourcelen < ZLIB_HEADER_WIDTH)
		return 0;
	source +=3D ZLIB_HEADER_WIDTH;
	sourcelen -=3D ZLIB_HEADER_WIDTH;
	const unsigned long max_destlen =3D 132 << 20;
	void* ret =3D mmap(0, max_destlen, PROT_WRITE | PROT_READ, MAP_PRIVATE | M=
AP_ANON, -1, 0);
	if (ret =3D=3D MAP_FAILED)
		return -1;
	unsigned char* dest =3D (unsigned char*)ret;
	unsigned long destlen =3D max_destlen;
	int err =3D puff(dest, &destlen, source, sourcelen);
	if (err) {
		munmap(dest, max_destlen);
		errno =3D -err;
		return -1;
	}
	if (write(dest_fd, dest, destlen) !=3D (ssize_t)destlen) {
		munmap(dest, max_destlen);
		return -1;
	}
	return munmap(dest, max_destlen);
}

static int setup_loop_device(unsigned char* data, unsigned long size, const=
 char* loopname, int* loopfd_p)
{
	int err =3D 0, loopfd =3D -1;
	int memfd =3D syscall(__NR_memfd_create, "syzkaller", 0);
	if (memfd =3D=3D -1) {
		err =3D errno;
		goto error;
	}
	if (puff_zlib_to_file(data, size, memfd)) {
		err =3D errno;
		goto error_close_memfd;
	}
	loopfd =3D open(loopname, O_RDWR);
	if (loopfd =3D=3D -1) {
		err =3D errno;
		goto error_close_memfd;
	}
	if (ioctl(loopfd, LOOP_SET_FD, memfd)) {
		if (errno !=3D EBUSY) {
			err =3D errno;
			goto error_close_loop;
		}
		ioctl(loopfd, LOOP_CLR_FD, 0);
		usleep(1000);
		if (ioctl(loopfd, LOOP_SET_FD, memfd)) {
			err =3D errno;
			goto error_close_loop;
		}
	}
	close(memfd);
	*loopfd_p =3D loopfd;
	return 0;

error_close_loop:
	close(loopfd);
error_close_memfd:
	close(memfd);
error:
	errno =3D err;
	return -1;
}

static void reset_loop_device(const char* loopname)
{
	int loopfd =3D open(loopname, O_RDWR);
	if (loopfd =3D=3D -1) {
		return;
	}
	if (ioctl(loopfd, LOOP_CLR_FD, 0)) {
	}
	close(loopfd);
}

static long syz_mount_image(
    volatile long fsarg,
    volatile long dir,
    volatile long flags,
    volatile long optsarg,
    volatile long change_dir,
    volatile unsigned long size,
    volatile long image)
{
	unsigned char* data =3D (unsigned char*)image;
	int res =3D -1, err =3D 0, need_loop_device =3D !!size;
	char* mount_opts =3D (char*)optsarg;
	char* target =3D (char*)dir;
	char* fs =3D (char*)fsarg;
	char* source =3D NULL;
	char loopname[64];
	if (need_loop_device) {
		int loopfd;
		memset(loopname, 0, sizeof(loopname));
		snprintf(loopname, sizeof(loopname), "/dev/loop%llu", procid);
		if (setup_loop_device(data, size, loopname, &loopfd) =3D=3D -1)
			return -1;
		close(loopfd);
		source =3D loopname;
	}
	mkdir(target, 0777);
	char opts[256];
	memset(opts, 0, sizeof(opts));
	if (strlen(mount_opts) > (sizeof(opts) - 32)) {
	}
	strncpy(opts, mount_opts, sizeof(opts) - 32);
	if (strcmp(fs, "iso9660") =3D=3D 0) {
		flags |=3D MS_RDONLY;
	} else if (strncmp(fs, "ext", 3) =3D=3D 0) {
		bool has_remount_ro =3D false;
		char* remount_ro_start =3D strstr(opts, "errors=3Dremount-ro");
		if (remount_ro_start !=3D NULL) {
			char after =3D *(remount_ro_start + strlen("errors=3Dremount-ro"));
			char before =3D remount_ro_start =3D=3D opts ? '\0' : *(remount_ro_start=
 - 1);
			has_remount_ro =3D ((before =3D=3D '\0' || before =3D=3D ',') && (after =
=3D=3D '\0' || after =3D=3D ','));
		}
		if (strstr(opts, "errors=3Dpanic") || !has_remount_ro)
			strcat(opts, ",errors=3Dcontinue");
	} else if (strcmp(fs, "xfs") =3D=3D 0) {
		strcat(opts, ",nouuid");
	} else if (strncmp(fs, "gfs2", 4) =3D=3D 0 && (strstr(opts, "errors=3Dpani=
c") || strstr(opts, "debug"))) {
		strcat(opts, ",errors=3Dwithdraw");
	}
	res =3D mount(source, target, fs, flags, opts);
	if (res =3D=3D -1) {
		err =3D errno;
		goto error_clear_loop;
	}
	res =3D open(target, O_RDONLY | O_DIRECTORY);
	if (res =3D=3D -1) {
		err =3D errno;
		goto error_clear_loop;
	}
	if (change_dir) {
		res =3D chdir(target);
		if (res =3D=3D -1) {
			err =3D errno;
		}
	}

error_clear_loop:
	if (need_loop_device)
		reset_loop_device(loopname);
	errno =3D err;
	return res;
}

static void kill_and_wait(int pid, int* status)
{
	kill(-pid, SIGKILL);
	kill(pid, SIGKILL);
	for (int i =3D 0; i < 100; i++) {
		if (waitpid(-1, status, WNOHANG | __WALL) =3D=3D pid)
			return;
		usleep(1000);
	}
	DIR* dir =3D opendir("/sys/fs/fuse/connections");
	if (dir) {
		for (;;) {
			struct dirent* ent =3D readdir(dir);
			if (!ent)
				break;
			if (strcmp(ent->d_name, ".") =3D=3D 0 || strcmp(ent->d_name, "..") =3D=
=3D 0)
				continue;
			char abort[300];
			snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort", ent-=
>d_name);
			int fd =3D open(abort, O_WRONLY);
			if (fd =3D=3D -1) {
				continue;
			}
			if (write(fd, abort, 1) < 0) {
			}
			close(fd);
		}
		closedir(dir);
	} else {
	}
	while (waitpid(-1, status, __WALL) !=3D pid) {
	}
}

static void reset_loop()
{
	char buf[64];
	snprintf(buf, sizeof(buf), "/dev/loop%llu", procid);
	int loopfd =3D open(buf, O_RDWR);
	if (loopfd !=3D -1) {
		ioctl(loopfd, LOOP_CLR_FD, 0);
		close(loopfd);
	}
}

static void setup_test()
{
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
	setpgrp();
	write_file("/proc/self/oom_score_adj", "1000");
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
	int iter =3D 0;
	for (;; iter++) {
		reset_loop();
		int pid =3D fork();
		if (pid < 0)
	exit(1);
		if (pid =3D=3D 0) {
			setup_test();
			execute_one();
			exit(0);
		}
		int status =3D 0;
		uint64_t start =3D current_time_ms();
		for (;;) {
			sleep_ms(10);
			if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) =3D=3D pid)
				break;
			if (current_time_ms() - start < 5000)
				continue;
			kill_and_wait(pid, &status);
			break;
		}
	}
}

void execute_one(void)
{
		if (write(1, "executing program\n", sizeof("executing program\n") - 1)) {}
memcpy((void*)0x200000000400, "ext2\000", 5);
memcpy((void*)0x200000000440, "./file0\000", 8);
*(uint8_t*)0x200000000480 =3D 0;
memcpy((void*)0x2000000004c0, "\x78\x9c\xec\xdc\xcd\x6b\x1c\x65\x1c\x07\xf0=
\xef\xce\x36\xda\x97\xd4\xd6\xb6\xbe\x55\xa5\x05\x85\x0a\x62\x9a\x36\x8a\xb=
d\x49\xf5\x0f\x10\xac\x82\xd7\x60\xd3\x17\xba\x6d\x24\x89\xd4\x16\x5a\xec\x=
5d\x3c\x14\x41\xc1\x93\x9e\x3d\xf4\x26\xde\xf4\xe6\xc5\x83\xe0\x41\xf0\xe2\=
xa1\x20\x08\xc5\x1e\x3c\xf8\xbe\x32\xbb\xb3\xeb\x36\xee\x06\xdb\x26\x6e\xec=
\x7c\x3e\x30\xbb\xcf\x33\x33\xcb\xef\x79\x92\xfc\x26\xcf\xfc\xc8\x24\x40\x6=
d\xed\x2d\x5f\x1a\xc9\x64\x92\x6f\x93\x6c\xeb\x76\x6f\x3c\x61\x6f\xf7\xed\x=
f2\xcc\x95\x13\xe5\xd6\x48\xbb\x7d\xe4\xc7\x46\xe7\xbc\x8b\x33\x57\x4e\xf4\=
x4e\xed\x7d\x6e\x4b\x92\xb7\x92\x6c\x4c\xb2\x23\x49\x73\x48\xdc\xc5\x73\xe7=
\x4f\xcd\xb6\x5a\x73\x0b\x55\x7f\xff\xd2\xe9\xd7\xf7\x2f\x9e\x3b\xff\xd4\xc=
9\xd3\xb3\xc7\xe7\x8e\xcf\x9d\x39\x30\xf3\xec\xd3\xd3\x87\x9e\x99\x3e\x74\x=
68\xd5\xe6\x7a\xed\xf3\xb7\x5f\xcd\xcb\x2f\x1e\x7c\x67\xcf\x77\x1f\xbd\xf0\=
xe9\xce\x0b\xe5\x78\x27\xab\x63\x83\xf3\x58\x4d\x8d\x11\xfb\x1f\x5c\x8b\x60=
\x63\xb4\x69\xdc\x03\xe0\x96\x94\xb9\xb9\x21\xc9\x44\x27\xff\xb7\xa5\xd9\xe=
9\x01\x75\xd0\x6e\xb7\xf7\xac\x7c\x18\xb8\x73\x35\x24\x39\xd4\x54\xef\x17\x=
7d\x79\xff\xdb\xdb\xfe\x9b\x95\x47\xd7\xb5\xc3\xdd\x1b\x90\x8b\x55\x6d\xe1\=
x72\x3f\xfe\x86\x14\xd5\x39\x13\xee\x2f\x81\x35\xf0\x59\x79\xfd\x99\x1e\x76=
\xfd\x2b\x6e\xa8\xd1\x6d\xae\xea\x9a\x93\x49\xb6\x26\xb9\xa7\xaa\x95\x6e\x4=
f\x72\x6f\x55\xe7\xdc\x99\x64\x57\x92\xfb\x6e\x22\x7e\xef\xfa\x77\xf9\x1f\x=
d7\xbf\xa2\x7f\xfd\x6b\x26\xb9\xff\x36\xe6\x38\xd1\xba\x7e\x75\xb0\x3f\x58\=
x8f\xbd\x76\x29\xd9\x3d\x34\x7e\xa3\x5f\x09\x6a\x94\x37\x82\x49\x1e\xb8\xc5=
\xf8\x9f\x3c\x77\xe1\x8b\x51\xc7\xda\x1f\x26\xfb\x32\x3c\x7e\x06\xe2\xaf\x5=
0\x1f\xde\x7f\xec\x64\x6b\x6e\xba\xfb\x3a\x34\xc6\xf3\xaf\x1c\xfb\x72\x54\x=
fc\x72\xfe\x9b\x87\xc5\x2f\xd2\x9f\x7f\xf3\x36\xeb\xb5\x57\x37\xbd\x94\x3f\=
x56\x88\xff\xc4\x63\xc3\xbf\xff\x3b\x06\xe6\xff\x67\x92\x5f\x92\xfc\x9a\xe4=
\xb7\x24\xbf\x27\x79\x28\xc9\xee\x24\x0f\x27\x79\x64\x85\xf8\x87\xbf\xfa\x7=
a\x7e\xd4\xb1\x32\xfe\xd1\x11\x5f\xff\x62\x20\xfe\xa3\xb7\x32\xf1\xca\xd9\x=
ef\x3f\xbe\x74\x1b\x1f\x07\x00\x56\x59\xd1\x59\xd3\x36\x8a\xa9\x7e\xbb\x28\=
xa6\xa6\xba\x6b\xdd\x5d\xd9\x5c\xb4\xe6\x17\x97\x9e\x3c\x36\xff\xc6\x99\xa3=
\xdd\xb5\xef\xf6\x4c\x14\xbd\x95\x56\x77\xfd\x3b\xd1\x28\xfb\x07\xaa\xb5\x7=
0\xaf\x7f\x70\x59\x7f\xa6\x5a\x27\xbf\xdb\xdc\xd4\xe9\x4f\xbd\x36\xdf\x3a\x=
3a\xee\xc9\x43\xcd\x6d\x59\x96\xff\x3f\x35\xbb\xf9\x0f\xd4\x84\x3f\xf9\x81\=
xfa\x92\xff\x50\x5f\xf2\x1f\xea\x4b\xfe\x43\x7d\xc9\x7f\xa8\x2f\xf9\x0f\xf5=
\x25\xff\xa1\xbe\xe4\x3f\xd4\x97\xfc\x87\xfa\x92\xff\x50\x5f\xf2\x1f\x6a\x6=
9\x72\xc4\xf3\x3f\x5b\x07\x9e\xdd\x99\xae\x9e\x77\xff\xa6\x39\x71\x77\xef\x=
59\x1f\xe0\xff\x6f\x6e\xa1\xff\x9f\x78\x97\x35\xc6\x3d\x32\x60\xad\xfd\x9d\=
xf4\xe3\x1e\x09\x00\x00\x00\x00\xb0\xda\x46\x55\xff\x57\xb3\x31\xee\x39\x02=
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdc\x9c\xe2\x87=
\x46\x92\x72\xdb\xb7\xed\xf1\xc9\xe5\x47\xef\x6a\xfc\xdc\xec\xbc\x27\x39\xf=
b\xc1\x91\xf7\xde\x9c\x5d\x5a\x5a\x38\x50\xee\xbf\xde\xdf\xbf\xf4\x7e\xb5\x=
ff\xe0\x38\xc6\x0f\xfc\x5b\xbd\x3c\xed\xe5\x31\x50\x5f\x8b\xe7\xce\x9f\x9a\=
x6d\xb5\xe6\x16\xee\x9c\xc6\xc6\x24\xeb\x60\x18\x1a\xeb\xa9\xb1\xbd\xfa\x79=
\x5f\x2f\xe3\x59\x2f\x8d\xbf\x02\x00\x00\xff\xff\x87\xb5\x73\xae", 1002);
syz_mount_image(/*fs=3D*/0x200000000400, /*dir=3D*/0x200000000440, /*flags=
=3D*/0, /*opts=3D*/0x200000000480, /*chdir=3D*/1, /*size=3D*/0x3ea, /*img=
=3D*/0x2000000004c0);
memcpy((void*)0x200000000000, "./file0/file0\000", 14);
memcpy((void*)0x2000000000c0, "./file1\000", 8);
	syscall(__NR_rename, /*old=3D*/0x200000000000ul, /*new=3D*/0x2000000000c0u=
l);

}
int main(void)
{
		syscall(__NR_mmap, /*addr=3D*/0x1ffffffff000ul, /*len=3D*/0x1000ul, /*pro=
t=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul, /*fd=3D*/=
(intptr_t)-1, /*offset=3D*/0ul);
	syscall(__NR_mmap, /*addr=3D*/0x200000000000ul, /*len=3D*/0x1000000ul, /*p=
rot=3DPROT_WRITE|PROT_READ|PROT_EXEC*/7ul, /*flags=3DMAP_FIXED|MAP_ANONYMOU=
S|MAP_PRIVATE*/0x32ul, /*fd=3D*/(intptr_t)-1, /*offset=3D*/0ul);
	syscall(__NR_mmap, /*addr=3D*/0x200001000000ul, /*len=3D*/0x1000ul, /*prot=
=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul, /*fd=3D*/(=
intptr_t)-1, /*offset=3D*/0ul);
	const char* reason;
	(void)reason;
			loop();
	return 0;
}

--
2.50.1

