From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [RFC PATCH] ext4: Don't release mutex for DAX write
Date: Tue, 3 May 2016 11:58:46 -0400
Message-ID: <5728CAB6.4050101@hpe.com>
References: <1462219138-44089-1-git-send-email-Waiman.Long@hpe.com> <20160503084343.GA31363@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:40576
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933748AbcECP7D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2016 11:59:03 -0400
In-Reply-To: <20160503084343.GA31363@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/03/2016 04:43 AM, Christoph Hellwig wrote:
> As explained in another thread I really think we need to get DAX
> to stop pretending to be direct I/O, which should also take care
> of the locking.  The same issue also exists for ext2 and XFS so it
> needs to be solved at a higher level.

I think the DAX code was in the DIO path because it didn't want to use 
buffer cache at all. Taking DAX out from DIO will mean having a third 
mode of doing I/O which is similar to DIO in certain ways, but not 
exactly the same. There will be a certain amount of code duplication in 
this case. Do we really want to do that?

As for the locking problem, xfs doesn't seem to have issue as it uses a 
rwsem in the xfs inode for synchronization. I haven't looked into the 
ext2 code to see if there is any issue there.

Cheers,
Longman


