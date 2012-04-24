From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Tue, 24 Apr 2012 16:26:02 -0500
Message-ID: <4F971A6A.90502@redhat.com>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com> <4F96D08B.2020606@itwm.fraunhofer.de> <4F96FD45.9080902@redhat.com> <901B2AB2-C9FF-47AE-BB8F-5005BD80B9D0@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	linux-ext4@vger.kernel.org, Fan Yong <yong.fan@whamcloud.com>,
	bfields@redhat.com
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab2DXV0G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 17:26:06 -0400
In-Reply-To: <901B2AB2-C9FF-47AE-BB8F-5005BD80B9D0@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/24/12 4:28 PM, Andreas Dilger wrote:
> On 2012-04-24, at 2:21 PM, Eric Sandeen wrote:
>> I know I'm being a little pedantic w/ the late review here....
>>
>> It seems like the only differences between ext4_dir_llseek and the old ext4_llseek are these:
>>
>> 1) For SEEK_END, we now return -EINVAL for a positive offset (i.e. past EOF)
>> 2) For SEEK_END, we seek to ext4_get_htree_eof() not to inode->i_size
>> 3) For SEEK_SET, we impose different limits for max offset
>>  - s_maxbytes / ext4_get_htree_eof for !dx/dx, vs. s_bitmap_maxbytes/s_maxbytes
>>
>> Do any of these changes relate to the hash collision problem?  Are any of them uniquely required for ext4, enough to warrant cut & paste of the vfs llseek code (again?)
>>
>> What I'm getting at is: what are the reasons that we cannot use generic_file_llseek_size(), maybe with a new argument to specify a non-standard location for SEEK_END.  Such a change would require a solid explanation, but it'd probably go in if it meant one less seek implementation to worry about.
> 
> So, when we were looking at this code, it makes sense that if dir seek is being done for telldir/seekdir that the parameters for ext4 are hash functions, so they should be compared against hash limits instead of the file size.
> 
> This probably makes sense for other filesystems that use hash cookies instead of byte offsets to have a similar dir seek implementation, but I thought there might be a controversy about this and I'm happy to get it into ext4 as a starting point.

That makes sense... but I think the generic code could be expanded to handle this, if we used the existing size parameter to specify max seekable offset in the dir, and a new parameter to cause SEEK_END to behave in a special way (not depending on i_size?)

-Eric

> Cheers, Andreas
> --
> Andreas Dilger                       Whamcloud, Inc.
> Principal Lustre Engineer            http://www.whamcloud.com/
> 
> 
> 
> 

