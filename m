From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 3.10.10: quota problems
Date: Tue, 15 Oct 2013 22:25:48 -0400
Message-ID: <20131016022548.GB28823@thunk.org>
References: <21080.35061.164482.975014@fisica.ufpr.br>
 <20131015155334.GG12428@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46621 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab3JPCZ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 22:25:56 -0400
Content-Disposition: inline
In-Reply-To: <20131015155334.GG12428@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 15, 2013 at 05:53:34PM +0200, Jan Kara wrote:
> On Fri 11-10-13 20:25:41, Carlos Carvalho wrote:
>   No idea here, sorry. I will try to reproduce the problem and see what I
> can find. I'd just note that userspace support of hidden quotas in
> e2fsprogs is still experimental and Ted pointed out a few problems in it.
> Among others I think limits are not properly transferred from old to new
> quota file during fsck... But it still doesn't explain why the limits got
> lost after the crash.

This is a known bug, alas.  mke2fs -O quota directs the user to read:

https://ext4.wiki.kernel.org/index.php/Quota

for a list of caveats, including:

  Support for the quota feature first appeared in e2fsprogs 1.42,
  although it is not enabled by default. It must enabled via a
  compile-time configuration option, --enable-quota. There are bug fixes
  which have been applied in various 1.42.x maintenance branch releases,
  so users who wish to experiment with the quota feature are strongly
  encouraged upgrade to the latest e2fsprogs 1.42.x maintenance
  release. As of this writing the following bugs are still in e2fsprogs
  1.42.7, which means use of file systems with the quota feature in
  production can not be recommended:

    * The e2fsck check of the on-disk quota inodes won't notice if
      there is a missing uid record. (i.e., if some uid, say daemon
      owns a bunch of files, but that uid record is not in the quota
      inode, e2fsck won't say boo.)

    * If e2fsck *does* notice a discrepancy between the usage
      information recorded in the hidden quota inodes, and the actual
      number of blocks used by a particular user id or group id, it
      will overwrite the user or group quota inode with all of the
      information it has. Unfortunately, in the process it will zero
      out all of the current quota limits set. This is unfortunate....

The problem is that the person who originally contributed the code was
working in an environment where they only needed usage tracking, and
they weren't using quota enforcement.  So the fact that the e2fsck
code that was submitted was incomplete wasn't something that got
noticed right away.

It's been on my todo list to fix, but I just haven't had time to get
to it.  :-(   Part of the problem is that it requires some fairly major
restructuring in how the quota support is handled in e2fsprogs.

						- Ted
