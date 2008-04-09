From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 11:09:18 -0500
Message-ID: <47FCEA2E.3030302@redhat.com>
References: <47FBB24D.90807@yahoo.de>  <47FBBB13.7060501@redhat.com> <1207752320.30215.1.camel@zem> <47FCD828.9020204@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Calvin Walton <calvin.walton@gmail.com>, linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbYDIQJX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2008 12:09:23 -0400
In-Reply-To: <47FCD828.9020204@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

supersud501 wrote:
> Calvin Walton wrote:
>> On Tue, 2008-04-08 at 13:36 -0500, Eric Sandeen wrote:

...

>>> Do you in fact have any very large files on the disk?
>> I'm just curious - if I know for sure that I don't have any huge files
>> on my disk, would I be able to do something like use debugfs to simply
>> clear the flag?
>>
> 
> interests mee, too. and how are "huge files" defined? thought they are 
>  >4gb files?

"large" files are for ei->i_disksize > 0x7fffffffULL, or 2147483647
bytes / 2G.  This is just max offset, not block counts; i.e. completely
sparse 2g file will set this flag.

the "huge" sb flag is set if any file has i_blocks > ~0UL, or 2^32
512-byte blocks, or around 2T, but in this case I think sparseness
doesn't count; you have to actually have the blocks allocated.

-Eric

