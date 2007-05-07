From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] - Make mke2fs.c defaults match mke2fs.conf defaults
Date: Mon, 07 May 2007 14:52:45 -0500
Message-ID: <463F838D.9030508@redhat.com>
References: <463F545A.10903@redhat.com> <20070507194749.GG17180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbXEGTzB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 15:55:01 -0400
In-Reply-To: <20070507194749.GG17180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Mon, May 07, 2007 at 11:31:22AM -0500, Eric Sandeen wrote: One of
>> our testers filed a bug that said "mkfs.ext3 is much slower when
>> mke2fs.conf is missing..."
>>
>> This is because the shipped defaults in mke2fs.conf do not match the
>> shipped defaults in the mkfs code itself; he wound up making a 1k
>> block filesystem on a very large block device, for example.
>>
>> So - How about this patch, to bring them back into line?  
> 
> It doesn't actually bring them completely back into line, since mke2fs
> will use different block sizes depending on the size of the
> filesystem.  So your patch makes the default probably a bit more
> reasonable, and so I'll probably end up applying it, but it definitely
> isn't a complete replacement for /etc/mke2fs.conf.

Well, sure, I don't mean for it to *replace* mke2fs.conf...

Hm, does having

[defaults]
        blocksize = 4096

in mke2fs.conf turn off the blocksize heuristics and force 4k?  is
what's in mke2fs.conf a starting point or an absolute?  I guess I need
to read up on the code...

> How likely do you think the case will be that mke2fs.conf would be
> missing?  I'm trying to figure out how high priority of an item this
> really is.

Well, not too likely, although for some reason I guess it happened in
the installer root in FC6 or so.  That's what raised the issue.

> We could enhance the profile code so that it could read in the profile
> from a memory buffer, and simply compile /etc/mke2fs.conf into mke2fs,
> but that adds bloat --- the question is how necessary do we think that
> really is?

I guess it doesn't really sound *necessary* - it's just that if we have
2 different "defaults" and they drift, it can be confusing...

-Eric
