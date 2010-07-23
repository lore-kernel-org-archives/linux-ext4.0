From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests 240: test non-aligned AIO hole-filling
Date: Thu, 22 Jul 2010 22:32:29 -0500
Message-ID: <4C490D4D.603@redhat.com>
References: <4C489676.2000605@redhat.com> <20100723024938.GD32635@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab0GWDcl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 23:32:41 -0400
In-Reply-To: <20100723024938.GD32635@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner wrote:

> On Thu, Jul 22, 2010 at 02:05:26PM -0500, Eric Sandeen wrote:
>   
>> This replicates file corruption we've seen with qemu-kvm when
>> we use if=virtio,cache=none,aio=native for IO to a sparse
>> ext4- or xfs-hosted file, and the partitions/filesystems
>> within that file image are not block-aligned.  (think sector
>> 63 here...)  This results in AIO IOs not aligned to the
>> filesystem blocks.
>>
>> This test modifies aiodio_sparse2.c to add an option to start
>> the file IO at an offset.
>>
>> When we do 4k writes to a 16k file in 2 threads, starting
>> at offset 512, we get 0s interspersed in the file where they
>> should not be:
>>
>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00000200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
>> *
>> 00001000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00001200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
>> ....
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>     
>
> looks good - it needs to remove the $TEST_DIR/aiodio_sparse file
> before the test starts, though, so that repeated tests fail
> correctly. Otherwise:
>
>   
hm, but:

+rm -f "$TEST_DIR/aiodio_sparse*"
+
+# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
+$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"

It does remove it ... no?


> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
>   
thanks

> Also, Eric, can you run this proof-of-concept test branch (on top of
> the current XFS for-2.6.36 branch) and see if QEMU is happy with it?
> It passes this test on my machine....
>
>   
Absolutely, thanks!

-Eric

