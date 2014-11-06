From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [LKP] [jbd2] cc97f1a7c7e: +87.2% fsmark.files_per_sec
Date: Thu, 6 Nov 2014 10:43:56 -0500
Message-ID: <20141106154356.GA2928@thunk.org>
References: <20141106072314.GA16008@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	linux-ext4@vger.kernel.org
To: LKP <lkp@01.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42684 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaKFPoF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Nov 2014 10:44:05 -0500
Content-Disposition: inline
In-Reply-To: <20141106072314.GA16008@yliu-dev.sh.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kudo's to Jan and Yuanhan!

Cheers,

					- Ted

On Thu, Nov 06, 2014 at 03:23:14PM +0800, LKP wrote:
> FYI, we noticed the below good changes on
>=20
> commit cc97f1a7c7eed970e674b84be0e68f479c80228d ("jbd2: avoid pointle=
ss scanning of checkpoint lists")
>=20
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0  testbox/testcase/testpa=
rams
> ----------------  --------------------------  -----------------------=
----
>          %stddev     %change         %stddev
>              \          |                \ =20
>       6026 =B1  1%     +87.2%      11283 =B1  2%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       6026           +87.2%      11283        GEO-MEAN fsmark.files_p=
er_sec
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>   86294457 =B1  7%     -99.0%     822113 =B1 25%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>   86294457           -99.0%     822113        GEO-MEAN cpuidle.C1E-IV=
T.time
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     795159 =B1  5%     -99.9%        931 =B1 16%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     795159           -99.9%        931        GEO-MEAN cpuidle.C1E-IV=
T.usage
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      13012 =B1 36%     -68.0%       4169 =B1 45%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      13012           -68.0%       4168        GEO-MEAN sched_debug.cp=
u#15.sched_goidle
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      26135 =B1 36%     -67.9%       8395 =B1 45%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      26135           -67.9%       8395        GEO-MEAN sched_debug.cp=
u#15.nr_switches
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        890 =B1 36%    +154.2%       2263 =B1 29%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        890          +154.2%       2263        GEO-MEAN sched_debug.cf=
s_rq[39]:/.tg_load_contrib
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      13688 =B1 44%     -63.9%       4936 =B1 28%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      13688           -63.9%       4936        GEO-MEAN sched_debug.cp=
u#14.ttwu_count
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       1792 =B1 24%     -64.5%        636 =B1 37%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       1792           -64.5%        636        GEO-MEAN cpuidle.C3-IVT=
=2Eusage
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       2118 =B1 43%    +129.9%       4869 =B1 23%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       2118          +129.9%       4869        GEO-MEAN sched_debug.cf=
s_rq[25]:/.blocked_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     244970 =B1  2%     -52.1%     117231 =B1  1%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     244970           -52.1%     117231        GEO-MEAN cpuidle.C6-IVT=
=2Eusage
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       2175 =B1 41%    +126.3%       4923 =B1 24%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       2175          +126.3%       4922        GEO-MEAN sched_debug.cf=
s_rq[25]:/.tg_load_contrib
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      14419 =B1 28%     -58.4%       5996 =B1 17%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      14419           -58.4%       5996        GEO-MEAN sched_debug.cp=
u#14.sched_goidle
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      32555 =B1 25%     -54.4%      14859 =B1 17%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      32555           -54.4%      14859        GEO-MEAN sched_debug.cp=
u#14.nr_switches
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107876 =B1 13%     +72.7%     186283 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107876           +72.7%     186283        GEO-MEAN proc-vmstat.nr=
_dirty
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>  7.587e+09 =B1  1%     -46.5%  4.059e+09 =B1  2%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>  7.587e+09           -46.5%  4.059e+09        GEO-MEAN cpuidle.C6-IVT=
=2Etime
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     432452 =B1 13%     +72.2%     744607 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     432452           +72.2%     744607        GEO-MEAN meminfo.Dirty
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        107 =B1 44%     -49.7%         54 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        107           -49.7%         54        GEO-MEAN sched_debug.cp=
u#33.ttwu_count
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>    1190529 =B1  3%     +68.4%    2004907 =B1  0%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>    1190529           +68.4%    2004907        GEO-MEAN cpuidle.C1-IVT=
=2Eusage
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        190 =B1  0%     -39.3%        115 =B1  2%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        190           -39.3%        115        GEO-MEAN uptime.boot
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       8735 =B1  1%     -39.5%       5285 =B1  2%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       8735           -39.5%       5285        GEO-MEAN uptime.idle
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     106392 =B1  1%     -32.4%      71966 =B1 13%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     106392           -32.4%      71966        GEO-MEAN softirqs.RCU
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107085 =B1  0%     -35.3%      69240 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107085           -35.3%      69240        GEO-MEAN sched_debug.cp=
u#3.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107086 =B1  0%     -35.3%      69240 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107086           -35.3%      69240        GEO-MEAN sched_debug.cp=
u#2.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107086 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107086           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#10.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107088 =B1  0%     -35.3%      69244 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107088           -35.3%      69244        GEO-MEAN sched_debug.cp=
u#8.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107088 =B1  0%     -35.3%      69243 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107088           -35.3%      69243        GEO-MEAN sched_debug.cp=
u#7.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107087 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107087           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#9.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107083 =B1  0%     -35.3%      69244 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107083           -35.3%      69244        GEO-MEAN sched_debug.cp=
u#24.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107092 =B1  0%     -35.3%      69247 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107092           -35.3%      69247        GEO-MEAN sched_debug.cp=
u#16.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107073 =B1  0%     -35.3%      69237 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107073           -35.3%      69237        GEO-MEAN sched_debug.cp=
u#1.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107091 =B1  0%     -35.3%      69245 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107091           -35.3%      69245        GEO-MEAN sched_debug.cp=
u#28.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107090 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107090           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#27.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69245 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69245        GEO-MEAN sched_debug.cp=
u#17.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107086 =B1  0%     -35.3%      69245 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107086           -35.3%      69245        GEO-MEAN sched_debug.cp=
u#6.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107087 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107087           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#25.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107091 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107091           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#38.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107092 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107092           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#41.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107091 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107091           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#36.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#43.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#44.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#45.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#46.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#47.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107084 =B1  0%     -35.3%      69249 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107084           -35.3%      69249        GEO-MEAN sched_debug.cp=
u#26.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107092 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107092           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#30.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107089 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107089           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#29.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69245 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69245        GEO-MEAN sched_debug.cp=
u#31.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107090 =B1  0%     -35.3%      69245 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107090           -35.3%      69245        GEO-MEAN sched_debug.cp=
u#32.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107090 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107090           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#33.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107090 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107090           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#34.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107095 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107095           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#42.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107090 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107090           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#35.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107087 =B1  0%     -35.3%      69246 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107087           -35.3%      69246        GEO-MEAN sched_debug.cp=
u#13.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69250 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69250        GEO-MEAN sched_debug.cp=
u#37.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107088 =B1  0%     -35.3%      69247 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107088           -35.3%      69247        GEO-MEAN sched_debug.cp=
u#12.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107091 =B1  0%     -35.3%      69245 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107091           -35.3%      69245        GEO-MEAN sched_debug.cp=
u#23.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107090 =B1  0%     -35.3%      69249 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107090           -35.3%      69249        GEO-MEAN sched_debug.cp=
u#19.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107083 =B1  0%     -35.3%      69249 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107083           -35.3%      69249        GEO-MEAN sched_debug.cp=
u#4.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107092 =B1  0%     -35.3%      69247 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107092           -35.3%      69247        GEO-MEAN sched_debug.cp=
u#20.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107088 =B1  0%     -35.3%      69249 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107088           -35.3%      69249        GEO-MEAN sched_debug.cp=
u#5.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107084 =B1  0%     -35.3%      69249 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107084           -35.3%      69249        GEO-MEAN sched_debug.cp=
u#11.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107097 =B1  0%     -35.3%      69251 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107097           -35.3%      69251        GEO-MEAN sched_debug.sc=
hed_clk
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107097 =B1  0%     -35.3%      69251 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107097           -35.3%      69251        GEO-MEAN sched_debug.cp=
u_clk
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107089 =B1  0%     -35.3%      69248 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107089           -35.3%      69248        GEO-MEAN sched_debug.cp=
u#21.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107094 =B1  0%     -35.3%      69252 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107094           -35.3%      69252        GEO-MEAN sched_debug.cp=
u#15.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107089 =B1  0%     -35.3%      69250 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107089           -35.3%      69250        GEO-MEAN sched_debug.cp=
u#18.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107095 =B1  0%     -35.3%      69250 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107095           -35.3%      69250        GEO-MEAN sched_debug.cp=
u#40.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107087 =B1  0%     -35.3%      69252 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107087           -35.3%      69252        GEO-MEAN sched_debug.cp=
u#22.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107093 =B1  0%     -35.3%      69253 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107093           -35.3%      69253        GEO-MEAN sched_debug.cp=
u#39.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107065 =B1  0%     -35.3%      69234 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107065           -35.3%      69234        GEO-MEAN sched_debug.cp=
u#0.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     107094 =B1  0%     -35.3%      69253 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     107094           -35.3%      69253        GEO-MEAN sched_debug.cp=
u#14.clock
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        381 =B1  5%     +81.8%        692 =B1 31%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        381           +81.8%        692        GEO-MEAN sched_debug.cf=
s_rq[26]:/.tg_load_contrib
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        379 =B1  6%     +80.3%        684 =B1 32%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        379           +80.3%        684        GEO-MEAN sched_debug.cf=
s_rq[26]:/.blocked_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11427 =B1  3%     +57.5%      18000 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11427           +57.5%      18000        GEO-MEAN sched_debug.cf=
s_rq[44]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11405 =B1  3%     +58.0%      18019 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11405           +58.0%      18018        GEO-MEAN sched_debug.cf=
s_rq[45]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     104000 =B1  0%     -35.2%      67385 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     104000           -35.2%      67385        GEO-MEAN sched_debug.kt=
ime
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11379 =B1  3%     +58.2%      18001 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11379           +58.2%      18000        GEO-MEAN sched_debug.cf=
s_rq[46]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11388 =B1  3%     +58.3%      18023 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11388           +58.3%      18023        GEO-MEAN sched_debug.cf=
s_rq[47]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11395 =B1  3%     +55.7%      17744 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11395           +55.7%      17744        GEO-MEAN sched_debug.cf=
s_rq[31]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11382 =B1  4%     +56.6%      17829 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11382           +56.6%      17829        GEO-MEAN sched_debug.cf=
s_rq[36]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11379 =B1  3%     +57.4%      17915 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11379           +57.4%      17915        GEO-MEAN sched_debug.cf=
s_rq[39]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11415 =B1  3%     +56.2%      17835 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11415           +56.2%      17835        GEO-MEAN sched_debug.cf=
s_rq[35]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11408 =B1  3%     +55.5%      17736 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11407           +55.5%      17736        GEO-MEAN sched_debug.cf=
s_rq[33]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11401 =B1  3%     +57.4%      17941 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11401           +57.4%      17941        GEO-MEAN sched_debug.cf=
s_rq[42]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11402 =B1  3%     +57.4%      17942 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11402           +57.4%      17942        GEO-MEAN sched_debug.cf=
s_rq[43]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11398 =B1  3%     +57.3%      17932 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11398           +57.3%      17932        GEO-MEAN sched_debug.cf=
s_rq[41]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11412 =B1  3%     +55.2%      17716 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11412           +55.2%      17716        GEO-MEAN sched_debug.cf=
s_rq[32]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11384 =B1  3%     +57.1%      17882 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11383           +57.1%      17882        GEO-MEAN sched_debug.cf=
s_rq[38]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11408 =B1  3%     +57.1%      17917 =B1  6%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11408           +57.1%      17917        GEO-MEAN sched_debug.cf=
s_rq[40]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11419 =B1  3%     +55.6%      17770 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11419           +55.6%      17770        GEO-MEAN sched_debug.cf=
s_rq[34]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11369 =B1  3%     +55.4%      17669 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11369           +55.4%      17668        GEO-MEAN sched_debug.cf=
s_rq[29]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11391 =B1  3%     +55.5%      17711 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11391           +55.5%      17711        GEO-MEAN sched_debug.cf=
s_rq[30]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11373 =B1  3%     +55.1%      17644 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11373           +55.1%      17644        GEO-MEAN sched_debug.cf=
s_rq[28]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11407 =B1  4%     +56.4%      17839 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11407           +56.4%      17839        GEO-MEAN sched_debug.cf=
s_rq[37]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11385 =B1  3%     +54.9%      17638 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11385           +54.9%      17638        GEO-MEAN sched_debug.cf=
s_rq[16]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11389 =B1  4%     +56.2%      17790 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11389           +56.2%      17790        GEO-MEAN sched_debug.cf=
s_rq[24]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11388 =B1  4%     +56.3%      17800 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11388           +56.3%      17800        GEO-MEAN sched_debug.cf=
s_rq[23]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11399 =B1  4%     +56.0%      17782 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11398           +56.0%      17782        GEO-MEAN sched_debug.cf=
s_rq[25]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11339 =B1  3%     +55.9%      17678 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11338           +55.9%      17678        GEO-MEAN sched_debug.cf=
s_rq[18]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11391 =B1  4%     +55.7%      17742 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11391           +55.7%      17742        GEO-MEAN sched_debug.cf=
s_rq[26]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11335 =B1  4%     +56.0%      17682 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11334           +56.0%      17682        GEO-MEAN sched_debug.cf=
s_rq[19]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11330 =B1  4%     +56.0%      17670 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11329           +56.0%      17670        GEO-MEAN sched_debug.cf=
s_rq[20]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11361 =B1  4%     +56.7%      17803 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11361           +56.7%      17802        GEO-MEAN sched_debug.cf=
s_rq[21]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11374 =B1  4%     +56.5%      17803 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11373           +56.5%      17803        GEO-MEAN sched_debug.cf=
s_rq[22]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11329 =B1  3%     +55.8%      17652 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11329           +55.8%      17652        GEO-MEAN sched_debug.cf=
s_rq[17]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11364 =B1  4%     +54.3%      17540 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11364           +54.3%      17540        GEO-MEAN sched_debug.cf=
s_rq[14]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11378 =B1  3%     +54.7%      17597 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11378           +54.7%      17597        GEO-MEAN sched_debug.cf=
s_rq[15]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11344 =B1  4%     +54.7%      17552 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11344           +54.7%      17552        GEO-MEAN sched_debug.cf=
s_rq[13]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11407 =B1  3%     +54.5%      17623 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11407           +54.5%      17623        GEO-MEAN sched_debug.cf=
s_rq[27]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11350 =B1  4%     +55.1%      17608 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11350           +55.1%      17608        GEO-MEAN sched_debug.cf=
s_rq[12]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11375 =B1  4%     +53.8%      17492 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11375           +53.8%      17492        GEO-MEAN sched_debug.cf=
s_rq[8]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11369 =B1  4%     +54.2%      17536 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11368           +54.2%      17536        GEO-MEAN sched_debug.cf=
s_rq[11]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11408 =B1  5%     +53.6%      17523 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11407           +53.6%      17523        GEO-MEAN sched_debug.cf=
s_rq[7]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11492 =B1  4%     +54.1%      17704 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11492           +54.1%      17704        GEO-MEAN sched_debug.cf=
s_rq[5]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11550 =B1  4%     +56.0%      18022 =B1  8%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11550           +56.0%      18022        GEO-MEAN sched_debug.cf=
s_rq[4]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11366 =B1  4%     +53.9%      17493 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11366           +53.9%      17493        GEO-MEAN sched_debug.cf=
s_rq[9]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11748 =B1  4%     +55.0%      18209 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11748           +55.0%      18208        GEO-MEAN sched_debug.cf=
s_rq[1]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11411 =B1  5%     +53.1%      17466 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11411           +53.1%      17465        GEO-MEAN sched_debug.cf=
s_rq[6]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11385 =B1  4%     +53.6%      17487 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11385           +53.6%      17487        GEO-MEAN sched_debug.cf=
s_rq[10]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11835 =B1  4%     +54.6%      18293 =B1  7%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11834           +54.6%      18293        GEO-MEAN sched_debug.cf=
s_rq[0]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       1862 =B1 20%     +29.9%       2418 =B1 14%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       1862           +29.9%       2418        GEO-MEAN sched_debug.cf=
s_rq[25]:/.avg->runnable_avg_sum
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>         39 =B1 20%     +31.2%         52 =B1 14%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>         39           +31.2%         52        GEO-MEAN sched_debug.cf=
s_rq[25]:/.tg_runnable_contrib
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11642 =B1  4%     +55.3%      18079 =B1  8%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11642           +55.3%      18079        GEO-MEAN sched_debug.cf=
s_rq[3]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>         49 =B1 17%     +55.1%         76 =B1 21%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>         48           +55.1%         76        GEO-MEAN sched_debug.cp=
u#46.ttwu_count
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      11683 =B1  4%     +54.5%      18052 =B1  8%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      11683           +54.5%      18052        GEO-MEAN sched_debug.cf=
s_rq[2]:/.tg_load_avg
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     581872 =B1  4%     -27.2%     423323 =B1  1%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     581872           -27.2%     423323        GEO-MEAN proc-vmstat.pg=
fault
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       7910 =B1 11%     +35.8%      10744 =B1 15%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       7910           +35.8%      10744        GEO-MEAN sched_debug.cf=
s_rq[25]:/.min_vruntime
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        272 =B1 16%     -30.9%        188 =B1 22%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        272           -30.9%        188        GEO-MEAN sched_debug.cp=
u#41.ttwu_count
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     446764 =B1  3%     -20.9%     353422 =B1  1%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     446764           -20.9%     353422        GEO-MEAN proc-vmstat.pg=
free
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     112632 =B1  1%     -25.8%      83611 =B1 17%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     112632           -25.8%      83611        GEO-MEAN softirqs.SCHED
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       4606 =B1  5%     -17.0%       3824 =B1 11%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       4606           -17.0%       3824        GEO-MEAN slabinfo.dquot=
=2Enum_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        748 =B1 18%     -33.5%        497 =B1 20%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        748           -33.5%        497        GEO-MEAN slabinfo.ext4_=
allocation_context.num_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        748 =B1 18%     -33.5%        497 =B1 20%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        748           -33.5%        497        GEO-MEAN slabinfo.ext4_=
allocation_context.active_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        993 =B1 18%     -33.5%        660 =B1 20%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        993           -33.5%        660        GEO-MEAN slabinfo.jbd2_=
journal_handle.num_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        993 =B1 18%     -33.5%        660 =B1 20%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        993           -33.5%        660        GEO-MEAN slabinfo.jbd2_=
journal_handle.active_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        643 =B1 16%     -32.3%        435 =B1 20%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        643           -32.3%        435        GEO-MEAN slabinfo.ext4_=
io_end.num_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>        643 =B1 16%     -32.3%        435 =B1 20%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>        643           -32.3%        435        GEO-MEAN slabinfo.ext4_=
io_end.active_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       4561 =B1  4%     -16.2%       3822 =B1 11%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       4561           -16.2%       3822        GEO-MEAN slabinfo.dquot=
=2Eactive_objs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>         38 =B1  2%     +88.4%         71 =B1  3%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>         37           +88.4%         71        GEO-MEAN time.percent_o=
f_cpu_this_job_got
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     165.96 =B1  1%     -46.6%      88.67 =B1  2%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     165.96           -46.6%      88.67        GEO-MEAN time.elapsed_t=
ime
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>     311261 =B1  1%     +85.0%     575680 =B1  2%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>     311261           +85.0%     575680        GEO-MEAN vmstat.io.bo
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>      26582 =B1  1%     +76.2%      46834 =B1  2%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>      26582           +76.2%      46834        GEO-MEAN vmstat.system.=
cs
>=20
> 844749764b416ee2  cc97f1a7c7eed970e674b84be0 =20
> ----------------  -------------------------- =20
>       2.26 =B1  0%      +2.7%       2.32 =B1  1%  ivb43/fsmark/perfor=
mance-1x-1t-1BRD_32G-ext4-4K-4G-fsyncBeforeClose-1fpd
>       2.26            +2.7%       2.32        GEO-MEAN turbostat.%c0
>=20
> ivb43: Ivytown Ivy Bridge-EP
> Memory: 64G
>=20
>=20
>=20
>=20
>                                 fsmark.files_per_sec
>=20
>   12000 ++-----------------------------------------------------------=
-------+
>         O  O O  O  O  O O  O    O     O    O  O  O    O     O O  O  O=
  O    |
>   10000 ++                         O     O          O                =
       |
>         |                                                            =
       |
>         |                                                            =
       |
>    8000 ++                                                           =
       |
>         |                                                            =
       |
>    6000 *+.*.*..*..*..*.*..*..*.*..*..*..*.*..*..*..*.*..*..*.*..*..*=
=2E.*.*..*
>         |                                                            =
       |
>    4000 ++                                                           =
       |
>         |                                                            =
       |
>         |                                                            =
       |
>    2000 ++                                                           =
       |
>         |                                                            =
       |
>       0 ++-----------------------------------------------------------=
-------+
>=20
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample
>=20
> To reproduce:
>=20
> 	apt-get install ruby ruby-oj
> 	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-test=
s.git
> 	cd lkp-tests
> 	bin/setup-local job.yaml # the job file attached in this email
> 	bin/run-local   job.yaml
>=20
>=20
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are =
provided
> for informational purposes only. Any difference in system hardware or=
 software
> design or configuration may affect actual performance.

> ---
> testcase: fsmark
> default_monitors:
>   wait: pre-test
>   uptime:=20
>   iostat:=20
>   vmstat:=20
>   numa-numastat:=20
>   numa-vmstat:=20
>   numa-meminfo:=20
>   proc-vmstat:=20
>   proc-stat:=20
>   meminfo:=20
>   slabinfo:=20
>   interrupts:=20
>   lock_stat:=20
>   latency_stats:=20
>   softirqs:=20
>   bdi_dev_mapping:=20
>   diskstats:=20
>   cpuidle:=20
>   cpufreq:=20
>   turbostat:=20
>   sched_debug:
>     interval: 10
>   pmeter:=20
> default_watchdogs:
>   watch-oom:=20
>   watchdog:=20
> cpufreq_governor:
> - performance
> commit: cac7f2429872d3733dc3f9915857b1691da2eb2f
> model: Ivytown Ivy Bridge-EP
> nr_cpu: 48
> memory: 64G
> nr_hdd_partitions: 3
> hdd_partitions: "/dev/disk/by-id/ata-ST2000NM0011*-part1"
> rootfs_partition: "/dev/disk/by-id/ata-ST2000NM0011_Z1P67EBL-part3"
> swap_partitions: "/dev/disk/by-id/ata-ST2000NM0011_Z1P67EBL-part2"
> iterations: 1x
> nr_threads: 1t
> disk: 1BRD_32G
> need_memory: 48G
> fs:
> - ext4
> fs2:
> -=20
> fsmark:
>   filesize: 4K
>   test_size: 4G
>   sync_method: fsyncBeforeClose
>   nr_files_per_directory: 1fpd
> enqueue_time: 2014-10-28 11:07:59.352040504 +08:00
> testbox: ivb43
> tbox_group: ivb43
> kconfig: x86_64-rhel
> head_commit: 1dc9d2c43b9b25cc48ce37e86c906487e1cd9df6
> base_commit: cac7f2429872d3733dc3f9915857b1691da2eb2f
> branch: linux-devel/devel-hourly-2014102809
> kernel: "/kernel/x86_64-rhel/cac7f2429872d3733dc3f9915857b1691da2eb2f=
/vmlinuz-3.18.0-rc2"
> user: lkp
> queue: cyclic
> rootfs: debian-x86_64.cgz
> result_root: "/result/ivb43/fsmark/performance-1x-1t-1BRD_32G-ext4-4K=
-4G-fsyncBeforeClose-1fpd/debian-x86_64.cgz/x86_64-rhel/cac7f2429872d37=
33dc3f9915857b1691da2eb2f/0"
> job_file: "/lkp/scheduled/ivb43/cyclic_fsmark-performance-1x-1t-1BRD_=
32G-ext4-4K-4G-fsyncBeforeClose-1fpd-x86_64-rhel-BASE-cac7f2429872d3733=
dc3f9915857b1691da2eb2f-0.yaml"
> dequeue_time: 2014-10-28 11:19:28.081330731 +08:00
> job_state: finished
> loadavg: 1.08 0.39 0.14 1/422 6523
> start_time: '1414466414'
> end_time: '1414466506'
> version: "/lkp/lkp/.src-20141027-213532"

> echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_gove=
rnor
> echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_gover=
nor
> echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_gover=
nor
> mkfs -t ext4 -q -F /dev/ram0
> mount -t ext4 /dev/ram0 /fs/ram0
> ./fs_mark -d /fs/ram0/1 -D 1000000 -N 1 -n 1000000 -L 1 -S 1 -s 4096

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
