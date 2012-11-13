From: Peng Tao <bergwolf@gmail.com>
Subject: Re: Commit Interval and Delayed Allocation
Date: Tue, 13 Nov 2012 19:37:20 +0800
Message-ID: <CA+a=Yy4KjhA5N2=ooc3Z405wfGDg2fsUH7qvF=iwJ9hiQM7zkw@mail.gmail.com>
References: <0408C81F72528E40A0D3235A1F67FFC83ECD9881@SN2PRD0202MB144.namprd02.prod.outlook.com>
 <20121110025838.GA5974@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Nelson, John R" <John_Nelson@student.uml.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39342 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2KMLhm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 06:37:42 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so96806lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2012 03:37:41 -0800 (PST)
In-Reply-To: <20121110025838.GA5974@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 10, 2012 at 10:58 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Nov 10, 2012 at 12:40:42AM +0000, Nelson, John R wrote:
>> Hi,
>>   Say if ext4 commits every 5 seconds, does this mean whatever is
>>buffered for delayed allocation is flushed every 5 seconds as well?
>
> No; there is a separate 30 second timer which is used for writeback
> thread.
>
> For ext3 in data=ordered mode, we will flush out dirty pages for
> inodes which have been written to make sure that stale data can never
> get revealed.
>
> But in delayed allocation, there is no risk that stale data can get
> revealed until we actually allocate the data blocks.
>
Hi Ted,

Then ext4.txt seems need updating? If I understand you correctly, I'd
expect to lose 30 seconds of data rather than 5 seconds if data is
delayed allocated.

172 commit=nrsec    (*)     Ext4 can be told to sync all its data and metadata
173                         every 'nrsec' seconds. The default value
is 5 seconds.
174                         This means that if you lose your power,
you will lose
175                         as much as the latest 5 seconds of work (your
176                         filesystem will not be damaged though, thanks to the
177                         journaling).  This default value (or any low value)
178                         will hurt performance, but it's good for
data-safety.
179                         Setting it to 0 will have the same effect as leaving
180                         it at the default (5 seconds).
181                         Setting it to very large values will improve
182                         performance.


-- 
Thanks,
Tao
