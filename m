From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Date: Mon, 18 Mar 2013 11:10:51 -0500
Message-ID: <51473C8B.5070509@redhat.com>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com> <20130317030648.GA14225@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3CRQKn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 12:10:43 -0400
In-Reply-To: <20130317030648.GA14225@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/16/13 10:06 PM, Theodore Ts'o wrote:
> On Sat, Mar 16, 2013 at 11:09:23PM +0800, Zheng Liu wrote:
>>
>> I see what's going on.  First of all it isn't a bug. :-)  Please let me
>> describe why it happens.
>>
>> In this commit (4f42f80a8f), it tries to fix a bug that we never zero
>> out an unwritten extent.  So after applied it, when an unwritten extent
>> is converted, it could be zeroed out.  In xfstests #285 subtest 08 it
>> preallocates an unwritten extent which is 4MB.  Then it writes some data
>> at offset 10 * blocksize, which the length is one blocksize, and calles
>> sync_file_range(2) to flush it.
> 
> Specifically, we are now honoring the default setting which sets the
> max_zeroout_kb value to be 32.  With a 4k block file system, if we
> were to zeroout the extent, we would have to zero out 40k, which is
> greater than 32k, so resulting file after pwrite(fd, 4096, 40960)
> looks like this:
> 
> % filefrag -v /u1/foo08 
> Filesystem type is: ef53
> File size of /u1/foo08 is 4194304 (1024 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..       9:    1852416..   1852425:     10:             unwritten
>    1:       10..      10:    1852426..   1852426:      1:            
>    2:       11..    1023:    1852427..   1853439:   1013:             unwritten,eof
> /u1/foo08: 1 extent found
> 
> With a 1k block file system, we only need to zero out 10k, which is
> less than 32k, and so after pwrite(fd, 1024, 10240), the file looks
> like this:
> 
> % filefrag -v /mnt/foo08
> Filesystem type is: ef53
> File size of /mnt/foo08 is 4194304 (4096 blocks of 1024 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..      10:      81921..     81931:     11:            
>    1:       11..    4095:      81932..     86016:   4085:             unwritten,eof
> /mnt/foo08: 1 extent found
> 

So the issue is just that the test is looking for actual holes
in specific locations , but the fs chose to allocate zero-filled
blocks instead?

> If we run src/seek_sanity_test by hand, we can make it happy by
> setting the following configuration option before we run it:
> 
> echo 0 > /sys/fs/ext4/<dev>/extent_max_zeroout_kb 

The test could do this too, right?

_need_to_be_root

and:

if [ "$FSTYP" == "ext4" ]; then
	ORIG_ZEROOUT_KB=`cat /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb`
	echo 0 > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
fi

and put it back to default in _cleanup:

	echo $ORIG_ZEROOUT_KB > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb

That way we'd be testing seek hole correctness w/o being subject to
the vagaries in allocator behavior.

-Eric


> I'm not sure what's the best way to make xfstest #285 happy, though.
> 
> One way might be to change the test so that instead of writing the
> data at offset bufsize*10, we change it so it writes the data at
> offset bufsize*40, and change the expected values accordingly.  The
> other would be to add some kind of ext4-specific hack to test #285
> which manually sets the extent_max_zeroout_kb tuning parameter after
> the file system is mounted.
> 
> I'm not sure which is more likely to be accepted by the xfstests
> maintainers.  I suspect the former, but they may not like either
> solution, in which case we might have to disable 285 for ext4 and
> create an ext4-specific test.
> 
> 	      		    	    	    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

