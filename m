From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext3 warnings from LTP rename14
Date: Thu, 18 Oct 2007 00:08:50 -0600
Message-ID: <20071018060850.GN8122@schatzie.adilger.int>
References: <20071017002009.GA2966@palantir8> <4715637B.1090503@redhat.com> <471570CB.3030709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48786 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbXJRGI6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2007 02:08:58 -0400
Content-Disposition: inline
In-Reply-To: <471570CB.3030709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 16, 2007  21:17 -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Martin Habets wrote:
> >> I ran the ltp-full-20070930 tests on 2.6.23-rc9-mph4 (sparc32 SMP), and am
> >> seeing the following warnings:
> > 
> > This makes me a little nervous about my change
> > ef2b02d3e617cb0400eedf2668f86215e1b0e6af
> > (ext34: ensure do_split leaves enough free space in both blocks)
> > 
> > Do you know when this first showed up?  Could you test -rc6?
> > 
> > You say you can reproduce it; have you checked (fsck'd) the filesystem
> > in between, and is it in good shape?
> > 
> > -Eric
> 
> FWIW, I ran rename14 "standalone" a few times on 2.6.23.1 with no
> problems...
> 
> [root@bear-05 ltp-full-20070930]#
> ./testcases/kernel/syscalls/rename/rename14
> rename14    1  PASS  :  Test Passed
> [root@bear-05 ltp-full-20070930]#
> ./testcases/kernel/syscalls/rename/rename14
> rename14    1  PASS  :  Test Passed
> [root@bear-05 ltp-full-20070930]#
> ./testcases/kernel/syscalls/rename/rename14
> rename14    1  PASS  :  Test Passed
> [root@bear-05 ~]# uname -a
> Linux bear-05.lab.msp.redhat.com 2.6.23.1 #1 SMP Mon Oct 15 15:28:08 CDT
> 2007 i686 athlon i386 GNU/Linux

It is probably significant that the original machine is a sparc32 (big
endian).  I'd suspect you can reproduce this on a PPC system also.  You
might also consider running sparse on it ext3/ext4 in case you missed an
le32_to_cpu() or something.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
