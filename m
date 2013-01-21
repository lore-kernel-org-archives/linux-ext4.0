From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] quota: autoload the quota_v2 module for QFMT_VFS_V1
 quota format
Date: Mon, 21 Jan 2013 10:50:20 -0500
Message-ID: <20130121155020.GD5618@thunk.org>
References: <20130121054741.GB321@thunk.org>
 <1358750781-5670-1-git-send-email-tytso@mit.edu>
 <1358750781-5670-2-git-send-email-tytso@mit.edu>
 <20130121104017.GD5588@quack.suse.cz>
 <20130121150134.GB5618@thunk.org>
 <20130121151008.GM5588@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org, adityakali@google.com, adilger@dilger.ca
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44622 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab3AUPu0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 10:50:26 -0500
Content-Disposition: inline
In-Reply-To: <20130121151008.GM5588@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 21, 2013 at 04:10:08PM +0100, Jan Kara wrote:
>   Exactly. There shouldn't be any conflicts so just keep it in your tree.
> You can add to the patch:
> Acked-by: Jan Kara <jack@suse.cz>

Great, thanks.

BTW, do you have any plans to work on getting repquota support for
ocfs2 and ext4 with the internal quota support into quotactl(2) and
quotatools?  It's missing functionality that I think users who want to
switch to the internal quota support will very much care about.

The work list that I have currently for ext4 w/ internal quota support
are:

1)  Debugfs support for manipulating the quota inode directly.  (So we
can introduce fs corruptions and make sure e2fsck deals
appropriately).

2)  Make sure e2fsck preserves the quota limits information when it
repairs the quota information, and that it notices a missing quota
record in the quota inode.

3)  Make sure e2fsck notices repairs a quota inode which is corrupted
in some way (and not just contains missing or incorrect usage
information).

4)  More regression tests in e2fsprogs.

5) Add some kind of functional replacement for repquota.  If
quotactl(2) support is not forthcoming in the near future, at the very
least debugfs should have a way of dumping out the repquota
information for an unmounted ext4 file system with internal quotas
enabled.

Can anyone think of other things which might be missing?

					- Ted
