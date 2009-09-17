From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 and quota generate "Data will be lost" errors :-(
Date: Thu, 17 Sep 2009 09:40:03 -0500
Message-ID: <4AB24A43.6090205@redhat.com>
References: <4AB23E80.9070805@it-sudparis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jehan.procaccia@it-sudparis.eu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZIQOkG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 10:40:06 -0400
In-Reply-To: <4AB23E80.9070805@it-sudparis.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jehan procaccia wrote:
> Since I run a ext4 FS with quota on my Redhat 5.4 , I often get these 
> kind of messages on the console:
> 
> Message from syslogd@ at Thu Sep 17 15:40:11 2009 ...
> gizeh kernel: mpage_da_map_blocks block allocation failed for inode 
> 3412191 at logical offset 0 with max blocks 1 with error -122
> Message from syslogd@ at Thu Sep 17 15:40:11 2009 ...
> gizeh kernel: This should not happen.!! Data will be lost
> 
> my system is runing on:
> $ uname -a
> Linux gizeh.int-evry.fr 2.6.18-164.el5 #1 SMP Tue Aug 18 15:51:48 EDT 
> 2009 x86_64 x86_64 x86_64 GNU/Linux

which has a 2.6.29-ish ext4 codebase

> $ rpm -q quota
> quota-3.16-7 
> I upgraded redhat quota package from recompile fedora10 sources because 
> of this changelog:
> 
> * Thu Oct 30 2008 Ondrej Vasik <ovasik@redhat.com <mailto:ovasik@redhat.com>> 1:3.16-6
> - fix implementation of ext4 support

and this will not affect your kernelspace issues, which were mostly
fixed in .30 by this and other commits:

commit 60e58e0f30e723464c2a7d34b71b8675566c572d
Author: Mingming Cao <cmm@us.ibm.com>
Date:   Thu Jan 22 18:13:05 2009 +0100

    ext4: quota reservation for delayed allocation

    Uses quota reservation/claim/release to handle quota properly for
delayed
    allocation in the three steps: 1) quotas are reserved when data
being copied
    to cache when block allocation is defered 2) when new blocks are
allocated.
    reserved quotas are converted to the real allocated quota, 2)
over-booked
    quotas for metadata blocks are released back.

    Signed-off-by: Mingming Cao <cmm@us.ibm.com>
    Acked-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Jan Kara <jack@suse.cz>

> I have a discussion with redhat on this: 
> https://bugzilla.redhat.com/show_bug.cgi?id=522615
> the reponse is to move back to ext3 until redhat support quota for ext4 .
> 
> my probleme is that I have lot of users and filesystems in this 
> situation now, and I wonder I couldn't expect a workaround ?
> is this issue know in recent kernel,  will I really lose data ? 
> any advice greatly appreciated .

It's a fundamental change in quota to deal with delalloc, which was not
ready in time for RHEL5.4.  It's mostly fixed upstream, though there
have been some recent bug reports.  If anyone on the list has other
suggestions I'm all ears, but I think we've covered most of this in the
bug already.

Thanks,
-Eric
