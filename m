From: Avi Kivity <avi@redhat.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Thu, 05 Aug 2010 05:20:12 +0300
Message-ID: <4C5A1FDC.3010700@redhat.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org> <4C5818A1.9070102@redhat.com> <20100804233206.GA2901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.ker
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600Ab0HECUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 22:20:23 -0400
In-Reply-To: <20100804233206.GA2901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  On 08/05/2010 02:32 AM, Ted Ts'o wrote:
> On Tue, Aug 03, 2010 at 04:24:49PM +0300, Avi Kivity wrote:
>>   On 06/30/2010 03:48 PM, tytso@mit.edu wrote:
>>> I wonder if it's worthwhile to think about a new system call which
>>> allows users to provide an array of fd's which are collectively should
>>> be fsync'ed out at the same time.  Otherwise, we end up issuing
>>> multiple barrier operations in cases where the application needs to
>>> do:
>>>
>>> 	fsync(control_fd);
>>> 	fsync(data_fd);
>>>
>> The system call exists, it's called io_submit().
> Um, not the same thing at all.

Why not?  To be clear, I'm talking about an io_submit() with multiple 
IO_CMD_FSYNC requests, with a kernel implementation that is able to 
batch these requests.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

