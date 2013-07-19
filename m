From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Thu, 18 Jul 2013 19:56:45 -0500
Message-ID: <51E88ECD.3040806@redhat.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu> <51E8356C.9030603@redhat.com> <20130718185310.GA17548@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934943Ab3GSA4u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jul 2013 20:56:50 -0400
In-Reply-To: <20130718185310.GA17548@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/18/13 1:53 PM, Theodore Ts'o wrote:
> On Thu, Jul 18, 2013 at 01:35:24PM -0500, Eric Sandeen wrote:
>>> (Should we do this all the time, instead of when the application
>>> explicitly requests it?  Maybe; there could be cases with very large,
>>> fragmented files accessed by an application such as "file" is only needs
>>> to look at a small subset of the file where this could result in an
>>> unnecessary work and memory allocated.  OTOH, 95%+ of the time this
>>> would probably be a win...)
>>
>> I'd say yes, we should - maybe not in all cases but if you need it for
>> AIO, try to make it "all the time" at least for that AIO?
> 
> The problem is we don't know that we're doing AIO until we see the
> first io_submit(2) call.  With this patch series, we'll pull the
> contents of the entire leaf tree block into extent cache, but if the
> extent tree is larger than that, if we read in the entire extent tree
> on the first AIO request, then that first request will delayed even
> more, and it's not clear that's a good thing.

Is blocking on a pre-AIO ioctl better than blocking on the
first AIO?

-Eric
