From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Mon, 22 Feb 2010 21:57:18 +0300
Message-ID: <87bpfhyu7l.fsf@openvz.org>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
	<20100216185452.GE3153@quack.suse.cz>
	<4B7BAA70.9070605@jp.fujitsu.com> <20100217164933.GC5337@thunk.org>
	<4B8219B8.8070207@jp.fujitsu.com>
	<9B774728-3508-4850-B036-CB0013403DE9@mit.edu>
	<20100222180246.GA3112@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>,
	"toshi.okajima\@jp.fujitsu.com" <toshi.okajima@jp.fujitsu.com>,
	"akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
	"adilger\@sun.com" <adilger@sun.com>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63269 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0BVS51 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Feb 2010 13:57:27 -0500
Received: by bwz1 with SMTP id 1so312248bwz.21
        for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2010 10:57:25 -0800 (PST)
In-Reply-To: <20100222180246.GA3112@quack.suse.cz> (Jan Kara's message of
	"Mon, 22 Feb 2010 21:02:47 +0300")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Mon 22-02-10 08:55:53, Theodore Tso wrote:
>> As for quota --- quite seriously --- if you have mission critical users,
>> I'd suggest that they not use quota.  Dimitry has been turning up all
>> sorts of bugs in the quota subsystem, many of which are just as
>> applicable to ext3.  The real issue is that quota hasn't received as much
>> testing as other file system features --- in any file system, not just
>> ext4.
>   I don't agree with this. I know about quite a few large customers
> depending on quotas on their servers and they run on ext3 / reiserfs quite
> happily. Dmitry's patches touching the generic code were mostly cleanups,
> the fixes were just in the delayed allocation handling but that never
> gets executed for ext3 or reiserfs...
Stability is relative thing. I's quite depends on usecase.
For example after triggering bug on not empty orphan list on ext3_umount
i've started full orphan-list management code revision. And both
ext3/ext4 appears to be almost broken in case of errors.
But nobody seems never catch it in real life. But still
at that time i have triggered:
1) non empty orphan list on umount for both (ext3 and ext4)
2) on_disk linked list corruption  for both
3) data blocks beyond i_size 
4) bit-difference on fsck  for both
Currently i'm working on fixes. It takes week or so.
So at least i'll reduce "project_id quota" spam flow a bit.
>   I don't say there cannot be bugs and certainly quota code has less
> exposure than other more used filesystem parts. But I don't know about
> any serious quota issue on ext3 / reiserfs in last two years or so
> (except the one that was caused by Dmitry's fixes ;).
This time i'll try to give enough test coverage.
>
> 								Honza
