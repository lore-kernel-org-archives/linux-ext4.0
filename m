From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Mon, 21 Jan 2013 00:47:41 -0500
Message-ID: <20130121054741.GB321@thunk.org>
References: <20730.1955.395545.141779@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adityakali@google.com, jack@suse.cz
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44532 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab3AUFrt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 00:47:49 -0500
Content-Disposition: inline
In-Reply-To: <20730.1955.395545.141779@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 19, 2013 at 12:40:35AM -0200, Carlos Carvalho wrote:
> I've started to use the new quota implementation (3.7.3 running now).
> I used tune2fs -Q to turn non {usr,grp}quota. It's nice, no need to
> run quotaon and all the jquota=file options. It works but it starts
> counting only what comes after the mount with the new quota. If there
> is already stuff in the filesystem it's not counted. How can we do a
> quotacheck?

tune2fs -Q should have set up the quota inodes with the correct usage
information.  What version of e2fsprogs were you using?  If the quota
information is incorrect, e2fsck will correct it --- so e2fsck will
serve as the quota check.

That being said, I've been doing some testing, and I have found some
shortcomings with the e2fsck's handling of the quota option that we
need to fix before I can recommend people use the new quota
implementation.

1) The e2fsck check of the on-disk quota inodes won't notice if there
is a missing uid record.  (i.e., if some uid, say daemon owns a bunch
of files, but that uid record is not in the quota inode, e2fsck won't
say boo.)

2) If e2fsck *does* notice a discrepancy between the usage information
recorded in the hidden quota inodes, and the actual number of blocks
used by a particular user id or group id, it will overwrite the user
or group quota inode with all of the information it has.
Unfortunately, in the process it will zero out all of the current
quota limits set.   This is unfortunate....

I've also found two kernel bugs.  If the quota code is built as a
kernel module, and the quota_v2 module is not loaded, and the file
system has a hidden quota module, currently the kernel (a) won't
request that the quota_v2 module be loaded, since the array which
control the module loading only know about QFMT_VFS_OLD and
QFMT_VFS_V0, but not QFMT_VFS_CV1, and then (b)it will return a
mysterious error, "No such process" (ESRCH) without printing any kind
of explanatory printk message, and then fail to delete the
/sys/fs/ext4/<dev> kobject, which will cause future attempts to load
that device to fail and to trigger a sysfs WARN_ON when ext4 tries to
create the /sys/fs/ext4/<dev> object, and sysfs discovers that the old
one still exists.

I'll send patches for the kernel bugs, but that still leaves some
additional work that needs to be done before I'd be ready to call the
quota feature fully ready for prime time....

> Also, what happens if the machine crashes without umounting? How is
> the usage going to be handled? Is it in the journal? Anyway, it'd also
> be important to do a quotacheck.

The quota updates are all journalled, so that's all OK.  And if they
aren't correct, e2fsck will correct them, although as mentioned above,
there are some cases when e2fsck might not notice a problem (a bug)
and when it does try to correct them, it will blow away all of the
stored quota limits in the quota inode (another bug).  Also, we're
still missing repquota functionality for ocfs2 and ext4 with the
hidden inode feature --- this requires a new quotactl kernel interface
to support iterating over the uid/gid values in the dquot tree, and
userspace support in the quotatools package.

						- Ted
