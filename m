From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: buggy EOFBLOCKS_FL handling
Date: Thu, 19 Aug 2010 12:03:17 -0500
Message-ID: <4C6D63D5.8030600@redhat.com>
References: <E1OlvNi-00063m-09@tytso-glaptop> <FB932B24-52F7-4C97-9BF6-58A78DFA5FBF@dilger.ca> <20100819144432.GA23345@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0HSRDY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 13:03:24 -0400
In-Reply-To: <20100819144432.GA23345@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
> On Wed, Aug 18, 2010 at 11:13:00PM -0600, Andreas Dilger wrote:
>> On 2010-08-18, at 21:01, Theodore Ts'o wrote:
>>> It looks like how we handle the EOFBLOCKS_FL flag is buggy.  This means
>>> that when we fallocate a file to have 128k using the KEEP_SIZE flag, and
>>> then write exactly 128k, the EOFBLOCKS_FL isn't getting cleared
>>> correctly.
>>>
>>> This is bad, because e2fsck will then complain about that inode.  If you
>>> have a large number of inodes that are written with fallocate using
>>> KEEP_SIZE, and then fill them up to their expected size, e2fsck will
>>> potentially complain about a _huge_ number of inodes.
>> Probably e2fsck also shouldn't complain if EOFBLOCKS_FL is set, but
>> the i_size is within the range implied by i_blocks.
> 
> My current thinking is to have an EOFBLOCKS_relaxed mode setting in
> /etc/e2fsck.conf which controls whether we test for this case or not.
> Technically it *is* an error, but if there are file systems with a
> large number of files in this state, running e2fsck could take a
> ***very*** long time (potentially, hours longer than would otherwise
> be expected).  Hopefully once the bug fix gets pushed out, eventually
> we'll be able to turn this feature off.  (Where eventually might be a
> year or two, given that it's probably too late to get this fixed in
> RHEL 6.  :-( )

Oh it can get fixed during rhel6's lifetime, certainly.  :)

Regarding a conf file setting, I'd really rather not have another knob
that is non-obvious to the user.

Maybe e2fsck could tally these and after I dunno, 10 or 20 or so, ask
whether it should keep flagging them or just go into "yes" mode for
the rest of the inodes with that problem?

-Eric
