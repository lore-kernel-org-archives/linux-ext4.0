From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V2] ext4: unmap the underlying metadata when allocating
 blocks via fallocate
Date: Thu, 14 Jan 2010 13:31:56 -0600
Message-ID: <4B4F712C.3070902@redhat.com>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>	<1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>	<4B4F4DB7.1070501@redhat.com> <87wrzklesd.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab0ANTcL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jan 2010 14:32:11 -0500
In-Reply-To: <87wrzklesd.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K. V wrote:
> On Thu, 14 Jan 2010 11:00:39 -0600, Eric Sandeen <sandeen@redhat.com> wrote:
>> Aneesh Kumar K.V wrote:
>>> This become important when we are running with nojournal mode. We
>>> may end up allocating recently freed metablocks for fallocate. We
>>> want to make sure we unmap the old mapping so that when we convert
>>> the fallocated uninitialized extent to initialized extent we don't
>>> have the old mapping around. Leaving the old mapping can cause
>>> file system corruption
>>>
>>> Now that we unmap old metadata blocks we need not return blocks
>>> allocated from fallocate area as new.
>> With this, unmap_underlying_metadata_blocks is no longer used
>> and can be removed I guess.
>>
> 
> Yes. Updated patch below

Ok, with the latest versions of these 3 patches, fsstress / 013
is working here, modulo the blocks-past-eof-from-fallocate problem
that remains.

Thanks,
-Eric
