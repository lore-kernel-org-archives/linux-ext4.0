From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: xfstests: test ext4 statfs
Date: Mon, 29 Oct 2012 08:28:32 -0500
Message-ID: <508E8480.5020507@sgi.com>
References: <5089749C.4050003@redhat.com> <508AD066.4090102@sgi.com> <508AD8E8.1040301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:46232 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753911Ab2J2N0x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 09:26:53 -0400
In-Reply-To: <508AD8E8.1040301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/2012 01:39 PM, Eric Sandeen wrote:
> On 10/26/12 1:03 PM, Rich Johnston wrote:
>> On 10/25/2012 12:19 PM, Eric Sandeen wrote:
>>> Calculating free blocks in ext[234] is surprisingly hard, since
>>> by default we report "bsd" style df which doesn't count filesystem
>>> "overhead" blocks as used.
>>>
>>> With a lot of code dedicated to sorting out what to report as
>>> free, things tend to go wrong surprisingly often.
>>>
>>> Here's a test to actually try to stop the next regression.  ;)
>>>
>>> NB: For bsddf, the kernel currently does not count journal blocks
>>> as overhead; it probably should.  But the test below looks to have
>>> the result within 1% of perfection, so it still passes even if
>>> the kernel doesn't count the journal against free blocks.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>
>>> ---
>>>

>
>
> Yep - it's an ext4 bug.  I sent a patch to fix it.
>
> [PATCH] ext4: fix overhead calculations in ext4_stats, again
>
> You might want to retest w/ that.
>
> -Eric
>
>>> +

Thanks Eric,

Everything passes now.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


