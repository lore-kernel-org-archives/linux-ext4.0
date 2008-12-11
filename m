From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: Checking link targets are NULL-terminated
Date: Thu, 11 Dec 2008 16:06:40 +0000
Message-ID: <e9e943910812110806h1a70756es854d95d6b719a609@mail.gmail.com>
References: <20081205144810.GA25585@dastardly.home.dghda.com>
	 <20081208143003.9449bc77.akpm@linux-foundation.org>
	 <20081209171814.GA8667@infradead.org> <493EB22C.2050108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Boaz Harrosh" <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:41136 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbYLKQGm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Dec 2008 11:06:42 -0500
In-Reply-To: <493EB22C.2050108@panasas.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/12/9 Boaz Harrosh <bharrosh@panasas.com>:
> Christoph Hellwig wrote:
>> On Mon, Dec 08, 2008 at 02:30:03PM -0800, Andrew Morton wrote:
>>> Perhaps nd_set_link() is a suitable place?  Change that function so
>>> that it is passed a third argument (max_len) and then check that within
>>> nd_set_link().  Change nd_set_link() to return a __must_check-marked
>>> errno, change callers to handle errors appropriately.
>>>
>>> Or something totally different ;)  But along those lines?
>>
>> Note that XFS and possibly other filesystem don't store the NULL
>> termination on disk.
>
> Note that ext2, for example, also only writes the string bytes without
> any NULLs. It only happen to be zero padded because any last-page is zero-padded
> from i_size to end of page.
>
>> So having a follow_link interface that uses a
>> counted string would be a nice little optimization for the XFS
>> follow_link / readlink implementation.   But I'm not really sure it's
>> worth complicating the VFS for that little gem.
>
> The inode's i_size already holds the string count so at the higher level
> we have that information. But I'm convinced, nd_set_link() should receive
> a new max_len, all users should be changed as a matter of code audit.
> nd_set_link() should then proceed to truncate the string at that length
> unconditionally no need for error returns.

I've looked at a few alternative options: scanning for NULLs,
NULL-terminating in nd_set_link, NULL-terminating in the FS code
(where it is necessary and not already being done), and passing the
length around explicitly.

NULL-terminating is definitely cleaner and easier than scanning.
Unfortunately, as Christoph indicated, passing the length around
explicitly does rather complicate the code. So the question is whether
to NULL-terminate in nd_set_link or earlier in the FS code.

Having tried both options, I'm inclined to do it in the FS code and
leave nd_set_link as it is. Many of the filesystems already take pains
to ensure the links are NULL-terminated and the minimal change of
fixing the others seems the safest option. However, this way we won't
solve things for all filesystems for all time, as Andrew wanted. I'll
post my preferred patches shortly, but if anyone would like to see
what the full nd_set_link change would look like let me know and I'll
post them for comparison.

FYI, here are the diffstats for the two options:

Terminating in FS code:
 fs/9p/vfs_inode.c        |    5 +++--
 fs/befs/linuxvfs.c       |    5 ++++-
 fs/ecryptfs/inode.c      |    3 ++-
 fs/ext2/symlink.c        |    4 +++-
 fs/ext3/symlink.c        |    4 +++-
 fs/ext4/symlink.c        |    4 +++-
 fs/freevxfs/vxfs_immed.c |    1 +
 fs/jfs/symlink.c         |    2 ++
 fs/namei.c               |    8 ++++++--
 fs/sysv/symlink.c        |    4 +++-
 fs/ufs/symlink.c         |    4 +++-
 11 files changed, 33 insertions(+), 11 deletions(-)

Adding length param and terminating in nd_set_link (but not removing
all the existing FS termination code):
 fs/9p/vfs_inode.c           |   10 +++++-----
 fs/autofs/symlink.c         |    2 +-
 fs/autofs4/symlink.c        |    2 +-
 fs/befs/linuxvfs.c          |   14 ++++++++++++--
 fs/cifs/link.c              |    8 ++------
 fs/configfs/symlink.c       |    4 ++--
 fs/debugfs/file.c           |    2 +-
 fs/ecryptfs/inode.c         |   20 ++++++++++----------
 fs/ext2/symlink.c           |    2 +-
 fs/ext3/symlink.c           |    2 +-
 fs/ext4/symlink.c           |    2 +-
 fs/freevxfs/vxfs_immed.c    |    2 +-
 fs/fuse/dir.c               |    2 +-
 fs/jffs2/symlink.c          |    2 +-
 fs/jfs/symlink.c            |    3 ++-
 fs/namei.c                  |   11 +++++++++--
 fs/nfs/symlink.c            |    4 ++--
 fs/proc/generic.c           |    2 +-
 fs/smbfs/symlink.c          |    8 ++++----
 fs/sysfs/symlink.c          |    2 +-
 fs/sysv/symlink.c           |    3 ++-
 fs/ubifs/file.c             |    2 +-
 fs/ufs/symlink.c            |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c |    4 ++--
 include/linux/namei.h       |    4 +++-
 mm/shmem.c                  |    4 ++--
 26 files changed, 70 insertions(+), 53 deletions(-)

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
