From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Using O_DIRECT in ext4
Date: Mon, 20 Jul 2009 22:41:15 -0500
Message-ID: <4A6538DB.5050202@redhat.com>
References: <d5ca277e0907201841i18b83bb6uea757e83d177bc9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Xiang Wang <xiangw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbZGUDlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 23:41:21 -0400
In-Reply-To: <d5ca277e0907201841i18b83bb6uea757e83d177bc9b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Xiang Wang wrote:
> Hi,
> 
> Recently I've been experimenting with O_DIRECT in ext4 to get a
> feeling of how much file fragmentation will be generated.
> 
> On a newly formatted ext4 partition(no-journal), I created a top-level
> directory and under this top-level directory I ran a test program to
> generate some files.
> 
> The test program does the following:
> -- create multiple threads(in my test case: 16 threads)
> -- each thread creates a file with the O_DIRECT flag and keeps
> extending the file to 1MB
> Since these threads run concurrently, they compete in block allocation.
> 
> After the program ran to a completion, I ran filefrag on each file and
> measure how many extents there are in the file.
> And here is a sample result:
> file0: 6 extents found
> file1: 20 extents found
> file2: 7 extents found
> file3: 6 extents found
> file4: 6 extents found
> file5: 5 extents found
> file6: 6 extents found
> file7: 20 extents found
> file8: 20 extents found
> file9: 20 extents found
> file10: 20 extents found
> file11: 20 extents found
> file12: 20 extents found
> file13: 19 extents found
> file14: 19 extents found
> file15: 19 extents found
> 
> Looks like these files are quite heavily fragmented.

Multiple parallel extending DIOs in a single dir is a tough case for a
filesystem - it has no hints about what to do, and can't use delalloc to
wait to see what's happening; it just has to allocate things as they
come, more or less.

> For comparison, I did the same experiment on an ext2 partition,
> resulting in each file having only 1 extent.

Interestinng, not sure I would have expected that.

> I also did the experiments of using buffered writes(by removing the
> O_DIRECT flag) on ext2 and ext4, both resulting in each file having
> only 1 extent.

delayed allocation at work I suppose.

> I am wondering whether this kind of file fragmentation is already a
> known issue in ext4 when O_DIRECT is used? Is it something by design?
> Since it seems like ext2 does not have this issue under my test case,
> is it necessary that we make the behavior of ext4 similar to ext2
> under situations like this?

Is this representative of a real workload?

-Eric

> Thanks,
> Xiang


