From: Chanho Park <chanho61.park@samsung.com>
Subject: RE: [e2fsprogs] resizing to minimum was failed since 45a78b
Date: Thu, 30 Apr 2015 19:12:04 +0900
Message-ID: <012401d0832e$1b353330$519f9990$@samsung.com>
References: <01cb01d08257$26157350$724059f0$@samsung.com>
 <20150429142912.GA18756@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:13651 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbD3KMH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Apr 2015 06:12:07 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NNM00205704MS00@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 30 Apr 2015 19:12:04 +0900 (KST)
In-reply-to: <20150429142912.GA18756@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> -----Original Message-----
> From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-
> owner@vger.kernel.org] On Behalf Of Theodore Ts'o
> Sent: Wednesday, April 29, 2015 11:29 PM
> To: Chanho Park
> Cc: darrick.wong@oracle.com; linux-ext4@vger.kernel.org
> Subject: Re: [e2fsprogs] resizing to minimum was failed since 45a78b
> 
> On Wed, Apr 29, 2015 at 05:33:20PM +0900, Chanho Park wrote:
> >
> > When I tried to resize a loop ext4 image to minimum, I couldn't get
> correct
> > result.
> 
> It all depends on your definition of "correct".  I've regretted
> accepting the the patch to implement -M, since in practice almost
> everyone who has been using really shouldn't have been.  It's useful
> for developers who want to stress test resize2fs to make sure it does
> the right thing in corner cases.
> 
> However, it's a *terrible* idea for anyone to use it for __anything__
> else.  The result of using resize2fs -M is a file system where the
> files are highly fragmented.  The first real world use of resizde2fs
> -M I was aware of, which was some clever Red Hat release engineer
> which created a huge file system, installed Red Hat on it, compressed
> it down to a minimum size using resize2fs -M, and then burned the
> result on a CD-ROM for use as a bootable Live CD system image.  The
> resulting fragmentation of files as a result of resize2fs -M meant
> that reading certain files from the CD-ROM, which is not known for its
> high seek speeds, was, shall we say, less than optimal.
> 
> Because I don't think there are mant (any?) real sane/valid production
> uses of resize2fs -M, my definition of "correct" for resize -M is that
> it doesn't (a) corrupt file systems, or (b) lead to a state when
> resize2fs -M might not be able to make forward progress, leaving to a
> file-system which is half-resized, corrupt, and requiring expert
> surgery from a file system expert to recover.  The reason why I care
> about this is because it's not just used by misguided release
> engineers trying to create file system images from source builds,
> where if there is a corrupted file system, it's not a disaster.
> 
> Unfortunately, it's also used by clueless users who usually have _not_
> made a backup before trying to use resize2fs -M to shrink their file
> system before trying to rearrange their LVM volumes.  And users get
> cranky when they lose data.

In my situation, I usually use the "resize2fs -M" when making a tizen
platform image. As you know, like android, tizen also uses ext4 filesystem
and flash the image from bootloader. Instead of flashing full image size, we
only flash shrinked filesystem image to reduce flashing time and want to
avoid download huge files. If the partition size is 3GB, we'll make a 3GB
loop image and fill files into it. And I shrink the loop image to the
minimum size and flash it to my phone. When first booting, the system will
do resizing the partition to 3GB original size.

> 
> So the bottom line is I care a lot more about data loss than I do
> about shrinking file systems to the absolute minimum size, and I
> personaly don't think it's worth a huge amount of effort to try to
> make the calculation of the minimum size where resize2fs is guaranteed
> to succeed any closer to being exact.
> 
> That being said, if you are creating a read-only file system for a
> flash image (where seeks are largely free), and you really insist on
> using resize2fs -M, it may be that your best bet is to turn off the
> flex_bg option, since most of the advantages of flex_bg aren't there
> on a read-only flash image (such as might be used for a
> system/firmware image).

I could get below result when I turned off flex_bg option.

ls -al foo.img
-rw-r--r-- 1 root root 390680576 Apr 30 10:02 foo.img

Like android, a root filesystem of tizen is also read-only, but it's only to
protect the filesystem from sudden power off. Sometimes it could be
writeable when installing some system packages and required some system
actions.

> 
> Alternatively, if you want to invest effort in trying to make
> resize2fs -M mimum file system size more accurate, feel free to send
> me patches --- plus your proof in terms of code analysis and an
> exhaustive test regime to make sure that it works for a wide variety
> of file system sizes and free space availability pre-resize2fs.
> Personally, I don't think it's a particularly worthwhile use of an
> engineer's time, but if you really have a strong business need for
> this, feel free work on it and send me the results of your efforts.

Okay. I'll investigate it and make a patch if possible :)

Best Regards,
Chanho Park

