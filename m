From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 08 Apr 2010 10:25:50 -0400
Message-ID: <x49hbnm9g29.fsf@segfault.boston.devel.redhat.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
	<20100408110045.GJ10103@kernel.dk> <20100408135901.GA10879@redhat.com>
	<x49pr2a9h3n.fsf@segfault.boston.devel.redhat.com>
	<20100408141004.GC10879@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0DHO0L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 10:26:11 -0400
In-Reply-To: <20100408141004.GC10879@redhat.com> (Vivek Goyal's message of
	"Thu, 8 Apr 2010 10:10:04 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Apr 08, 2010 at 10:03:24AM -0400, Jeff Moyer wrote:
>> Which actually brings up the question of whether this needs some
>> knowledge of whether the journal is on the same device as the file
>> system!  In such a case, we need not yield.  I think I'll stick my head
>> in the sand for this one.  ;-)
>
> Jeff even if journal is not on same device, what harm yielding could do?
> Anyway there is no IO on that queue and we are idling. Only side affect is
> that yielding process could lose a bit if after fsync it immediately submits
> more IO. Because this process has yielded it slice, it is back in the queue
> instead of doing more IO in the current slice immediately.

What happens if the journal is on a super fast device, and finishes up
very quickly allowing our process to initiate more I/O within the idle
window?

Cheers,
Jeff
