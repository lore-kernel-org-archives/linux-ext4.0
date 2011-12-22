From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL
 for new inodes
Date: Thu, 22 Dec 2011 12:23:41 -0600
Message-ID: <4EF375AD.4080306@redhat.com>
References: <20110814020617.GB3524@thunk.org> <1313288886-32689-1-git-send-email-tytso@mit.edu> <4EF371AC.6000001@redhat.com> <20111222181949.GE5041@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1LVSXo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Dec 2011 13:23:44 -0500
In-Reply-To: <20111222181949.GE5041@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/22/11 12:19 PM, Ted Ts'o wrote:
> On Thu, Dec 22, 2011 at 12:06:36PM -0600, Eric Sandeen wrote:
>> On 8/13/11 9:28 PM, Theodore Ts'o wrote:
>>> This doesn't make much sense, and it exposes a bug in the kernel where
>>> attempts to create a new file in an append-only directory using
>>> O_CREAT will fail (but still leave a zero-length file).  This was
>>> discovered when xfstests #79 was generalized so it could run on all
>>> file systems.
>>
>> Curious about the status of this one; I think it makes sense to me, but
>> I don't think it ever made it upstream?  I'd be willing to give it a:
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Are there concerns about it or did it just slip through the cracks?
> 
> Yes, it's there.  It hit upstream as of v3.2-rc1.  Commit id 1cd9f097

Argh sorry, how did I miss that, I thought my tree was up to date, oh well.

Sorry for the noise & thanks,

-Eric

>      	  	     	 	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

