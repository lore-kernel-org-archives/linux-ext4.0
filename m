From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] xfstests: make 275 pass
Date: Wed, 04 Jan 2012 17:21:00 -0600
Message-ID: <4F04DEDC.6020807@redhat.com>
References: <4F04A6E6.1090304@redhat.com> <4F04BC81.1000207@redhat.com> <20120104231725.GB24466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eryu Guan <eguan@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2ADXVR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 18:21:17 -0500
In-Reply-To: <20120104231725.GB24466@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/4/12 5:17 PM, Dave Chinner wrote:
> On Wed, Jan 04, 2012 at 02:54:25PM -0600, Eric Sandeen wrote:
>> Ok, this is a significant rework of 275, which made too many
>> assumptions about details of space usage and failed on several
>> filesystems (it passed on xfs, but only by accident).
>>
>> This new version tries to leave about 256k free, then tries
>> a single 1M IO, and fails only if 0 bytes are written.
>>
>> It also sends a lot more to $seq.full for debugging on failure
>> and fixes a few other stylistic things.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> I just had another thought about this, Eric....
> 
>> +# And at least some of it should succeed.
>> +_filesize=`du $SCRATCH_MNT/tmp1 | awk '{print $1}'`
>> +[ $_filesize -eq 0 ] && _fail "write file err: Partial write until enospc failed; wrote 0 bytes."
> 
> The question that just came to mind was this assumes that allocation
> succeeded so therefore the partial write succeeded. But that's not
> necessary the case. The partial write might not succeed leaving the
> file size as zero, but the underlying FS might not remove all the
> blocks it allocated (nothing says that it has to). Hence to
> determine if a partial write succeeded, we also need to check that
> the file size itself is greater than zero....

Probably need to read up on what posix says it should do.  I think
what you're saying is that it might leave blocks allocated past EOF?
That'd be surprising to me, but maybe I misunderstand?

Anyway, testing file size as well as space is simple enough.

-Eric

> Cheers,
> 
> Dave.

