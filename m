From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: An idea for supporting large directories and readdir+stat workloads
Date: Sun, 12 Aug 2012 23:11:32 -0600
Message-ID: <B12EEBD6-6DA4-4D2C-A31F-B2F7FAFCD372@dilger.ca>
References: <20120811212532.GB906@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <aedilger@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39303 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2HMFLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2012 01:11:34 -0400
Received: by ghrr11 with SMTP id r11so2637260ghr.19
        for <linux-ext4@vger.kernel.org>; Sun, 12 Aug 2012 22:11:34 -0700 (PDT)
In-Reply-To: <20120811212532.GB906@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2012-08-11, at 3:25 PM, Ted Ts'o wrote:
> I was thinking about how to respond to Andreas's offer:
> 
> On Fri, Aug 10, 2012 at 05:14:12PM -0600, Andreas Dilger wrote:
>> We have a patch to fix the 2-level htree and 2GB directory size limits
>> already, in case that is of interest to anyone.
> 
> where in theory, I'd be interested, but there have been enough other
> performance problems with really large directories that it was never
> been clear to me it would be a huge win, and given the many other
> changes queued up, I was hesitant.
> 
> ... and then I started thinking about this while I was in the shower,
> and I think I've come up with a really good solution to the problem.
> What if we also integrated the proposed extension that you guys have
> designed for storing additional metadata in the directory, and then
> for files that do not have hard links, we keep a copy of all of the fs
> metadata required for stat(2) in the directory?
> 
> This would speed up the readdir() + stat(2) workload, which has always
> been the major problem, in the common case where a file is linked to
> via only a single directory.  If a file gets hard-linked, we will need
> to drop the copy in the directory and then make sure the fields in the
> inode table are up-to-date.  But if we do this, I think it would be a
> huge improvement for ext4.
> 
> What do folks think?

Essentially, this is storing the inode in the directory.  What might be
possible is to have the directory leaf block point be the same thing as
the inode table block, and then use an xattr in the inode to hold the
parent directory number and filename as the "dirent".

We are actually already storing the Lustre parent FID and filename in an
xattr in the inode as a mechanism for doing inode->path generation on the
fly, but this could replace the directory entry entirely.  It is possible
to have multiple links to a file by having multiple xattr entries on the
inode, and if some inode is renamed to another directory then the xattr
is changed.  If there are a lot of hard links to a single file, then it
is possible that an external xattr block would be needed, but in the
overwhelmingly common case of a single link it can be stored in the inode.

The htree index would be used to reference the various inode table blocks.  Each inode in that block would check the xattr for entries for the parent
directory that is doing readdir/lookup, and would otherwise be ignored if
the parent inode does not match.


> P.S.  We might need to add a special case hack for the SELINUX sid,
> and put it in the extended directory entry as well, since otherwise
> every single stat operation will need to go to the inode table just to
> read the SELINUX extended attribute.  But I don't really care about
> that, since my personal answer to SELINUX has been "just say no".  But
> I do know there are enough people using it that we probably do need to
> accomodate those poor folks....

I think that by the time we store all of the "stat" attributes into the
directory it would essentially duplicate the inode, and increase overhead
instead of reducing it.  Every inode update would likely require also
updating the directory (mtime, ctime, etc).

Cheers, Andreas





