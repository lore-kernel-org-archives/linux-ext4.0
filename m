From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4_freeze: don't return to userspace with a mutex held
Date: Sun, 04 Apr 2010 19:43:41 -0500
Message-ID: <4BB9323D.7050206@redhat.com>
References: <4BB12B03.9070906@redhat.com> <20100404205237.GK18524@thunk.org> <4BB90354.3040300@redhat.com> <A0351AEF-E91E-4CD8-A38E-DAE3EEEBB127@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab0DEAn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 20:43:56 -0400
In-Reply-To: <A0351AEF-E91E-4CD8-A38E-DAE3EEEBB127@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Apr 4, 2010, at 5:23 PM, Eric Sandeen wrote:
>> Well, there is __generic_file_aio_write doing vfs_check_frozen, but
>>  I thought there was more at the vfs level to stop things from
>> getting to the filesystem... *shrug* I see you put the patch in as
>> sent, it sounds right to me.
> 
> Yeah, it looks safe but it would be nice to do some testing to make
> sure there's nothing we missed.
> 
> I'm also vaguely worried whether the right thing will happen in
> no-journal mode, but it looks like it's better than what we had
> before (which clearly would have never worked in no journal mode), so
> I decided to let it pass.

I did go back up the callchain from where the old lock should have
caught it, so I think I've plugged the same holes that were protected
before.

> Testing the freeze functionality definitely needs to be done before
> we trust what happens in no journal mode, for sure.

Oh good point, hadn't even thought about nojournal mode & freeze.
Always nice to "accidentally" fix things ;)

-Eric

> 
> -- Ted
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-ext4" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

