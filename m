From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests 241: run parallel dbench
Date: Wed, 18 Aug 2010 09:26:32 -0500
Message-ID: <4C6BED98.10203@redhat.com>
References: <4C6AE57D.7090807@redhat.com> <20100818114507.GS10429@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab0HRO0n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Aug 2010 10:26:43 -0400
In-Reply-To: <20100818114507.GS10429@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner wrote:
> On Tue, Aug 17, 2010 at 02:39:41PM -0500, Eric Sandeen wrote:
>> ext4 was corrupting inode table bitmaps due to a mishmash of
>> atomic & nonatomic bitops.  This got broken twice and fixed
>> twice; let's add a test.
>>
>> On a 4-way box this reliably ends up with a corrupted filesystem
>> if we get it wrong (upstream as of 2.6.35 at least is fine again)
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Looks good, except it's missing a 241.out file for the golden
> output.

grr "guilt add" :)

Thanks, will add that to the commit.

-Eric
 
> Cheers,
> 
> Dave.

