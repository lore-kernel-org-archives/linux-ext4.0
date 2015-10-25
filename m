From: Theodore Ts'o <tytso@mit.edu>
Subject: Refreshed rootfs.img for kvm-xfstests
Date: Sun, 25 Oct 2015 17:26:46 -0400
Message-ID: <20151025212646.GA25680@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43211 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbbJYV0v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Oct 2015 17:26:51 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, I've uploaded an updated rootfs.img at:

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

It includes the xfstests-dev upstream version 0e6ead559169 (Updated
from Oct. 14th) and some configuration changes to minimize some test
failure noise.  The config files are commented with the known
failures, for example:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/test-appliance/files/root/conf/encrypt.exclude

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/test-appliance/files/root/conf/data_journal_noleak

I am currently getting the following results:

BEGIN TEST 4k: Ext4 4k block Sun Oct 25 07:29:52 EDT 2015
Failures: ext4/304
BEGIN TEST 1k: Ext4 1k block Sun Oct 25 08:12:58 EDT 2015
Failures: ext4/304 generic/018
BEGIN TEST ext3: Ext4 4k block emulating ext3 Sun Oct 25 09:01:21 EDT 2015
Failures: ext4/301 ext4/302 ext4/303 ext4/304 generic/018
BEGIN TEST encrypt: Ext4 encryption Sun Oct 25 09:44:13 EDT 2015
Failures: ext4/301 ext4/303 ext4/304
BEGIN TEST nojournal: Ext4 4k block w/ no journal Sun Oct 25 10:20:57 EDT 2015
Failures: ext4/301 ext4/304
BEGIN TEST ext3conv: Ext4 4k block w/nodelalloc and no flex_bg Sun Oct 25 11:01:06 EDT 2015
Failures: ext4/304
BEGIN TEST dioread_nolock: Ext4 4k block w/dioread_nolock Sun Oct 25 11:41:36 EDT 2015
Failures: ext4/001 ext4/304 ext4/308 generic/324
BEGIN TEST data_journal_noleak: Ext4 4k block w/data=journal Sun Oct 25 12:24:57 EDT 2015
Failures: ext4/271 ext4/301 ext4/302 ext4/303 ext4/304 ext4/308 generic/018
BEGIN TEST inline: Ext4 4k block w/inline Sun Oct 25 13:16:58 EDT 2015
Failures: ext4/304
BEGIN TEST bigalloc: Ext4 4k block w/bigalloc Sun Oct 25 14:00:23 EDT 2015
Failures: ext4/004 generic/018 generic/204 generic/219 generic/235 generic/273
BEGIN TEST bigalloc_1k: Ext4 1k block w/bigalloc Sun Oct 25 14:46:29 EDT 2015
Failures: ext4/004 generic/018 generic/204 generic/235

(The ext4/30[1234] failures we only recently added back the these
tests that had been previously marked as dangerous and not in the auto
group.  ext4/304 is pretty clearly a buggy test as near as I can tell.
I haven't had a chance to rule out the others.  generic/018 is an
expected failures due to how we handle defrag; I should just add that
to all.exclude.  I need to take a closer look at some of the other
failures to understand what is going on.)

						- Ted

