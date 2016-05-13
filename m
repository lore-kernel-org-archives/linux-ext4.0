From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Fri, 13 May 2016 09:56:00 -0400
Message-ID: <20160513135600.GA2996@thunk.org>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
 <20160513052419.GD5862@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-nvdimm@ml01.01.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52214 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbcEMN4H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2016 09:56:07 -0400
Content-Disposition: inline
In-Reply-To: <20160513052419.GD5862@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2016 at 01:24:19AM -0400, Theodore Ts'o wrote:
> Queued and I'm running tests before I push them out.  The patches
> passed the smoke tests[1], and the full tests should be running for the
> next seven hours or so at:   http://104.197.222.91

So the good news is that the full tests ("gce-xfstests full") look
really good[1]) Unfortunately the DAX tests ("gce-xfstests -c dax -g
auto") show a regression.  Is this expected?  (i.e., were you
expecting test regressions that will be fixed by the DAX patch
series?)

Before this patch series:

BEGIN TEST dax: Ext4 4k block using DAX Fri May 13 08:01:57 EDT 2016
Failures: generic/250 generic/252 generic/299 generic/338

After the patch series:

CMDLINE: -c dax -g auto
FSTESTVER: e2fsprogs	v1.43-WIP-2015-05-18-64-g2334bd3 (Sat, 5 Sep 2015 22:21:35 -0400)
FSTESTVER: fio		fio-2.6-8-ge6989e1 (Thu, 4 Feb 2016 12:09:48 -0700)
FSTESTVER: quota		67fd9cc (Mon, 4 Apr 2016 00:32:39 -0400)
FSTESTVER: xfsprogs	v4.3.0 (Mon, 23 Nov 2015 15:24:24 +1100)
FSTESTVER: xfstests-bld	ccae8d1 (Tue, 26 Apr 2016 00:42:18 -0400)
FSTESTVER: xfstests	linux-v3.8-1010-g97dd2d8 (Wed, 27 Apr 2016 00:04:44 -0400)
FSTESTVER: kernel	4.6.0-rc4-ext4-00022-gaacd0c8 #282 SMP Fri May 13 00:52:07 EDT 2016 x86_64
FSTESTCFG: "dax"
FSTESTSET: "-g auto"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "4"
MEM: "13052.8"
MEM: 26 GB (Max capacity)
BEGIN TEST dax: Ext4 4k block using DAX Fri May 13 01:21:58 EDT 2016
Failures: generic/075 generic/091 generic/112 generic/127 generic/231 generic/250 generic/252 generic/263 generic/299 generic/338 generic/340

				- Ted

[1] CMDLINE: full
FSTESTVER: e2fsprogs	v1.43-WIP-2015-05-18-64-g2334bd3 (Sat, 5 Sep 2015 22:21:35 -0400)
FSTESTVER: fio		fio-2.6-8-ge6989e1 (Thu, 4 Feb 2016 12:09:48 -0700)
FSTESTVER: quota		67fd9cc (Mon, 4 Apr 2016 00:32:39 -0400)
FSTESTVER: xfsprogs	v4.3.0 (Mon, 23 Nov 2015 15:24:24 +1100)
FSTESTVER: xfstests-bld	ccae8d1 (Tue, 26 Apr 2016 00:42:18 -0400)
FSTESTVER: xfstests	linux-v3.8-1010-g97dd2d8 (Wed, 27 Apr 2016 00:04:44 -0400)
FSTESTVER: kernel	4.6.0-rc4-ext4-00018-g816cd71 #279 SMP Thu May 5 22:45:36 EDT 2016 x86_64
FSTESTCFG: "4k 1k ext3 encrypt nojournal ext3conv adv dioread_nolock data_journal bigalloc bigalloc_1k"
FSTESTSET: "-g auto"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "7497.07"
MEM: 7680 MB (Max capacity)
BEGIN TEST 4k: Ext4 4k block Thu May  5 22:52:10 EDT 2016
Passed all 212 tests
BEGIN TEST 1k: Ext4 1k block Thu May  5 23:38:50 EDT 2016
Failures: generic/018
BEGIN TEST ext3: Ext4 4k block emulating ext3 Fri May  6 00:30:11 EDT 2016
Passed all 167 tests
BEGIN TEST encrypt: Ext4 encryption Fri May  6 01:15:41 EDT 2016
Failures: ext4/020
BEGIN TEST nojournal: Ext4 4k block w/ no journal Fri May  6 01:40:25 EDT 2016
Failures: ext4/301
BEGIN TEST ext3conv: Ext4 4k block w/nodelalloc and no flex_bg Fri May  6 02:20:39 EDT 2016
Passed all 212 tests
BEGIN TEST adv: Ext4 advanced features (inline_data, metadata_csum, 64bit) Fri May  6 03:06:25 EDT 2016
Passed all 211 tests
BEGIN TEST dioread_nolock: Ext4 4k block w/dioread_nolock Fri May  6 03:53:34 EDT 2016
Passed all 212 tests
BEGIN TEST data_journal: Ext4 4k block w/data=journal Fri May  6 04:40:52 EDT 2016
Failures: ext4/271 generic/018
BEGIN TEST bigalloc: Ext4 4k block w/bigalloc Fri May  6 05:28:12 EDT 2016
Failures: ext4/004 generic/204 generic/219 generic/235 generic/273
BEGIN TEST bigalloc_1k: Ext4 1k block w/bigalloc Fri May  6 06:18:54 EDT 2016
Failures: ext4/004 generic/204 generic/235 generic/270
