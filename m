From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:dev 5/25] fs/jbd2/commit.c:351:18: sparse: incorrect type
 in assignment (different base types)
Date: Sun, 11 Nov 2012 12:32:36 +0800
Message-ID: <509f2a64.XFrkA1UaQS/vutlH%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Behan Webster <behanw@converseincode.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57751 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2KKEcu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Nov 2012 23:32:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   dffe9d8da715bed4d395883add90a2d150d85729
commit: fd47d3e1c2949838e858379aaf2bc20647be2912 [5/25] jbd2: remove VLAIS usage from JBD2 code


sparse warnings:

+ fs/jbd2/commit.c:351:18: sparse: incorrect type in assignment (different base types)
fs/jbd2/commit.c:351:18:    expected unsigned int [unsigned] [usertype] sequence
fs/jbd2/commit.c:351:18:    got restricted __be32 [usertype] <noident>
fs/jbd2/commit.c:359:25: sparse: incorrect type in assignment (different base types)
fs/jbd2/commit.c:359:25:    expected restricted __be16 [usertype] t_checksum
fs/jbd2/commit.c:359:25:    got restricted __be32 [usertype] <noident>
--
fs/jbd2/journal.c:100:5: sparse: symbol 'jbd2_verify_csum_type' was not declared. Should it be static?
fs/jbd2/journal.c:112:18: sparse: incorrect type in assignment (different base types)
fs/jbd2/journal.c:112:18:    expected unsigned int [unsigned] [usertype] old_csum
fs/jbd2/journal.c:112:18:    got restricted __be32 [usertype] s_checksum
fs/jbd2/journal.c:115:24: sparse: incorrect type in assignment (different base types)
fs/jbd2/journal.c:115:24:    expected restricted __be32 [usertype] s_checksum
fs/jbd2/journal.c:115:24:    got unsigned int [unsigned] [usertype] old_csum
+ fs/jbd2/journal.c:117:16: sparse: incorrect type in return expression (different base types)
fs/jbd2/journal.c:117:16:    expected unsigned int
fs/jbd2/journal.c:117:16:    got restricted __be32 [usertype] <noident>
+ fs/jbd2/journal.c:125:18: sparse: restricted __be32 degrades to integer
+ fs/jbd2/journal.c:120:5: sparse: symbol 'jbd2_superblock_csum_verify' was not declared. Should it be static?
fs/jbd2/journal.c:133:24: sparse: incorrect type in assignment (different base types)
fs/jbd2/journal.c:133:24:    expected restricted __be32 [usertype] s_checksum
fs/jbd2/journal.c:133:24:    got unsigned int
+ fs/jbd2/journal.c:128:6: sparse: symbol 'jbd2_superblock_csum_set' was not declared. Should it be static?
--
fs/jbd2/recovery.c:188:18: sparse: incorrect type in assignment (different base types)
fs/jbd2/recovery.c:188:18:    expected unsigned int [unsigned] [usertype] provided
fs/jbd2/recovery.c:188:18:    got restricted __be32 [usertype] t_checksum
fs/jbd2/recovery.c:191:26: sparse: incorrect type in assignment (different base types)
fs/jbd2/recovery.c:191:26:    expected restricted __be32 [usertype] t_checksum
fs/jbd2/recovery.c:191:26:    got unsigned int [unsigned] [usertype] provided
+ fs/jbd2/recovery.c:193:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:193:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:193:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:193:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:193:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:193:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:390:18: sparse: incorrect type in assignment (different base types)
fs/jbd2/recovery.c:390:18:    expected unsigned int [unsigned] [usertype] provided
fs/jbd2/recovery.c:390:18:    got restricted __be32 <noident>
fs/jbd2/recovery.c:393:24: sparse: incorrect type in assignment (different base types)
fs/jbd2/recovery.c:393:24:    expected restricted __be32 <noident>
fs/jbd2/recovery.c:393:24:    got unsigned int [unsigned] [usertype] provided
fs/jbd2/recovery.c:395:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:395:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:395:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:395:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:395:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:395:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:407:18: sparse: incorrect type in assignment (different base types)
fs/jbd2/recovery.c:407:18:    expected unsigned int [unsigned] [usertype] sequence
fs/jbd2/recovery.c:407:18:    got restricted __be32 [usertype] <noident>
fs/jbd2/recovery.c:411:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:411:20: sparse: cast from restricted __be16
fs/jbd2/recovery.c:411:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:411:20: sparse: cast from restricted __be16
fs/jbd2/recovery.c:411:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:411:20: sparse: cast from restricted __be16
fs/jbd2/recovery.c:411:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:411:20: sparse: cast from restricted __be16
fs/jbd2/recovery.c:411:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:411:20: sparse: cast from restricted __be16
fs/jbd2/recovery.c:411:20: sparse: cast to restricted __be32
+ fs/jbd2/recovery.c:411:20: sparse: cast from restricted __be16
+ fs/jbd2/recovery.c:413:28: sparse: restricted __be32 degrades to integer
fs/jbd2/recovery.c:819:18: sparse: incorrect type in assignment (different base types)
fs/jbd2/recovery.c:819:18:    expected unsigned int [unsigned] [usertype] provided
fs/jbd2/recovery.c:819:18:    got restricted __be32 [usertype] r_checksum
fs/jbd2/recovery.c:822:26: sparse: incorrect type in assignment (different base types)
fs/jbd2/recovery.c:822:26:    expected restricted __be32 [usertype] r_checksum
fs/jbd2/recovery.c:822:26:    got unsigned int [unsigned] [usertype] provided
fs/jbd2/recovery.c:824:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:824:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:824:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:824:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:824:20: sparse: cast to restricted __be32
fs/jbd2/recovery.c:824:20: sparse: cast to restricted __be32

vim +351 fs/jbd2/commit.c

3caa487f Darrick J. Wong 2012-05-27  335  	tail->t_checksum = 0;
3caa487f Darrick J. Wong 2012-05-27  336  	csum = jbd2_chksum(j, j->j_csum_seed, jh2bh(descriptor)->b_data,
3caa487f Darrick J. Wong 2012-05-27  337  			   j->j_blocksize);
3caa487f Darrick J. Wong 2012-05-27  338  	tail->t_checksum = cpu_to_be32(csum);
3caa487f Darrick J. Wong 2012-05-27  339  }
3caa487f Darrick J. Wong 2012-05-27  340  
c3900875 Darrick J. Wong 2012-05-27  341  static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
c3900875 Darrick J. Wong 2012-05-27  342  				    struct buffer_head *bh, __u32 sequence)
c3900875 Darrick J. Wong 2012-05-27  343  {
c3900875 Darrick J. Wong 2012-05-27  344  	struct page *page = bh->b_page;
c3900875 Darrick J. Wong 2012-05-27  345  	__u8 *addr;
c3900875 Darrick J. Wong 2012-05-27  346  	__u32 csum;
c3900875 Darrick J. Wong 2012-05-27  347  
c3900875 Darrick J. Wong 2012-05-27  348  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
c3900875 Darrick J. Wong 2012-05-27  349  		return;
c3900875 Darrick J. Wong 2012-05-27  350  
c3900875 Darrick J. Wong 2012-05-27 @351  	sequence = cpu_to_be32(sequence);
906adea1 Cong Wang       2012-06-23  352  	addr = kmap_atomic(page);
c3900875 Darrick J. Wong 2012-05-27  353  	csum = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
c3900875 Darrick J. Wong 2012-05-27  354  			  sizeof(sequence));
c3900875 Darrick J. Wong 2012-05-27  355  	csum = jbd2_chksum(j, csum, addr + offset_in_page(bh->b_data),
c3900875 Darrick J. Wong 2012-05-27  356  			  bh->b_size);
906adea1 Cong Wang       2012-06-23  357  	kunmap_atomic(addr);
c3900875 Darrick J. Wong 2012-05-27  358  
c3900875 Darrick J. Wong 2012-05-27  359  	tag->t_checksum = cpu_to_be32(csum);

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
