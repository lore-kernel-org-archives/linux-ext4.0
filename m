From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Ext4 test failures -- COLLAPSE_RANGE and ZERO_RANGE
Date: Fri, 4 Apr 2014 17:04:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404041704310.3075@localhost.localdomain>
References: <20140403184703.GA2246@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbaDDPE6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2014 11:04:58 -0400
In-Reply-To: <20140403184703.GA2246@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Apr 2014, Theodore Ts'o wrote:

> Date: Thu, 3 Apr 2014 14:47:03 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>, Namjae Jeon <linkinjeon@gmail.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Ext4 test failures -- COLLAPSE_RANGE and ZERO_RANGE
> 
> Hi Lukas, Namjae,

Hi Ted,

thanks for letting me know. I'll take a look at it.

-Lukas

> 
> During final testing, I found two problems.  One is that the mount
> option dioread_nolock is causing a test failure for ext4/001, which is
> a ZERO_RANGE test.
> 
> The other is that the mount option data=journal is cuasing a test
> failure for shared/002 and shared/004, which are COLLAPSE_RANGE bugs.
> 
> Since these aren't regressions, and I don't think these new fallocate
> modes will probably be widely used at least initially, I don't think
> it's worth it to drop these two patches, especialy since we've done
> all of our testing for this merge window with the tests present.
> However, I'd really appreicate it if you take a look at them.
> 
> The dioread_nolock failure does mean that we're definitely not going
> to turn on dioread_nolock automatically if page_size == block_size, at
> least not for 3.14.  But I would like to turn it on automatically in
> 3.15 if possible.
> 
> The reason why I didn't notice these until now was that things have
> been pretty busy these last few weeks, and because the bugs only turn
> up if the patches to enable are new fallocate options are enabled, and
> they weren't merged into the ext4 tree, but rather had to be merged in
> separately in a test branch before doing a build and test.  I did that
> to keep things the the cleaner, and to avoid extraneous merges, but in
> retrospect, that was clearly a mistake, since it meant that we weren't
> doing as much automated testing of these two patches as we could have
> had.
> 
> My bad, and obviously I should take a different path when it comes
> time to review and test the INSERT_RANGE patches.
> 
> Regards,
> 
> 							- Ted
> 
> FSTESTCFG is "data_journal dioread_nolock"
> FSTESTSET is "AEX ext4/001 shared/002 shared/004"
> umount: /dev/vdb: not mounted
> umount: /dev/vdd: not mounted
> e2fsck 1.42.9 (4-Feb-2014)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/vdb: 8184/327680 files (4.0% non-contiguous), 127034/1310720 blocks
> Enabling auto exclude
>              total       used       free     shared    buffers     cached
> Mem:          1990         43       1946          0          2          8
> -/+ buffers/cache:         32       1957
> Swap:            0          0          0
> BEGIN TEST: Ext4 4k block w/data=journal Thu Apr  3 18:13:45 UTC 2014
> Device: /dev/vdb
> mk2fs options: -q
> mount options: -o block_validity,data=journal
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 candygram 3.14.0-00048-g1eff00a
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/vdc /vdc
> 
> [   16.800915] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
> ext4/001 4s ...	[18:13:49] [18:13:52] 3s
> shared/002		[18:13:54] [18:13:57] - output mismatch (see /results/results-data_journal/shared/002.out.bad)
>     --- tests/shared/002.out	2014-04-01 18:46:39.000000000 +0000
>     +++ /results/results-data_journal/shared/002.out.bad	2014-04-03 18:13:57.910609206 +0000
>     @@ -11,7 +11,7 @@
>      0: [0..31]: hole
>      1: [32..63]: extent
>      2: [64..95]: hole
>     -d8f51c20223dbce5c7c90db87bc221b0
>     +f4f35d60b3cc18aaa6d8d92f0cd3708a
>      	5. hole -> unwritten
>      0: [0..31]: hole
>     ...
>     (Run 'diff -u tests/shared/002.out /results/results-data_journal/shared/002.out.bad'  to see the entire diff)
> shared/004		[18:13:59] [18:14:01] - output mismatch (see /results/results-data_journal/shared/004.out.bad)
>     --- tests/shared/004.out	2014-04-01 18:46:39.000000000 +0000
>     +++ /results/results-data_journal/shared/004.out.bad	2014-04-03 18:14:01.833942566 +0000
>     @@ -3,14 +3,14 @@
>      f4f35d60b3cc18aaa6d8d92f0cd3708a
>      	2. into allocated space
>      0: [0..95]: extent
>     -f1894a71ac539f6f90426d98a4990a47
>     +f07217d5ac7ffa15dd8910c4aa912674
>      	3. into unwritten space
>      0: [0..95]: extent
>     ...
>     (Run 'diff -u tests/shared/004.out /results/results-data_journal/shared/004.out.bad'  to see the entire diff)
> Ran: ext4/001 shared/002 shared/004
> Failures: shared/002 shared/004
> Failed 2 of 3 tests
>              total       used       free     shared    buffers     cached
> Mem:          1990         50       1939          0          3         12
> -/+ buffers/cache:         34       1955
> Swap:            0          0          0
> ext4_groupinfo_4k    184    184    168   23    1 : tunables  120   60    8 : slabdata      8      8      0
> ext4_inode_cache     399    399   1168    3    1 : tunables   24   12    8 : slabdata    133    133      0
> ext4_free_data        56     93     40   93    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_allocation_context     18     37    104   37    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_prealloc_space      9     37    104   37    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_system_zone      70    146     24  146    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_io_end           52     93     40   93    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_extent_status    339    339     32  113    1 : tunables  120   60    8 : slabdata      3      3      0
> END TEST: Ext4 4k block w/data=journal Thu Apr  3 18:14:03 UTC 2014
> e2fsck 1.42.9 (4-Feb-2014)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/vdb: 8187/327680 files (4.0% non-contiguous), 127059/1310720 blocks
> BEGIN TEST: Ext4 4k block w/dioread_nolock Thu Apr  3 18:14:04 UTC 2014
> Device: /dev/vdb
> mk2fs options: -q
> mount options: -o block_validity,dioread_nolock
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 candygram 3.14.0-00048-g1eff00a
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,dioread_nolock /dev/vdc /vdc
> 
> ext4/001		[18:14:08] [18:14:12] - output mismatch (see /results/results-dioread_nolock/ext4/001.out.bad)
>     --- tests/ext4/001.out	2014-04-01 18:46:39.000000000 +0000
>     +++ /results/results-dioread_nolock/ext4/001.out.bad	2014-04-03 18:14:12.250609307 +0000
>     @@ -53,9 +53,7 @@
>      2: [32..39]: data
>      f6aeca13ec49e5b266cd1c913cd726e3
>      	12. unwritten -> data -> unwritten
>     -0: [0..7]: data
>     -1: [8..31]: unwritten
>     -2: [32..39]: data
>     +0: [0..39]: unwritten
>     ...
>     (Run 'diff -u tests/ext4/001.out /results/results-dioread_nolock/ext4/001.out.bad'  to see the entire diff)
> shared/002 3s ...	[18:14:14] [18:14:17] 3s
> shared/004 2s ...	[18:14:18] [18:14:21] 3s
> Ran: ext4/001 shared/002 shared/004
> Failures: ext4/001
> Failed 1 of 3 tests
>              total       used       free     shared    buffers     cached
> Mem:          1990         50       1939          0          3         12
> -/+ buffers/cache:         35       1955
> Swap:            0          0          0
> ext4_groupinfo_4k    203    230    168   23    1 : tunables  120   60    8 : slabdata     10     10      0
> ext4_inode_cache     412    414   1168    3    1 : tunables   24   12    8 : slabdata    138    138      0
> ext4_free_data        58     93     40   93    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_allocation_context     18     37    104   37    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_prealloc_space     35     37    104   37    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_system_zone      39    146     24  146    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_io_end           14     93     40   93    1 : tunables  120   60    8 : slabdata      1      1      0
> ext4_extent_status    330    339     32  113    1 : tunables  120   60    8 : slabdata      3      3      0
> END TEST: Ext4 4k block w/dioread_nolock Thu Apr  3 18:14:23 UTC 2014
> e2fsck 1.42.9 (4-Feb-2014)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/vdb: 8190/327680 files (4.0% non-contiguous), 127084/1310720 blocks
> 
> 
