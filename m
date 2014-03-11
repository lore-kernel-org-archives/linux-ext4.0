From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Tue, 11 Mar 2014 16:47:02 -0500
Message-ID: <531F8456.2020404@redhat.com>
References: <20140311213932.GA19176@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones@redhat.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbaCKVrE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 17:47:04 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2BLl334007710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 17:47:04 -0400
In-Reply-To: <20140311213932.GA19176@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/11/14, 4:39 PM, Richard W.M. Jones wrote:
> 
> Here's a problem I can't work out:
> 
> I have a filesystem (in a VM) that I know has at least 100MB of
> deleted files on it.

Was it mounted with -o discard at the time the files were deleted?
If so, then the trim is already done during the unlink process,
and there's no more work to do.

So that's my first thought, but ...

>  Doing this in a script:
> 
>   mount -o discard /dev/sda1 /mnt
>   fstrim /mnt
> 
> ... does nothing.  Also the fstrim is almost instantaneous -- there's
> no way it could be scanning the disk.

blktrace would be a better tool to find out whether or not discards
are actually getting issued to storage...

And if you strace it what does the ioctl return?

Enabling the trace_ext4_trim_all_free tracepoint might be interesting too.

> However, if I start with the same filesystem, mounted with -o discard,
> and create and rm large files, while observing the size of the
> underlying virtual disk, then discard is obviously working fine.  'rm'
> of large files makes the underlying disk shrink.
> 
> Any ideas here?

first of all, I should point out that "-o discard" is not necessary for
fstrim / FITRIM ioctl to work.  The former tries to trim as soon
as files are unlinked; FITRIM goes looking for free blocks to trim.

If you're mounting with -o discard, then fstrim should never find any
workd to do.

-Eric


> Rich.
> 
> kernel: 3.12.5-302.fc20.x86_64
> qemu: 1.7.0
> virtio-scsi with discard=unmap
> 

