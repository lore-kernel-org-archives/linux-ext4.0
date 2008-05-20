From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 13:29:28 +1000
Message-ID: <48324598.4060803@sgi.com>
References: <482DDA56.6000301@redhat.com> <200805191439.36577.chris.mason@oracle.com> <20080519223959.GA14602@atrey.karlin.mff.cuni.cz> <200805192029.21688.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40195 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756380AbYETD3x (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Mon, 19 May 2008 23:29:53 -0400
In-Reply-To: <200805192029.21688.chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Chris,

Chris Mason wrote:
> On Monday 19 May 2008, Jan Kara wrote:
>>> On Monday 19 May 2008, Chris Mason wrote:
>>>> Here's a test workload that corrupts ext3 50% of the time on power fail
>>>> testing for me.  The machine in this test is my poor dell desktop
>>>> (3ghz, dual core, 2GB of ram), and the power controller is me walking
>>>> over and ripping the plug out the back.
>>> Here's a new version that still gets about corruptions 50% of the time,
>>> but does it with fewer files by using longer file names (240 chars
>>> instead of 160 chars).
>>>
>>> I tested this one with a larger FS (40GB instead of 2GB) and larger log
>>> (128MB instead of 32MB).  barrier-test -s 32 -p 1500 was still able to
>>> get a 50% corruption rate on the larger FS.
>>   Hmm, this is worse than I'd have expected :( If it is that bad, I
>> think we should really enable them by default... I can give your script
>> a try on my test machine when I get back (which is next week).
> 
> That would be great, I'd like to confirm that my machine isn't the only one on 
> the planet so easily broken ;)
> 
> I was also able to trigger corruptions on XFS (one run out of two), so it is 
> unlikely I'm seeing bugs in the ext3 replay or logging code.
>

Just to clarify,
was this test with barriers on or off for XFS?
I'm wondering if it was with barriers on, then we have a reproducible
bug in log replay.
Or whether you were just confirming the problems with barriers off on
another filesystem.

Thanks muchly,
Tim.

