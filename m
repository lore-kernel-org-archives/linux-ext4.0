From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 recovery, the saga of 16777215 continues
Date: Sat, 14 Sep 2013 07:42:53 -0400
Message-ID: <20130914114253.GA11574@thunk.org>
References: <CA+qGm=_vV3xv8ip6JfuW7hDo3ZgR5Bj4oA_1r0BPD33rAso0Jg@mail.gmail.com>
 <20130914021818.GA1112@thunk.org>
 <CA+qGm=-tSOFyWJFTwB3HWpS_WdGekXyWUVMP8RN33sciwkafMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Alexander Harrowell <a.harrowell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60079 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab3INLm5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Sep 2013 07:42:57 -0400
Content-Disposition: inline
In-Reply-To: <CA+qGm=-tSOFyWJFTwB3HWpS_WdGekXyWUVMP8RN33sciwkafMQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 14, 2013 at 09:25:35AM +0000, Alexander Harrowell wrote:
> dump_inode 2937950 /media/usbdisk/dump

That writes the contents of that inode to a disk.  So your question of
"inodes having a defined size" doesn't make much sense.  An inode is a
fixed size, usually 128 or 256 bytes.  But the contents of the inode
(file) is anything up to 16TB....

In general if we're looking at a potentially corrupted file system,
the first thing you want to do is to look at it via the stat command
and make sure it looks at least vaguely sane.  You do this via the command
"stat <2937950>".

							- Ted
