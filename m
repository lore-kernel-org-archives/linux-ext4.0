From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: jbd2 batch time tuning behavior question
Date: Mon, 02 Jun 2014 10:00:05 -0500
Message-ID: <538C9175.7010003@redhat.com>
References: <5384C18A.7040501@redhat.com> <20140602144210.GC30598@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaFBPAH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 11:00:07 -0400
In-Reply-To: <20140602144210.GC30598@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/2/14, 9:42 AM, Theodore Ts'o wrote:
> On Tue, May 27, 2014 at 11:47:06AM -0500, Eric Sandeen wrote:
>>
>> Docs say "0" turns it off, but option handling turns "0" into 
>> EXT4_DEF_MAX_BATCH_TIME.  What was the real intent here; should the
>> docs or the behavior be changed?
> 
> Nice catch!  I would think it's probably better if we make the
> behavior change to match the docs.
> 
> Want to send a patch, since you found the problem, or shall I create a
> patch myself to fix things up?
> 
> Thanks,
> 
>      	       	      	       	      	  - Ted
> 

I can send the patch, I just wondered what the intent was.

Thanks,
-Eric
