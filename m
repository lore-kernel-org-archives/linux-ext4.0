From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Slowness on ext4 master branch (Was: The new ext4 git tree re-org)
Date: Mon, 16 May 2011 10:06:01 -0500
Message-ID: <4DD13D59.20802@redhat.com>
References: <BANLkTi=ZgVsPRKE8tQZ=s6qjTLuYopMBBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1EPPGF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 11:06:05 -0400
In-Reply-To: <BANLkTi=ZgVsPRKE8tQZ=s6qjTLuYopMBBg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/14/11 1:49 PM, Amir Goldstein wrote:
> On Wed, May 11, 2011 at 9:59 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, May 10, 2011 at 4:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>>>
>>> I've uploaded an updated dev branch to the ext4 tree.  Compared to the
>>> previous version of dev branch, I've removed my modified version of
>>> Allison's "NULL pointer when make_indexed_dir returns -ENOSPC" patch,
>>> and I've added Amir's alloc_semp removal patches.  I'm still in the
>>> process of reviewing those patches; I've included them to make it easier
>>> for I and others to test them.
>>>
>>
>> I have a general question regarding testing for next merge window.
>> What kernel do you usually use when testing the dev branch?
>> I started writing an xfstest to test online resize and filesystem
>> filling in parallel, based on test 224 (Delayed allocation at ENOSPC test).
>> I started running test 224 on a kernel built from ext4/master
>> and it seemed to run too slow. looking at the waiting tasks
>> it looked like it could be related to I/O less throttling.
>> Since ext4/master is based on 2.6.39-rc3, I figured maybe I am running
>> a buggy kernel, so I merged 2.6.39-rc7 to ext4/master to build a new kernel.
>>
>> Am I going in the right direction at all?
>> I have a dedicated server for tests (X64_64 quad core), so it you would
>> like me to run some xfstest runs with specific configuration, or certain
>> patches applied, please let me know.
>>
>>
> 
> So now that I know I am not hearing voices, I guess test 224 is also too new
> to be tested by many people.

I hope not, it was committed over a year ago :)

If it does enospc, ext4 gets into the flushing & syncing mode as things
fill up, so maybe something changed in that area?

-Eric

> The good news is that test 224 runs smoothly on kernel 2.6.39-rc7.
> on ext4 master branch is either hung or took too long time for me to wait.
> I will try to find the offending commit on Monday.
> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

