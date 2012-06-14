From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Discrepancy in 'df' output between kernel 3.0 and 3.2 for ext4?
Date: Thu, 14 Jun 2012 14:00:29 -0500
Message-ID: <4FDA34CD.9070404@redhat.com>
References: <4FD8D731.9070008@cleversafe.com> <4FD8DB86.8030603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zachary Mark <zmark@cleversafe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2FNTAe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2012 15:00:34 -0400
In-Reply-To: <4FD8DB86.8030603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/13/12 1:27 PM, Eric Sandeen wrote:
> On 6/13/12 1:08 PM, Zachary Mark wrote:
>> Ext4 developers,
>>
>> I recently upgraded my kernel from 3.0.24 to 3.2.18, and discovered
>> that df is now reporting different statistics for my ext4 file
>> systems (sda1 is ext3 and unaffected). Notice the difference
>> between the 1K-blocks column and Used column between kernel
>> versions (Available remains constant, as it is merely Used
>> subtracted from the total size):

...

>> Is this discrepancy between the df outputs on the two kernel versions
>> expected given my mount options? I decided to come to the list
>> because I don't have the technical depth with regard to ext4 to be
>> able to analyze the ext4_statfs changes that went into making
>> bigalloc work, and I haven't found any reports of similar symptoms
>> via web searches or the Documentation/filesystems/ext4.txt. This is
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=830412 just came in and is probably the same root cause.
> 
> Thanks for the bisect!  I'll let Ted worry about it for now, at least until I have more time.

Ted, one thing that seems very weird to me.  When using BSD-style df, which is supposed to ignore basic metadata overhead, shouldn't a freshly mkfs'd filesystem always show free blocks == total blocks?  It doesn't do that either before or after your changes, which seems odd to me.  Am I misunderstanding what "bsddf" is supposed to do?

-eric
