From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Ensure writecache to disk in no journal mode
Date: Fri, 26 Mar 2010 12:40:04 -0500
Message-ID: <4BACF174.50703@redhat.com>
References: <1269620462-25906-1-git-send-email-surbhi.palande@canonical.com> <87pr2rhwe0.fsf@openvz.org> <4BACEBE3.50108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Surbhi Palande <surbhi.palande@canonical.com>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0CZRkK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 13:40:10 -0400
In-Reply-To: <4BACEBE3.50108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/26/2010 12:16 PM, Ric Wheeler wrote:
> On 03/26/2010 12:37 PM, Dmitry Monakhov wrote:
>> Surbhi Palande<surbhi.palande@canonical.com>  writes:
>>
>>    
>>> Ensure that in the no journal mode the write cache is flushed to the disk by
>>> calling a blkdev_issue_flush() which issues a WRITE_BARRIER if necessary.
>>>      
>> As soon as i understand, nojournal mode is assumed to be used for
>> fail-free block devices(raid + UPS). So we don't have to worry about
>> blkdev's wcache vs persistent storage correctness.

No, I don't think so - even with "fail-free" storage, a system crash
still results in an inconsistent filesystem; with nojournalling you've
made the decision to either fsck or re-mkfs after that event.

> I don't think that is a safe assumption. If users want that behavior, 
> they can mount with fs without barriers...

yes, I agree with Ric - even if you don't have journalling, the proper
sequence of sync calls should still result in data permanently on disk
by default.  (though I think using mount -o nobarrier for this purpose,
in absence of journalling, overloads the option a little...)

-Eric
