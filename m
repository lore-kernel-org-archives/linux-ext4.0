From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH] ext4: Fix overflow of metadata block reservation
 counter
Date: Tue, 18 Jan 2011 10:02:03 +0900
Message-ID: <4D34E68B.3070804@rs.jp.nec.com>
References: <4D33FDF6.5040700@rs.jp.nec.com> <87tyh7x01i.fsf@dmon-lp.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33209 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1ARBDD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jan 2011 20:03:03 -0500
In-Reply-To: <87tyh7x01i.fsf@dmon-lp.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



(2011/01/17 20:05), Dmitry wrote:
> On Mon, 17 Jan 2011 17:29:42 +0900, Akira Fujita<a-fujita@rs.jp.nec.com>  wrote:
>> Hi,
>>
>> The metadata block reservation counter overflows with data write
>> on ext4 (indirect block map) when its disk space is almost full.
>> This overflow triggers following BUG_ON.
>>
>> Jan 14 09:36:48 TNESG9423 kernel: ------------[ cut here ]------------
>> Jan 14 09:36:48 TNESG9423 kernel: kernel BUG at fs/ext4/inode.c:2170!
>> Jan 14 09:36:48 TNESG9423 kernel: invalid opcode: 0000 [#1] SMP
>> Jan 14 09:36:48 TNESG9423 kernel: last sysfs file: /sys/kernel/mm/ksm/run
>> Jan 14 09:36:48 TNESG9423 kernel: CPU 0
>> Jan 14 09:36:48 TNESG9423 kernel: Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
>> xt_state nf_conntrack ipt_REJECT bridge stp llc autofs4 sunrpc p4_clockmod freq_table speedstep_lib ipv6 xt_physdev iptable_filter ip_tables nls_utf8 dm_mirror dm_region_hash dm_log dm_mod kvm_intel
>> kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore
>> snd_page_alloc e1000e ext3 jbd sd_mod crc_t10dif sr_mod cdrom pata_via pata_acpi ata_generic ata_piix i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: mperf]
>> Jan 14 09:36:48 TNESG9423 kernel:
>> Jan 14 09:36:48 TNESG9423 kernel: Pid: 937, comm: flush-8:0 Not tainted 2.6.37 #1 MS-7264BLM/PC-MJ18ABZR4
>> Jan 14 09:36:48 TNESG9423 kernel: RIP: 0010:[<ffffffff811c5298>]  [<ffffffff811c5298>] ext4_da_block_invalidatepages+0x168/0x180
>> Jan 14 09:36:48 TNESG9423 kernel: RSP: 0018:ffff88007613f780  EFLAGS: 00010246
>> Jan 14 09:36:48 TNESG9423 kernel: RAX: 0010000000000024 RBX: 0000000000008cf2 RCX: 000000000000000e
>> Jan 14 09:36:48 TNESG9423 kernel: RDX: 000000000000000e RSI: 0000000000000001 RDI: ffffea0000a70d30
>> Jan 14 09:36:48 TNESG9423 kernel: RBP: ffff88007613f850 R08: 0000000000000001 R09: 0000000000000002
>> Jan 14 09:36:48 TNESG9423 kernel: R10: ffffea0000a70d38 R11: ffff880035f01b58 R12: ffff88007613f7a0
>> Jan 14 09:36:48 TNESG9423 kernel: R13: ffff880065eecd68 R14: ffff88007613f7b8 R15: ffffea0000a70a58
>> Jan 14 09:36:48 TNESG9423 kernel: FS:  0000000000000000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
>> Jan 14 09:36:48 TNESG9423 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> Jan 14 09:36:48 TNESG9423 kernel: CR2: 0000003680ae1560 CR3: 000000004da45000 CR4: 00000000000006f0
>> Jan 14 09:36:48 TNESG9423 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> Jan 14 09:36:48 TNESG9423 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Jan 14 09:36:48 TNESG9423 kernel: Process flush-8:0 (pid: 937, threadinfo ffff88007613e000, task ffff8800371b54e0)
>> Jan 14 09:36:48 TNESG9423 kernel: Stack:
>> Jan 14 09:36:48 TNESG9423 kernel: ffff88007613f7e0 ffffffff814ee3d6 0000000000000008 0000000e7613f7f0
>> Jan 14 09:36:48 TNESG9423 kernel: 000000000000000e 000000003741a4b9 ffffea0000a70a58 ffffea0000a70a90
>> Jan 14 09:36:48 TNESG9423 kernel: ffffea0000a70ac8 ffffea0000a70b00 ffffea0000a70b38 ffffea0000a70b70
>> Jan 14 09:36:48 TNESG9423 kernel: Call Trace:
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff814ee3d6>] ? printk+0x41/0x43
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811c9fe4>] mpage_da_map_and_submit+0x274/0x470
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811ca24d>] mpage_add_bh_to_extent+0x6d/0xf0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811ca5a0>] write_cache_pages_da+0x2d0/0x4a0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811caa4c>] ext4_da_writepages+0x2dc/0x650
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81105321>] do_writepages+0x21/0x40
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810fb55b>] __filemap_fdatawrite_range+0x5b/0x60
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810fb833>] filemap_fdatawrite_range+0x13/0x20
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811fb6ce>] jbd2_journal_begin_ordered_truncate+0x8e/0xb0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811cd02b>] ext4_evict_inode+0x23b/0x3b0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81167477>] evict+0x27/0xc0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81167a4b>] iput+0x1bb/0x2a0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811734a4>] writeback_sb_inodes+0x104/0x180
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81173cfd>] writeback_inodes_wb+0x9d/0x160
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff8117404b>] wb_writeback+0x28b/0x400
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810714cc>] ? lock_timer_base+0x3c/0x70
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81072092>] ? del_timer_sync+0x22/0x30
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81174257>] wb_do_writeback+0x97/0x1e0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81174452>] bdi_writeback_thread+0xb2/0x270
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811743a0>] ? bdi_writeback_thread+0x0/0x270
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811743a0>] ? bdi_writeback_thread+0x0/0x270
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81083356>] kthread+0x96/0xa0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810832c0>] ? kthread+0x0/0xa0
>> Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
>> Jan 14 09:36:48 TNESG9423 kernel: Code: a8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c9 c3 0f 1f 40 00 4c 89 e7 48 89 95 40 ff ff ff e8 01 1b f4 ff 48 8b 95 40 ff ff ff eb c9<0f>  0b eb fe 0f 0b 66 90 eb fc
>> 66 66 66 66 66 2e 0f 1f 84 00 00
>> Jan 14 09:36:48 TNESG9423 kernel: RIP  [<ffffffff811c5298>] ext4_da_block_invalidatepages+0x168/0x180
>> Jan 14 09:36:48 TNESG9423 kernel: RSP<ffff88007613f780>
>> Jan 14 09:36:48 TNESG9423 kernel: ---[ end trace 0496eaed3b9ec629 ]---
>>
>> To fix this, I referred to the patch which is for data blocks
>> reservation counter (commit: ef627929781c98113e6ae93f159dd3c12a884ad8)
> I cant find that commit in  linus's, and tytso's tries, can you please
> specify where it can be found.

Oops, commit ef627929781c98113e6ae93f159dd3c12a884ad8 is on
http://lkml.indiana.edu/hypermail/linux/kernel/0912.3/01475.html,
but actually it's incorrect. The correct commit is
61820f33e1bcadff14af25a4a894240e7903dd3d in ext4 patch queue.


>> and made a following patch which prints metadata block inconsistency
>> and corrects it.
>> My patch is trial, if you have better idea, feel free to fix this bug.
>>
>> # You can reproduce this problem with attached programs.
>> # In my environment, this occurs in 1 minute.
>>
>> Signed-off-by: Akira Fujita<a-fujita@rs.jp.nec.com>
>> ---
>>   fs/ext4/inode.c |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>> diff -Nrup -X linux-2.6.37-org/Documentation/dontdiff linux-2.6.37-org/fs/ext4/inode.c linux-2.6.37/fs/ext4/inode.c
>> --- linux-2.6.37-org/fs/ext4/inode.c	2011-01-17 15:47:59.000000000 +0900
>> +++ linux-2.6.37/fs/ext4/inode.c	2011-01-17 15:52:25.000000000 +0900
>> @@ -1127,6 +1127,16 @@ void ext4_da_update_reserve_space(struct
>>   		used = ei->i_reserved_data_blocks;
>>   	}
>>
>> +	if (unlikely(ei->i_allocated_meta_blocks>
>> +			ei->i_reserved_meta_blocks)) {
>> +		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, "
>> +			"meta blocks %d with only %d reserved meta blocks\n",
>> +			__func__, inode->i_ino, ei->i_allocated_meta_blocks,
>> +			ei->i_reserved_meta_blocks);
>> +		WARN_ON(1);
>> +		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
>> +	}
>> +
> The situation where allocated>  reservation is a very nasty bug and
> means what reservation is broken, so next moment result in user data
> drop/corruption, due to ENOSPC, so we definitely have to investigate
> the root of cause. BTW i cant reproduce the bug with your test
> on 2.6.34.7-63.fc13 which is really old, but still.
> Which version should i use to reproduce the issue?

My kernel is 2.6.37 + ext4 patch queue (2741742fcfca2e19cd26b1cfe8e43e7b444c8e35).
[akira@bsd086 ~]$ uname -a
Linux bsd086.bsd.tnes.nec.co.jp 2.6.37 #6 SMP Mon Jan 17 11:54:42 JST 2011 x86_64 x86_64 x86_64 GNU/Linux


>>   	/* Update per-inode reservations */
>>   	ei->i_reserved_data_blocks -= used;
>>   	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
> Attachment: metadata_blocks_overflow.sh (application/x-shellscript)
>> #include<stdio.h>
>> #include<stdlib.h>
>> #include<unistd.h>
>> #include<string.h>
>> #include<sys/file.h>
>> #include<sys/mman.h>
>> #include<sys/uio.h>
>> #include<sys/wait.h>
>> #include<errno.h>
>> #include<malloc.h>
>>
>> #define	BUFSIZE	4096
>> #define PATH_MAX 4096
>> #define	MINIOSIZE 4*1024
>> #define	MAXIOSIZE 4*1024*1024
>>
>> #ifndef O_DIRECT
>> #define O_DIRECT 040000
>> #endif
>>
>> static int	bufsize = 0;		/* Buffersize. Default random */
>> static int	bufsize_random = 1;	/* Buffersize random flag. Default random */
>> static long long	filesize = 0;	/* Target file size */
>> static long long	target_range = 0;	/* Target range per process */
>> static int	files_num = 0;
>> static char	*filenames;
>> static int	mmap_write = 0;
>> static int	o_sync = 0;
>> static int	o_async = 0;
>> static int	o_direct = 0;
>>
>> static void setup(void);
>> static void cleanup(void);
>>
>> void prg_usage()
>> {
>> 	fprintf(stderr, "Usage: fs_write [-S 0|1] [-D] [-n num_process]\n");
>> 	fprintf(stderr, "                -s file_size file...\n");
>> 	fprintf(stderr, "\n");
>> 	fprintf(stderr, "		-S	sync mode (0:O_ASYNC 1:O_SYNC)\n");
>> 	fprintf(stderr, "		-D	Direct IO\n");
>> 	fprintf(stderr, "		-n	Process count (default is 1)\n");
>> 	fprintf(stderr, "		-s	File size\n");
>> 	fprintf(stderr, "		file...	Traget file\n");
>>
>> 	exit(1);
>> }
>>
>> int runtest(int fd_w[], int childnum)
>> {
>> 	int num = 0;
>> 	int err = 0;
>> 	long long offset = target_range * childnum;
>> 	long long  remain = target_range;
>> 	int len = bufsize;
>> 	int write_len = 0;
>> 	int psize = getpagesize();
>> 	int max_page = MAXIOSIZE / psize;
>> 	char *buf_w;
>> 	void *p;
>>
>> 	buf_w = (char*)memalign(psize, MAXIOSIZE);
>>
>> 	while (remain>  0) {
>> 		if (bufsize_random == 1) {
>> 			len = (rand() % max_page) * psize;
>> 			if (!len)
>> 				len = MINIOSIZE;
>> 		}
>> 		if (len>  remain)
>> 			len = remain;
>>
>> 		for (num = 0; num<  files_num ; num++) {
>> 			memset(buf_w, childnum+num, len);
>> 			if (!mmap_write) {
>> 				if (lseek(fd_w[num], offset, SEEK_SET)<  0) {
>> 					err = errno;
>> 					goto out;
>> 				}
>> 				if ((write_len = write(fd_w[num], buf_w, len))<  0) {
>> 					err = errno;
>> 					goto out;
>> 				}
>> 				if (len != write_len)
>> 					goto out;
>> 			} else {
>> 				p = mmap(NULL, len, PROT_WRITE, MAP_SHARED,
>> 							fd_w[num], offset);
>> 				if (p == MAP_FAILED) {
>> 					err = errno;
>> 					goto out;
>> 				}
>> 				memcpy(p, buf_w, len);
>> 				if (munmap(p, len) == -1) {
>> 					err = errno;
>> 					goto out;
>> 				}
>> 			}
>> 		}
>> 		offset += len;
>> 		remain -= len;
>> 	}
>>
>> out:
>> 	if (err == ENOSPC || len != write_len)
>> 		err = 0;
>> 	if (err>  0)
>> 		fprintf(stderr, "%s;\n", strerror(err));
>> 	free(buf_w);
>>
>> 	return err;
>> }
>>
>> int child_function(int childnum)
>> {
>> 	int num, ret = -1;
>> 	int fd_w[files_num];
>> 	char *filename;
>> 	
>> 	for (num = 0; num<  files_num ; num++) {
>> 		fd_w[num] = -1;
>> 	}
>> 	for (num = 0; num<  files_num ; num++) {
>> 		filename = filenames + (num*PATH_MAX);
>> 		if ((fd_w[num] = open(filename,
>> 				O_RDWR|o_sync|o_async|o_direct))<  0) {
>> 			printf("TINFO:fd_w open failed for %s: %s\n",filename, strerror(errno));
>> 			goto out;
>> 		}
>> 	}
>>
>> 	ret = runtest(fd_w, childnum);
>>
>> out:
>> 	for (num = 0; num<  files_num ; num++) {
>> 		if (fd_w[num] != -1)
>> 			close(fd_w[num]);
>> 	}
>>
>> 	exit(ret);
>> }
>>
>> static void setup(void)
>> {
>> 	int num, fd;
>> 	char *filename;
>>
>> 	for (num = 0; num<  files_num; num++) {
>> 		filename = filenames + (num * PATH_MAX);
>> 		if ((fd = open(filename, O_CREAT|O_EXCL|O_WRONLY|O_TRUNC, 0666))<  0) {
>> 			printf("TBROK, Couldn't create test file %s: %s\n", filename, strerror(errno));
>> 			cleanup();
>> 		}
>>
>> 		if (mmap_write) {
>> 			if (ftruncate(fd, filesize)<  0) {
>> 				printf("TBROK2: Couldn't create test file %s: %s\n", filename, strerror(errno));
>> 				cleanup();
>> 			}
>> 		}
>> 		close(fd);
>> 	}
>> }
>>
>> static void cleanup(void)
>> {
>> 	int num;
>> 	for (num = 0; num<  files_num; num++)
>> 		unlink(filenames + (num * PATH_MAX));
>> 	free(filenames);
>> 	exit(1);
>> }
>>
>> int main(int argc, char *argv[])
>> {
>> 	int	numchild = 1;	/* Number of children. Default 5 */
>> 	int	i, num;
>> 	int	err = 0;
>> 	int	sync_mode = 0;
>> 	int	*cpid;
>> 	int 	status;
>>
>> 	while ((i = getopt(argc, argv, "MS:Dn:s:")) != -1) {
>> 		switch(i) {
>> 		case 'M':
>> 			mmap_write = 1;
>> 			break;
>> 		case 'S':
>> 			if ((sync_mode = atoi(optarg))<  0) {
>> 				fprintf(stderr, "sync mode must be 0 or 1;\n");
>> 				prg_usage();
>> 			}
>> 			switch (sync_mode) {
>> 			case 0:
>> 				o_async = O_ASYNC;
>> 				break;
>> 			case 1:
>> 				o_sync = O_SYNC;
>> 				break;
>> 			default:
>> 				fprintf(stderr, "sync mode must be 0 or 1;\n");
>> 				prg_usage();
>> 			}
>> 			break;
>> 		case 'D':
>> 			o_direct = O_DIRECT;
>> 			break;
>> 		case 'n':
>> 			if ((numchild = atoi(optarg))<= 0) {
>> 				fprintf(stderr, "no of children must be>  0;\n");
>> 				prg_usage();
>> 			}
>> 			break;
>> 		case 's':
>> 			filesize = atol(optarg);
>> 			if (filesize<= 0) {
>> 				fprintf(stderr, "filesize must be>  0;\n");
>> 				prg_usage();
>> 			}
>> 			break;
>> 		default:
>> 			prg_usage();
>> 		}
>> 	}
>>
>> 	files_num = argc - optind;
>> 	if (files_num<= 0)
>> 		prg_usage();
>> 	if (filesize % numchild != 0 || (filesize / numchild) % BUFSIZE != 0) {
>> 		fprintf(stderr, "filesize must be multiple of 4k*numchild:"
>> 				"filesize=%lld;\n", filesize);
>> 		prg_usage();
>> 	}
>>
>> 	if ((filenames = (char *)malloc(files_num * PATH_MAX)) == NULL ||
>> 	    (cpid = (int *)malloc(sizeof(int)*numchild)) == NULL) {
>> 		perror("malloc");
>> 		exit(1);
>> 	}
>> 	for(i = optind, num = 0 ; i<  argc; i++, num++)
>> 		strcpy((char *)filenames + (num * PATH_MAX), argv[i]);
>> 	target_range = filesize / numchild;
>>
>>
>> 	setup();
>>
>> 	for(i = 0; i<  numchild; i++) {
>> 		*(cpid+i) = fork();
>> 		if (*(cpid+i) == 0)
>> 			child_function(i);
>> 	}
>> 	for(i = 0; i<  numchild; i++) {
>> 		waitpid(*(cpid+1),&status, 0);
>> 	}
>>
>> 	cleanup();
>> 	return err;
>> }
> 

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Software Development Division,
NEC Software Tohoku, Ltd.

