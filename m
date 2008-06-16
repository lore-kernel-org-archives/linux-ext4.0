From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] ext4: Semantics of delalloc,data=ordered
Date: Mon, 16 Jun 2008 14:22:24 -0500
Message-ID: <4856BD70.4080000@redhat.com>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080616150533.GB3279@atrey.karlin.mff.cuni.cz> <20080616160251.GA14214@skywalker> <20080616172046.GC3279@atrey.karlin.mff.cuni.cz> <20080616181152.GG14214@skywalker> <20080616191727.GD31567@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org,
	adilger@sun.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYFPTXj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jun 2008 15:23:39 -0400
In-Reply-To: <20080616191727.GD31567@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>>>   Imagine you have a file with blocks 1 and 3 allocated and block 2 is a
>>> hole. You write blocks 1-3. Block 2 isn't allocated because of delalloc.
>>> Now if inode is already in the current transaction's list, during commit
>>> writes to blocks 1 and 3 will land on disk but write to block 2 will
>>> happen only after pdflush finds it.
>> And that should be fine with data=ordered mode right ?. Because since
>> block 2 is not yet allocated we don't have associated meta-data. So
>> even if we crash we have meta-data pointing to 1 and 3 and not 2. The
>> problem is only when we write the meta-data pointing to block 2 and not
>> block 2 itself ?.
>   Yes, it is correct. I may be just surprising (we didn't do things like
> this in data=ordered mode before).

Will it even be surprising?  "fill-in-hole; crash;" today may give you
the same thing, right?  It's just that with delalloc it might be a
bigger window in time for this to happen?

-Eric
