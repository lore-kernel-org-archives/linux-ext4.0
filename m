From: "Joseph D. Wagner" <joe@josephdwagner.info>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 11:53:12 -0700
Message-ID: <49ee4e84554c82d944d092fe2ec8ce82@josephdwagner.info>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
 <20130626140205.GE3875@thunk.org> <20130626145417.GB32092@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nagachandra P <nagachandra@gmail.com>,
	Vikram MP <mp.vikram@gmail.com>, <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from josephdwagner.info ([72.4.161.242]:59741 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3FZSwk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jun 2013 14:52:40 -0400
In-Reply-To: <20130626145417.GB32092@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/26/2013 7:54 am, Theodore Ts'o wrote:

> On Wed, Jun 26, 2013 at 10:02:05AM -0400, Theodore Ts'o wrote:
> 
>> In this particular case, we could reflect the error all the way up to
>> the ftruncate(2) system call. Fixing this is going to be a bit
>> involved, unfortunately; we'll need to update a fairly large number 
>> of
>> function signatures, including ext4_truncate(), ext4_ext_truncate(),
>> ext4_free_blocks(), and a number of others.
> 
> One thing that comes to mind. If we change things so that ftruncate
> reflects an ENOMEM error all the way up to userspace, one side effect
> of this is that the file may be partially truncated when ENOMEM is
> returned. Applications may not be prepared for this.

Hi Ted, it's the newbie again.  I'd like to throw out a possible
band-aid, which I know is ugly, but I'm not sure how it compares to
other ideas discussed.

What if there was a check at the start of the chain for free memory?
For example:

  1. User program calls function_x(parameter y).
  2. We know function_x() calls function_a(), function_b(), and
     function_c().
  3. Based upon our knowledge of those functions (and perhaps
     parameter y), we can _estimate_ that function_x() will require
     z bytes memory.
  4. Alter function_x() so that the first step is to check for free
     memory z.

Upside
  1. Obvious memory shortages are returned immediately, instead of 30
     steps down the chain.
  2. No risk of non-deterministic data changes (if caught; see 
downside).
  2. No risk of infinite loop due to retries.
  3. Puts a spotlight on applications that do not correctly handle
     ENOMEM, which to me is the equivalent of not correctly calling
     fsync().

Downside
  1. Does not guarantee that memory will be available when ext4 needs
     its.  Memory might be available during this pre-check, but another
     process might scoop it up between the pre-check and ext4's
     allocation.
  2. Does not catch all cases.  The check is only an estimate.

Thank you for your patience and for answering my questions.

Joseph D. Wagner
