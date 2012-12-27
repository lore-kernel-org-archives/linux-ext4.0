From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 3.8.0-rc1: WARNING: at fs/ext4/page-io.c:232
Date: Thu, 27 Dec 2012 08:44:13 -0500
Message-ID: <20121227134413.GA20671@thunk.org>
References: <CAA1sL1QgkEWciR2qBbKWr+_2tRdhxpE1Jh3P0waSeYR8LR8R5w@mail.gmail.com>
 <20121227062907.GA5001@gmail.com>
 <87mwwzq5t7.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40578 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab2L0NoT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Dec 2012 08:44:19 -0500
Content-Disposition: inline
In-Reply-To: <87mwwzq5t7.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 27, 2012 at 12:04:36PM +0400, Dmitry Monakhov wrote:
> In fact this is my fault that we still not have autotest for that.
> I'm think of add crash-test to xfstests which should trigger journal
> abort and forced umount. Later test should mount FS which trigger
> journal_replay and orphan_cleanup.

We could create some tests in xfstests which force a crash via "echo b
> /proc/sysrq-trigger", but the trick is would require xfstests to
install something in the /etc/rc scripts so xfstests could resume
right after it came back --- and perhaps to echo something to the
console which automated test runners (such as the one I use which I've
published at [1] could capture so they would know that they should
restart the system.

[1] git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

For now the simplest way to test this is to use the file system image
in tests/f_orphan_extents_inode/image.gz, and make this be an
ext4-specific test.  This is how I tested it when I created my fix (in
parallel with Zheng's patch).  The compressed file system image is
only 564 bytes --- and was made deliberately w/o a journal so it could
be that small --- and the lack of a journal was how I found the
infinite loop problem which was fixed in the 2/2 patch in my patches.
So including this compressed fs image in xfstests is probably the way
I would suggest for now.

							- Ted
