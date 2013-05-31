From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
Date: Fri, 31 May 2013 12:15:55 -0500
Message-ID: <51A8DACB.2030806@redhat.com>
References: <51A8C59B.3030308@redhat.com> <20130531172456.GB6915@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab3EaRP6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 13:15:58 -0400
In-Reply-To: <20130531172456.GB6915@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/31/13 12:24 PM, Zheng Liu wrote:
> On Fri, May 31, 2013 at 10:45:31AM -0500, Eric Sandeen wrote:
>> currently the seek_sanity_test (generic/285) fails on ext3
>> or ext2 due to fallocate() failures.  Just ignore that test
>> if the fs doesn't support fallocate.
> 
> Hi Eric,
> 
> I remember that my patch had been applied [1].  But stranger I couldn't
> find it in xfstests tree.  However, I think that your patch is better.
> 
> 1. http://oss.sgi.com/archives/xfs/2013-05/msg00534.html

Oh, right, I had forgotten about that.  Rich, any idea?

I don't care which patch goes in....

-Eric

>                                                 - Zheng
> 
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
>> index cd3b1ee..fbf5a8c 100644
>> --- a/src/seek_sanity_test.c
>> +++ b/src/seek_sanity_test.c
>> @@ -96,9 +96,13 @@ static int do_fallocate(int fd, off_t offset, off_t length, int mode)
>>  	int ret;
>>  
>>  	ret = fallocate(fd, mode, offset, length);
>> -	if (ret)
>> +	if (ret) {
>> +		/* Don't warn about a filesystem w/o fallocate support */
>> +		if (errno == EOPNOTSUPP)
>> +			return ret;
>>  		fprintf(stderr, "  ERROR %d: Failed to preallocate "
>>  			"space to %ld bytes\n", errno, (long) length);
>> +	}
>>  
>>  	return ret;
>>  }
>> @@ -290,8 +294,14 @@ static int test09(int fd, int testnum)
>>  
>>  	/* preallocate 8M space to file */
>>  	ret = do_fallocate(fd, 0, filsz, 0);
>> -	if (ret < 0)
>> +	if (ret < 0) {
>> +		/* Report success if fs doesn't support fallocate */
>> +		if (errno == EOPNOTSUPP) {
>> +			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
>> +			ret = 0;
>> +		}
>>  		goto out;
>> +	}
>>  
>>  	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
>>  	if (!ret) {
>> @@ -336,8 +346,14 @@ static int test08(int fd, int testnum)
>>  
>>  	/* preallocate 4M space to file */
>>  	ret = do_fallocate(fd, 0, filsz, 0);
>> -	if (ret < 0)
>> +	if (ret < 0) {
>> +		/* Report success if fs doesn't support fallocate */
>> +		if (errno == EOPNOTSUPP) {
>> +			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
>> +			ret = 0;
>> +		}
>>  		goto out;
>> +	}
>>  
>>  	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
>>  	if (ret)
>> @@ -379,8 +395,14 @@ static int test07(int fd, int testnum)
>>  
>>  	/* preallocate 4M space to file */
>>  	ret = do_fallocate(fd, 0, filsz, 0);
>> -	if (ret < 0)
>> +	if (ret < 0) {
>> +		/* Report success if fs doesn't support fallocate */
>> +		if (errno == EOPNOTSUPP) {
>> +			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
>> +			ret = 0;
>> +		}
>>  		goto out;
>> +	}
>>  
>>  	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
>>  	if (ret)
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

