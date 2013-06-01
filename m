From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
Date: Fri, 31 May 2013 23:51:32 -0500
Message-ID: <5E41AE1A-97B8-4746-84DA-A6C0B9A714B3@sandeen.net>
References: <51A8C59B.3030308@redhat.com> <20130531172456.GB6915@gmail.com> <51A8DACB.2030806@redhat.com> <51A8F3CE.4030801@sgi.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Rich Johnston <rjohnston@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34095 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3FAEvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Jun 2013 00:51:35 -0400
In-Reply-To: <51A8F3CE.4030801@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 31, 2013, at 2:02 PM, Rich Johnston <rjohnston@sgi.com> wrote:

> On 05/31/2013 12:15 PM, Eric Sandeen wrote:
>> On 5/31/13 12:24 PM, Zheng Liu wrote:
>>> On Fri, May 31, 2013 at 10:45:31AM -0500, Eric Sandeen wrote:
>>>> currently the seek_sanity_test (generic/285) fails on ext3
>>>> or ext2 due to fallocate() failures.  Just ignore that test
>>>> if the fs doesn't support fallocate.
>>> 
>>> Hi Eric,
>>> 
>>> I remember that my patch had been applied [1].  But stranger I couldn't
>>> find it in xfstests tree.  However, I think that your patch is better.
>>> 
>>> 1. http://oss.sgi.com/archives/xfs/2013-05/msg00534.html
>> 
>> Oh, right, I had forgotten about that.  Rich, any idea?
> 
> No other than it was a Friday.  My apologies Zheng.
> Zheng as your's should have been committed, what do you want me to do?
> 
Actually let's merge mine since it allows testing on ext2/3.  The other just disables those filesystems...

-Eric

> --Rich
> 
>> 
>> I don't care which patch goes in....
>> 
>> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
