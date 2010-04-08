From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 08 Apr 2010 10:03:24 -0400
Message-ID: <x49pr2a9h3n.fsf@segfault.boston.devel.redhat.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
	<20100408110045.GJ10103@kernel.dk> <20100408135901.GA10879@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0DHOD7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 10:03:59 -0400
In-Reply-To: <20100408135901.GA10879@redhat.com> (Vivek Goyal's message of
	"Thu, 8 Apr 2010 09:59:01 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Apr 08, 2010 at 01:00:45PM +0200, Jens Axboe wrote:

>> I like the concept, it's definitely useful (and your results amply
>> demonstrate that). I was thinking if there was a way in through the ioc
>> itself, rather than bdi -> queue and like you are doing. But I can't
>> think of a nice way to do it, so this is probably as good as it gets.
>> 
>
> I think, one issue with ioc based approach will be that it will then call
> yield operation on all the devices in the system where this context has ever
> done any IO. With bdi based approach this call will remain limited to
> a smaller set of devices.

Which actually brings up the question of whether this needs some
knowledge of whether the journal is on the same device as the file
system!  In such a case, we need not yield.  I think I'll stick my head
in the sand for this one.  ;-)

Cheers,
Jeff
