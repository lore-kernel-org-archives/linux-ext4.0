From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in
 ext4_setattr()
Date: Wed, 18 May 2011 15:31:29 -0500
Message-ID: <4DD42CA1.8050700@redhat.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>	<4DD33AA9.9060104@redhat.com> <BANLkTi=Yv_q820aHFa2wkCL-PnYNcZdWCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab1ERUbe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 16:31:34 -0400
In-Reply-To: <BANLkTi=Yv_q820aHFa2wkCL-PnYNcZdWCQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/18/11 3:28 PM, Jiaying Zhang wrote:
> 
> 
> On Tue, May 17, 2011 at 8:19 PM, Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> wrote:
> 
>     On 5/17/11 5:59 PM, Jiaying Zhang wrote:
>     > There is a bug in commit c8d46e41 "ext4: Add flag to files with blocks
>     > intentionally past EOF" that if we fallocate a file with FALLOC_FL_KEEP_SIZE
>     > flag and then ftruncate the file to a size larger than the file's i_size,
>     > any allocated but unwritten blocks will be freed but the file size is set
>     > to the size that ftruncate specifies.
>     >
>     > Here is a simple test to reproduce the problem:
>     >   1. fallocate a 12k size file with KEEP_SIZE flag
>     >   2. write the first 4k
>     >   3. ftruncate the file to 8k
>     > Then 'ls -l' shows that the i_size of the file becomes 8k but debugfs
>     > shows the file has only the first written block left.
> 
>     To be honest I'm not 100% certain what the fiesystem -should- do in this case.
> 
>     If I go through that same sequence on xfs, I get 4k written / 8k unwritten:
> 
>     # xfs_bmap -vp testfile
>     testfile:
>      EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET              TOTAL FLAGS
>       0: [0..7]:          2648750760..2648750767  3 (356066400..356066407)     8 00000
>       1: [8..23]:         2648750768..2648750783  3 (356066408..356066423)    16 10000
> 
>     size 8k:
>     # ls -l testfile
>     -rw-r--r-- 1 root root 8192 May 17 22:33 testfile
> 
>     and diskspace used 12k:
>     # du -hc testfile
>     12K     testfile
>     12K     total
> 
>     I think this is a different result from ext4, either with or without your patch.
> 
>     On ext4 I get size 8k, but only the first 4k mapped, as you say.
> 
> I agree that truncating to a size larger than i_size is un-specified by
> POSIX. However, I think the problem with the current behavior is that
> we have an inconsistency between file's i_size and its extent tree.
> Now we have 8k i_size but the file has only 4k space allocated. That
> can confuse applications.

That's called "a sparse file" right?  Apps should not be confused by that ...

-Eric
