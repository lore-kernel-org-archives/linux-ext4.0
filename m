From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Wed, 14 Mar 2012 19:10:21 -0700
Message-ID: <4F614F8D.5010702@amacapital.net>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com> <4F57FC14.5090207@panasas.com> <yq1zkbrhi2l.fsf@sermon.lab.mkp.net> <4F5837A2.8000306@panasas.com> <Pine.LNX.4.64.1203072207050.24564@cobra.newdream.net> <20120308154326.GA6777@thunk.org> <Pine.LNX.4.64.1203080829300.23757@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Boaz Harrosh <bharrosh@panasas.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51308 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab2COCKZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 22:10:25 -0400
Received: by dadp12 with SMTP id p12so3921104dad.11
        for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 19:10:25 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.1203080829300.23757@cobra.newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/08/2012 08:43 AM, Sage Weil wrote:
> On Thu, 8 Mar 2012, Ted Ts'o wrote:
>> On Wed, Mar 07, 2012 at 10:27:43PM -0800, Sage Weil wrote:
>>>
>>> This avoids the problem for devices that don't need stable pages, but 
>>> doesn't help for those that do (btrfs, raid, iscsi, dif/dix, etc.).  It 
>>> seems to me like a more elegant solution would be to COW the page in the 
>>> address_space so that you get stable writeback pages without blocking.  
>>> That's clearly more complex, and I'm sure there are a range of issues 
>>> involved in making that work, but I would hope that it would be doable 
>>> with generic MM infrastructure so that everyone would benefit.
>>
>> Well, even doing a COW (or anything that involves messing with page
>> tables) is not free.  So even if we can make the cost of stable
>> writeback pages cheaper, if we can completely avoid the cost, this
>> would be good.  I'd also rather fix the performance regression sooner
>> rather than later, and I suspect the COW solution is not something
>> that could be prepared in time for the upcoming merge window.
> 
> Definitely.  This patch looks like a fine approach for your situation. I 
> just don't want the subject to come up without talking about a general 
> solution.  And it's very interesting to hear about a (simple) workload 
> that is affected by the wait_on_page_writeback().

I'll add a simple workload.  I have a soft real-time program that has
two threads.  One of them fallocates some files, mmaps them, mlocks
them, and touches all the pages to prefault them.  (This thread has no
real-time constraints -- it just needs to keep up.)  The other thread
writes to the files.

On Windows, this works very well.  On Linux without stable pages, it
almost works.  With stable pages, it's a complete disaster.  No amount
of minimizing the amount of time that pages under writeback can cause
writers to sleep will help -- writers *must not wait for io* when
writing mlocked, prefaulted pages for my code to work.

(The other issue involves file_update_time.  I'll send a fix eventually.)

FWIW, it would be really nice if there was a way to lock a mapping so
hard that accesses are guaranteed to not even cause soft faults.  We're
far from being able to do that now, though.

--Andy
