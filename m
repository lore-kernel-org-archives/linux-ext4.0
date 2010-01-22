From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] default max mount count to unused
Date: Thu, 21 Jan 2010 21:37:36 -0600
Message-ID: <4B591D80.6010309@redhat.com>
References: <4B5785A5.2010505@redhat.com> <20100122012929.GA21263@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0AVDhl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jan 2010 22:37:41 -0500
In-Reply-To: <20100122012929.GA21263@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Wed, Jan 20, 2010 at 04:37:25PM -0600, Eric Sandeen wrote:
>> From: Bill Nottingham <notting@redhat.com>
>>
>> Anaconda has been setting the max mount count on the root fs
>> to -1 (unused) for ages.
>>
>> I (Eric) tend to agree that using mount count as a proxy for potential
>> for corruption seems odd.  And waiting for fsck on a reboot just because
>> it's number 20 (or so) is painful.  Can we just turn it off by default?
>>
>> I wouldn't mind killing the periodic check as well, but consider
>> this a trial balloon.  :)
> 
> I think it would be better to make this be something tunable via
> mke2fs.conf. 

And defaulting it to unused, right ;)

> And as a profile option, maybe we would want this to be
> something where we periodically force a full fsck check and then send
> TRIM commands down to the SSD.  Given the size and speed of SSD's,
> doing periodic TRIM's every N mounts mike actually be a good thing.
> (It's dangerous to do a TRIM without doing a full fsck since if the
> block allocation bitmap isn't quite right, the user could lose data.)

That sounds fine, as do mke2fs.conf hooks, as does a nice shipped script
to do background checking of snapshots.

But I still don't know why "You mounted your fs 20 times" is a good
proxy for "you had better check for corruption now."  Have we so
little faith?  :)

-Eric
