From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Thu, 08 Apr 2010 11:34:37 -0500
Message-ID: <4BBE059D.3080208@redhat.com>
References: <4BBD285B.9000603@gmail.com> <4BBD2FDF.4040407@redhat.com> <4BBD3365.90306@gmail.com> <4BBD5740.4070101@redhat.com> <4BBD5D90.4090203@redhat.com> <4BBD5FDB.9010100@redhat.com> <4BBDC2A3.1040901@gmail.com> <4BBDF6F4.2020208@redhat.com> <4BBE029D.9030303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158Ab0DHQyp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 12:54:45 -0400
In-Reply-To: <4BBE029D.9030303@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nebojsa Trpkovic wrote:
> On 04/08/10 17:32, Eric Sandeen wrote:
>> Well, you might just keep in mind that:
>>
>> 1) trimming these small amounts has actually looked very inefficient, and
>> 2) data=writeback really isn't very safe in the face of a crash or power loss, and
>> 3) hopefully we'll have a better trim solution eventually.
> 
> 1) I understand that big TRIMs are better then small ones, but skipping
> some TRIMs completely would lead to slow but sure drive degradation as
> drive would have less and less spare space for wear leveling.
> 
> 2) Yes, I'm aware of possible data=writeback inconsistency, but I've
> tried to let IO scheduler to merge and reorganize as many writes as it
> can, all to avoid small writes to SSD which are main cause of write
> amplification.
> 
> 3) I'll stick with no data=writeback for the time being. I guess I'm
> doing just fine even without it. :)
> 
> 
> One more noob quotestion completely out-of-topic:
> Will md layer pass TRIM command to drive if one has ext4 on linux
> software RAID 0/1/5 ?

I think the answer is "not yet but it's being worked on"

-Eric
 
> Nebojsa

