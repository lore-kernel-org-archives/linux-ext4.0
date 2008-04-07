From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [ANNOUNCEMENT] Linux POSIX file system test suite
Date: Mon, 07 Apr 2008 10:04:03 -0700
Message-ID: <1207587843.31073.3.camel@badari-desktop>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>
	 <1207247251.30407.59.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.62.0804070207160.25240@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: shaggy@us.ibm.com, chris.mason@oracle.com,
	ntfs-3g-devel@lists.sf.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52739 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYDGREF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2008 13:04:05 -0400
In-Reply-To: <Pine.LNX.4.62.0804070207160.25240@tamago.serverit.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 2008-04-07 at 02:34 +0300, Szabolcs Szakacsits wrote:
> On Thu, 3 Apr 2008, Badari Pulavarty wrote:
> > On Thu, 2008-04-03 at 00:29 +0300, Szabolcs Szakacsits wrote:
> >
> > > The default file system type is ext3 and it passes all tests.
> > 
> > Hmm.. I ran it against ext2, ext3, jfs, btrfs. I don't see all "pass"
> > on ext3. What am I missing ?
> 
> Your unique, consistently failing test cases for all file systems suggest 
> that you have a buggy private kernel or some other individual issue in your 
> test environment.
> 
> You could use the -x debug shell option in the test scripts, rerun the 
> failing ones and they will show why these test cases exactly fail.

I am running 2.6.25-rc8-mm1. What I noticed is, these failures happen
on ppc64. I ran the tests on x86-64 and ext2, ext3 passed all the tests.

> > btrfs seems to have little more failures.
> 
> If you find the reason for the unexpected failures then the btrfs result 
> will be quite good. Apparently it has only a few link, truncate, and unlink 
> ctimes update problems. I think that's quite impressive in its state of 
> development.

Yes. Indeed. btrfs has only these tests failing now (x86-64).


Failed Test                     Stat Wstat Total Fail  Failed  List of Failed
-------------------------------------------------------------------------------
/root/posix/tests/link/00.t                   82    2   2.44%  56 63
/root/posix/tests/truncate/00.t               21    1   4.76%  15
/root/posix/tests/unlink/00.t                 55    3   5.45%  17 22 53
Failed 3/184 test scripts, 98.37% okay. 6/1950 subtests failed, 99.69% okay.

Thanks,
Badari

