From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 2.6.33.1: ext4 disk free weirdness
Date: Mon, 29 Mar 2010 10:01:38 -0500
Message-ID: <4BB0C0D2.1080303@redhat.com>
References: <20100329045748.GR2657@zip.com.au> <4BB0BDD2.3080100@redhat.com> <20100329145311.GA4671@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: CaT <cat@zip.com.au>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0C2PBn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 11:01:43 -0400
In-Reply-To: <20100329145311.GA4671@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Mon, Mar 29, 2010 at 09:48:50AM -0500, Eric Sandeen wrote:
>> CaT wrote:
>>> Using kernel 2.6.33.1. Am rsyncing from /data/mirror (a raid0 mount) to
>>> /dev/sda1 (a usb HD). Both filesystems formatted as ext3 but mounted as
>>> ext4. /mnt filesystem is only being added to and currently large files
>>> (iso files 700MB-4.4GB) are being copied. When I remounted /mnt as ext3
>>> I could not duplicate the issue and the amount of disk used stabilised
>>> at 182G. The df results, whilst /mnt is mounted as ext4, are below:
>> I would say this is likely speculative allocation due to delalloc
>> (ext4 has to reserve worst-case metadata amounts to prepare for
>> delalloc writeback).  When the file data actually gets written out,
>> the worst-case reservation is freed up again.  We also flush and
>> switch to nodelalloc when the filesystem is pretty close to full.
>> see ext4_nonda_switch() for example.
>>
>> This looks pretty severe though, more than I would expect
>> from that behavior.
> 
> This is fixed in commit d330a5bef, which which got merged post
> 2.6.34-rc2, and which we need to get into 2.6.33 stable.  If you
> cherry-pick that commit, I think you'll see that it fixes this
> problem.

Oh, right, spaced that one.  Thanks for the reminder Ted.  :)

And from now on ext3-mounted-as-ext4 is special-cased so you won't get
delalloc, and you won't get this behavior at all (nor will you get
any delalloc benefits, FWIW).

Thanks,
-Eric
 
> 						- Ted

