From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: make "norecovery" an alias for "noload"
Date: Fri, 20 Nov 2009 09:41:12 -0600
Message-ID: <4B06B898.1010606@redhat.com>
References: <4B01D749.3030601@redhat.com> <20091119151233.GE24836@duck.suse.cz> <20091119193358.GE2099@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZKTPlq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2009 10:41:46 -0500
In-Reply-To: <20091119193358.GE2099@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Thu, Nov 19, 2009 at 04:12:33PM +0100, Jan Kara wrote:
>> On Mon 16-11-09 16:50:49, Eric Sandeen wrote:
>>> Users on the list recently complained about differences across
>>> filesystems w.r.t. how to mount without a journal replay.
>>>
>>> In the discussion it was noted that xfs's "norecovery" option is
>>> perhaps more descriptively accurate than "noload," so let's make
>>> that an alias for ext3.
>>>
>>> Also show this status in /proc/mounts
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>   OK, provided ext4 will have the same change, I'm fine with the patch.
>> So how is it with ext4?
> 
> Queued for the next merge window.  I did slightly change the
> documentation in Documentation/filesystems/ext4.txt to make
> "norecovery" be the canonnical option name, since that's what Eric had
> show up in /proc/mounts.  That seems fair, we might as well try to add
> consistency between different Linux filesystems.
> 
> 							- Ted

FWIW, the nilfs folks just added an option to do the same thing, and
I steered them towards "norecovery" - we may just get some consistency,
yet!

-Eric
