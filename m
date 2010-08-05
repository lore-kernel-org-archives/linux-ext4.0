From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are no dirty pages.
Date: Thu, 05 Aug 2010 15:13:44 -0400
Message-ID: <x49pqxwc1p3.fsf@segfault.boston.devel.redhat.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
	<1272934667.2544.3.camel@mingming-laptop>
	<4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org>
	<20100630124832.GA1333@thunk.org> <4C5818A1.9070102@redhat.com>
	<20100804233206.GA2901@thunk.org> <4C5A1FDC.3010700@redhat.com>
	<20100805161745.GG2901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758831Ab0HETNw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 15:13:52 -0400
In-Reply-To: <20100805161745.GG2901@thunk.org> (Ted Ts'o's message of "Thu, 5
	Aug 2010 12:17:45 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Ted Ts'o" <tytso@mit.edu> writes:

> On Thu, Aug 05, 2010 at 05:20:12AM +0300, Avi Kivity wrote:
>> 
>> Why not?  To be clear, I'm talking about an io_submit() with
>> multiple IO_CMD_FSYNC requests, with a kernel implementation that is
>> able to batch these requests.
>
> IO_CMD_FSYNC doesn't exist right now, but sure, it means we don't have

Well, there's IOCB_CMD_FSYNC.  But still, this isn't the same thing as
what's requested.  If I understand correctly, what is requested is a
mechanism to flush out all data for multiple file descriptors and follow
that with a single barrier/flush (and yes, Ted did give a summary of the
commands that would be required to accomplish that).

There still remains the question of why this should be tied to the AIO
submission interface.


Cheers,
Jeff
