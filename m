From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: Updated version of kvm-xfstests available
Date: Sat, 23 Aug 2014 13:35:35 -0400
Message-ID: <20140823173535.GA2553@wallace>
References: <20140809234556.GA11072@thunk.org>
 <20140812160832.GB12871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52970 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHWRf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2014 13:35:59 -0400
Received: by mail-qa0-f51.google.com with SMTP id k15so10981789qaq.10
        for <linux-ext4@vger.kernel.org>; Sat, 23 Aug 2014 10:35:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140812160832.GB12871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> On Sat, Aug 09, 2014 at 07:45:56PM -0400, Theodore Ts'o wrote:
> > Once I'm done running my baseline, I'll send out the results for your
> > convenience; if your patches cause any regressions, *please* take a
> > look and figure out why, since that will save me a lot of time and
> > allow your patches to get merged that much more quickly.
> 
> I did two different baseline runs; I will attach the full log files
> under separate cover, to avoid running into the vger message size
> limits.  There are a few differences in the bigalloc and bigalloc-1k
> runs, and clearly we still have some work to do there.  I believe most
> of the bigalloc test failures are with the "punch hole" and/or
> "collapse range" functions.
> 
> Of note are the test failures with inline data.  I had to skip
> generic/027 because it would BUG the kernel.  There were also failures
> with the tests generic/015, generic/077, generic/083, and shared/298
> which need investigation.

I was able to get successful runs of generic/027 with inline data on both
x86_64 and ARM running 3.17-rc1, but with considerable pain.  This test took
anywhere from a day and a half to slightly more than two days to complete.
It's a time-consuming test to run in all the other xfstests-bld scenarios as
well (usually 20 to 40 minutes, depending), but it's consistently much worse
in the inline test scenario.  (generic/027 only fails for me consistently
on bigalloc and bigalloc_1k where it hits ENOSPC.)

I did see one "unable to handle kernel paging request" failure on ARM that
prematurely killed one test run on 3.17-rc1, but my other runs were fine.

I think I'm going to blacklist generic/027 for inline data test runs
temporarily just to free up my test setups, but that huge runtime delta
deserves investigation.

Eric


> 
> 						- Ted
> 
> [    0.000000] Linux version 3.16.0-03638-g8e099d1 (tytso@rt-11.cam.corp.google.com) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #2 SMP Fri Aug 8 19:33:13 EDT 2014
> FSTESTVER: e2fsprogs	v1.42.11-340-g489ff4a (Fri, 8 Aug 2014 17:02:34 -0400)
> FSTESTVER: fio		fio-2.1.4 (Sat, 16 Nov 2013 11:15:12 -0700)
> FSTESTVER: quota		f215e3f (Mon, 2 Dec 2013 23:06:23 -0300)
> FSTESTVER: xfsprogs	v3.2.1-6-gba24eb7 (Fri, 18 Jul 2014 10:47:11 +1000)
> FSTESTVER: xfstests-bld	7f80d5e (Sun, 10 Aug 2014 16:18:45 -0400)
> FSTESTVER: xfstests	linux-v3.8-438-g67abe66 (Sat, 9 Aug 2014 01:29:24 -0400)
> FSTESTVER: kernel	3.16.0-03638-g8e099d1 #2 SMP Fri Aug 8 19:33:13 EDT 2014 i686
> FSTESTCFG: "all"
> FSTESTSET: "-g auto"
> FSTESTOPT: "aex"
> BEGIN TEST: Ext4 4k block Sun Aug 10 19:25:52 EDT 2014
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 gene
 ric/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/256
> END TEST: Ext4 4k block Sun Aug 10 20:51:59 EDT 2014
> BEGIN TEST: Ext4 1k block Sun Aug 10 20:52:02 EDT 2014
> MKFS_OPTIONS  -- -q -b 1024 /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 gene
 ric/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/018 generic/256
> END TEST: Ext4 1k block Sun Aug 10 23:37:15 EDT 2014
> BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Sun Aug 10 23:37:20 EDT 2014
> MKFS_OPTIONS  -- -q -O ^extents,^flex_bg,^uninit_bg /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc
> Ran: ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/010 generic/011 generic/013 generic/014 generic/015 generic/018 generic/020 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 generic/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/21
 2 generic/215 generic/219 generic/221 generic/224 generic/225 generic/226 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/306 generic/307 generic/308 generic/309 generic/310 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/018 generic/256
> END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Mon Aug 11 01:41:10 EDT 2014
> BEGIN TEST: Ext4 4k block w/ no journal Mon Aug 11 01:41:10 EDT 2014
> MKFS_OPTIONS  -- -q -O ^has_journal /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,noload /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 generic/193 gene
 ric/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/256
> END TEST: Ext4 4k block w/ no journal Mon Aug 11 03:08:21 EDT 2014
> BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Mon Aug 11 03:08:24 EDT 2014
> MKFS_OPTIONS  -- -q -O ^flex_bg /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 gene
 ric/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/223 generic/256
> END TEST: Ext4 4k block w/nodelalloc and no flex_bg Mon Aug 11 05:06:35 EDT 2014
> BEGIN TEST: Ext4 4k block w/metadata_csum Mon Aug 11 05:06:39 EDT 2014
> MKFS_OPTIONS  -- -q -O metadata_csum,64bit /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 gene
 ric/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/256
> END TEST: Ext4 4k block w/metadata_csum Mon Aug 11 06:35:52 EDT 2014
> BEGIN TEST: Ext4 4k block w/dioread_nolock Mon Aug 11 06:35:52 EDT 2014
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,dioread_nolock /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 gene
 ric/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: ext4/001 generic/017 generic/256
> END TEST: Ext4 4k block w/dioread_nolock Mon Aug 11 08:07:21 EDT 2014
> BEGIN TEST: Ext4 4k block w/data=journal Mon Aug 11 08:07:21 EDT 2014
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 generic/193 gene
 ric/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/018 generic/223 generic/256
> END TEST: Ext4 4k block w/data=journal Mon Aug 11 11:35:03 EDT 2014
> BEGIN TEST: Ext4 4k block w/bigalloc Mon Aug 11 11:35:06 EDT 2014
> MKFS_OPTIONS  -- -q -O bigalloc /dev/vdf
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdf /vdf
> [61175.808220] WARNING: CPU: 0 PID: 16980 at /usr/local/google/home/tytso/linux/ext4/fs/quota/dquot.c:1092 dquot_claim_space_nodirty+0xf1/0x1e3()
>     +_check_generic_filesystem: filesystem on /dev/vdf is inconsistent (see /results/results-bigalloc/generic/300.full)
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 gene
 ric/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/012 generic/016 generic/017 generic/018 generic/021 generic/022 generic/027 generic/075 generic/091 generic/112 generic/127 generic/192 generic/204 generic/219 generic/231 generic/233 generic/235 generic/256 generic/263 generic/273 generic/300
> END TEST: Ext4 4k block w/bigalloc Mon Aug 11 12:42:03 EDT 2014
> BEGIN TEST: Ext4 1k block w/bigalloc Mon Aug 11 12:42:04 EDT 2014
> MKFS_OPTIONS  -- -q -b 1024 -O bigalloc /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
>     +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent (see /results/results-bigalloc_1k/generic/300.full)
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 gene
 ric/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/017 generic/018 generic/027 generic/075 generic/091 generic/112 generic/127 generic/204 generic/231 generic/235 generic/256 generic/263 generic/273 generic/300
> END TEST: Ext4 1k block w/bigalloc Mon Aug 11 14:04:28 EDT 2014
> BEGIN TEST: Ext4 4k block w/inline Mon Aug 11 14:04:35 EDT 2014
> MKFS_OPTIONS  -- -q -O inline_data,metadata_csum,64bit /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> Ran: ext4/001 ext4/002 ext4/271 ext4/305 ext4/306 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/028 generic/053 generic/062 generic/068 generic/069 generic/070 generic/074 generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 generic/193 gene
 ric/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 shared/006 shared/272 shared/289 shared/298
> Failures: generic/015 generic/077 generic/083 generic/256 shared/298
> END TEST: Ext4 4k block w/inline Mon Aug 11 15:30:09 EDT 2014
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
