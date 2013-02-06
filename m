From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/4] xfstests: seek data/hole and hole punching
 improvements
Date: Wed, 6 Feb 2013 10:42:25 +0800
Message-ID: <20130206024225.GA11254@gmail.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
 <511127C2.2010409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Jie Liu <jeff.liu@oracle.com>
To: Mark Tinguely <tinguely@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:47118 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3BFC2H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2013 21:28:07 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so373878dan.9
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 18:28:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <511127C2.2010409@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 05, 2013 at 09:39:46AM -0600, Mark Tinguely wrote:
> On 01/28/13 01:32, Zheng Liu wrote:
> >Hi all,
> >
> >Here is my first try to improve seek data/hole and hole punching test
> >cases in xfstests.  The key issue in 255 and 285 is that they assume that
> >all file systems that are tested support unwritten extent preallocation.
> >Before 3.8 kernel it is correct.  But now ext4 file system has ability
> >to seek data/hole and punch a hole for a file w/o unwritten extent.  So
> >it is time to improve these test cases.
> >
> >In this patch series it calls _require_xfs_io_falloc in 255 and 285 to
> >make sure that unwritten extent is supprted by tested file system.  A
> >new argument '-t' is added into seek_sanity_test to check a file system
> >that supports seek data/hole or not.  In the mean time _require_seek_data_hole
> >is defined to be used by all tests.
> >
> >Further two new test cases are created to test seek data/hole and hole
> >punching w/o unwritten extent, which do the same thing like 255 and 285
> >except that they don't do some test cases which are related to unwritten
> >extent.
> >
> >Any comments or feedbacks are welcome.
> >
> >Thanks,
> >						- Zheng
> 
> Hi Zheng,
> 
> I wonder if reviving the idea of putting the SEEK_DATA/SEEK_HOLE
> feature into xfs_io would simplify the existing tests and future ones.
> 
> My last version of the SEEK_DATA/SEEK_HOLE xfs_io extension should be
> sightly changed to make the hole only test output to be consistent with
> the data test; namely, it should end with an EOF entry.
> 
> 	http://oss.sgi.com/archives/xfs/2012-11/msg00106.html
> 
> I know there will be some result filtering needed for holes which the C
> program based tests already provide.

Hi Mark,

Thanks for your comment.  I am fine with your idea of using xfs_io to
seek data/hole.  In next version I will try to use xfs_io to implement
_require_seek_data_hole().

Regards,
                                                - Zheng
