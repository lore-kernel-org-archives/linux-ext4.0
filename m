From: Ted Ts'o <tytso@mit.edu>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Wed, 29 Jun 2011 22:33:06 -0400
Message-ID: <20110630023306.GY2729@thunk.org>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>
 <20110627030539.GF3064@thunk.org>
 <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>
 <F673734C-4ECE-40B2-B283-959027C34B06@mit.edu>
 <341DAA96EE3A8444B6E4657BE8A846EA4B3DA1270A@NDJSSCC06.ndc.nasa.gov>
 <50F503A1-6A16-41C4-9C27-0662063C7817@mit.edu>
 <4E0BBCE9.9020600@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Sean McCauliff <Sean.D.McCauliff@nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55074 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab1F3CdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jun 2011 22:33:09 -0400
Content-Disposition: inline
In-Reply-To: <4E0BBCE9.9020600@nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 29, 2011 at 05:01:45PM -0700, Sean McCauliff wrote:
> Sorry, I didn't mean to bother you.  I did try and email ext3-users
> so as to not take up any developer time with my question.  

Yeah, but it's not likely anyone on that list would be able to help
you.  Both ext3 and ext4 isn't expected to take a huge amount of CPU
under normal conditions when doing this type of copying where you will
be likely disk bound.

Well, you're not using fallocate() (at least you haven't disclosed it
to date), and writing into fallocated space is the only thing that
would be using a workqueue at all (which is what the kworker threads
are using).

So I very much doubt it has anything to do with ext4.  The fiber
channel drivers do use workqueues a fair amount, so yes, it would be
useful to know that you are using a fiber channel SAN.  At this point
I'd suggest that you use oprofile or perf to see where the CPU is
being consumed.  Perf is probably better since it will allow you to
see the call chains.

						- Ted
