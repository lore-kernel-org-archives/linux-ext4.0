From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 0/5][64-BIT] Miscellaneous e2fsprogs 64-bit patches - description
Date: Wed, 15 Apr 2009 15:50:14 -0400
Message-ID: <20090415195014.GB1668@shell>
References: <11629.1239227147@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbZDOTu2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 15:50:28 -0400
Content-Disposition: inline
In-Reply-To: <11629.1239227147@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2009 at 05:45:47PM -0400, Nick Dokos wrote:
> [I submitted the first three of these last week, but the first one,
> although the fix was correct (in the sense of fiddling with the correct
> bits), stylistically and from the point of code conventions and
> readability, was rather a botch.  #2 and #3 are identical as patches but
> I fixed up parts of the commentary that were wrong or misleading. So I
> am reposting these as well as a couple of new ones. Please let me know
> if there are other problems of this sort. Thanks!]

Hi Nick,

Thanks for the testing and patches!  I apologize for the delay in
replying; if it's any consolation, we were all at the Linux file
systems workshop when you sent this email.

All the patches look good to me (and I will ACK them individually).  I
pulled them into my shared-64bit branch at:

http://git.kernel.org/?p=fs/ext2/val/e2fsprogs.git;a=summary

> P.S. Here is an interesting side issue:
> 
> Patch 3 mentions that e2image ran to completion after the patch was applied
> (btw, in addition to the 16TiB file, the fs contains a directory with about
> 10^7 zero length files):
> 
> # time e2image -r /dev/mapper/bigvg-bigvol /dev/null
> e2image 1.41.4-shared-64bit (27-Jan-2009)
> 
> real	37m18.991s
> user	15m21.148s
> sys	17m57.151s
> 
> but there is an interesting catch-22: how do I save its output?
> 
> I can try the command line suggested in the manual page:
> 
>   e2image -r <dev> - | bzip2 > image.bz2
> 
> but it takes forever: I started a run on Saturday and it was not
> done by Tuesday when I killed it - writing to the pipe at 4096 bytes
> a pop is very slow.
> 
> Or I can forego the compression and try to save to a file: it's sparse
> (I only used 7GiB before it failed), but its nominal size exceeded the
> maximum file size limit on ext4, at which point I start getting lseek
> failures.

The 16TB limit on ext4 files is an enormous pain for testing 64-bit
(>= 16TB) file systems.  I keep intending to write some simple dm
setup to concatenate two loopback files together, but instead I always
install XFS and create a loopback file on an XFS partition.

-VAL
