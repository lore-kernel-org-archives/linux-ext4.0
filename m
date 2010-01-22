From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Add flag to files with blocks intentionally past EOF
Date: Fri, 22 Jan 2010 11:40:56 -0600
Message-ID: <4B59E328.8020008@redhat.com>
References: <4B5627EF.3080804@redhat.com> <87tyuhdu6q.fsf@linux.vnet.ibm.com> <22655F73-6EB0-40AC-9D51-794F6764CF67@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab0AVRlL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 12:41:11 -0500
In-Reply-To: <22655F73-6EB0-40AC-9D51-794F6764CF67@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-01-20, at 02:03, Aneesh Kumar K. V wrote:

...

>> If we remove ext4_ioctl support i guess that patch can become much
>> simpler.
> 
> 
> Sure it will be simpler, but less useful.  The point of exposing this
> flag via lsattr is to allow userspace to determine which files are
> holding blocks beyond EOF, so that if the filesystem is getting too full
> it is possible to run e.g. "lsattr -R" and find files with this EOF
> attribute and truncate them.  Without keeping at least the EOFBLOCKS
> flag in USER_VISIBLE this is impossible.

Well, I submitted an updated patch without it.  We can add another when
we sort out what we really want with the flags, but fixing the
corruption e2fsck finds seems paramount.

I think the case of stray files w/ blocks past EOF is probably pretty
rare - but I guess I agree, at least seeing the flags would be nice.

But let's handle that separately...

-Eric
