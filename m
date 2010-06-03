From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: Use bitops to read/modify i_flags part2
Date: Thu, 3 Jun 2010 06:37:57 -0400
Message-ID: <DB06625C-975E-4B03-8447-318DBEBE7BF8@mit.edu>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org> <1274734174-28830-1-git-send-email-tytso@mit.edu> <87ocfwsb3m.fsf_-_@openvz.org> <20100603025559.GG24062@thunk.org> <87iq601oyb.fsf@openvz.org>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:47076 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933486Ab0FCKiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 06:38:00 -0400
In-Reply-To: <87iq601oyb.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jun 3, 2010, at 4:48 AM, Dmitry Monakhov wrote:

> tytso@mit.edu writes:
> 
>> On Mon, May 31, 2010 at 12:56:45PM +0400, Dmitry Monakhov wrote:
>>> "Theodore Ts'o" <tytso@mit.edu> writes:
>>> 
>>>> From: "Theodore Ts'o" <tytso@mit.edu>
>>>> 
>>>> From: Dmitry Monakhov <dmonakhov@openvz.org>
>>> Bad news. Bug still exist because you've missed several important chunks 
>>> (ext4_set_inode_flags, ext4_inode_blocks) while porting original patch.
>>> And I've missed this too on review cycle.
>>> Please add following patch to patch-queue.
>> 
>> Added to the ext4 patch queue (with minor updates to the commit
>> description).
> BTW. The patch that i've sent would not compile because of misstype.
> So it may looks like that i've sent untested random peace of crap
> from a first glance. But the truth is that that misstype was fixed
> in to topmost quilt's patch so i've missed it original patch.
> And indeed the bug with non-atomic bit's manipulation has gone, at
> least i can't reproduce it any more. Incremental fix attached.

Yeah, I caught that.  It caused me to review that part of the patch much
more carefully, but no harm done.

-- Ted

