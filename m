From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [Ext2-devel] [PATCH] 2/6 Detect overflows in loop counters
Date: Tue, 12 Sep 2006 14:38:09 -0500
Message-ID: <45070CA1.20903@redhat.com>
References: <44E3855D.5040303@redhat.com> <20060830061825.GB8046@thunk.org> <44F5D66D.8030500@redhat.com> <20060912192808.GB21500@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28599 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1030234AbWILTiQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Sep 2006 15:38:16 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20060912192808.GB21500@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Wed, Aug 30, 2006 at 01:18:21PM -0500, Eric Sandeen wrote:
>> new patchset & series is at
>>
>> http://people.redhat.com/esandeen/ext3/e2fsprogs-1.39-16T/e2fsprogs-hg-20060830-16T-patches.tar.gz
> 
> I've applied your patches (with a few minor changes in the
> ChangeLogs), and committed them into Mercurial.
> 
> Regards,
> 
> 						- Ted

Thanks Ted!

There's one more lurking out there that I somehow neglected to put in 
the above patchset, sent 08/16/2006, [Ext2-devel] [PATCH] fix size 
calculation when mkfs is pointed at a regular file

http://article.gmane.org/gmane.comp.file-systems.ext2.devel/4703

Thanks,

-Eric
