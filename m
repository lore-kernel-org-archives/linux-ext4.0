From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A question about EXT4_INODE_JOURNAL_DATA flag with delalloc
Date: Wed, 12 Aug 2015 11:31:48 -0400
Message-ID: <20150812153148.GA3373@thunk.org>
References: <790473091.764741439359628318.JavaMail.weblogic@epmlwas06a>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"daehojng@gmail.com" <daehojng@gmail.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55051 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbbHLPbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 11:31:51 -0400
Content-Disposition: inline
In-Reply-To: <790473091.764741439359628318.JavaMail.weblogic@epmlwas06a>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 12, 2015 at 06:07:08AM +0000, Daeho Jeong wrote:
> Ted, thanks for your response.
> 
> I just have tested the below test by temporally enabling per-file data journalling with delalloc
> and it didn't cause kernel oops any more. I will check further whether per-file data journalling
> while allowing the rest of the file system to be using delalloc will cause another type of problem
> or not.
> 
>  dd if=/dev/zero of=/mnt/test1/file bs=1M count=4
>  chattr +j /mnt/test1/file
>  dd if=/dev/zero of=/mnt/test1/file bs=1M count=4 conv=notrunc
>  chattr -j /mnt/test1/file

If you could use xfstests to test your patch, and let me know what you
find, that would be great!

For a change like this, I'd recommend running "kvm-xfstests -g auto"
using the latest ext4 git tree with your patches applied:

      https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/plain/quick-start?h=META

With the exception of the bigalloc configs, the test runs are
relatively clear.  Here are the expected failures for the current dev
branch for ext4.git (git commit 4.2.0-rc2-ext4-00013-g6d3ec14d):

BEGIN TEST 4k: Ext4 4k block Fri Aug  7 21:28:37 UTC 2015
Passed all 182 tests
BEGIN TEST 1k: Ext4 1k block Fri Aug  7 22:12:08 UTC 2015
Failures: generic/018 generic/273
BEGIN TEST ext3: Ext4 4k block emulating ext3 Fri Aug  7 22:59:18 UTC 2015
Failures: generic/018
BEGIN TEST nojournal: Ext4 4k block w/ no journal Fri Aug  7 23:41:10 UTC 2015
Passed all 168 tests
BEGIN TEST ext3conv: Ext4 4k block w/nodelalloc and no flex_bg Sat Aug  8 00:21:46 UTC 2015
Failures: generic/223
BEGIN TEST dioread_nolock: Ext4 4k block w/dioread_nolock Sat Aug  8 01:04:00 UTC 2015
Failures: ext4/001 ext4/308 generic/324
BEGIN TEST data_journal: Ext4 4k block w/data=journal Sat Aug  8 01:46:34 UTC 2015
Failures: generic/018 generic/223
BEGIN TEST inline: Ext4 4k block w/inline Sat Aug  8 02:45:06 UTC 2015
Failures: ext4/004
BEGIN TEST bigalloc: Ext4 4k block w/bigalloc Sat Aug  8 03:27:52 UTC 2015
Failures: ext4/004 generic/012 generic/016 generic/017 generic/018 generic/021 generic/022 generic/031 generic/058 generic
/060 generic/061 generic/063 generic/064 generic/075 generic/091 generic/112 generic/127 generic/204 generic/219 generic/2
31 generic/235 generic/263 generic/273
BEGIN TEST bigalloc_1k: Ext4 1k block w/bigalloc Sat Aug  8 04:07:13 UTC 2015
Failures: ext4/004 generic/017 generic/018 generic/031 generic/058 generic/060 generic/061 generic/063 generic/064 generic
/075 generic/091 generic/112 generic/127 generic/204 generic/231 generic/235 generic/263 generic/273

					- Ted

P.S.  The above was done using gce-xfstests, which uses Google Compute
Engine.  Using kvm-xfstests is better documented at the moment, and
will give similar results, although it will take about 22-24 hours for
a full test run assuming you are using an HDD for your test disks.
For more information about gce-xfstests, see
https://plus.google.com/+TheodoreTso/posts/ReLNMRYUjiZ
