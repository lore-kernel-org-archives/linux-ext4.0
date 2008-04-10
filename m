From: Andreas Dilger <adilger@sun.com>
Subject: Re: Bug in ext2fs_set_gdt_csum() and uninit_groups handling
Date: Thu, 10 Apr 2008 11:33:08 -0600
Message-ID: <20080410173307.GC5693@webber.adilger.int>
References: <E1JhOy1-0006g8-Oy@closure.thunk.org>
 <20080403141745.GB13486@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59896 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbYDJRdS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2008 13:33:18 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3AHXItV014315
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 10:33:18 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZ400I01D9P1G00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 10 Apr 2008 10:33:18 -0700 (PDT)
In-reply-to: <20080403141745.GB13486@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 03, 2008  10:17 -0400, Theodore Ts'o wrote:
> So after looking at this some more, I think I understand what had
> happened.  The code as currently written is OK, because we are
> initializing the inode table even if the uninit_group feature is
> enabled.  There is a new COMPAT feature, lazy_bg, which causes mke2fs
> to skip initializing the inode table --- but since it's not in the
> allowed set of filesystem features, we're not in any danger since
> currently zeroing of the inode table can't be skipped.
> 
> HOWEVER, the code in ext2fs_set_gdt_csum() which I pointed out in my
> earlier message is a ticking time bomb that will go off if we ever
> enable lazy_bg.
> 
> Given that uninit_groups has only recently hit the e2fsprosg mainline,
> and as far as I know, no one is currently using it in production ---
> and those that might be, such as CFS, are zero'ing out the entire
> inode table anyway (since the feature was originally called gdt_cksum)
> --- and it would seem HIGHLY uninituitive that uninit_groups, or
> uninit_bg doesn't actually prevent the slow step of zeroing the inode
> table, I propose that we do the following:
> 
> *)  Remove lazy_bg feature flag entirely
> 
> *)  Remove the bogus code in ext2fs_set_gdt_csum()
> 
> *)  Change mke2fs to skip initializing the inode tables if
>     uninit_groups is set.
> 
> *)  Implement the kernel code for ext4 so it will zero out the inode
>     table in the background.
> 
> Does this make sense?  I believe it is safe, given that all existing
> filesystems using uninit_groups (what few of them exist) have the
> inode table completely zero'ed out, so there is no danger in making
> this change in the deifnition of what uninit_groups (or uninit_bg) means.

Sorry for delayed reply - I was away the last 2 weeks and am just skimming
my email backlog.

The zeroing of the inode tables can definitely NOT be removed until
the kernel has the ability to do that if the ZEROED flag is not set.
It is otherwise dangerous if the group checksum is incorrect, or the
backup GDT blocks are used, because they will not have correct UNINIT
flags and itable_unused values.  When e2fsck runs from the backups or
if the checksum is bad then the UNINIT flags and itable_unused field
are cleared and a full-group itable scan is done, and this would raise
a HUGE problem if the itable blocks have not been zeroed, which I would
predict would lead to a corrupt and useless filesystem.   The window
between mke2fs and the zeroing of the itable blocks must be as small
as possible to avoid this risk.

We added the ZEROED flag as a way of allowing the fast mke2fs to be
added in the future, but the kernel-side support has never been added.
That lazy_bg skips the itable zeroing is no different before or after
the addition of uninit_groups.  We didn't consider it a huge problem
for initial uninit_groups implementation because mke2fs is run far less
often than e2fsck...

If the main concern is that lazy_bg is still setting the ZEROED flag,
then yes I agree this is a problem that definitely wasn't intended.  I
don't think it is safe to turn off the zeroing of itable blocks in mke2fs
until after the kernel-side support has been available for some time.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

