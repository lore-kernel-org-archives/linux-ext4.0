From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn commit
Date: Mon, 29 Sep 2008 19:05:49 -0400
Message-ID: <48E15F4D.3000305@redhat.com>
References: <E1KjlCM-0002L7-SO@closure.thunk.org> <48E138B2.8080707@sun.com> <20080929205712.GH10831@mit.edu> <48E142C4.7090809@redhat.com> <20080929230031.GK10831@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Alex Tomas <bzzz@sun.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYI2XGN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Sep 2008 19:06:13 -0400
In-Reply-To: <20080929230031.GK10831@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Sep 29, 2008 at 05:04:04PM -0400, Ric Wheeler wrote:
>   
>> I don't disagree with any of the above, just want to point out that TRIM  
>> has a  SCSI T10 cousin that is very similar (used to implement thinly  
>> provisioned luns). We should make sure as much as possible to make our  
>> file system level support work for both...
>>
>>     
>
> That's shouldn't be a problem.  David Woodhouse created a standard
> block device interface that should be suitable both for ATA and SCSI:
>
>     int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> 		         unsigned nr_sects, bio_end_io_t end_io);
>
> 							- Ted
>
>   

I know, just wanted to point out to the broader audience that it is not 
just trim ;-)

ric

