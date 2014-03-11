From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Tue, 11 Mar 2014 22:00:13 +0000
Message-ID: <20140311220013.GV1346@redhat.com>
References: <20140311213932.GA19176@redhat.com>
 <531F8456.2020404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbaCKWAT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 18:00:19 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2BM0HKi019921
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 18:00:17 -0400
Content-Disposition: inline
In-Reply-To: <531F8456.2020404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[The context of this is trying to get virt-sparsify to work in place
on disks.]

On Tue, Mar 11, 2014 at 04:47:02PM -0500, Eric Sandeen wrote:
> On 3/11/14, 4:39 PM, Richard W.M. Jones wrote:
> > 
> > Here's a problem I can't work out:
> > 
> > I have a filesystem (in a VM) that I know has at least 100MB of
> > deleted files on it.
> 
> Was it mounted with -o discard at the time the files were deleted?

No, it was not.

I know that the original 'rm' command didn't recover any space because
the disk image grew by ~100 MB.

> If so, then the trim is already done during the unlink process,
> and there's no more work to do.
> 
> So that's my first thought, but ...
> 
> >  Doing this in a script:
> > 
> >   mount -o discard /dev/sda1 /mnt
> >   fstrim /mnt
> > 
> > ... does nothing.  Also the fstrim is almost instantaneous -- there's
> > no way it could be scanning the disk.
> 
> blktrace would be a better tool to find out whether or not discards
> are actually getting issued to storage...
> 
> And if you strace it what does the ioctl return?

I'll try that in a few minutes.

In the mean time I captured the fstrim -v output:

  fstrim -v /
  /: 124 MiB (130039808 bytes) trimmed

124 MB is (within 25%) the amount of data I would expect needs to be
trimmed.

> Enabling the trace_ext4_trim_all_free tracepoint might be interesting too.

That a systemtap thing?  It's tricky to get systemtap working in a
virtual machine, but I guess I can try if nothing else works.

> > However, if I start with the same filesystem, mounted with -o discard,
> > and create and rm large files, while observing the size of the
> > underlying virtual disk, then discard is obviously working fine.  'rm'
> > of large files makes the underlying disk shrink.
> > 
> > Any ideas here?
> 
> first of all, I should point out that "-o discard" is not necessary for
> fstrim / FITRIM ioctl to work.  The former tries to trim as soon
> as files are unlinked; FITRIM goes looking for free blocks to trim.
>
> If you're mounting with -o discard, then fstrim should never find any
> workd to do.

Useful to know.

I thought I had to use -o discard in order for the ext4 module to send
discard commands at all to the block layer.

Thanks,

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
