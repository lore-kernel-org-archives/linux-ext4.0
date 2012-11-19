From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 09:29:01 -0600
Message-ID: <50AA503D.2060503@redhat.com>
References: <20121119083245.18044.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dreusser@gmail.com, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab2KSP3E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 10:29:04 -0500
In-Reply-To: <20121119083245.18044.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/19/12 2:32 AM, George Spelvin wrote:
...

> "e2fsck -n" will only print errors and not change anything.  It's
> always safe.
> 
> Try "e2fsck -n -v /dev/md0" (given the dumpe2fs failure, I expect that
> will not work) and then try "e2fsck -n -v -b 32768 /dev/md0".
> 
> I don't know what happened to your superblock, but if that's all that
> got trashed, recovery is actually quite straightforward and there's no
> risk of data loss.  e2fsck will just print a huge number of "free blocks
> count wrong" messages as it fixes them.
> 
> (However, that's a pretty big "if".)
> 
> 
> Another thing that would be useful is "dd if=/dev/md0 skip=2 count=2 | xxd"
> (or od -x if you don't have xxd).  That will give a hex dump of the
> primary superblock, which might show the extent of the damage.
> 
> 
> If "e2fsck -n -b 32768" works, the way to repair it is to run it again
> without the "-n", but the -n output will say how bad it is.

Whoops, I replied without seeing these other replies; somehow threading
was broken w/ George's first reply.

Anyway - I would not go to e2fsck yet.  I think your raid is mis-assembled.
I'd investigate that first.  I'll look at the other output a bit more, but
for now, I'd stay away from fsck - just wanted to get that out there quick.

-Eric
