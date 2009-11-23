From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4+quota patch series
Date: Mon, 23 Nov 2009 22:18:32 +0300
Message-ID: <87ljhxxd6f.fsf@openvz.org>
References: <87my2d5ctb.fsf@openvz.org> <4B0AD154.7070201@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_CQMAURynE2kXayhHRlGmxw)"
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:49721 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbZKWTS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 14:18:29 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KTK00DU2TUF4B20@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 23 Nov 2009 22:23:07 +0300 (MSK)
In-reply-to: <4B0AD154.7070201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_CQMAURynE2kXayhHRlGmxw)
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT

Eric Sandeen <sandeen@redhat.com> writes:
>Can you share those quota tests?  I'd love to put them into the xfstests
>suite we've been using for ext4 as well.

write-truncate-chown: test delalloc + quota_transfer
I've written crappy quotactl for quota manipulation
(which i use for ct-tree-quota development).Some times
it more useful. See files attached.

mkfs.ext4 /dev/sdb5 -b4096
mount /dev/sdb5 /mnt -ogrpquota,usrquota
quotacheck -cug /mnt
# sync is necessary, because files may have reserved some blocks
# which later lead to complain from claim_reserved_space
# Probably we have print *huge* warning if we found
# file with reserved blocks inodes traversing on quotaon 
sync;sync;sync
# turn on quota
./quotactl --all --on --device=/dev/sdb5 --path /mnt
# run test
./write-truncate-chown /mnt/ 9999999999&
# get quota report, print warn in case of incorrect quota.
./quotactl --all --get --type 0 --device=/dev/sdb5 || echo "failed"
# checkout dmesg
dmesg


--Boundary_(ID_CQMAURynE2kXayhHRlGmxw)
Content-type: text/x-csrc; NAME=quotactl.c
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=quotactl.c

/*
 * Disk quota reporting program.
 */
#include <sys/types.h>
#include <sys/param.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <error.h>
#include <linux/quota.h>
#include <linux/dqblk_v1.h>
#include <linux/dqblk_v2.h>

enum options {
	ID_FL  =  	0x1,
	HELP_FL = 	0x2,
	GET_FL = 	0x4,
	SET_FL = 	0x8,
	ALL_FL = 	0x10,
	ON_FL =		0x20,
	OFF_FL =	0x40,
	TYPE_FL =	0x80,
};
unsigned flags = 0;
char device[128];
char path[128];
int  id;
int type;
int warn = 0;
 void print_dqblk(int qid, struct if_dqblk *dqb)
 {
	 printf("%6d   %10lld  %10lld %10lld,    %10lld %10lld %10lld\n",

		 qid, dqb->dqb_curspace, dqb->dqb_bsoftlimit, dqb->dqb_bhardlimit,
		 dqb->dqb_curinodes, dqb->dqb_isoftlimit, dqb->dqb_ihardlimit);
	 if (((int64_t)dqb->dqb_curspace) < 0 ||
		 ((int64_t)dqb->dqb_bsoftlimit) < 0 ||
		 ((int64_t)dqb->dqb_bhardlimit) < 0 ||
		 ((int64_t)dqb->dqb_curinodes) < 0 ||
		 ((int64_t)dqb->dqb_isoftlimit) < 0 ||
		 ((int64_t)dqb->dqb_ihardlimit) < 0 ) {
		 printf ("WANR: Negative quota !!!");
		 warn = qid + 1;
	 }
 }
 int onoff_quota(int type, int on) {
	 int beg = type;
	 int end = type;
	 int i, ret;
	 char  *name[] = {"aquota.user", "aquota.group", "aquota.tree"};
	 char p[1024];
	 if (!(flags & TYPE_FL) && !(flags & ALL_FL)) {
		 printf("Err --set with out --all or --type opt\n");
		 exit(1);
	 }
	 if (flags & ALL_FL) {
		 beg = 0;
		 end = 2; /* MAXQUOTAS */
	 }
	 for (i = beg; i  <= end; i++) {
		 snprintf(p, sizeof(p), "%s/%s", path, name[i]);
		 ret = quotactl(QCMD(on ? Q_QUOTAON : Q_QUOTAOFF, i),
			 device, QFMT_VFS_V0, p);
		 if (ret)
			 perror("quotactl");
	 }
	 return ret;
 }



 int show_quota(int start, int end)
 {
	 struct if_dqblk dqb, sum_dqb;
	 int i,found = 0;
	 int ret;
	 memset(&sum_dqb, 0, sizeof(sum_dqb));
	 printf("    ID     curspace       soft        hard      curinodes      soft       hard\n");
	 for (i = start; i < end; i++) {
		 ret = quotactl(QCMD(Q_GETQUOTA, type),device, i, (char*)&dqb);
		 if (ret && errno == ESRCH)
			 continue;
		 if (!dqb.dqb_curspace && !dqb.dqb_bsoftlimit &&
			 !dqb.dqb_bhardlimit && !dqb.dqb_curinodes &&
			 !dqb.dqb_isoftlimit && !dqb.dqb_ihardlimit)
			 continue;
		 if (ret) {
			 perror ("quotactl");
			 return 1;
		 }
		 print_dqblk(i, &dqb);
		 found++;
		 sum_dqb.dqb_curspace += dqb.dqb_curspace;
		 sum_dqb.dqb_curinodes += dqb.dqb_curinodes;
	 }
	 printf("--------------------------------------------------------------------------------\n");
	 print_dqblk(found, &sum_dqb);
	 if (warn)
		 printf("WARN!!  bad quota found id:%d \n", warn - 1);
	 return warn;
 }
 int main(int argc, char **argv)
 {
	 unsigned treeid = -1;
	 gid_t gidset[NGROUPS], *gidsetp;
	 int i, ret;
	 int ngroups = 0;

	 struct if_dqblk dqb;
	 struct option long_opts[] = {
		 { "help", 0, NULL, 'H' },
		 { "path", 1, NULL, 'p'},
		 { "get", 0, NULL, 'G' },
		 { "set", 0, NULL, 'S' },
		 { "on", 0, NULL, 'O'},
		 { "off", 0, NULL, 'o'},
		{ "device", 1, NULL, 'D'},
		{ "bsoft", 1, NULL, 'b'},
		{ "bhard",1, NULL, 'B'},
		{ "curspace",1, NULL, 'c'},
		{ "curinodes",1, NULL, 'C'},
		{ "isoft",1, NULL, 'i'},
		{ "ihard",2, NULL, 'I'},
		{ "type",1, NULL, 'T'},
		{ "all",0, NULL, 'a'},
		{ "id",1, NULL, 'd'},
		{ NULL, 0, NULL, 0 }
	};
	while ((ret = getopt_long(argc, argv, "HGSp:D:T:i:b:B:i:I:c:C:aOo", long_opts, NULL)) != -1) {
		switch (ret) {
		case 'H':
			  flags |= HELP_FL;
			  break;
		case 'G':
			  flags |= GET_FL;
			  break;
		case 'S':
			  flags |= SET_FL;
			  break;
		case 'O':
			  flags |= ON_FL;
			  break;
		case 'o':
			flags |= OFF_FL;
			break;
		case 'p':
			strcpy(path, optarg);
			break;

		case 'a':
			  flags |= ALL_FL;
			  break;
		case 'D' :
			strcpy(device ,optarg);
			break;
		case 'T' :
			flags |= TYPE_FL;
			type = atoi(optarg);
			break;
		case 'd' :
			id = atoi(optarg);
			flags |= ID_FL;
			break;
		case 'b' :
			dqb.dqb_bsoftlimit= atol(optarg);
			dqb.dqb_valid |= QIF_BLIMITS;
			break;
		case 'B' :
			dqb.dqb_bhardlimit= atol(optarg);
			dqb.dqb_valid |= QIF_BLIMITS;
			break;
		case 'i' :
			dqb.dqb_isoftlimit= atol(optarg);
			dqb.dqb_valid |= QIF_ILIMITS;
			break;
		case 'I' :
			dqb.dqb_ihardlimit= atol(optarg);
			dqb.dqb_valid |= QIF_ILIMITS;
			break;
		case 'c' :
			dqb.dqb_curspace= atol(optarg);
			dqb.dqb_valid |= QIF_SPACE;
			break;
		case 'C' :
			dqb.dqb_curinodes= atol(optarg);
			dqb.dqb_valid |= QIF_INODES;
			break;

		default:
			printf("Unknown opt:%c\n", ret);
			exit(1);
		}
	}
	argc -= optind;
	argv += optind;
	if (flags & (ON_FL |OFF_FL))
		return onoff_quota(type, flags & ON_FL);

	if (flags & SET_FL) {
		if ((flags & (ID_FL| TYPE_FL)) != (ID_FL| TYPE_FL)) {
			printf("Err --set with out --id opt\n");
			exit(1);
		}
		if (!(dqb.dqb_valid & QIF_ALL)) {
			printf("Err --set with bhard,bsoft,isoft,ihard "
				 "curspace, curinodes opt\n");
			exit(1);
		}
		ret = quotactl(QCMD(Q_SETQUOTA, type),device, id, (char*)&dqb);
		if (ret) {
			perror("quotactl");
			return 1;
		}

	}
	if (flags & GET_FL)
		if (flags & ALL_FL)
			return show_quota(0, 65535);
		else
			return show_quota(id, id + 1);
	return 0;
}

--Boundary_(ID_CQMAURynE2kXayhHRlGmxw)
Content-type: text/x-csrc; NAME=write-truncate-chown.c
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=write-truncate-chown.c

/*
 *  Write-truncate-chown testcase
 */
#include <sys/types.h>
#include <limits.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include "time.h"

long long time_diff(struct timeval *tv1, struct timeval *tv2)
{
	long long diff = 0;
	long long sec = 0;
	diff = tv2->tv_usec - tv1->tv_usec;
	sec += (tv2->tv_sec - tv1->tv_sec);
	sec *= 1000000;
	diff += sec;
	return diff;
}

int main(int argc, char **argv)

{
	int num, i;
	int ret = 0;
	int fd;
	char name[] = "test-write-truncate-chown";
	uid_t uid, gid;
	char buf[1024*1024];
	struct timeval tv[2];
	if (argc  <  2) {
		printf("usage %s <path> <num_iter>\n", argv[0]);
		return 1;
	}
	chdir(argv[1]);

	if (argc == 2)
		num = INT_MAX;
	else
		num = atoi(argv[2]);
	fd = open(name, O_CREAT|O_RDWR, 0777);
	uid = geteuid();
	uid = getegid();
	if (fd < 0)
		goto out;

	gettimeofday(tv, NULL);
	for (i = 0; i < num; i+= 2) {
		// Trigger quota transfer
		ret |= fchown(fd, i % 65538, i % 65538);
		// Trigger pages invalidate
		ftruncate(fd, 0);
		// Trigger quota transfer
		ret |= fchown(fd, (i + 1) % 65538, (i+1) % 65538);
		// Trigger allocation + space reservation
		pwrite(fd, buf, sizeof(buf));
	}
	gettimeofday(tv+1, NULL);
	ret |= unlink (name);
	printf("%lld\n", time_diff(tv, tv+1));
	if (ret) {
out:
		printf("WARN error happend during test\n");
	}
	return ret;
}

--Boundary_(ID_CQMAURynE2kXayhHRlGmxw)--
