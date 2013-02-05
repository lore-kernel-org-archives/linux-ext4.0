From: Mark Tinguely <tinguely@sgi.com>
Subject: Re: [PATCH 0/4] xfstests: seek data/hole and hole punching improvements
Date: Tue, 05 Feb 2013 09:39:46 -0600
Message-ID: <511127C2.2010409@sgi.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Jie Liu <jeff.liu@oracle.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:37581 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab3BEPjr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2013 10:39:47 -0500
In-Reply-To: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/28/13 01:32, Zheng Liu wrote:
> Hi all,
>
> Here is my first try to improve seek data/hole and hole punching test
> cases in xfstests.  The key issue in 255 and 285 is that they assume that
> all file systems that are tested support unwritten extent preallocation.
> Before 3.8 kernel it is correct.  But now ext4 file system has ability
> to seek data/hole and punch a hole for a file w/o unwritten extent.  So
> it is time to improve these test cases.
>
> In this patch series it calls _require_xfs_io_falloc in 255 and 285 to
> make sure that unwritten extent is supprted by tested file system.  A
> new argument '-t' is added into seek_sanity_test to check a file system
> that supports seek data/hole or not.  In the mean time _require_seek_data_hole
> is defined to be used by all tests.
>
> Further two new test cases are created to test seek data/hole and hole
> punching w/o unwritten extent, which do the same thing like 255 and 285
> except that they don't do some test cases which are related to unwritten
> extent.
>
> Any comments or feedbacks are welcome.
>
> Thanks,
> 						- Zheng

Hi Zheng,

I wonder if reviving the idea of putting the SEEK_DATA/SEEK_HOLE
feature into xfs_io would simplify the existing tests and future ones.

My last version of the SEEK_DATA/SEEK_HOLE xfs_io extension should be
sightly changed to make the hole only test output to be consistent with
the data test; namely, it should end with an EOF entry.

	http://oss.sgi.com/archives/xfs/2012-11/msg00106.html

I know there will be some result filtering needed for holes which the C
program based tests already provide.

Just a thought.

--Mark.

