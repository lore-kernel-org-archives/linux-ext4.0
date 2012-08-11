From: Ted Ts'o <tytso@mit.edu>
Subject: An idea for supporting large directories and readdir+stat workloads
Date: Sat, 11 Aug 2012 17:25:32 -0400
Message-ID: <20120811212532.GB906@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44171 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2HKVZg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Aug 2012 17:25:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was thinking about how to respond to Andreas's offer:

On Fri, Aug 10, 2012 at 05:14:12PM -0600, Andreas Dilger wrote:
> We have a patch to fix the 2-level htree and 2GB directory size limits
> already, in case that is of interest to anyone.

where in theory, I'd be interested, but there have been enough other
performance problems with really large directories that it was never
been clear to me it would be a huge win, and given the many other
changes queued up, I was hesitant.

... and then I started thinking about this while I was in the shower,
and I think I've come up with a really good solution to the problem.
What if we also integrated the proposed extension that you guys have
designed for storing additional metadata in the directory, and then
for files that do not have hard links, we keep a copy of all of the fs
metadata required for stat(2) in the directory?

This would speed up the readdir() + stat(2) workload, which has always
been the major problem, in the common case where a file is linked to
via only a single directory.  If a file gets hard-linked, we will need
to drop the copy in the directory and then make sure the fields in the
inode table are up-to-date.  But if we do this, I think it would be a
huge improvement for ext4.

What do folks think?

						- Ted

P.S.  We might need to add a special case hack for the SELINUX sid,
and put it in the extended directory entry as well, since otherwise
every single stat operation will need to go to the inode table just to
read the SELINUX extended attribute.  But I don't really care about
that, since my personal answer to SELINUX has been "just say no".  But
I do know there are enough people using it that we probably do need to
accomodate those poor folks....
