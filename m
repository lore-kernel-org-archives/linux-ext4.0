From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 22:03:52 -0500
Message-ID: <4AB44A18.2090104@redhat.com>
References: <4AB2B6B9.7010506@redhat.com> <20090918235952.GE29406@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZISDDw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 23:03:52 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8J33uqY026623
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 23:03:56 -0400
In-Reply-To: <20090918235952.GE29406@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Karel Zak wrote:
> On Thu, Sep 17, 2009 at 05:22:49PM -0500, Eric Sandeen wrote:
>> +static errcode_t ext2fs_get_device_geometry(const char *file,
>> +					    struct ext2_super_block *fs_param)
>> +{

...

>> +	fs_param->s_raid_stride = min_io / blocksize;
>> +	fs_param->s_raid_stripe_width = opt_io / blocksize;
>> +	rc = 0;
>> +out:
> 
>    blkid_free_probe(pr);
> 
> just in case you want to keep valgrind mem-leak checkers silent :-) 

ok :)  If you haven't already updated your mkfs sample 
(blkid/samples/mkfs.c), now's the time to do so; I'll blame my error on 
cut and paste.  :)

Thanks,
-Eric

>> +	close(fd);
>> +	return rc;
>> +}
> 
>     Karel

