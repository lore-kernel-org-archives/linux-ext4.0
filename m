From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fallocate() not "atomic" if insufficient disk space?
Date: Fri, 30 Dec 2011 17:13:53 -0600
Message-ID: <4EFE45B1.9040902@redhat.com>
References: <e10c1a3b87ce0766dcc538b8332cb9a4.squirrel@ssl-webmail-vh.clara.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: markk@clara.co.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1L3XOA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Dec 2011 18:14:00 -0500
In-Reply-To: <e10c1a3b87ce0766dcc538b8332cb9a4.squirrel@ssl-webmail-vh.clara.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/28/11 10:09 AM, markk@clara.co.uk wrote:
> Hi,
> 
> I've been experimenting with using fallocate() to pre-allocate space for a
> file on an ext4 partition. I'm testing with Ubuntu kernel
> 3.0.0-14-generic. Does fallocate() behave in the same way on more
> recent/vanilla kernels?
> 
> What I expected to happen is that if fallocate() fails due to lack of disk
> space, no space is allocated, i.e. either nothing happens or the
> allocation succeeds.
> 
> What actually seems to happen is that all remaining space in the partition
> gets allocated to the file. (Thus risking that other programs will fail
> due to lack of disk space until the file is deleted.)

To be honest, I'm not sure how it is _supposed_ to work, but I see this
same behavior with fallocate, with posix_fallocate calling fallocate, and with
posix_fallocate simply writing out data via glibc, (I tested several of those 
combinations on different filesystems, anyway).

Even the posix_fallocate spec doesn't say what is supposed to happen to space
allocated prior to failure, but the implementations seem fairly consistent.
Seems fair to say that callers should check error returns, and unlink or
truncate on error as needed.

-Eric

> If it's relevant, the partition in question has no journal and is mounted
> with barrier=0.
> 
> Example on a partition with ~100MB free:
> 
> $ fallocate -o 0 -l 999999999 blah
> fallocate: blah: fallocate failed: No space left on device
> $ df /
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb1              3849136   3653604         0 100% /
> $ du blah
> 107860	blah
> $ ls -l blah
> -rw-r--r-- 1 mark mark 110444544 2011-12-28 15:51 blah
> $ rm blah
> 
> Same issue when specifying -n to call fallocate() with FALLOC_FL_KEEP_SIZE:
> 
> $ fallocate -n -o 0 -l 999999999 blah
> fallocate: blah: fallocate failed: No space left on device
> $ df /
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb1              3849136   3653604         0 100% /
> $ du blah
> 107860	blah
> $ ls -l blah
> -rw-r--r-- 1 mark mark 0 2011-12-28 15:52 blah
> 
> 
> -- Mark
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

