From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsprogs w/64-bit patches: make check gets one failure
Date: Thu, 12 Mar 2009 14:36:45 -0600
Message-ID: <20090312203645.GI3199@webber.adilger.int>
References: <12304.1236797612@alphaville.usa.hp.com>
 <20090312040210.GQ3199@webber.adilger.int>
 <12502.1236867091@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42253 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbZCLUhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2009 16:37:11 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2CKb5lq016797
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 13:37:05 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KGE00K00UA2C900@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 12 Mar 2009 13:37:05 -0700 (PDT)
In-reply-to: <12502.1236867091@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 12, 2009  10:11 -0400, Nick Dokos wrote:
> Andreas Dilger <adilger@sun.com> wrote:
> > On Mar 11, 2009  14:53 -0400, Nick Dokos wrote:
> > > I followed the workflow that Ted described in the following message:
> > > 
> > >    http://marc.info/?l=linux-ext4&m=123367642710241&w=2
> > > 
> > > with the patch series from git://github.com/tytso/e2fsprogs-64bit.git
> > > 
> > > With all the patches in the series file applied, make check gives
> > > me the following error:
> > > 
> > > ...
> > > f_h_reindex: reindex HTREE Directory with different hash seed: failed
> > > ...
> > > 100 tests succeeded	1 tests failed
> > > make[1]: *** [check] Error 1
> > > make[1]: Leaving directory `/home/nick/src/e2fsprogs/standard/build/tests'
> > > make: *** [check-recursive] Error 1
> > 
> > Including the content of the tests/f_h_reindex.failed file might make
> > the problem obvious.  Possibly it is just some change in the output
> > format that is causing expect to fail.
> > 
> 
> Here's the f_h_reindex.failed file:
> 
> --- ../../tests/f_h_reindex/expect.1	2009-03-09 17:14:20.000000000 +0000
> +++ f_h_reindex.1.log	2009-03-12 14:18:05.000000000 +0000
> @@ -954,5 +954,5 @@
>  Pass 5: Checking group summary information
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> -test_filesys: 30514/32000 files (0.0% non-contiguous), 5669/8000 blocks
> +test_filesys: 30514/32000 files (0.0% non-contiguous), 5560/8000 blocks
>  Exit status is 1
> --- ../../tests/f_h_reindex/expect.2	2009-03-09 17:14:20.000000000 +0000
> +++ f_h_reindex.2.log	2009-03-12 14:18:05.000000000 +0000
> @@ -1,7 +1,10823 @@
>  Pass 1: Checking inodes, blocks, and sizes
> +Inode 24001, i_size is 596992, should be 485376.  Fix? yes

This looks like it is causing an inode to be truncated.

>  Pass 2: Checking directory structure
> +Problem in HTREE directory inode 24001 (/test2): bad block number 578.
> +Clear HTree index? yes

Supporting evidence that this is a directory being truncated.

>  Pass 3: Checking directory connectivity
> +Pass 3A: Optimizing directories
>  Pass 4: Checking reference counts
> +Unattached zero-length inode 12.  Clear? yes
> +
> +Unattached zero-length inode 13.  Clear? yes

These are all of the inodes that were lost from the truncated directory.

This seems like a non-trivial failure and needs to be investigated.
Posting the offending patch (assuming you can pass "make check" before
the patch, and fail afterward) would get more eyes on the subject.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

