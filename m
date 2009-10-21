From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix configure.in typo
Date: Wed, 21 Oct 2009 17:14:17 -0500
Message-ID: <4ADF87B9.3040204@redhat.com>
References: <4ADE8477.2070906@redhat.com> <20091021075232.GA9574@mit.edu> <4ADF2711.50405@redhat.com> <20091021215751.GB20619@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbZJUWOP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Oct 2009 18:14:15 -0400
In-Reply-To: <20091021215751.GB20619@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Oct 21, 2009 at 10:21:53AM -0500, Eric Sandeen wrote:
>> seems like it's not picking up the system /usr/include/blkid/blkid.h but
>> rather e2fsprogs/lib/blkid/blkid.h
>>
> 
> Um, in the maint branch e2fsprogs/lib/blkid/blkid.h no longer exists
> in the Git tree.  It's been renamed to e2fsprogs/lib/blkid/blkid.h.in,
> and blkid.h is only built if libblkid is enabled.
> 
> Perhaps you have a stale file that wasn't deleted by git?
> 
> 						- Ted

oh dear, maybe that's it :)

Ok, on a fresh checkout it worked...

Sorry, not sure what state I got things into.

Thanks,
-Eric
