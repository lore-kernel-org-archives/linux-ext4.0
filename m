From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data	buffers
Date: Thu, 05 Jun 2008 20:33:27 +0900
Message-ID: <4847CF07.1020904@hitachi.com>
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com>
    <20080603153050.fb99ac8a.akpm@linux-foundation.org>
    <20080604101925.GB16572@duck.suse.cz>
    <20080604111911.c1fe09c6.akpm@linux-foundation.org>
    <20080604212202.GA8727@mit.edu>
    <20080604145848.e3da6f20.akpm@linux-foundation.org>
    <20080604225155.GB8727@mit.edu> <20080605093536.GE27370@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48146 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbYFELdh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 07:33:37 -0400
In-Reply-To: <20080605093536.GE27370@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Jan Kara wrote:

> On Wed 04-06-08 18:51:55, Theodore Tso wrote:
> 
>>On Wed, Jun 04, 2008 at 02:58:48PM -0700, Andrew Morton wrote:
>>
>>>On Wed, 4 Jun 2008 17:22:02 -0400
>>>Theodore Tso <tytso@mit.edu> wrote:
>>>
>>>>On Wed, Jun 04, 2008 at 11:19:11AM -0700, Andrew Morton wrote:

>>>But afaict this patch changes things so that if we get a write failure
>>>in a data block we make the entire fs read-only.  Which, as I said, is
>>>often "dead box".
>>>
>>>This seems like a quite major policy change to me.

My patch doesn't change the policy.  JBD aborts the journal when
it detects I/O error in file data since 2.6.11.  Perhaps this patch:
http://marc.info/?l=linux-kernel&m=110483888632225
I just added missing error checkings.

>>Agreed, and it's not appropriate.  I could imagine that for some
>>setups it is the right policy, but the kernel should not be setting
>>policy like this.  Maybe as a new tunable in the superblock, or maybe
>>via a round-trip to userspace via a uevent, but certainly not as the
>>new default behavior.
> 
>   Yes, I believe a tunable in superblock controlling how do we behave on
> EIO error in data block would be the best solution.

I agree.  I understood that there is a case where we don't want to
make the fs read-only when writing file data failed.  OTOH there are
people who want to make the fs read-only to avoid the damage from
expanding.  Introducing the tunable would be better.
I'm going to send a patch to make this behavior tunable if some of you
agree on this way.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

