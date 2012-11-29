From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 29 Nov 2012 12:56:16 -0600
Message-ID: <50B7AFD0.4040208@redhat.com>
References: <50A546D8.3020500@redhat.com> <20121129133129.GC20413@thunk.org> <50B77DB7.70307@redhat.com> <20121129164029.GA16577@thunk.org> <50B790C0.6080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2K2S4U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 13:56:20 -0500
In-Reply-To: <50B790C0.6080608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/29/12 10:43 AM, Eric Sandeen wrote:
> On 11/29/12 10:40 AM, Theodore Ts'o wrote:
>> On Thu, Nov 29, 2012 at 09:22:31AM -0600, Eric Sandeen wrote:
>>>
>>> But it's a weird inconsistency isn't it, and fixing it up in fsck should
>>> be the right thing to do anyway?
>>
>> Oh, I agree, but basically, as a result I'm going to put this patch on
>> hold until we do a bit more testing.  I'm just not ready to push this
>> out on the maint branch just yet.....
>>
>> (The general rule is that I want to keep the maint branch in a state
>> where someone who wants to take a snapshot for a production
>> environment should feel generally comfortable to do this --- modulo
>> rollout/integration testing, of course.  I'll keep it on an
>> es/fsck-int-node-fixup branch to make sure we don't lose it, but it's
>> something where I want to add some additional testing before I'm
>> comfortable rolling it out to the maint branch, just to make sure it
>> doesn't trigger any regression.)
> 
> FWIW, I hacked xfstests to always check the scratch device after any
> test uses it, too, and I'm re-running with this change to be sure
> it'll run over every fs modification xfstests makes ...
> 
> I'll send that upstream, too.

FWIW, ./check -g auto w/ fsck of both devices after each test
didn't encounter any fs which triggered this fsck check.

-Eric

