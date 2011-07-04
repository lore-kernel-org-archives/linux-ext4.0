From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2fsprogs 1.42-WIP-0702 released
Date: Mon, 4 Jul 2011 11:49:16 -0600
Message-ID: <D24E441E-2821-4BF5-9A8A-423070A2464E@dilger.ca>
References: <E1QdWwc-0002Qx-Th@tytso-glaptop> <4E117FB3.3030403@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:42503 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab1GDRtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jul 2011 13:49:32 -0400
In-Reply-To: <4E117FB3.3030403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-04, at 2:54 AM, Ric Wheeler wrote:
> On 07/04/2011 01:23 AM, Theodore Ts'o wrote:
>> I've made the first WIP release of e2fsprogs 1.42.  The primary purpose
>> is for people to test the 64-bit functionality and be confident that we
>> didn't introduce any 32-bit regressions.
>> 
>> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/e2fsprogs-1.42-WIP-0702.tar.gz
>> 
>> This has been built for Debian unstable, so we can get some initial
>> testing.
> 
> Thanks Ted!
> 
> Do we have a specific idea of who is going to be testing and on what size
> file systems?
> 
> We might want to see about getting this ready for Fedora as well at some point....

Ric,
we have been doing fairly thorough testing at 24TB, because that is
the LUN size when using 3TB drives in RAID-6 8+2 config.  One caveat
is that this is only on the Lustre data servers, so it doesn't exercise
namespace operations and external xattrs very much, since there is no
benefit to large LUNs on the metadata server due to the 4B inode limit.

We have also done some testing up to 128TB, which works fine if the
filesystem passes the initial mount, but has occasional problems at
mount due to kmalloc() failures of large data structs, with oops at
ext4_fill_super() cleanup (http://jira.whamcloud.com/browse/LU-136
and http://jira.whamcloud.com/browse/LU-477).  The oops is completely
unrelated to >16TB LUN support, but is in generic error handling in
ext4_fill_super().  Hopefully now that the developer doing this testing
has finished testing 24TB LUNs, she will be able to work on issues
we've found with 128TB+ LUNs.

In our admittedly unrealistic circumstances, e2fsck run time is very
short, due to flex_bg, uninit_bg, and extents avoiding a lot of seeking
and unnecessary IO.  With "lazy_journal_init" and "lazy_itable_init"
the mke2fs time is also very short.

Cheers, Andreas





