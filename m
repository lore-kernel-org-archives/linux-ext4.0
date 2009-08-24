From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 14:37:46 -0400
Message-ID: <4A92DDFA.1040906@redhat.com>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbZHXShu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 14:37:50 -0400
In-Reply-To: <20090824183119.GI5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Aug 24, 2009  09:34 -0400, Theodore Ts'o wrote:
>   
>> On Mon, Aug 24, 2009 at 10:33:10AM +0200, Christian Fischer wrote:
>>     
>>> I try to figure out reasonable mount options for ext4.
>>>
>>> I've seen a "Enable asynchronous commits by default" patch from Sun, 21 Sep 
>>> 2008.
>>>
>>> Why is it revoked?
>>>       
>> It patch was never merged because the ayschronous commits feature
>> disabled all write barriers, so under heavy workloads a power failure
>> could cause data loss.
>>
>> No one has gotten around to looking at this closely; I think adding a
>> strategically placed blkdev_issue_flush() will allow us to safely
>> enable this feature, but it needs careful study.
>>     
>
> I don't think that was the issue, but rather that we wanted to have
> per-block checksums in order to handle the case were some block in
> transaction A is causing a transaction checksum failure, yet transaction
> B has already committed and begun checkpointing.
>
> One option discussed was to add a lightweight 16-bit checksum (e.g. TCP
> checksum) to the high bits of the t_flags of the block tag.  The checksum
> doesn't have to be very strong since the whole-transaction checksum will
> be the primary point of validation.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>   

I still don't trust the logic. Seems like a very complex (and really 
non-intuitive - async and commit, really?) thing to support for a 
marginal performance impact. Any blkdev_issue_flush() call would dwarf 
the advantage of the async bit of the commit.

If we are looking to better support workloads that suffer from 
journalling, I suspect that we have more natural ways to do that...

ric

