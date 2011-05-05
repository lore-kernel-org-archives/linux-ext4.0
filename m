From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] jbd2: Fix forever sleeping process in do_get_write_access()
Date: Thu, 05 May 2011 09:28:30 -0500
Message-ID: <4DC2B40E.8080709@redhat.com>
References: <1304597439-7185-1-git-send-email-jack@suse.cz> <4DC2AADA.9070708@redhat.com> <20110505141114.GG5323@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1EEO2j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 10:28:39 -0400
In-Reply-To: <20110505141114.GG5323@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/5/11 9:11 AM, Jan Kara wrote:
> On Thu 05-05-11 08:49:14, Eric Sandeen wrote:
>> On 5/5/11 7:10 AM, Jan Kara wrote:
>>> In do_get_write_access() we wait on BH_Unshadow bit for buffer to get
>>> from shadow state. The waking code in journal_commit_transaction() has
>>> a bug because it does not issue a memory barrier after the buffer is moved
>>> from the shadow state and before wake_up_bit() is called. Thus a waitqueue
>>> check can happen before the buffer is actually moved from the shadow state
>>> and waiting process may never be woken. Fix the problem by issuing proper
>>> barrier.
>>
>> needed for jbd/commit.c as well, I guess?
>   Yes, I was already queued in my tree. I just sent it to the list as well.

sorry, sometimes "we" forget :)

Thanks!
-Eric
