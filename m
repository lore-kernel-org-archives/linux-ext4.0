From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2: include fs.h in ext2_fs.h
Date: Fri, 3 Dec 2010 13:20:29 -0500
Message-ID: <20101203182029.GB26906@thunk.org>
References: <4CF91A32.6080706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Cezary Sliwa <sliwa@blue.cft.edu.pl>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CF91A32.6080706@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 03, 2010 at 10:26:26AM -0600, Eric Sandeen wrote:
> As reported by Cezary Sliwa in
> https://bugzilla.kernel.org/show_bug.cgi?id=24282
> ext2_fs.h references FS_DIRSYNC_FL etc, but does not
> include <linux/fs.h> to define them.  This seems ok
> for kernelspace builds, but breaks userspace applications
> which include ext2_fs.h.
> 
> Reported-by: Cezary Sliwa <sliwa@blue.cft.edu.pl>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I wonder if we would be better off getting application programs weaned
off of trying to use the kernel's version of ext2_fs.h altogether.
E2fsprogs ships one which is going to be more uptodate, and works for
ext2/ext3/ext4.  Certainly if you plan to be using libext2fs (which I
would strongly advise for any program hoping to manipulate ext2
filesystem structures directly), you should be using the header file
shipped with e2fsprogs.

Debian and Ubuntu for example ships /usr/include/ext2fs/ext2_fs.h as
part of its e2fslibs-dev package.

						- Ted
