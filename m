From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: use lazy inode init on some discard-able devices
Date: Tue, 21 Sep 2010 11:01:47 -0500
Message-ID: <4C98D6EB.3040902@redhat.com>
References: <4C6EF67A.5080502@redhat.com> <20100920132324.GE3554@thunk.org> <E586FDF0-22B6-4FCD-80EB-F33F851AE031@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687Ab0IUQBv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Sep 2010 12:01:51 -0400
In-Reply-To: <E586FDF0-22B6-4FCD-80EB-F33F851AE031@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/21/2010 12:15 AM, Andreas Dilger wrote:
> On Fri, Aug 20, 2010 at 04:41:14PM -0500, Eric Sandeen wrote:
>> If a device supports discard -and- returns 0s for discarded blocks,
>> then we can skip the inode table initialization -and- the inode table
>> zeroing at mkfs time, and skip the lazy init as well since they are
>> already zeroed out.
> 
> Eric, do you have my patch for skipping the journal zeroing? If you
are already skipping the inode table zeroing (which is my bigger of a
deal) then you may as well skip zeroing the journal at the same time.

Hm good point.  Might be in my ext4 folder somewhere ;)

-Eric

> Cheers, Andreas

