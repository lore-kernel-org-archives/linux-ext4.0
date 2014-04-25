From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: introduce FSX_AVOID env var
Date: Fri, 25 Apr 2014 08:57:52 -0500
Message-ID: <535A69E0.80900@sandeen.net>
References: <5355478C.8070905@redhat.com> <20140425063153.GC27527@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33034 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaDYN5s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2014 09:57:48 -0400
In-Reply-To: <20140425063153.GC27527@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/25/14, 1:31 AM, Christoph Hellwig wrote:
> On Mon, Apr 21, 2014 at 11:30:04AM -0500, Eric Sandeen wrote:
>> Just like FSSTRESS_AVOID, FSX_AVOID can be used to add
>> options at the end of the default fsx runs in each test.
>> i.e. FSX_AVOID="-H -z -C" will disable punch hole, zero range,
>> and collapse range calls in all tests which run fsx.
>>
>> This should handle Ted's concerns about buggy ext4 fallocate
>> code without needing to add tunables to the kernel to reject
>> these operations during xfstests runs.
> 
> I would much prefer to add a little _run_fsx helper to encapsulate this.
> 

Dave already merged it, but yeah, that's a good idea, for fsx
as well as fsstress.

-Eric

