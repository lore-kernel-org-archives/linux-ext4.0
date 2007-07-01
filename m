From: Mingming Cao <cmm@us.ibm.com>
Subject: Ext4 patches for 2.6.22-rc6
Date: Sun, 01 Jul 2007 03:35:31 -0400
Message-ID: <1183275331.4010.116.camel@localhost.localdomain>
References: <20070512080157.GF85884050@sgi.com>
	 <20070612061652.GA6320@amitarora.in.ibm.com>
	 <20070613235217.GS86004887@sgi.com>
	 <20070614091458.GH5181@schatzie.adilger.int>
	 <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070628025543.9467216f.akpm@linux-foundation.org>
	 <20070628175757.GA1674@amitarora.in.ibm.com>
	 <20070628113342.c9c0f49c.akpm@linux-foundation.org>
	 <20070629135612.GH29279@thunk.org> <46852A2C.9040407@us.ibm.com>
	 <20070629135709.6cf0264d.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070629135709.6cf0264d.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-06-29 at 13:57 -0700, Andrew Morton wrote:
> On Fri, 29 Jun 2007 11:50:04 -0400
> Mingming Caoc <cmm@us.ibm.com> wrote:
> 
> > I think the ext4 patch queue is in good shape now.
> 
> Which ext4 patches are you intending to merge into 2.6.23?
> 
> Please send all those out to lkml for review?

Hi Andrew, 

Here are the patches in ext4-patch-queue that I think can be considered
to be merged to upstream. Please review.

All of the patches have been posted on ext4 mailinglist before. Some are
bug fixes, some are features, to summaries:
- make extents on by default in ext4dev
- nanosecond timestamp
- 64 bit inode versioning support
- remove 32k subdir limits
- journal  checksumming
- journal stats via procfs
- delayed allocation for ext4 writeback mode
- fallocate()

All the patches can be found at http://repo.or.cz/w/ext4-patch-queue.git
and have been tested(with fsx ,dbench, FFSB, iozone) on
x86,x86_64,ppc64, with extents and delayed allocation enabled

And the full series can be found at
http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=series;h=2f43431db28778ce8d2149bce7a51566a2d2517c;hb=56e27e20cf228b32f5162a76b3bad154d1d3b730

I will post the patches-in-good-shape (in 9 set of patches) to lkml in
the following emails, except for the bottom two feature:

*the fallocate() patches, which Amit just posted a few days ago and are
under review (hopefully we can reach a agreement on the interface and
the "modes" before 2.6.23-rc1 window closed).

*Another one is the delayed allocation patches in ext4 patch queue. Alex
mentioned in another email that he is working on another version of
delalloc that can handle block size < page size, and move some work to
vfs. So it's probably not very useful to post this version for people to
review.


So, here is the series file.

# Rebased the patches to 2.6.22-rc6

# Add mount option to turn off extents
ext4_noextent_mount_opt.patch

# Mounted ext4dev fs with extents by default for testing purpose,
# for Ext4 product release, extents mount option
# will be turn on only if the fs has EXTENTS feature on
ext4_extents_on_by_default.patch

# Propagate inode flags
ext4-propagate_flags.patch

# Add extent sanity checks
ext4-extent-sanity-checks.patch

# Bug fix:set 64bit JBD2 feature on >32bit ext4 fs
ext4_set_jbd2_64bit_feature.patch

# Fix: Rename CONFIG_JBD_DEBUG to CONFIG_JBD2_DEBUG
jbd2_config_jbd2_debug_fix.patch

# Export jbd2-debug via debugfs
ext4_CONFIG_JBD2_DEBUG.patch
jbd2_move_jbd2_debug_to_debugfs.patch

# Nanosecond timestamp support
ext4-nanosecond-patch

# inode verion patch series
# inode versioning is needed for NFSv4

# vfs changes, 64 bit inode->i_version
64-bit-i_version.patch
# reserve hi 32 bit inode version on ext4 on-disk inode
i_version_hi.patch
# ext4 inode version read/store
ext4_i_version_hi_2.patch
# ext4 inode version update
i_version_update_ext4.patch
# add a noversion mount option to disable inode version updates
ext4_no_version.patch

# New patch to expand inode i_extra_isize to support features
# in high part of inode (>128 bytes)
ext4_expand_inode_extra_isize.patch

# Export jbd stats through procfs
# Shall this move to debugfs?
jbd-stats-through-procfs

# Remove 32000 subdirs limit. 
ext4_remove_subdirs_limit.patch

# Add journal checksums
ext4-journal_chksum-2.6.20.patch

# Various Cleanups
ext4-zero_user_page.patch
is_power_of_2-ext4-superc.patch
ext4-remove-extra-is_rdonly-check.patch
ext4_extent_compilation_fixes.patch
ext4_extent_macros_cleanup.patch


