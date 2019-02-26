Return-Path: <SRS0=4ybF=RB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0CDC10F0B
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 15:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2804217F5
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 15:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="ipLMGYje"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfBZPR5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Feb 2019 10:17:57 -0500
Received: from mail-eopbgr780105.outbound.protection.outlook.com ([40.107.78.105]:56842
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726222AbfBZPR4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 26 Feb 2019 10:17:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dz9ZeduDIX26ft8FU9DrASDjt3Rx6rYBEseWozTjZnI=;
 b=ipLMGYje1BAmrctIbKQbPRjz3LGNKXqI7QLtG/PIZahbrd7+Ff/KYcjstuQyr/TVrV/+T9D0yO4mh3aJqJOaZxljZbVMhGiHzjZgFZSQXnm83gZzI16m+HDChVypzun30+ij0IRAkTUsP+oEUKH26BdVuKAw/zrXXxzUiPTbY00=
Received: from MN2PR01CA0031.prod.exchangelabs.com (2603:10b6:208:10c::44) by
 BYAPR01MB5606.prod.exchangelabs.com (2603:10b6:a03:127::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Tue, 26 Feb 2019 15:17:47 +0000
Received: from DM3NAM03FT017.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::202) by MN2PR01CA0031.outlook.office365.com
 (2603:10b6:208:10c::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.15 via Frontend
 Transport; Tue, 26 Feb 2019 15:17:46 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT017.mail.protection.outlook.com (10.152.82.201) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Tue, 26 Feb 2019 15:17:42 +0000
Received: from callcc.thunk.org (63-138-96-7.customer.static.ip.paetec.net [63.138.96.7] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1QFHcxK022318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Feb 2019 10:17:39 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 21CD07A2DF9; Tue, 26 Feb 2019 10:17:38 -0500 (EST)
Date:   Tue, 26 Feb 2019 10:17:38 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com>
CC:     <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_file_write_iter
Message-ID: <20190226151738.GA6430@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
References: <0000000000009a01370582c6772a@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <0000000000009a01370582c6772a@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(346002)(376002)(2980300002)(189003)(199004)(42186006)(76176011)(44144004)(16586007)(36906005)(33656002)(4326008)(316002)(786003)(36756003)(186003)(106002)(103686004)(75432002)(26005)(63394003)(246002)(235185007)(88552002)(356004)(54906003)(5024004)(14444005)(336012)(305945005)(106466001)(6246003)(6266002)(486006)(11346002)(8936002)(2906002)(2616005)(26826003)(476003)(5660300002)(126002)(84326002)(446003)(2476003)(86362001)(966005)(568964002)(1076003)(6306002)(71190400001)(58126008)(52956003)(229853002)(8676002)(90966002)(478600001)(18370500001)(42866002)(99710200001)(2700100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB5606;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 775c257a-75b4-4f12-b968-08d69bfd8faf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060)(49563074);SRVR:BYAPR01MB5606;
X-MS-TrafficTypeDiagnostic: BYAPR01MB5606:
X-MS-Exchange-PUrlCount: 5
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB5606;20:Qgd80FjHO3bVed0V6pmAZ19+t5LBr/dxN0Unjevbp0kp1jdzBu3rG6DPmE/Bc1O2sf6oBhiBbkAGSt6dYpOJxttRdFMTFPEMY1tGZ2cE2uSbSZ/C5/XzScDKm9PCjZZKQAG03oCCbedLI0ngK8mF8oPW8kCoXQyR5OjXRWqP8+Ki2kRhkWX/zBukNpbPbGnqRB29oDU+LiItLHVUgnZuuLh13b5l+fZu7CDz9cRNkKx352HpE8jkdHeb9oCHHWKnYOXLn78FddrXPFZ7enAbFFexzTHesOsNazbV/Hr6DqB1oHpTgr6V/UxRpyvG7ndu531QzveDXWREikTBmcc1rgyk8LlNzuJ0K5ErGrci/hanfHp6I/VqvCvtN84wh2sI1GEVFKosuj94ucFwt0JuEwZg24MdfimSUsu9HzFQ6nGeMuWfBkPPAOemaOs5A47rXgi/Wo7qLUwjnFEIWZAYK6XDL4qAgAcW+ovV8VwmwtDRQ2cK/I0ZZU7HYQCcGmU0WlpRvnDeJt2mlti3HqqfoikjR1fvvEnH85eIouDMuiys1bAQyyF6bi/co5meFtAzoQbMf6glj8F7bQ7LZWBmpYPbdudENUTk5N20C42l8a8=
X-Microsoft-Antispam-PRVS: <BYAPR01MB56063D6D81C6D807A63F29CBB57B0@BYAPR01MB5606.prod.exchangelabs.com>
X-Forefront-PRVS: 096029FF66
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB5606;23:ArpFpsvHCz3BHX/ATau8whG3XrbKyiZeBquqDpAnJ?=
 =?us-ascii?Q?I9r0O3lBw4WTh1phJHfpeEqnRzNZM+3v0S7a3smrY19USOj7tK2+Wg/O7V2N?=
 =?us-ascii?Q?+rUyp8YftX+yqxa7zex/ci99CbinErEoAjxQOIO/c2dcOG9sdkmdwFAuZsNy?=
 =?us-ascii?Q?PMZl3uKL1sUEHx7VIvc9g/jCc0cf3Hp4upenJootmL4KBwXhr213AUgGmrD7?=
 =?us-ascii?Q?0QNDz0wVEjrJKEZpC7pz8b1h9p7R7cq16lu2ngh4it7KF3BrPClpFJtUFnFI?=
 =?us-ascii?Q?+sBH7RCuHGRKPtnZkzjwKuBsdRyTZP9BR9hakN3QgvEYGrgHsXrcZj15Ymjc?=
 =?us-ascii?Q?yLkuhOAvGdLJtst0zImzk2ZUgZa9Ic0nX2vJw5GJQ73S/FktPJKluH1tk/J8?=
 =?us-ascii?Q?dI6VwgBabpE039dVpLP7nfWhe9WQFLo6V8sCDee6VTl2alY05VDpiWdDaR6S?=
 =?us-ascii?Q?BbqamJfM6e89sFR5P/DmodoJrWVXFgrzNWZBimUsXEa6Vz6vkX6l31QeFik9?=
 =?us-ascii?Q?UUmuE2S72sT08KG38qZVpqemId9w4fvixRXDQaPAfJkMih86oim3BPilPQzy?=
 =?us-ascii?Q?beR862P8QnqwKCoEvo2QskFhxlzZukPDKKNRieoHO0k3rzFab6rhEvkm5w0+?=
 =?us-ascii?Q?rPMlScf5OBA62OF0NQ5kro5d/hqg8Mvc1n1vZe21OW0o6TyRHGjK2FMUSHvH?=
 =?us-ascii?Q?28py4VOmOs07UEUNuh9jze3TL0HgB3CfIc2PRPrn2d/Fvv9WpDgX4m0+HX+O?=
 =?us-ascii?Q?28OhJNLRQbgwec6xFu0xn8D0aXm8vhy0W3ELjwyoImsTFOu5em3syDneOpDm?=
 =?us-ascii?Q?TrP8UlwTCoWRriVa4yOy0CT25/MULLFrsMHwdxIsxfbZIFMfK5zBIDOQR771?=
 =?us-ascii?Q?KbywT+jpPNfqNleAZJxiKvGXgnKCtyGlzfnWcVsU3bIQs0UIanPrk3vTspf4?=
 =?us-ascii?Q?jophoNuCvN1KwGjC5zh71hZhnVgiczLEb1EUeDDNvR3omitEVoBrc0kOG9go?=
 =?us-ascii?Q?+trVHcXkCJO46UqE1MdAoEwbU03Qc+yRsJdj4lpOgM4Vb7v6RpLkXAwrOA6e?=
 =?us-ascii?Q?8QcvkaQYAoEK6qcYOPOL8nyMhPWc1ieutq9Z7BpCxag2t1b1UVUJhqDLYVCF?=
 =?us-ascii?Q?VscLTSfkR6iHZfss+JCNVKB0uekg4opJUaqkcpH7aCAIw7G/q/T6TOwEOtXu?=
 =?us-ascii?Q?Wk2C+Flot8hvJKG3xJoZZQ8WLb52fCQY9jbf3u/LT//bMxZ33S71j0zSFfxU?=
 =?us-ascii?Q?UMU3K+AHpeOcbyLBjoIEDhuJzn/r0mHiMBD+7TFnWCW27fdQG6PUmgeJGTEO?=
 =?us-ascii?Q?8Co1YNmFqzelI+6K3iWu3Ql/5PXhTxhVfEnBwZYTF85I8qmo9VB5KE+YBs1H?=
 =?us-ascii?Q?J2SfhQyuZw1nIMkMxB1lWGv1pjD+XayrSAKGpzX71ljlFKAVc45qCnvDv58M?=
 =?us-ascii?Q?1096LGUQQ=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: z321sZkqml2DNfrsdDdSTs0LJj6D1hXwB1TCJKloXYgBdHse6ldJ5/2QBi3hnijPj1atU2/rnt7nFyCtWHNoRz/ywv0EBmQE6Favt/Q3PS+f1rAjtB2C7ULuaKCKobgtFy42GR5NWgklo58NFTmfDKA3F5u8ViHIOZ8XbrcRmyQkbn71xQS57b8NpeGaWzkTPGpGRDMbz6Tfw4cyL7h6bVVlUwTcu1GRoEmzOkBTNfi+YgC1cpRnFctPL14WSRyfEAnUOLgMDx6Xi+NsVcCyBv6nEV77f/78zdjetaNGreNa3umaI0yeQRtTE6+kkPnA7vum4MJguUTFD069JobhIOe2O6i6XNY4+bIfkSBpuupfsKfUQ/f+8YlXnZQjJJ/T7FX84VfarKW4DXRo8lCegor4CFerIoGem7l08sE07oA=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2019 15:17:42.6428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 775c257a-75b4-4f12-b968-08d69bfd8faf
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5606
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

TL;DR: This doesn't appear to be ext4 specific, and seems to involve
an unholy combination of the perf_event_open(2) and sendfile(2) system
calls.

On Mon, Feb 25, 2019 at 10:50:05PM -0800, syzbot wrote:
> syzbot found the following crash on:
> 
> HEAD commit:    8a61716ff2ab Merge tag 'ceph-for-5.0-rc8' of git://github...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=161b71d4c00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
> dashboard link: https://syzkaller.appspot.com/bug?extid=7d19c5fe6a3f1161abb7
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103908f8c00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105e5cd0c00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com
> 
> audit: type=1400 audit(1550814986.750:36): avc:  denied  { map } for
> pid=8058 comm="syz-executor004" path="/root/syz-executor004991115"
> dev="sda1" ino=1426 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> hrtimer: interrupt took 42841 ns
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	(detected by 1, t=10502 jiffies, g=5873, q=2)
> rcu: All QSes seen, last rcu_preempt kthread activity 10502
> (4295059997-4295049495), jiffies_till_next_fqs=1, root ->qsmask 0x0
> syz-executor004 R  running task    26448  8069   8060 0x00000000

This particular repro seems to induce similar failures when I tried it
with xfs and btrfs as well as ext4.

The repro seems to involve the perf_event_open(2) and sendfile(2)
system calls, and killing the process which is performing the
sendfile(2).  The repro also uses the sched_setattr(2) system call,
but when I commented it out, the failure still happened, so this
appears to be another case of "Syzkaller?  We don't need to bug
developers with a minimal test case!  Open source developers are a
free unlimited resource, after all!"  :-)

Commenting out the perf_event_open(2) does seem to make the problem go
away.

Since there are zillions of ways to self-DOS a Linux server without
having to resert to exotic combination of system calls, this isn't
something I'm going to prioritize for myself, but I'm hoping someone
else has time and curiosity.

					- Ted

--7AUc2qLy4jB3hD7Z
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="repro.c"

// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/futex.h>

unsigned long long procid;

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
  char tmpdir_template[] = "./syzkaller.XXXXXX";
  char* tmpdir = mkdtemp(tmpdir_template);
  if (!tmpdir)
    exit(1);
  if (chmod(tmpdir, 0777))
    exit(1);
  if (chdir(tmpdir))
    exit(1);
}

static void thread_start(void* (*fn)(void*), void* arg)
{
  pthread_t th;
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setstacksize(&attr, 128 << 10);
  int i;
  for (i = 0; i < 100; i++) {
    if (pthread_create(&th, &attr, fn, arg) == 0) {
      pthread_attr_destroy(&attr);
      return;
    }
    if (errno == EAGAIN) {
      usleep(50);
      continue;
    }
    break;
  }
  exit(1);
}

#define BITMASK(bf_off, bf_len) (((1ull << (bf_len)) - 1) << (bf_off))
#define STORE_BY_BITMASK(type, htobe, addr, val, bf_off, bf_len)               \
  *(type*)(addr) =                                                             \
      htobe((htobe(*(type*)(addr)) & ~BITMASK((bf_off), (bf_len))) |           \
            (((type)(val) << (bf_off)) & BITMASK((bf_off), (bf_len))))

typedef struct {
  int state;
} event_t;

static void event_init(event_t* ev)
{
  ev->state = 0;
}

static void event_reset(event_t* ev)
{
  ev->state = 0;
}

static void event_set(event_t* ev)
{
  if (ev->state)
    exit(1);
  __atomic_store_n(&ev->state, 1, __ATOMIC_RELEASE);
  syscall(SYS_futex, &ev->state, FUTEX_WAKE | FUTEX_PRIVATE_FLAG);
}

static void event_wait(event_t* ev)
{
  while (!__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, 0);
}

static int event_isset(event_t* ev)
{
  return __atomic_load_n(&ev->state, __ATOMIC_ACQUIRE);
}

static int event_timedwait(event_t* ev, uint64_t timeout)
{
  uint64_t start = current_time_ms();
  uint64_t now = start;
  for (;;) {
    uint64_t remain = timeout - (now - start);
    struct timespec ts;
    ts.tv_sec = remain / 1000;
    ts.tv_nsec = (remain % 1000) * 1000 * 1000;
    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, &ts);
    if (__atomic_load_n(&ev->state, __ATOMIC_RELAXED))
      return 1;
    now = current_time_ms();
    if (now - start > timeout)
      return 0;
  }
}

#define FS_IOC_SETFLAGS _IOW('f', 2, long)
static void remove_dir(const char* dir)
{
  DIR* dp;
  struct dirent* ep;
  int iter = 0;
retry:
  while (umount2(dir, MNT_DETACH) == 0) {
  }
  dp = opendir(dir);
  if (dp == NULL) {
    if (errno == EMFILE) {
      exit(1);
    }
    exit(1);
  }
  while ((ep = readdir(dp))) {
    if (strcmp(ep->d_name, ".") == 0 || strcmp(ep->d_name, "..") == 0)
      continue;
    char filename[FILENAME_MAX];
    snprintf(filename, sizeof(filename), "%s/%s", dir, ep->d_name);
    while (umount2(filename, MNT_DETACH) == 0) {
    }
    struct stat st;
    if (lstat(filename, &st))
      exit(1);
    if (S_ISDIR(st.st_mode)) {
      remove_dir(filename);
      continue;
    }
    int i;
    for (i = 0;; i++) {
      if (unlink(filename) == 0)
        break;
      if (errno == EPERM) {
        int fd = open(filename, O_RDONLY);
        if (fd != -1) {
          long flags = 0;
          if (ioctl(fd, FS_IOC_SETFLAGS, &flags) == 0)
            close(fd);
          continue;
        }
      }
      if (errno == EROFS) {
        break;
      }
      if (errno != EBUSY || i > 100)
        exit(1);
      if (umount2(filename, MNT_DETACH))
        exit(1);
    }
  }
  closedir(dp);
  int i;
  for (i = 0;; i++) {
    if (rmdir(dir) == 0)
      break;
    if (i < 100) {
      if (errno == EPERM) {
        int fd = open(dir, O_RDONLY);
        if (fd != -1) {
          long flags = 0;
          if (ioctl(fd, FS_IOC_SETFLAGS, &flags) == 0)
            close(fd);
          continue;
        }
      }
      if (errno == EROFS) {
        break;
      }
      if (errno == EBUSY) {
        if (umount2(dir, MNT_DETACH))
          exit(1);
        continue;
      }
      if (errno == ENOTEMPTY) {
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
  int i;
  for (i = 0; i < 100; i++) {
    if (waitpid(-1, status, WNOHANG | __WALL) == pid)
      return;
    usleep(1000);
  }
  DIR* dir = opendir("/sys/fs/fuse/connections");
  if (dir) {
    for (;;) {
      struct dirent* ent = readdir(dir);
      if (!ent)
        break;
      if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
        continue;
      char abort[300];
      snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort",
               ent->d_name);
      int fd = open(abort, O_WRONLY);
      if (fd == -1) {
        continue;
      }
      if (write(fd, abort, 1) < 0) {
      }
      close(fd);
    }
    closedir(dir);
  } else {
  }
  while (waitpid(-1, status, __WALL) != pid) {
  }
}

#define SYZ_HAVE_SETUP_TEST 1
static void setup_test()
{
  prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
  setpgrp();
}

#define SYZ_HAVE_RESET_TEST 1
static void reset_test()
{
  int fd;
  for (fd = 3; fd < 30; fd++)
    close(fd);
}

struct thread_t {
  int created, call;
  event_t ready, done;
};

static struct thread_t threads[16];
static void execute_call(int call);
static int running;

static void* thr(void* arg)
{
  struct thread_t* th = (struct thread_t*)arg;
  for (;;) {
    event_wait(&th->ready);
    event_reset(&th->ready);
    execute_call(th->call);
    __atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
    event_set(&th->done);
  }
  return 0;
}

static void execute_one(void)
{
  int i, call, thread;
  int collide = 0;
again:
  for (call = 0; call < 5; call++) {
    for (thread = 0; thread < (int)(sizeof(threads) / sizeof(threads[0]));
         thread++) {
      struct thread_t* th = &threads[thread];
      if (!th->created) {
        th->created = 1;
        event_init(&th->ready);
        event_init(&th->done);
        event_set(&th->done);
        thread_start(thr, th);
      }
      if (!event_isset(&th->done))
        continue;
      event_reset(&th->done);
      th->call = call;
      __atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
      event_set(&th->ready);
      if (collide && (call % 2) == 0)
        break;
      event_timedwait(&th->done, 45);
      break;
    }
  }
  for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); i++)
    sleep_ms(1);
  if (!collide) {
    collide = 1;
    goto again;
  }
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
  int iter;
  for (iter = 0;; iter++) {
    char cwdbuf[32];
    sprintf(cwdbuf, "./%d", iter);
    if (mkdir(cwdbuf, 0777))
      exit(1);
    int pid = fork();
    if (pid < 0)
      exit(1);
    if (pid == 0) {
      if (chdir(cwdbuf))
        exit(1);
      setup_test();
      execute_one();
      reset_test();
      exit(0);
    }
    int status = 0;
    uint64_t start = current_time_ms();
    for (;;) {
      if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
        break;
      sleep_ms(1);
      if (current_time_ms() - start < 5 * 1000)
        continue;
      kill_and_wait(pid, &status);
      break;
    }
    remove_dir(cwdbuf);
  }
}
#ifndef __NR_sched_setattr
#define __NR_sched_setattr 314
#endif

uint64_t r[1] = {0xffffffffffffffff};

void execute_call(int call)
{
  long res;
  switch (call) {
  case 0:
    memcpy((void*)0x20000040, "./bus\000", 6);
    res = syscall(__NR_open, 0x20000040, 0x1fe, 0);
    if (res != -1)
      r[0] = res;
    break;
  case 1:
    memcpy((void*)0x200001c0, "\x15\x8a\xdd\x00", 4);
    syscall(__NR_write, r[0], 0x200001c0, 4);
    break;
  case 2:
    *(uint32_t*)0x20000800 = 1;
    *(uint32_t*)0x20000804 = 0x70;
    *(uint8_t*)0x20000808 = 0;
    *(uint8_t*)0x20000809 = 0;
    *(uint8_t*)0x2000080a = 0;
    *(uint8_t*)0x2000080b = 0;
    *(uint32_t*)0x2000080c = 0;
    *(uint64_t*)0x20000810 = 0x50a;
    *(uint64_t*)0x20000818 = 0;
    *(uint64_t*)0x20000820 = 0;
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 0, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 1, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 2, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 3, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 4, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 7, 5, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 6, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 7, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 8, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 9, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 10, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 11, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 12, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 13, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0x7fff, 14, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 15, 2);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 17, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 18, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 19, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 20, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 21, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 22, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 23, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 24, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 25, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 26, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 27, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 28, 1);
    STORE_BY_BITMASK(uint64_t, , 0x20000828, 0, 29, 35);
    *(uint32_t*)0x20000830 = 0;
    *(uint32_t*)0x20000834 = 0;
    *(uint64_t*)0x20000838 = 0;
    *(uint64_t*)0x20000840 = 0;
    *(uint64_t*)0x20000848 = 0;
    *(uint64_t*)0x20000850 = 0;
    *(uint32_t*)0x20000858 = 0;
    *(uint32_t*)0x2000085c = 0;
    *(uint64_t*)0x20000860 = 0;
    *(uint32_t*)0x20000868 = 0xfffffffd;
    *(uint16_t*)0x2000086c = 0;
    *(uint16_t*)0x2000086e = 0;
    syscall(__NR_perf_event_open, 0x20000800, 0, -1, -1, 0);
    break;
  case 3:
    *(uint64_t*)0x20000000 = 0;
    syscall(__NR_sendfile, r[0], r[0], 0x20000000, 0x8080fffffffe);
    break;
#if 0
  case 4:
    *(uint32_t*)0x200002c0 = 0;
    *(uint32_t*)0x200002c4 = 2;
    *(uint64_t*)0x200002c8 = 0;
    *(uint32_t*)0x200002d0 = 0;
    *(uint32_t*)0x200002d4 = 3;
    *(uint64_t*)0x200002d8 = 0;
    *(uint64_t*)0x200002e0 = 0;
    *(uint64_t*)0x200002e8 = 0;
    syscall(__NR_sched_setattr, 0, 0x200002c0, 0);
    break;
#endif
  }
}
int main(void)
{
  syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
  for (procid = 0; procid < 6; procid++) {
    if (fork() == 0) {
      use_temporary_dir();
      loop();
    }
  }
  sleep(1000000);
  return 0;
}

--7AUc2qLy4jB3hD7Z--
