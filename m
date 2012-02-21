From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V4 00/22] ext4: Add inline data support
Date: Tue, 21 Feb 2012 16:44:35 -0700
Message-ID: <FA1EAF98-9D9C-408D-BB4C-4A116C6CEA19@dilger.ca>
References: <4F41EF95.2000909@tao.ma>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:51619 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2BUXoi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Feb 2012 18:44:38 -0500
In-Reply-To: <4F41EF95.2000909@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-20, at 12:00 AM, Tao Ma wrote:
> Hi Ted, Andreas and list,
>        This is the v4 attempt to add inline data support to ext4 inode.
> For more information about the background, please refer to the thread
> http://marc.info/?l=linux-ext4&m=131715205428067&w=2
> 
> Changlog from v3 to v4:
> 1. Add support for truncate which is really a bug.
> 2. Some bug fixes.
> 3. rebased to the latest kernel.

I'm starting to look through this patch series, and a number of things are
missing that would make it much easier to understand and accept:
- a good comment and possibly a diagram at the start of fs/ext4/xattr.c
  that describes where and how the inline data is stored in the inode,
  what the policies are for storing data inline or externally, etc.
- some benchmark data that shows why landing this code is desirable.
  My comments in the above thread show that small files and directories
  could benefit from this, but real proof now that you have made this
  patch is whether this translates into noticeable space savings, and
  hopefully also noticeable performance improvements in some benchmarks:
  - I suspect that running some tests with bigalloc + 512-byte inodes
    or similar could show significant space savings and speedups for
    cold-cache directory traversal
  - measuring boot time on a distro with Gnome or KDE could show real
    speedups due to the many small files and directories used at startup
  - running a benchmark like mongo or postmark with small files and
    with 256- or 512-byte inodes may also show real speedups
  - is there some workload that you are using that shows speedups that
    could be described in general terms and show relative performance,
    even if it is not possible to supply the actual benchmark/tests?

I'll go through the patches and suggest cleanups and improvements, but
without improved documentation and real performance tests the patch is
very unlikely to be accepted by Ted.

> Changelog from v2 to v3:
> 1. Add support for evict data from inode if we can store xattr in it.
> 2. Add support for fiemap
> 3. Some nasty bug fixes
> 
> The v3 can be found here:
> http://marc.info/?l=linux-ext4&m=132421821001634&w=2
> 
> The v2 can be found here:
> http://marc.info/?l=linux-ext4&m=132189338604177&w=2
> 
> The v1 can be found here:
> http://marc.info/?l=linux-ext4&m=131961438221255&w=2
> 
> any suggestions are welcomed.
> 
> Thanks
> Tao


Cheers, Andreas





