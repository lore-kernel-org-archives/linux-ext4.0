From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 12:43:47 -0600
Message-ID: <004198D6-9941-4322-BDB1-8176B80262C7@dilger.ca>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org> <1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org> <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca> <20110421180213.GA19255@infradead.org> <1303408883-sup-1495@think> <20110421180805.GA2627@infradead.org> <1303410534-sup-6933@think>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
	jack <jack@suse.cz>, axboe <axboe@kernel.dk>,
	dchinner <dchinner@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8145 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1DUSn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 14:43:58 -0400
In-Reply-To: <1303410534-sup-6933@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-21, at 12:29 PM, Chris Mason wrote:
> Excerpts from Christoph Hellwig's message of 2011-04-21 14:08:05 -0400:
>> On Thu, Apr 21, 2011 at 02:02:43PM -0400, Chris Mason wrote:
>>> For this program, they are almost all dirty pages.
>>> 
>>> I tried patching it to give up if we seek but it is still pretty slow.
>>> There's something else going on in addition to the xfs clustering being
>>> too aggressive.
>> 
>> I'm not sure where you this beeing to agressive from - it's doing
>> exactly the same amount of I/O as a filesystem writing out a single
>> page from ->writepage or using write_cache_pages (either directly
>> or as a copy) as ->writepages.  The only thing special compared to
>> the no ->writepages case is that it's submitting a large I/O
>> from the first ->writepage call.
> 
> Ok, I see what you mean.  The clustering code stops once it hits
> nr_to_write, I missed that.  So we shouldn't be doing more than a single
> writepages call.

I wonder if it makes sense to disentangle the two processes state in the kernel, by forking the fsync thread before any writes are done.  That would avoid penalizing the random writer in the VM/VFS, but means there needs to be some coordination between the threads (e.g. polling for a sentinel file written when the sequential phase is complete).

Cheers, Andreas





