From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What represent 646345728 bytes
Date: Mon, 01 Feb 2010 09:06:12 -0600
Message-ID: <4B66EDE4.6000204@redhat.com>
References: <7618835.18201265033304935.JavaMail.www@wsfrf1112>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: paul.chavent@fnac.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0BAPGT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Feb 2010 10:06:19 -0500
In-Reply-To: <7618835.18201265033304935.JavaMail.www@wsfrf1112>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

paul.chavent@fnac.net wrote:
> Hi
> 
> I'am writing an application that write a stream of pictures of fixed
> size on a disk.
> 
> My app run on a self integrated gnu/linux (based on a 2.6.31.6-rt19
> kernel).
> 
> My media is formated with
> 
> # mke2fs -t ext4 -L DATA -O large_file,^has_journal,extent -v
> /dev/sda3 [...]
> 
> And it is mounted with
> 
> # mount -t ext4 /dev/sda3 /var/data/ EXT4-fs (sda3): no journal 
> EXT4-fs (sda3): delayed allocation enabled EXT4-fs: file extents
> enabled EXT4-fs: mballoc enabled EXT4-fs (sda3): mounted filesystem
> without journal
> 
> My app opens the file with "O_WRONLY | O_CREAT | O_TRUNC | O_SYNC |
> O_DIRECT" flags.
> 
> Each write takes ~4.2ms for 304K (it is very good since it is the
> write bandwidth of my hard drive). There is a write every 100ms.

So you are doing streaming writes in 304k chunks?  Or each file
gets 304K?  It sounds like you are writing multiple 304k pictures
to a single file, right?

> But every exactly 646345728 bytes, the write takes ~46ms.

Do you mean every 304K written to the fs, or to the file?

304k doesn't divide evenly into 646345728 bytes so I'm not sure...

> I had the same problem with ext2 but every ~620M (the amount wasn't
> so constant).
> 
> Also i tryed to "posix_fallocate" with (eg 2G), and the first write
> overhead comes at this limit. I would like to avoid to preallocate.

Preallocation -should- be helpful in general, so if it's not ...

> I suppose it is a kind of block allocation issue. But i would like to
> have your opinion : - what is exatcly this amount of bytes ? - can i
> do something for having a "constant" write time from the user space
> point of view ? - is it a "probem" only for me ?

It might be interesting to know what the geometry of your filesystem is,
dumpe2fs -h would provide that.  Also if you could mock up a testcase
that demonstrates the behavior, it would help in debugging.

Actually... as a first step I would redo the test yourself with
-O ^uninit_bg at mkfs time to see if the bitmap init is causing the
delay.

-Eric

> Thank you for your reading.
> 
> Paul.
> 
> 
> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-ext4" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

  
