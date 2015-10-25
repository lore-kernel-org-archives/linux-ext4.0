From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 9/9] ext4: Use pre-zeroed blocks for DAX page faults
Date: Sun, 25 Oct 2015 05:23:27 -0400
Message-ID: <20151025092327.GD27558@thunk.org>
References: <1445501761-14528-1-git-send-email-jack@suse.com>
 <1445501761-14528-10-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	ross.zwisler@linux.intel.com, willy@linux.intel.com
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42570 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbbJYJXe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Oct 2015 05:23:34 -0400
Content-Disposition: inline
In-Reply-To: <1445501761-14528-10-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's the list of new test failures that I found after applying this
patch series:

CMDLINE: full
FSTESTVER: e2fsprogs	v1.43-WIP-2015-05-18-64-g2334bd3 (Sat, 5 Sep 2015 22:21:35 -0400)
FSTESTVER: fio		fio-2.1.3 (Tue, 24 Sep 2013 08:42:24 -0600)
FSTESTVER: quota		022aabf (Wed, 26 Nov 2014 10:22:08 +0100)
FSTESTVER: xfsprogs	v4.2.0 (Mon, 7 Sep 2015 10:14:31 +1000)
FSTESTVER: xfstests-bld	dbb0a26 (Sun, 18 Oct 2015 08:34:14 -0400)
FSTESTVER: xfstests	linux-v3.8-779-gc17e548 (Sun, 18 Oct 2015 23:40:39 -0400)
FSTESTVER: kernel	4.3.0-rc2-ext4-00034-gf29d88e8 #115 SMP Sat Oct 24 20:20:43 EDT 2015 x86_64
FSTESTCFG: "4k 1k ext3 encrypt nojournal ext3conv dioread_nolock data_journal_noleak inline bigalloc bigalloc_1k"
FSTESTSET: "-g auto"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "7477.52"
MEM: 7680 MB (Max capacity)
BEGIN TEST 4k: Ext4 4k block Sat Oct 24 20:53:11 EDT 2015
Failures: ext4/001
BEGIN TEST 1k: Ext4 1k block Sat Oct 24 21:35:55 EDT 2015
Failures: ext4/001 generic/075 generic/091 generic/112 generic/127 generic/263
BEGIN TEST ext3: Ext4 4k block emulating ext3 Sat Oct 24 22:20:37 EDT 2015
BEGIN TEST encrypt: Ext4 encryption Sat Oct 24 23:03:38 EDT 2015
BEGIN TEST nojournal: Ext4 4k block w/ no journal Sat Oct 24 23:40:09 EDT 2015
Failures: ext4/001
BEGIN TEST ext3conv: Ext4 4k block w/nodelalloc and no flex_bg Sun Oct 25 00:20:14 EDT 2015
Failures: generic/269
BEGIN TEST dioread_nolock: Ext4 4k block w/dioread_nolock Sun Oct 25 01:01:48 EDT 2015
Failures: ext4/001 generic/091
BEGIN TEST data_journal_noleak: Ext4 4k block w/data=journal Sun Oct 25 01:45:39 EDT 2015
BEGIN TEST inline: Ext4 4k block w/inline Sun Oct 25 02:37:44 EDT 2015
Failures: ext4/001
BEGIN TEST bigalloc: Ext4 4k block w/bigalloc Sun Oct 25 03:22:02 EDT 2015
Failures: ext4/001
BEGIN TEST bigalloc_1k: Ext4 1k block w/bigalloc Sun Oct 25 04:08:26 EDT 2015
Failures: ext4/001

Cheers,

						- Ted
