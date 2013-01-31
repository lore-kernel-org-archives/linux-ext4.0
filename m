From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Thu, 31 Jan 2013 17:03:12 -0500
Message-ID: <20130131220312.GA15322@thunk.org>
References: <20730.1955.395545.141779@fisica.ufpr.br>
 <20130121054741.GB321@thunk.org>
 <20746.49010.569691.44452@fisica.ufpr.br>
 <CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
 <20746.49740.638811.698394@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46429 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab3AaWD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 17:03:28 -0500
Content-Disposition: inline
In-Reply-To: <20746.49740.638811.698394@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 05:13:16PM -0200, Carlos Carvalho wrote:
> Ah, fine. It works, fortunately :-). Thanks.
> 
> It's not clear what can be dropped and what must still be used in the
> new implementation. It'd be nice to state it in the man page of
> tune2fs, for example. I thought that if we wanted to stop quotas it'd
> be necessary to umount and tune2fs again.

This sequence documents the biggest set of issues with the new
implementation:

1) Create a file system.  Populate it with files.  I untarred the
e2fsprogs source tree as root, so there were a lot of files owned by
root.

2)  unmount the filesystem and run tune2fs -O quota /dev/XXX

3) mount the file system; observe that the quota tools don't realize
that they should be trying to do the quota thing.

4) mount the file system with the -o quota flag; this sets the quota
option in /etc/mtab, which is necessary for the quota tools to
correctly deal with the ext4 file system.

5) mount the file system; observe (via "quota -v root") that the usage
information for root is _not_ correct; in fact the usage for root is
nonexistent.

6)  unmount the file system and run e2fsck

7) mount the file system; observe that the usage information for root
still doesn't exist.

8)  Set a quota for root: "setquota  -u root  1024 2048 500 1000 /mnt"

9) Unmount the file system and run e2fsck.  Now e2fsck will complain
and ask if you should fix the usage information for rooot.  Say yes.

10) Mount the file system (with -o quota), and run "quota -v root".
Observe that the usage information is now correct, but the quota
limits for root (and all users/groups) have been cleared.

Basically, there are a bunch of e2fsprogs bugs with quota which we
need to fix before we can really recommend end users to use the first
class quota support.  If you use quota with a freshly created file
system, it works pretty well, as long as the usage quota information
never gets inconsistent (or if you are using the quota system for
usage tracking only and not for quota enforcement).  But if you try to
add the quota feature to an already existing file system which has
files already pre-populated, there are some definite issues that need
fixing.   :-(


Most of these issues have been written up at:

      https://ext4.wiki.kernel.org/index.php/Quota


						- Ted
