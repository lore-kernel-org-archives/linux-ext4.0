From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: rawhide's init/nash segfaults in libblkid
Date: Mon, 23 Feb 2009 16:52:34 -0600
Message-ID: <49A328B2.7090503@redhat.com>
References: <87ab8dds1z.fsf@meyering.net> <20090223224219.GB3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jim Meyering <jim@meyering.net>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45664 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbZBWWwk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 17:52:40 -0500
In-Reply-To: <20090223224219.GB3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Feb 23, 2009  17:41 +0100, Jim Meyering wrote:
>> FYI, I've just filed this against the kernel:
>>
>>   http://bugzilla.redhat.com/486997
>>
>> Perhaps it should be reassigned to e2fsprogs...
>> ---------
>>
>> Normally I track rawhide pretty closely, but for the last few weeks
>> new kernels haven't booted on the system I use for that, so I stuck
>> with the most recent one that worked,
> 
> Is rawhide using util-linux-ng that included the libblkid code?  It
> seems we probably need to add a configure check to e2fsprogs not to
> build libblkid if util-linux-ng has it.

Karel just sent a patch to do so (more or less), I think.

[PATCH] blkid: add --disable-libblkid to build with external libblkid

but AFAIK rawhide is still using e2fsprogs' blkid.  I'll look into it.

-Eric
