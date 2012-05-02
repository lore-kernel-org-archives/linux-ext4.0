From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Support systems without posix_memalign() and memalign()
Date: Wed, 2 May 2012 16:21:19 -0400
Message-ID: <20120502202119.GB18002@thunk.org>
References: <1335983451-30160-1-git-send-email-tytso@mit.edu>
 <C93BF332-FFF4-45E1-811D-6E641F54C9BD@dilger.ca>
 <20120502194058.GA18002@thunk.org>
 <CAJr8W+i3vjmVw5Bxh5pDveuXvkC_q6YkayuA8SfF=kjSLqEFAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ken Sumrall <ksumrall@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53240 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab2EBUVX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 May 2012 16:21:23 -0400
Content-Disposition: inline
In-Reply-To: <CAJr8W+i3vjmVw5Bxh5pDveuXvkC_q6YkayuA8SfF=kjSLqEFAg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 02, 2012 at 01:01:35PM -0700, Ken Sumrall wrote:
> I thought this patch enabled O_DIRECT functionality on the Mac:
> 
>   http://sourceforge.net/tracker/index.php?func=detail&aid=3140289&group_id=2406&atid=102406

Yeah, I was looking at this.  It turns out that F_NOCACHE has the
effect of O_DIRECT, but it does not require memory alignment.  There
are some hints that you get really bad performance if the read/write
size is not a multiple of 4k, and/or is not well-aligned ---
presumably in that case Mac OS uses a bounce buffer.

In practice, Linux works the same way --- we'll fall back to using the
page cache if the alignment requirements are not met.  However, there
have historically been bugs that cause this not to work correctly (and
in fact caused data corruption):

	https://bugzilla.redhat.com/show_bug.cgi?id=471613
	http://kerneltrap.org/mailarchive/linux-fsdevel/2008/11/14/4099714

... and the formal documentation of O_DIRECT in the open(2) man page
in Linux makes very little guarantees about what the requirements are
for O_DIRECT to work correctly:

       The  O_DIRECT  flag may impose alignment restrictions on the length and
       address of userspace buffers and the file offset  of  I/Os.   In  Linux
       alignment restrictions vary by file system and kernel version and might
       be absent entirely. 

So there are two possibilities; one is that we change
ext2fs_get_memalign() so it gets aligned memory on a best-efforts
basis, but does not guarantee that the memory will be aligned.

The other is we keep ext2fs_get_memalign() as an interface which
returns an error if the request memory alignment can not be honored,
and then add code so that we only try using ext2fs_get_memalign() if
we are trying to use O_DIRECT (and make an exception for F_NOCACHE on
Mac systems that don't have memalign or posix_memalign).

The first is tempting, but it just seems a little dirty to me.  On the
other hand, we've never published a formal API specification for
ext2fs_get_memalign(), and it's relatively unlikely there are users of
the API outside of e2fsprogs.

						- Ted
