From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 0/5][64-BIT] Miscellaneous e2fsprogs 64-bit patches - description
Date: Wed, 15 Apr 2009 18:16:02 -0400
Message-ID: <20090415221602.GJ1668@shell>
References: <11629.1239227147@alphaville.usa.hp.com> <20090415195014.GB1668@shell> <49E63BDF.5020506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZDOWQH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 18:16:07 -0400
Content-Disposition: inline
In-Reply-To: <49E63BDF.5020506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2009 at 02:56:15PM -0500, Eric Sandeen wrote:
> Valerie Aurora Henson wrote:
> > On Wed, Apr 08, 2009 at 05:45:47PM -0400, Nick Dokos wrote:
> 
> 
> >> but there is an interesting catch-22: how do I save its output?
> >>
> >> I can try the command line suggested in the manual page:
> >>
> >>   e2image -r <dev> - | bzip2 > image.bz2
> >>
> >> but it takes forever: I started a run on Saturday and it was not
> >> done by Tuesday when I killed it - writing to the pipe at 4096 bytes
> >> a pop is very slow.
> >>
> >> Or I can forego the compression and try to save to a file: it's sparse
> >> (I only used 7GiB before it failed), but its nominal size exceeded the
> >> maximum file size limit on ext4, at which point I start getting lseek
> >> failures.
> 
> We really need some e2image format which encodes the sparseness, I think...

That seems like a low priority to me.  But it would make a great
Google Summer of Code project...

> > The 16TB limit on ext4 files is an enormous pain for testing 64-bit
> > (>= 16TB) file systems.  I keep intending to write some simple dm
> > setup to concatenate two loopback files together, but instead I always
> > install XFS and create a loopback file on an XFS partition.
> 
> For testing a large device, say /dev/sdb1 is 10GB large:
> 
> # TERABYTES=`expr 20 \* 1024 \* 1024 \* 1024 \* 2`   # 20 TB in sectors
> # echo "0 $ERABYTES zero" | dmsetup create zero1
> # echo "0 $TERABYTES snapshot /dev/mapper/zero1 /dev/sdb1 p 128" | \
>    dmsetup create sparse1
> 
> This will create a 20TB sparse device called /dev/mapper/sparse1 that
> has 10GB of actual storage space available. If more than 10GB of data is
> written to this device, it will start returning I/O errors.
> 
> This is from Documentation/device-mapper/zero.txt

Wow, that just rolls right off the tongue... Thanks for the pointer.
I'm going to see if I can come up with something that I can memorize
(although generally not hurting for a copy of the kernel source).

-VAL
