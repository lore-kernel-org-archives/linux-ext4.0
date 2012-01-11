From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Support "check=none" "nocheck" mount options
Date: Wed, 11 Jan 2012 09:35:52 -0600
Message-ID: <4F0DAC58.8040503@redhat.com>
References: <20120110174118.GB3015@zod.bos.redhat.com> <4F0C78CD.6070809@redhat.com> <7A0721E1-689F-4B9B-BD8C-86A03DDF20CE@dilger.ca> <4F0DA724.2040506@redhat.com> <20120111152646.GB4589@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	Josh Boyer <jwboyer@redhat.com>, linux-ext4@vger.kernel.org,
	kernel-team@fedoraproject.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab2AKPf5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 10:35:57 -0500
In-Reply-To: <20120111152646.GB4589@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/11/12 9:26 AM, Ted Ts'o wrote:
> On Wed, Jan 11, 2012 at 09:13:40AM -0600, Eric Sandeen wrote:
>>> In any case, I can't imagine why a user would have this set for a kernel
>>> option that might have last been valid 10 years ago, and why the 5 users
>>> in the world that might have this set cannot simply remove it from their
>>> fstab, since it does absolutely nothing?
>>
>> Well, I agree that it should be deprecated, but that's a separate issue from
>> making ext4 handle all current ext2/3 mount options.
>>
>> Let's just push this one in, and can do another patch to add the dire
>> deprecation warnings to all filesystems, ok?  Then in 5 more years we can
>> remember to remove it ;)
> 
> If we're going to deprecate it, we should deprecate it for *all* of
> the ext 2/3/4 file systems.  Otherwise let's not bother, and keep the
> no-op for backwards compatibility.  If we are going to support ext4
> taking over for ext2/3, then yes we need to support any common mount
> options, and if we want to deprecate a particular option in ext4, we
> should try to deprecate them in ext2/3 as well.

I agree, I'm just saying it can be 2 separate steps; fixing ext4 doesn't
need to wait for deprecating the option on ext2/3.

-Eric

>        	      		     	       	  - Ted

