From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to recover a damaged ext4 file system?
Date: Thu, 08 Jan 2009 03:11:45 -0700
Message-ID: <20090108101145.GJ13721@webber.adilger.int>
References: <20090105135347.GA3337@localdomain>
 <20090106120527.GT3932@webber.adilger.int> <20090106193404.GA18957@mit.edu>
 <20090107214148.GA3151@moongate.localnet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_RyLefb3Yrg7CNk65myV6CQ)"
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Christian Ohm <chr.ohm@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62142 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZAHKLw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2009 05:11:52 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n08ABmbH028102
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 02:11:50 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KD500L01DI9PC00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 08 Jan 2009 02:11:48 -0800 (PST)
In-reply-to: <20090107214148.GA3151@moongate.localnet>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_RyLefb3Yrg7CNk65myV6CQ)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline

On Jan 07, 2009  22:42 +0100, Christian Ohm wrote:
> > Can you upload someplace the output of
> > 
> > dumpe2fs /dev/XXX
> > dumpe2fs -o superblock=32768 /dev/XXX
> > dumpe2fs -o superblock=98304 /dev/XXX
> > 
> > That would be helpful to see what had happened.
> 
> I'll do that soon; I got another harddisk to copy the partition, but both
> disks aren't connected right now. 

You could also and compile and run the e2fsprogs "findsuper" tool (I've
attached it here, it isn't built by default).  This will scan the specified
device and look for ext2/3/4 superblock signatures.

> > > 2. Is this corruption a fault of ext4? I guess this is difficult to
> > > answer, but I had ext3 survive any lockups without much problems. So
> > > far ext4 seems not quite that robust, but perhaps another file
> > > system would have blown up as well in this situation. Is there any
> > > information I can give you to help make ext4 more robust?
> > 
> > I'm not sure what the hard system hang did, but it looks like it
> > splattered a lot of random crap all over the harddrive.  I doubt ext4
> > did this, and I doubt ext3 would have done any better.... we need to
> > know a lot more about exactly what sort damage was done to the
> > filesytem to say for certain, though.
> 
> I did one copy of the partition already (took three hours, so not something to
> do often...), and ran fsck -y on that. The result was an endless fsck loop like
> that described in
> http://www.linuxquestions.org/questions/linux-hardware-18/corrupt-ext3-partition-need-to-recover-376366/.
> Oh, and I have to try if dumpe2fs actually works, either that or debugfs failed
> when I tried to run it on the original disk (I also ran dumpe2fs on the copy
> while fsck was doing its looping, and depending on the time it did or did not
> find a file system on the device). Anyway, I hope I can experiment some more
> tomorrow.
> 
> Oh, and is there a human understandable description of the on-disk data format
> to compare with a hexdump? A (admittedly very short) search didn't turn up
> anything.
> 
> Best regards,
> Christian Ohm
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--Boundary_(ID_RyLefb3Yrg7CNk65myV6CQ)
Content-type: text/plain; NAME=findsuper.c; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=findsuper.c

/*
 * findsuper --- quick hacked up program to find ext2 superblocks.
 *
 * This is a hack, and really shouldn't be installed anywhere.  If you
 * need a program which does this sort of functionality, please try
 * using gpart program.
 *
 * Portions Copyright 1998-2000, Theodore Ts'o.
 *
 * Well, here's my linux version of findsuper.
 * I'm sure you coulda done it faster.  :)
 * IMHO there isn't as much interesting data to print in the
 * linux superblock as there is in the SunOS superblock--disk geometry is
 * not there...and linux seems to update the dates in all the superblocks.
 * SunOS doesn't ever touch the backup superblocks after the fs is created,
 * as far as I can tell, so the date is more interesting IMHO and certainly
 * marks which superblocks are backup ones.
 *
 * I wanted to add msdos support, but I couldn't make heads or tails
 * of the kernel include files to find anything I could look for in msdos.
 *
 * Reading every block of a Sun partition is fairly quick.  Doing the
 * same under linux (slower hardware I suppose) just isn't the same.
 * It might be more useful to default to reading the first (second?) block
 * on each cyl; however, if the disk geometry is wrong, this is useless.
 * But ya could still get the cyl size to print the numbers as cyls instead
 * of blocks...
 *
 * run this as (for example)
 *   findsuper /dev/hda
 *   findsuper /dev/hda 437760 1024   (my disk has cyls of 855*512)
 *
 * I suppose the next step is to figgure out a way to determine if
 * the block found is the first superblock somehow, and if so, build
 * a partition table from the superblocks found... but this is still
 * useful as is.
 *
 *		Steve
 * ssd@nevets.oau.org
 * ssd@mae.engr.ucf.edu
 *
 * Additional notes by Andreas Dilger <adilger@turbolinux.com>:
 * - fixed to support > 2G devices by using lseek64
 * - add reliability checking for the superblock to avoid random garbage
 * - add adaptive progress meter
 *
 * It _should_ also handle signals and tell you the ending block, so
 * that you can resume at a later time, but it doesn't yet...
 *
 * Note that gpart does not appear to find all superblocks that aren't aligned
 * with the start of a possible partition, so it is not useful in systems
 * with LVM or similar setups which don't use fat partition alignment.
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
 */

/*
 * Documentation addendum added by Andreas dwguest@win.tue.nl/aeb@cwi.nl
 *
 * The program findsuper is a utility that scans a disk and finds
 * copies of ext2 superblocks (by checking for the ext2 signature).
 *
 * For each superblock found, it prints the offset in bytes, the
 * offset in 1024-byte blocks, the size of the ext2 partition in fs
 * blocks, the filesystem blocksize (in bytes), the block group number
 * (always 0 for older ext2 systems), and a timestamp (s_mtime).
 *
 * This program can be used to retrieve partitions that have been
 * lost.  The superblock for block group 0 is found 1 block (2
 * sectors) after the partition start.
 *
 * For new systems that have a block group number in the superblock it
 * is immediately clear which superblock is the first of a partition.
 * For old systems where no group numbers are given, the first
 * superblock can be recognised by the timestamp: all superblock
 * copies have the creation time in s_mtime, except the first, which
 * has the last time e2fsck or tune2fs wrote to the filesystem.
 *
 */

#define _FILE_OFFSET_BITS 64

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <time.h>

#include "ext2fs/ext2_fs.h"
#include "nls-enable.h"

#undef DEBUG

#ifdef DEBUG
#define WHY(fmt, arg...) { printf("\r%Ld: " fmt, sk, ##arg) ; continue; }
#else
#define WHY(fmt, arg...) { continue; }
#endif

static void usage(void)
{
	fprintf(stderr,
		_("Usage:  findsuper device [skipbytes [startkb]]\n"));
	exit(1);
}


int main(int argc, char *argv[])
{
	int skiprate=512;		/* one sector */
	loff_t sk=0, skl=0;
	int fd;
	char *s;
	time_t tm, last = time(0);
	loff_t interval = 1024 * 1024;
	int c, print_jnl_copies = 0;
	const char * device_name;
	struct ext2_super_block ext2;
	/* interesting fields: EXT2_SUPER_MAGIC
	 *      s_blocks_count s_log_block_size s_mtime s_magic s_lastcheck */

#ifdef ENABLE_NLS
	setlocale(LC_MESSAGES, "");
	setlocale(LC_CTYPE, "");
	bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
	textdomain(NLS_CAT_NAME);
#endif

	while ((c = getopt (argc, argv, "j")) != EOF) {
		switch (c) {
		case 'j':
			print_jnl_copies++;
			break;
		default:
			usage();
		}
	}

	if (optind == argc)
		usage();

	device_name = argv[optind++];

	if (optind < argc) {
		skiprate = strtol(argv[optind], &s, 0);
		if (s == argv[optind]) {
			fprintf(stderr,_("skipbytes should be a number, not %s\n"), s);
			exit(1);
		}
		optind++;
	}
	if (skiprate & 0x1ff) {
		fprintf(stderr,
			_("skipbytes must be a multiple of the sector size\n"));
		exit(2);
	}
	if (optind < argc) {
		sk = skl = strtoll(argv[optind], &s, 0) << 10;
		if (s == argv[optind]) {
			fprintf(stderr,
				_("startkb should be a number, not %s\n"), s);
			exit(1);
		}
		optind++;
	}
	if (sk < 0) {
		fprintf(stderr, _("startkb should be positive, not %Lu\n"), sk);
		exit(1);
	}

	fd = open(device_name, O_RDONLY);
	if (fd < 0) {
		perror(device_name);
		exit(1);
	}

	/* Now, go looking for the superblock! */
	printf(_("starting at %Lu, with %u byte increments\n"), sk, skiprate);
	if (print_jnl_copies)
		printf(_("[*] probably superblock written in the ext3 "
			 "journal superblock,\n\tso start/end/grp wrong\n"));
	printf(_("byte_offset  byte_start     byte_end  fs_blocks blksz  grp  last_mount_time           sb_uuid label\n"));
	for (; lseek64(fd, sk, SEEK_SET) != -1 &&
	       read(fd, &ext2, 512) == 512; sk += skiprate) {
		static unsigned char last_uuid[16] = "blah";
		unsigned long long bsize, grpsize;
		int jnl_copy, sb_offset;

		if (sk && !(sk & (interval - 1))) {
			time_t now, diff;

			now = time(0);
			diff = now - last;

			if (diff > 0) {
				s = ctime(&now);
				s[24] = 0;
				printf("\r%11Lu: %8LukB/s @ %s", sk,
				       (((sk - skl)) / diff) >> 10, s);
				fflush(stdout);
			}
			if (diff < 5)
				interval <<= 1;
			else if (diff > 20)
				interval >>= 1;
			last = now;
			skl = sk;
		}
		if (ext2.s_magic != EXT2_SUPER_MAGIC)
			continue;
		if (ext2.s_log_block_size > 6)
			WHY("log block size > 6 (%u)\n", ext2.s_log_block_size);
		if (ext2.s_r_blocks_count > ext2.s_blocks_count)
			WHY("r_blocks_count > blocks_count (%u > %u)\n",
			    ext2.s_r_blocks_count, ext2.s_blocks_count);
		if (ext2.s_free_blocks_count > ext2.s_blocks_count)
			WHY("free_blocks_count > blocks_count\n (%u > %u)\n",
			    ext2.s_free_blocks_count, ext2.s_blocks_count);
		if (ext2.s_free_inodes_count > ext2.s_inodes_count)
			WHY("free_inodes_count > inodes_count (%u > %u)\n",
			    ext2.s_free_inodes_count, ext2.s_inodes_count);

		tm = ext2.s_mtime;
		s = ctime(&tm);
		s[24] = 0;
		bsize = 1 << (ext2.s_log_block_size + 10);
		grpsize = bsize * ext2.s_blocks_per_group;
		if (memcmp(ext2.s_uuid, last_uuid, sizeof(last_uuid)) == 0 &&
		    ext2.s_rev_level > 0 && ext2.s_block_group_nr == 0) {
			jnl_copy = 1;
		} else {
			jnl_copy = 0;
			memcpy(last_uuid, ext2.s_uuid, sizeof(last_uuid));
		}
		if (ext2.s_block_group_nr == 0 || bsize == 1024)
			sb_offset = 1024;
		else
			sb_offset = 0;
		if (jnl_copy && !print_jnl_copies)
			continue;
		printf("\r%11Lu %11Lu%s %11Lu%s %9u %5Lu %4u%s %s %02x%02x%02x%02x %s\n",
		       sk, sk - ext2.s_block_group_nr * grpsize - sb_offset,
		       jnl_copy ? "*":" ",
		       sk + ext2.s_blocks_count * bsize -
		            ext2.s_block_group_nr * grpsize - sb_offset,
		       jnl_copy ? "*" : " ", ext2.s_blocks_count, bsize,
		       ext2.s_block_group_nr, jnl_copy ? "*" : " ", s,
		       ext2.s_uuid[0], ext2.s_uuid[1],
		       ext2.s_uuid[2], ext2.s_uuid[3], ext2.s_volume_name);
	}
	printf(_("\n%11Lu: finished with errno %d\n"), sk, errno);
	close(fd);

	return errno;
}

--Boundary_(ID_RyLefb3Yrg7CNk65myV6CQ)--
