From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs 1.42-WIP busted on big endian
Date: Tue, 08 Nov 2011 16:27:59 -0600
Message-ID: <4EB9ACEF.50206@redhat.com>
References: <4EB958E5.3080604@redhat.com> <20111108202809.GO24234@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab1KHW2G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Nov 2011 17:28:06 -0500
In-Reply-To: <20111108202809.GO24234@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/8/11 2:28 PM, Ted Ts'o wrote:
> On Tue, Nov 08, 2011 at 10:29:25AM -0600, Eric Sandeen wrote:
>> This was noted in commit ccc7cf032852dd5c84b227bafb481b1d158e2b5e:
>>
>>
>> commit ccc7cf032852dd5c84b227bafb481b1d158e2b5e
>> Author: Theodore Ts'o <tytso@mit.edu>
>> Date:   Fri Jul 30 18:41:47 2010 -0400
>>
>>     libext2fs: fix obvious big-endian bugs introduced by 64-bit changes
>>     
>>     These patches fix obvious bone-headed mistakes, so e2fsprogs will now
>>     build and mostly work on powerpc.  The m_meta_bg, u_mke2fs, and
>>     u_tune2fs tests are still failing, however, so there's still work to do...
>>     
>>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
>> but not fixed yet.  Just a heads up, when contemplating a 1.42
>> release.  I will try to find some time to look into it, but it's not
>> a simple regression, something must have gone wrong in the bowls of
>> 64-bitness.
> 
> Um, thanks for reminding me!  I'll try to schedule time to look at
> them later in this week, but if you get a chance ahead of me, let me
> know if you make any progress.

Sent a patch, 

[PATCH] libext2: advance group in ext2fs_open2 during swapping

 - let me know what you think.

-Eric
