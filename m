From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: add block-based file punching hole support
Date: Fri, 28 Sep 2012 09:12:15 -0400
Message-ID: <20120928131215.GB13352@thunk.org>
References: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
 <1345695941-15053-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1345695941-15053-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 23, 2012 at 12:25:39PM +0800, Zheng Liu wrote:
> I run xfstests to do some tests, and I got an error from xfstests #
> 255.  The failure reason is that block-based file in ext4 cannot
> support fallocate(2) to allocate an unwritten blocks.  I am not sure
> whether we should change # 255 in xfstests or not.  So Cc' to Dave
> Chinner to get some feedbacks.

Zheng,

I gave these patches a quick try and I'm seeing many more failures
than just test #255.  Tests 75, 91, 112, 215, and 263 are also
failing, and I don't think it's all due to punch being supported w/o
fallocate support.

							- Ted

BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri Sep 28 01:42:51 EDT 2012
Device: /dev/vdd
mk2fs options: -q -O ^extents,^flex_bg,^uninit_bg
mount options: -o block_validity,nodelalloc
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.6.0-rc1-00068-gb2f1a8e
MKFS_OPTIONS  -- -q -O ^extents,^flex_bg,^uninit_bg /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc

001 6s ... 6s
002 0s ... 1s
003	 [not run] not suitable for this filesystem type: ext4
004	 [not run] not suitable for this filesystem type: ext4
005 0s ... 0s
006 5s ... 1s
007 1s ... 2s
008	 [not run] not suitable for this filesystem type: ext4
009	 [not run] not suitable for this filesystem type: ext4
011 11s ... 2s
012	 [not run] not suitable for this filesystem type: ext4
013 240s ... 83s
014 0s ... 3s
015 1s ... 1s
016	 [not run] not suitable for this filesystem type: ext4
017	 [not run] not suitable for this filesystem type: ext4
019	 [not run] not suitable for this filesystem type: ext4
020 1s ... 1s
021	 [not run] not suitable for this filesystem type: ext4
026	 [not run] xfsdump not found
027	 [not run] xfsdump not found
028	 [not run] xfsdump not found
029	 [not run] not suitable for this filesystem type: ext4
030	 [not run] not suitable for this filesystem type: ext4
031	 [not run] not suitable for this filesystem type: ext4
032	 [not run] not suitable for this filesystem type: ext4
033	 [not run] not suitable for this filesystem type: ext4
034	 [not run] not suitable for this filesystem type: ext4
045	 [not run] not suitable for this filesystem type: ext4
046	 [not run] xfsdump not found
048	 [not run] not suitable for this filesystem type: ext4
049	 [not run] not suitable for this filesystem type: ext4
050	 [not run] not suitable for this filesystem type: ext4
051	 [not run] not suitable for this filesystem type: ext4
052	 [not run] not suitable for this filesystem type: ext4
053 3s ... 7s
054	 [not run] not suitable for this filesystem type: ext4
056	 [not run] xfsdump not found
059	 [not run] xfsdump not found
060	 [not run] xfsdump not found
061	 [not run] xfsdump not found
062 3s ... 5s
063	 [not run] xfsdump not found
066	 [not run] xfsdump not found
067	 [not run] not suitable for this filesystem type: ext4
069 16s ... 19s
070 31s ... 39s
072	 [not run] not suitable for this filesystem type: ext4
075 163s ... [failed, exit status 1] - output mismatch (see 075.out.bad)
--- 075.out	2012-09-19 01:15:44.000000000 -0400
+++ 075.out.bad	2012-09-28 01:46:39.857494435 -0400
@@ -4,15 +4,4 @@
 -----------------------------------------------
 fsx.0 : -d -N numops -S 0
 -----------------------------------------------
-
------------------------------------------------
-fsx.1 : -d -N numops -S 0 -x
------------------------------------------------
-
------------------------------------------------
-fsx.2 : -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -d -N numops -l filelen -S 0 -x
------------------------------------------------
+    fsx (-d -N 1000 -S 0) failed, 0 - compare 075.0.{good,bad,fsxlog}
076 68s ... 74s
078	 [not run] not suitable for this filesystem type: ext4
079 2s ... 4s
085	 [not run] not suitable for this filesystem type: ext4
088 1s ... 1s
091 214s ... [failed, exit status 1] - output mismatch (see 091.out.bad)
--- 091.out	2012-09-19 01:15:44.000000000 -0400
+++ 091.out.bad	2012-09-28 01:48:10.427510912 -0400
@@ -1,7 +1,121 @@
 QA output created by 091
 fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
+fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+fsx: main: filesystem does not support fallocate, disabling
+: Operation not supported
+truncating to largest ever: 0x1f400
+truncating to largest ever: 0x4f000
+truncating to largest ever: 0x75400
+READ BAD DATA: offset = 0x7000, size = 0x9000, fname = /vdd/junk
+OFFSET	GOOD	BAD	RANGE
+0x c000	0x0000	0x2c77	0x    0
+operation# (mod 256) for the bad data may be 44
+0x c001	0x0000	0x772c	0x    1
+operation# (mod 256) for the bad data may be 44
+0x c002	0x0000	0x2c4b	0x    2
+operation# (mod 256) for the bad data may be 44
+0x c003	0x0000	0x4b2c	0x    3
+operation# (mod 256) for the bad data may be 44
+0x c004	0x0000	0x2ccf	0x    4
+operation# (mod 256) for the bad data may be 44
+0x c005	0x0000	0xcf2c	0x    5
+operation# (mod 256) for the bad data may be 44
+0x c006	0x0000	0x2cfa	0x    6
+operation# (mod 256) for the bad data may be 44
+0x c007	0x0000	0xfa2c	0x    7
+operation# (mod 256) for the bad data may be 44
+0x c008	0x0000	0x2cb4	0x    8
+operation# (mod 256) for the bad data may be 44
+0x c009	0x0000	0xb42c	0x    9
+operation# (mod 256) for the bad data may be 44
+0x c00a	0x0000	0x2c21	0x    a
+operation# (mod 256) for the bad data may be 44
+0x c00b	0x0000	0x212c	0x    b
+operation# (mod 256) for the bad data may be 44
+0x c00c	0x0000	0x2c78	0x    c
+operation# (mod 256) for the bad data may be 44
+0x c00d	0x0000	0x782c	0x    d
+operation# (mod 256) for the bad data may be 44
+0x c00e	0x0000	0x2cee	0x    e
+operation# (mod 256) for the bad data may be 44
+0x c00f	0x0000	0xee2c	0x    f
+operation# (mod 256) for the bad data may be 44
+LOG DUMP (75 total operations):
+1(  1 mod 256): SKIPPED (no operation)
+2(  2 mod 256): WRITE    0x62600 thru 0x6bdff	(0x9800 bytes) HOLE	***WWWW
+3(  3 mod 256): SKIPPED (no operation)
+4(  4 mod 256): WRITE    0x10c00 thru 0x11dff	(0x1200 bytes)
+5(  5 mod 256): TRUNCATE DOWN	from 0x6be00 to 0x1f400
+6(  6 mod 256): TRUNCATE DOWN	from 0x1f400 to 0x11e00
+7(  7 mod 256): WRITE    0x73400 thru 0x79fff	(0x6c00 bytes) HOLE
+8(  8 mod 256): WRITE    0x4a200 thru 0x4fbff	(0x5a00 bytes)
+9(  9 mod 256): WRITE    0x8e00 thru 0x171ff	(0xe400 bytes)	***WWWW
+10( 10 mod 256): WRITE    0x3400 thru 0xe1ff	(0xae00 bytes)	***WWWW
+11( 11 mod 256): SKIPPED (no operation)
+12( 12 mod 256): READ     0x72000 thru 0x78fff	(0x7000 bytes)
+13( 13 mod 256): READ     0x44000 thru 0x51fff	(0xe000 bytes)
+14( 14 mod 256): READ     0xa000 thru 0x11fff	(0x8000 bytes)	***RRRR***
+15( 15 mod 256): WRITE    0x27c00 thru 0x327ff	(0xac00 bytes)
+16( 16 mod 256): WRITE    0x54e00 thru 0x637ff	(0xea00 bytes)
+17( 17 mod 256): READ     0x54000 thru 0x5bfff	(0x8000 bytes)
+18( 18 mod 256): WRITE    0x13800 thru 0x205ff	(0xce00 bytes)
+19( 19 mod 256): PUNCH    0x58ea1 thru 0x62eff	(0xa05f bytes)
+20( 20 mod 256): TRUNCATE DOWN	from 0x7a000 to 0x4f000
+21( 21 mod 256): WRITE    0x4be00 thru 0x533ff	(0x7600 bytes) EXTEND
+22( 22 mod 256): WRITE    0x59000 thru 0x5edff	(0x5e00 bytes) HOLE
+23( 23 mod 256): READ     0x40000 thru 0x42fff	(0x3000 bytes)
+24( 24 mod 256): WRITE    0x35c00 thru 0x453ff	(0xf800 bytes)
+25( 25 mod 256): SKIPPED (no operation)
+26( 26 mod 256): PUNCH    0x1d981 thru 0x2b8f9	(0xdf79 bytes)
+27( 27 mod 256): READ     0x3f000 thru 0x44fff	(0x6000 bytes)
+28( 28 mod 256): READ     0xf000 thru 0x12fff	(0x4000 bytes)
+29( 29 mod 256): WRITE    0x6f600 thru 0x6f7ff	(0x200 bytes) HOLE
+30( 30 mod 256): READ     0x13000 thru 0x19fff	(0x7000 bytes)
+31( 31 mod 256): TRUNCATE UP	from 0x6f800 to 0x75400
+32( 32 mod 256): READ     0x4000 thru 0xafff	(0x7000 bytes)
+33( 33 mod 256): SKIPPED (no operation)
+34( 34 mod 256): SKIPPED (no operation)
+35( 35 mod 256): WRITE    0x44600 thru 0x531ff	(0xec00 bytes)
+36( 36 mod 256): READ     0x55000 thru 0x5efff	(0xa000 bytes)
+37( 37 mod 256): READ     0x3b000 thru 0x46fff	(0xc000 bytes)
+38( 38 mod 256): READ     0x44000 thru 0x52fff	(0xf000 bytes)
+39( 39 mod 256): WRITE    0x24800 thru 0x275ff	(0x2e00 bytes)
+40( 40 mod 256): READ     0x2f000 thru 0x3cfff	(0xe000 bytes)
+41( 41 mod 256): SKIPPED (no operation)
+42( 42 mod 256): READ     0x28000 thru 0x29fff	(0x2000 bytes)
+43( 43 mod 256): READ     0x68000 thru 0x73fff	(0xc000 bytes)
+44( 44 mod 256): WRITE    0xa800 thru 0xe9ff	(0x4200 bytes)	***WWWW
+45( 45 mod 256): WRITE    0x22600 thru 0x257ff	(0x3200 bytes)
+46( 46 mod 256): READ     0x2e000 thru 0x32fff	(0x5000 bytes)
+47( 47 mod 256): WRITE    0xf800 thru 0x191ff	(0x9a00 bytes)
+48( 48 mod 256): PUNCH    0x1e34b thru 0x271c5	(0x8e7b bytes)
+49( 49 mod 256): SKIPPED (no operation)
+50( 50 mod 256): READ     0x13000 thru 0x20fff	(0xe000 bytes)
+51( 51 mod 256): WRITE    0x24600 thru 0x25dff	(0x1800 bytes)
+52( 52 mod 256): SKIPPED (no operation)
+53( 53 mod 256): READ     0x2c000 thru 0x33fff	(0x8000 bytes)
+54( 54 mod 256): SKIPPED (no operation)
+55( 55 mod 256): SKIPPED (no operation)
+56( 56 mod 256): TRUNCATE DOWN	from 0x75400 to 0x1a600
+57( 57 mod 256): READ     0x7000 thru 0x7fff	(0x1000 bytes)
+58( 58 mod 256): SKIPPED (no operation)
+59( 59 mod 256): READ     0x15000 thru 0x16fff	(0x2000 bytes)
+60( 60 mod 256): TRUNCATE UP	from 0x1a600 to 0x5a600
+61( 61 mod 256): READ     0x21000 thru 0x24fff	(0x4000 bytes)
+62( 62 mod 256): READ     0x3b000 thru 0x3efff	(0x4000 bytes)
+63( 63 mod 256): PUNCH    0x10ba5 thru 0x16a43	(0x5e9f bytes)
+64( 64 mod 256): PUNCH    0x6f09 thru 0xc536	(0x562e bytes)	******PPPP
+65( 65 mod 256): SKIPPED (no operation)
+66( 66 mod 256): SKIPPED (no operation)
+67( 67 mod 256): READ     0x52000 thru 0x55fff	(0x4000 bytes)
+68( 68 mod 256): PUNCH    0x2ef43 thru 0x3d7a7	(0xe865 bytes)
+69( 69 mod 256): READ     0x30000 thru 0x39fff	(0xa000 bytes)
+70( 70 mod 256): WRITE    0x72200 thru 0x77bff	(0x5a00 bytes) HOLE
+71( 71 mod 256): WRITE    0x21200 thru 0x2cbff	(0xba00 bytes)
+72( 72 mod 256): PUNCH    0x31d83 thru 0x3e994	(0xcc12 bytes)
+73( 73 mod 256): PUNCH    0x1b19e thru 0x1f8b2	(0x4715 bytes)
+74( 74 mod 256): WRITE    0x6c000 thru 0x78bff	(0xcc00 bytes) EXTEND
+75( 75 mod 256): READ     0x7000 thru 0xffff	(0x9000 bytes)	***RRRR***
+Correct content saved for comparison
+(maybe hexdump "/vdd/junk" vs "/vdd/junk.fsxgood")
092	 [not run] not suitable for this filesystem type: ext4
096	 [not run] not suitable for this filesystem type: ext4
103	 [not run] not suitable for this filesystem type: ext4
105 3s ... 4s
108	 [not run] not suitable for this filesystem type: ext4
112 162s ... [failed, exit status 1] - output mismatch (see 112.out.bad)
--- 112.out	2012-09-19 01:15:44.000000000 -0400
+++ 112.out.bad	2012-09-28 01:48:24.467513558 -0400
@@ -4,15 +4,5 @@
 -----------------------------------------------
 fsx.0 : -A -d -N numops -S 0
 -----------------------------------------------
-
------------------------------------------------
-fsx.1 : -A -d -N numops -S 0 -x
------------------------------------------------
-
------------------------------------------------
-fsx.2 : -A -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -A -d -N numops -l filelen -S 0 -x
------------------------------------------------
+    fsx (-A -d -N 1000 -S 0) returned 0 - see 112.0.full
+mv: cannot stat `112.0.fsxlog': No such file or directory
113 354s ... 163s
116	 [not run] not suitable for this filesystem type: ext4
117 38s ... 43s
118	 [not run] not suitable for this filesystem type: ext4
120 18s ... 19s
121	 [not run] not suitable for this filesystem type: ext4
122	 [not run] not suitable for this filesystem type: ext4
123 0s ... 1s
124 38s ... 12s
126 1s ... 1s
128 3s ... 5s
129 13s ... 20s
130 7s ... 17s
131 2s ... 2s
134	 [not run] not suitable for this filesystem type: ext4
135 3s ... 5s
141 3s ... 4s
164	 [not run] not suitable for this filesystem type: ext4
165	 [not run] not suitable for this filesystem type: ext4
166	 [not run] not suitable for this filesystem type: ext4
169 3s ... 5s
170	 [not run] not suitable for this filesystem type: ext4
181	 [not run] not suitable for this filesystem type: ext4
183	 [not run] not suitable for this filesystem type: ext4
184 0s ... 0s
186	 [not run] not suitable for this filesystem type: ext4
187	 [not run] not suitable for this filesystem type: ext4
189	 [not run] not suitable for this filesystem type: ext4
190	 [not run] not suitable for this filesystem type: ext4
193 1s ... 1s
195	 [not run] not suitable for this filesystem type: ext4
196	 [not run] not suitable for this filesystem type: ext4
197	 [not run] not suitable for this filesystem type: ext4
198 2s ... 3s
199	 [not run] not suitable for this filesystem type: ext4
200	 [not run] not suitable for this filesystem type: ext4
201	 [not run] not suitable for this filesystem type: ext4
202	 [not run] not suitable for this filesystem type: ext4
206	 [not run] not suitable for this filesystem type: ext4
207 3s ... 2s
210 0s ... 0s
211 0s ... 0s
212 0s ... 0s
213 2s ... [not run] xfs_io fallocate command failed (old kernel/wrong fs?)
214 0s ... [not run] xfs_io fallocate command failed (old kernel/wrong fs?)
215 3s ... - output mismatch (see 215.out.bad)
--- 215.out	2012-09-19 01:15:44.000000000 -0400
+++ 215.out.bad	2012-09-28 01:54:30.624213770 -0400
@@ -5,4 +5,6 @@
 4096+0 records out
 
 writing via mmap
+FAIL: mtime not update after mapped write
+FAIL: ctime not update after mapped write
 *** done
216	 [not run] not suitable for this filesystem type: ext4
218	 [not run] /usr/bin/e4defrag utility required, skipped this test
219 4s ... 6s
220	 [not run] not suitable for this filesystem type: ext4
221 2s ... 2s
222	 [not run] not suitable for this filesystem type: ext4
223 17s ... [not run] xfs_io fallocate command failed (old kernel/wrong fs?)
225 10s ... 12s
228 1s ... [not run] xfs_io fallocate command failed (old kernel/wrong fs?)
230 16s ... 18s
235 3s ... 5s
236 2s ... 1s
237 0s ... 0s
238	 [not run] not suitable for this filesystem type: ext4
240 1s ... 1s
242	 [not run] not suitable for this filesystem type: ext4
243 2s ... [not run] xfs_io fallocate command failed (old kernel/wrong fs?)
244	 [not run] not suitable for this filesystem type: ext4
245 1s ... 0s
246 1s ... 0s
247 27s ... 27s
248 1s ... 0s
249 2s ... 2s
250	 [not run] not suitable for this filesystem type: ext4
252	 [not run] not suitable for this filesystem type: ext4
253	 [not run] not suitable for this filesystem type: ext4
254	 [not run] not suitable for this filesystem type: ext4
255 3s ... - output mismatch (see 255.out.bad)
--- 255.out	2012-09-19 01:15:44.000000000 -0400
+++ 255.out.bad	2012-09-28 01:56:32.830894233 -0400
@@ -7,9 +7,7 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	4. hole -> data
 0: [0..23]: hole
@@ -17,43 +15,39 @@
 2: [32..39]: hole
 cc63069677939f69a6e8f68cae6a6dac
 	5. hole -> unwritten
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	6. data -> hole
 0: [0..7]: extent
 1: [8..39]: hole
 1b3779878366498b28c702ef88c4a773
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
+1: [8..39]: hole
 1b3779878366498b28c702ef88c4a773
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..39]: hole
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
+fallocate: Operation not supported
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
 cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
 daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
@@ -81,9 +75,7 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	4. hole -> data
 0: [0..23]: hole
@@ -91,43 +83,39 @@
 2: [32..39]: hole
 cc63069677939f69a6e8f68cae6a6dac
 	5. hole -> unwritten
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	6. data -> hole
 0: [0..7]: extent
 1: [8..39]: hole
 1b3779878366498b28c702ef88c4a773
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
+1: [8..39]: hole
 1b3779878366498b28c702ef88c4a773
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..39]: hole
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
+fallocate: Operation not supported
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
 cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
 daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
+fallocate: Operation not supported
 daa100df6e6711906b61c9ab5aa16032
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
@@ -157,6 +145,7 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
@@ -167,6 +156,7 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	5. hole -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
@@ -177,16 +167,19 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	8. unwritten -> hole
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	9. unwritten -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
@@ -197,16 +190,19 @@
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
@@ -236,6 +232,7 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
@@ -246,6 +243,7 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	5. hole -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
@@ -256,16 +254,19 @@
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	8. unwritten -> hole
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
 cc58a7417c2d7763adc45b6fcd3fa024
 	9. unwritten -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..23]: hole
 2: [24..39]: extent
@@ -276,16 +277,19 @@
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
 f6aeca13ec49e5b266cd1c913cd726e3
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..7]: extent
 1: [8..31]: hole
 2: [32..39]: extent
256 88s ... 39s
257 1s ... 1s
258 1s ... 1s
259	 [not run] not suitable for this filesystem type: ext4
260	 [not run] FSTRIM is not supported
261	 [not run] not suitable for this filesystem type: ext4
262	 [not run] not suitable for this filesystem type: ext4
263 165s ... [failed, exit status 1] - output mismatch (see 263.out.bad)
--- 263.out	2012-09-19 01:15:44.000000000 -0400
+++ 263.out.bad	2012-09-28 01:57:30.644238169 -0400
@@ -1,3 +1,248 @@
 QA output created by 263
 fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
-fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+fsx: main: filesystem does not support fallocate, disabling
+: Operation not supported
+truncating to largest ever: 0x1f400
+truncating to largest ever: 0x4f000
+truncating to largest ever: 0x75400
+truncating to largest ever: 0x76e00
+READ BAD DATA: offset = 0xf000, size = 0xb09, fname = /vdd/junk
+OFFSET	GOOD	BAD	RANGE
+0x f000	0x0000	0xc330	0x    0
+operation# (mod 256) for the bad data may be 195
+0x f001	0x0000	0x30c3	0x    1
+operation# (mod 256) for the bad data may be 195
+0x f002	0x0000	0xc36e	0x    2
+operation# (mod 256) for the bad data may be 195
+0x f003	0x0000	0x6ec3	0x    3
+operation# (mod 256) for the bad data may be 195
+0x f004	0x0000	0xc35e	0x    4
+operation# (mod 256) for the bad data may be 195
+0x f005	0x0000	0x5ec3	0x    5
+operation# (mod 256) for the bad data may be 195
+0x f006	0x0000	0xc340	0x    6
+operation# (mod 256) for the bad data may be 195
+0x f007	0x0000	0x40c3	0x    7
+operation# (mod 256) for the bad data may be 195
+0x f008	0x0000	0xc37b	0x    8
+operation# (mod 256) for the bad data may be 195
+0x f009	0x0000	0x7bc3	0x    9
+operation# (mod 256) for the bad data may be 195
+0x f00a	0x0000	0xc37e	0x    a
+operation# (mod 256) for the bad data may be 195
+0x f00b	0x0000	0x7ec3	0x    b
+operation# (mod 256) for the bad data may be 195
+0x f00c	0x0000	0xc3c8	0x    c
+operation# (mod 256) for the bad data may be 195
+0x f00d	0x0000	0xc8c3	0x    d
+operation# (mod 256) for the bad data may be 195
+0x f00e	0x0000	0xc30d	0x    e
+operation# (mod 256) for the bad data may be 195
+0x f00f	0x0000	0x0dc3	0x    f
+operation# (mod 256) for the bad data may be 195
+LOG DUMP (202 total operations):
+1(  1 mod 256): SKIPPED (no operation)
+2(  2 mod 256): MAPWRITE 0x62600 thru 0x626e8	(0xe9 bytes)
+3(  3 mod 256): SKIPPED (no operation)
+4(  4 mod 256): WRITE    0x10c00 thru 0x111ff	(0x600 bytes)
+5(  5 mod 256): TRUNCATE DOWN	from 0x626e9 to 0x1f400
+6(  6 mod 256): TRUNCATE DOWN	from 0x1f400 to 0x11e00
+7(  7 mod 256): WRITE    0x73400 thru 0x745ff	(0x1200 bytes) HOLE
+8(  8 mod 256): WRITE    0x4a200 thru 0x4a3ff	(0x200 bytes)
+9(  9 mod 256): MAPWRITE 0x8e00 thru 0x9ef9	(0x10fa bytes)
+10( 10 mod 256): WRITE    0x3400 thru 0x37ff	(0x400 bytes)
+11( 11 mod 256): MAPWRITE 0x79e00 thru 0x79f55	(0x156 bytes)
+12( 12 mod 256): SKIPPED (no operation)
+13( 13 mod 256): SKIPPED (no operation)
+14( 14 mod 256): MAPREAD  0xb000 thru 0xb2bf	(0x2c0 bytes)
+15( 15 mod 256): MAPWRITE 0x27c00 thru 0x2923d	(0x163e bytes)
+16( 16 mod 256): WRITE    0x54e00 thru 0x551ff	(0x400 bytes)
+17( 17 mod 256): READ     0x69000 thru 0x69fff	(0x1000 bytes)
+18( 18 mod 256): MAPWRITE 0x13800 thru 0x13f40	(0x741 bytes)
+19( 19 mod 256): PUNCH    0x107dd thru 0x11beb	(0x140f bytes)
+20( 20 mod 256): TRUNCATE DOWN	from 0x79f56 to 0x4f000
+21( 21 mod 256): MAPWRITE 0x4be00 thru 0x4cc59	(0xe5a bytes)
+22( 22 mod 256): WRITE    0x59000 thru 0x59dff	(0xe00 bytes) HOLE
+23( 23 mod 256): READ     0xc000 thru 0xcfff	(0x1000 bytes)
+24( 24 mod 256): WRITE    0x35c00 thru 0x369ff	(0xe00 bytes)
+25( 25 mod 256): SKIPPED (no operation)
+26( 26 mod 256): PUNCH    0x32181 thru 0x32dae	(0xc2e bytes)
+27( 27 mod 256): MAPREAD  0x3f000 thru 0x3f188	(0x189 bytes)
+28( 28 mod 256): MAPREAD  0x19000 thru 0x1ae43	(0x1e44 bytes)
+29( 29 mod 256): WRITE    0x6f600 thru 0x705ff	(0x1000 bytes) HOLE
+30( 30 mod 256): MAPREAD  0x5b000 thru 0x5c99e	(0x199f bytes)
+31( 31 mod 256): TRUNCATE UP	from 0x70600 to 0x75400
+32( 32 mod 256): MAPREAD  0x4000 thru 0x54d5	(0x14d6 bytes)
+33( 33 mod 256): SKIPPED (no operation)
+34( 34 mod 256): SKIPPED (no operation)
+35( 35 mod 256): WRITE    0x44600 thru 0x44bff	(0x600 bytes)
+36( 36 mod 256): SKIPPED (no operation)
+37( 37 mod 256): SKIPPED (no operation)
+38( 38 mod 256): MAPREAD  0x44000 thru 0x441de	(0x1df bytes)
+39( 39 mod 256): MAPWRITE 0x24800 thru 0x25d8f	(0x1590 bytes)
+40( 40 mod 256): SKIPPED (no operation)
+41( 41 mod 256): SKIPPED (no operation)
+42( 42 mod 256): MAPREAD  0x28000 thru 0x2979a	(0x179b bytes)
+43( 43 mod 256): SKIPPED (no operation)
+44( 44 mod 256): MAPWRITE 0xa800 thru 0xacf2	(0x4f3 bytes)
+45( 45 mod 256): MAPWRITE 0x22600 thru 0x24508	(0x1f09 bytes)
+46( 46 mod 256): MAPREAD  0x2e000 thru 0x2f596	(0x1597 bytes)
+47( 47 mod 256): WRITE    0xf800 thru 0x10fff	(0x1800 bytes)
+48( 48 mod 256): PUNCH    0x1e34b thru 0x1e357	(0xd bytes)
+49( 49 mod 256): SKIPPED (no operation)
+50( 50 mod 256): MAPREAD  0x13000 thru 0x1309d	(0x9e bytes)
+51( 51 mod 256): WRITE    0x24600 thru 0x25dff	(0x1800 bytes)
+52( 52 mod 256): SKIPPED (no operation)
+53( 53 mod 256): MAPREAD  0x2c000 thru 0x2d734	(0x1735 bytes)
+54( 54 mod 256): SKIPPED (no operation)
+55( 55 mod 256): SKIPPED (no operation)
+56( 56 mod 256): TRUNCATE DOWN	from 0x75400 to 0x1a600
+57( 57 mod 256): MAPREAD  0x7000 thru 0x760b	(0x60c bytes)
+58( 58 mod 256): SKIPPED (no operation)
+59( 59 mod 256): SKIPPED (no operation)
+60( 60 mod 256): TRUNCATE UP	from 0x1a600 to 0x5a600
+61( 61 mod 256): READ     0x21000 thru 0x21fff	(0x1000 bytes)
+62( 62 mod 256): READ     0x3b000 thru 0x3bfff	(0x1000 bytes)
+63( 63 mod 256): PUNCH    0x10ba5 thru 0x10db1	(0x20d bytes)
+64( 64 mod 256): PUNCH    0x6f09 thru 0x806a	(0x1162 bytes)
+65( 65 mod 256): SKIPPED (no operation)
+66( 66 mod 256): SKIPPED (no operation)
+67( 67 mod 256): MAPREAD  0x52000 thru 0x521b2	(0x1b3 bytes)
+68( 68 mod 256): PUNCH    0x2ef43 thru 0x2fb51	(0xc0f bytes)
+69( 69 mod 256): SKIPPED (no operation)
+70( 70 mod 256): MAPWRITE 0x72200 thru 0x73d0d	(0x1b0e bytes)
+71( 71 mod 256): MAPWRITE 0x21200 thru 0x21f14	(0xd15 bytes)
+72( 72 mod 256): PUNCH    0x426bd thru 0x442eb	(0x1c2f bytes)
+73( 73 mod 256): PUNCH    0x66018 thru 0x66d3f	(0xd28 bytes)
+74( 74 mod 256): MAPWRITE 0x6c000 thru 0x6db45	(0x1b46 bytes)
+75( 75 mod 256): READ     0x3d000 thru 0x3dfff	(0x1000 bytes)
+76( 76 mod 256): READ     0x34000 thru 0x34fff	(0x1000 bytes)
+77( 77 mod 256): MAPREAD  0x20000 thru 0x218f5	(0x18f6 bytes)
+78( 78 mod 256): MAPREAD  0x29000 thru 0x2a1a6	(0x11a7 bytes)
+79( 79 mod 256): READ     0x62000 thru 0x62fff	(0x1000 bytes)
+80( 80 mod 256): PUNCH    0x33108 thru 0x347ea	(0x16e3 bytes)
+81( 81 mod 256): MAPWRITE 0x2be00 thru 0x2c035	(0x236 bytes)
+82( 82 mod 256): TRUNCATE DOWN	from 0x73d0e to 0x14e00
+83( 83 mod 256): MAPWRITE 0x33800 thru 0x355a6	(0x1da7 bytes)
+84( 84 mod 256): SKIPPED (no operation)
+85( 85 mod 256): MAPREAD  0x2000 thru 0x3e54	(0x1e55 bytes)
+86( 86 mod 256): MAPREAD  0x5000 thru 0x6c7f	(0x1c80 bytes)
+87( 87 mod 256): MAPREAD  0x8000 thru 0x9845	(0x1846 bytes)
+88( 88 mod 256): PUNCH    0x27626 thru 0x29575	(0x1f50 bytes)
+89( 89 mod 256): SKIPPED (no operation)
+90( 90 mod 256): SKIPPED (no operation)
+91( 91 mod 256): WRITE    0x1ca00 thru 0x1e5ff	(0x1c00 bytes)
+92( 92 mod 256): MAPREAD  0xf000 thru 0xfcbe	(0xcbf bytes)	***RRRR***
+93( 93 mod 256): MAPWRITE 0x6f600 thru 0x7035d	(0xd5e bytes)
+94( 94 mod 256): READ     0x22000 thru 0x22fff	(0x1000 bytes)
+95( 95 mod 256): WRITE    0x41600 thru 0x421ff	(0xc00 bytes)
+96( 96 mod 256): MAPREAD  0x7000 thru 0x7e8b	(0xe8c bytes)
+97( 97 mod 256): PUNCH    0x2fad9 thru 0x301f3	(0x71b bytes)
+98( 98 mod 256): READ     0xf000 thru 0xffff	(0x1000 bytes)	***RRRR***
+99( 99 mod 256): READ     0xa000 thru 0xafff	(0x1000 bytes)
+100(100 mod 256): PUNCH    0x1b784 thru 0x1d0ac	(0x1929 bytes)
+101(101 mod 256): MAPWRITE 0x56400 thru 0x57e85	(0x1a86 bytes)
+102(102 mod 256): MAPREAD  0x2c000 thru 0x2dc1b	(0x1c1c bytes)
+103(103 mod 256): MAPWRITE 0x60a00 thru 0x60eb3	(0x4b4 bytes)
+104(104 mod 256): MAPREAD  0x65000 thru 0x65c2e	(0xc2f bytes)
+105(105 mod 256): SKIPPED (no operation)
+106(106 mod 256): TRUNCATE DOWN	from 0x7035e to 0x3200	******WWWW
+107(107 mod 256): PUNCH    0x165a thru 0x2b4a	(0x14f1 bytes)
+108(108 mod 256): PUNCH    0x31c6 thru 0x31ff	(0x3a bytes)
+109(109 mod 256): SKIPPED (no operation)
+110(110 mod 256): MAPWRITE 0x4600 thru 0x58e8	(0x12e9 bytes)
+111(111 mod 256)[ 5085.746283] serial8250: too much work for irq4
: TRUNCATE UP	from 0x58e9 to 0x6ac00	******WWWW
+112(112 mod 256): PUNCH    0x37e86 thru 0x39074	(0x11ef bytes)
+113(113 mod 256): PUNCH    0x41e96 thru 0x43c8d	(0x1df8 bytes)
+114(114 mod 256): SKIPPED (no operation)
+115(115 mod 256): PUNCH    0x10182 thru 0x11000	(0xe7f bytes)
+116(116 mod 256): SKIPPED (no operation)
+117(117 mod 256): READ     0x28000 thru 0x28fff	(0x1000 bytes)
+118(118 mod 256): MAPREAD  0x2f000 thru 0x307ba	(0x17bb bytes)
+119(119 mod 256): TRUNCATE DOWN	from 0x6ac00 to 0x36e00
+120(120 mod 256): SKIPPED (no operation)
+121(121 mod 256): MAPREAD  0x1d000 thru 0x1e896	(0x1897 bytes)
+122(122 mod 256): TRUNCATE UP	from 0x36e00 to 0x69800
+123(123 mod 256): READ     0x4a000 thru 0x4afff	(0x1000 bytes)
+124(124 mod 256): PUNCH    0x23efa thru 0x24efd	(0x1004 bytes)
+125(125 mod 256): PUNCH    0x5fa4 thru 0x799b	(0x19f8 bytes)
+126(126 mod 256): SKIPPED (no operation)
+127(127 mod 256): SKIPPED (no operation)
+128(128 mod 256): WRITE    0x59a00 thru 0x5a5ff	(0xc00 bytes)
+129(129 mod 256): WRITE    0xee00 thru 0xffff	(0x1200 bytes)	***WWWW
+130(130 mod 256): WRITE    0xb000 thru 0xc5ff	(0x1600 bytes)
+131(131 mod 256): SKIPPED (no operation)
+132(132 mod 256): SKIPPED (no operation)
+133(133 mod 256): READ     0x66000 thru 0x66fff	(0x1000 bytes)
+134(134 mod 256): PUNCH    0x65c89 thru 0x663ae	(0x726 bytes)
+135(135 mod 256): WRITE    0x36e00 thru 0x377ff	(0xa00 bytes)
+136(136 mod 256): PUNCH    0x1a470 thru 0x1a76a	(0x2fb bytes)
+137(137 mod 256): PUNCH    0x4a424 thru 0x4a9bd	(0x59a bytes)
+138(138 mod 256): MAPWRITE 0x32600 thru 0x33e37	(0x1838 bytes)
+139(139 mod 256): TRUNCATE DOWN	from 0x69800 to 0x6600	******WWWW
+140(140 mod 256): MAPREAD  0x1000 thru 0x1a3e	(0xa3f bytes)
+141(141 mod 256): READ     0x1000 thru 0x1fff	(0x1000 bytes)
+142(142 mod 256): READ     0x3000 thru 0x3fff	(0x1000 bytes)
+143(143 mod 256): MAPWRITE 0x60800 thru 0x62048	(0x1849 bytes)
+144(144 mod 256): MAPREAD  0x4f000 thru 0x4f015	(0x16 bytes)
+145(145 mod 256): MAPWRITE 0x36400 thru 0x36a96	(0x697 bytes)
+146(146 mod 256): TRUNCATE DOWN	from 0x62049 to 0x34e00
+147(147 mod 256): READ     0x1d000 thru 0x1dfff	(0x1000 bytes)
+148(148 mod 256): WRITE    0x15c00 thru 0x177ff	(0x1c00 bytes)
+149(149 mod 256): SKIPPED (no operation)
+150(150 mod 256): PUNCH    0x32154 thru 0x329bf	(0x86c bytes)
+151(151 mod 256): MAPWRITE 0x6f800 thru 0x6fdad	(0x5ae bytes)
+152(152 mod 256): WRITE    0x2be00 thru 0x2c9ff	(0xc00 bytes)
+153(153 mod 256): PUNCH    0x43c3b thru 0x44877	(0xc3d bytes)
+154(154 mod 256): TRUNCATE UP	from 0x6fdae to 0x76e00
+155(155 mod 256): MAPWRITE 0xe00 thru 0x2802	(0x1a03 bytes)
+156(156 mod 256): PUNCH    0x39bc9 thru 0x3a296	(0x6ce bytes)
+157(157 mod 256): SKIPPED (no operation)
+158(158 mod 256): READ     0x53000 thru 0x53fff	(0x1000 bytes)
+159(159 mod 256): MAPREAD  0x4e000 thru 0x4f8be	(0x18bf bytes)
+160(160 mod 256): MAPWRITE 0x38400 thru 0x39cee	(0x18ef bytes)
+161(161 mod 256): MAPREAD  0x72000 thru 0x72f1b	(0xf1c bytes)
+162(162 mod 256): WRITE    0x36800 thru 0x36dff	(0x600 bytes)
+163(163 mod 256): TRUNCATE DOWN	from 0x76e00 to 0x2b400
+164(164 mod 256): WRITE    0x25800 thru 0x263ff	(0xc00 bytes)
+165(165 mod 256): READ     0x3000 thru 0x3fff	(0x1000 bytes)
+166(166 mod 256): TRUNCATE UP	from 0x2b400 to 0x4e400
+167(167 mod 256): TRUNCATE UP	from 0x4e400 to 0x6de00
+168(168 mod 256): MAPREAD  0x36000 thru 0x367a7	(0x7a8 bytes)
+169(169 mod 256): MAPREAD  0x8000 thru 0x958e	(0x158f bytes)
+170(170 mod 256): SKIPPED (no operation)
+171(171 mod 256): TRUNCATE DOWN	from 0x6de00 to 0x3c00	******WWWW
+172(172 mod 256): TRUNCATE UP	from 0x3c00 to 0x2e200	******WWWW
+173(173 mod 256): TRUNCATE DOWN	from 0x2e200 to 0x23400
+174(174 mod 256): TRUNCATE DOWN	from 0x23400 to 0xac00	******WWWW
+175(175 mod 256): MAPWRITE 0x4e200 thru 0x4fc0f	(0x1a10 bytes)
+176(176 mod 256): SKIPPED (no operation)
+177(177 mod 256): MAPWRITE 0x70c00 thru 0x71af7	(0xef8 bytes)
+178(178 mod 256): MAPWRITE 0x2c200 thru 0x2df47	(0x1d48 bytes)
+179(179 mod 256): SKIPPED (no operation)
+180(180 mod 256): PUNCH    0x6948f thru 0x6b2df	(0x1e51 bytes)
+181(181 mod 256): WRITE    0x46400 thru 0x475ff	(0x1200 bytes)
+182(182 mod 256): SKIPPED (no operation)
+183(183 mod 256): TRUNCATE DOWN	from 0x71af8 to 0x32200
+184(184 mod 256): WRITE    0x58800 thru 0x591ff	(0xa00 bytes) HOLE
+185(185 mod 256): WRITE    0x78000 thru 0x783ff	(0x400 bytes) HOLE
+186(186 mod 256): SKIPPED (no operation)
+187(187 mod 256): SKIPPED (no operation)
+188(188 mod 256): MAPWRITE 0x9600 thru 0xa3b6	(0xdb7 bytes)
+189(189 mod 256): TRUNCATE DOWN	from 0x78400 to 0x2bc00
+190(190 mod 256): SKIPPED (no operation)
+191(191 mod 256): MAPWRITE 0x42c00 thru 0x436d7	(0xad8 bytes)
+192(192 mod 256): SKIPPED (no operation)
+193(193 mod 256): WRITE    0x43a00 thru 0x43dff	(0x400 bytes) HOLE
+194(194 mod 256): SKIPPED (no operation)
+195(195 mod 256): MAPWRITE 0xd600 thru 0xf580	(0x1f81 bytes)	******WWWW
+196(196 mod 256): SKIPPED (no operation)
+197(197 mod 256): WRITE    0xae00 thru 0xcbff	(0x1e00 bytes)
+198(198 mod 256): PUNCH    0xee35 thru 0xff4a	(0x1116 bytes)	******PPPP
+199(199 mod 256): MAPWRITE 0x39c00 thru 0x3a556	(0x957 bytes)
+200(200 mod 256): MAPWRITE 0x7600 thru 0x7fb8	(0x9b9 bytes)
+201(201 mod 256): MAPWRITE 0x5a400 thru 0x5b3b6	(0xfb7 bytes)
+202(202 mod 256): MAPREAD  0xf000 thru 0xfb08	(0xb09 bytes)	***RRRR***
+Correct content saved for comparison
+(maybe hexdump "/vdd/junk" vs "/vdd/junk.fsxgood")
266	 [not run] xfsdump not found
271 1s ... 2s
277 4s ... 5s
281	 [not run] xfsdump not found
282	 [not run] xfsdump not found
283	 [not run] xfsdump not found
285 0s ... 1s
286 2s ... 2s
287	 [not run] not suitable for this filesystem type: ext4
Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 215 219 221 225 230 235 236 237 240 245 246 247 248 249 255 256 257 258 263 271 277 285 286
Not run: 003 004 008 009 012 016 017 019 021 026 027 028 029 030 031 032 033 034 045 046 048 049 050 051 052 054 056 059 060 061 063 066 067 072 078 085 092 096 103 108 116 118 121 122 134 164 165 166 170 181 183 186 187 189 190 195 196 197 199 200 201 202 206 213 214 216 218 220 222 223 228 238 242 243 244 250 252 253 254 259 260 261 262 266 281 282 283 287
Failures: 075 091 112 215 255 263
Failed 6 of 64 tests
END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri Sep 28 01:57:54 EDT 2012


