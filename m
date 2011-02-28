From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: orphan cleanup on readonly fs will corrupt future fs!
Date: Mon, 28 Feb 2011 09:05:30 -0600
Message-ID: <4D6BB9BA.3050000@redhat.com>
References: <AANLkTi=_QBgDutcb7h2XHpjHR6k-4Rj-r6zryMXaNn6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab1B1PFi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 10:05:38 -0500
In-Reply-To: <AANLkTi=_QBgDutcb7h2XHpjHR6k-4Rj-r6zryMXaNn6e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/26/11 12:21 PM, Amir Goldstein wrote:
> Hi guys,
> 
> I have just realized something very disturbing -
> that orphan cleanup is not being skipped on readonly mount of ext4/ext3.
> 
> I know that journal recovery is done on readonly mount
> and there is problem with that, since nothing happens
> in the fs level.
> 
> But orphan cleanup deletes inodes and frees blocks and that
> could be very bad for some RO_COMPAT features, SNAPSHOT
> and BIGALLOC to name two.

One thing to note is that if the device itself is readonly,
both journal recovery and orphan processing will be skipped,
if I recall...

-Eric

> I am not so sure why orphan cleanup is so important for readonly
> mount in the first place?
> 
> Now the damage has been done, because current stock kernels will
> corrupt future fs with SNAPSHOT and BIGALLOC features
> (unless Ted backs up from the decision to make BIGALLOC RO_COMPAT...)
> 
> I think that we should skip orphan cleanup on readonly mount ASAP and try
> to push this fix to as many stable/maint kernels out there, before the
> problem gets worse.
> 
> Can anyway see a problem with skipping orphan cleanup?
> Maybe there is a problem with later remount read-write?
> 
> I would spend time more time to investigate these questions,
> but I find this problem too disturbing and urgent to wait until I find
> the time to do so...
> 
> Amir.

