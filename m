From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Tue, 17 Apr 2012 13:53:20 -0500
Message-ID: <4F8DBC20.5010401@redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAF89.5070805@redhat.com> <20120417184306.GA5916@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab2DQSx1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2012 14:53:27 -0400
In-Reply-To: <20120417184306.GA5916@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/17/12 1:43 PM, Ted Ts'o wrote:
> On Tue, Apr 17, 2012 at 01:59:37PM -0400, Ric Wheeler wrote:
>>
>> You could get both security and avoid the run time hit by fully
>> writing the file or by having a variation that relied on "discard"
>> (i.e., no need to zero data if we can discard or track it as
>> unwritten).
> 
> It's certainly the case that if the device supports persistent
> discard, something which we definitely *should* do is to send the
> discard at fallocate time and then mark the space as initialized.
> 
> Unfortunately, not all devices, and in particular no HDD's for which I
> aware support persistent discard.  And, writing all zero's to the file
> is in fact what a number of programs for which I am aware (including
> an enterprise database) are doing, precisely because they tend to
> write into the fallocated space in a somewhat random order, and the
> extent conversion costs is in fact quite significant.  But writing all
> zero's to the file before you can use it is quite costly; at the very
> least it burns disk bandwidth --- one of the main motivations of
> fallocate was to avoid needing to do a "write all zero pass", and
> while it does solve the problem for some use cases (such as DVR's),
> it's not a complete solution.

Can we please start with profiling the workload causing trouble, see why
ext4 takes such a hit, and see if anything can be done there to fix
it surgically, rather than just throwing this big hammer at it?

In my (admittedly quick, hacky) test, xfs suffed about a 1% perf degradation,
ext4 about 8%.  Until we at least know why ext4 is so much worse, I'll
signal a strong NAK for this change, for whatever may or may not be worth.  :)

-Eric
