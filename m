From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Tue, 05 Apr 2011 19:25:44 +0900
Message-ID: <4D9AEE28.4000003@jp.fujitsu.com>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com> <20110215160630.GH17313@quack.suse.cz> <20110215170352.GE4255@thunk.org> <20110215172954.GK17313@quack.suse.cz> <20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com> <20110216145627.GB5592@quack.suse.cz> <4D5C9B1B.2050304@jp.fujitsu.com> <20110217104552.GD4947@quack.suse.cz> <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com> <20110330141205.GC22349@quack.suse.cz> <4D946DAB.3010107@jp.fujitsu.com>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46487 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1DEKYN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 06:24:13 -0400
In-Reply-To: <4D946DAB.3010107@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

(2011/03/31 21:03), Toshiyuki Okajima wrote:
> Hi, thanks for your reviewing.
>
> (2011/03/30 23:12), Jan Kara wrote:
>> Hello,
>>
>> On Mon 28-03-11 17:06:28, Toshiyuki Okajima wrote:
>>> On Thu, 17 Feb 2011 11:45:52 +0100
>>> Jan Kara<jack@suse.cz> wrote:
>>>> On Thu 17-02-11 12:50:51, Toshiyuki Okajima wrote:
>>>>> (2011/02/16 23:56), Jan Kara wrote:
>>>>>> On Wed 16-02-11 08:17:46, Toshiyuki Okajima wrote:
>>>>>>> On Tue, 15 Feb 2011 18:29:54 +0100
>>>>>>> Jan Kara<jack@suse.cz> wrote:
>>>>>>>> On Tue 15-02-11 12:03:52, Ted Ts'o wrote:
>>>>>>>>> On Tue, Feb 15, 2011 at 05:06:30PM +0100, Jan Kara wrote:
> <SNIP>
>>> I have deeply continued to examined the root cause of this problem, then
>>> I found it.
>>>
>>> It is that we can write a memory which is mmaped to a file. Then the memory
>>> becomes "DIRTY" so then the flusher thread (ex. wb_do_writeback) tries to
>>> "writeback" the memory.
>>>
>>> Therefore, the root cause of this hangup is not only ext4 component (with
>>> delayed allocation feature) but also writeback mechanism for mmap. If you
>>> use the other filesystem, you can write something to the filesystem though
>>> you have freezed the filesystem.
>
>> Well, you can write something only in the caches, not to the on disk
>> image. So it's not a problem as such.
> My reproducer uses the loopback device(/dev/loopX). By using it, I have confirmed that
> we can write in not only the caches but also the loopback device. However,
> I don't still confirm that we can write to the real device(/dev/sdaX).
>
>>
>>> A sample problem is attached on this mail. Try to execute it then you can
>>> confirm that we can write some data to your filesystem while freezing the
>>> filesystem.
>>> (If you change FS variable in go.sh from ext3 to ext4 and you execute
>>> "fsfreeze -u mnt" manually on other prompt, you can also confirm this deadlock.)
>>>
>>> I think the best approach to fix this problem is to let users not to write
>>> memory which is mapped to a certain file while the filesystem is freezing.
>>> However, it is very difficult to control users not to write memory which has
>>> been already mapped to the file.
>> It is actually possible. In case of ext4, you could add a check (+ wait)
>> in ext4_page_mkwrite() whether the filesystem is frozen or in the process
>> of being frozen and if so, wait for it to get unfrozen. The only tough
>> problem here might be the locking as ext4_page_mkwrite() is called with
>> mmap_sem held and I'm not sure we can take s_umount with mmap_sem held.
>> But you'd have to fix all filesystems (and all paths possibly creating
>> dirty data) in this way.
>>
>
>>> Therefore, I think there is only actual method that we stop writeback thread
>>> to resolve the mmap problem. Also, by this fix, the original problem
>>> (ext4 delayed write vs unfreeze) can be solved.
>> Hmm, I had a look at the code again and think we could fix the issue
>> cleanly (i.e. all possible users of s_umount) as follows: The lock
>> ordering will be
>> s_umount -> "fs frozen"
>> and there will be a new mutex s_freeze_mutex protecting changes of
>> s_frozen.
>>
>> freeze_bdev() already observes this lock ordering, it will only take
>> s_freeze_mutex for the changes of s_frozen values. The only other code
>> that is relevant for the lock ordering is thaw_super() (the freezing
>> process is not expected to reenter kernel for the frozen filesystem).
>> In thaw_super() we could take s_freeze_mutex, do all the thawing work,
>> set s_frozen, release s_freeze_mutex and put superblock reference.
>>
>
>> So something like the patch below - it seems to work for me, can you test
>> it please?
> I think your patch looks good, so, the original problem seems to be solved.
> OK, I will test your patch.
> This weekend I cannot test it. So, I will reply next week.
I have tested whether Mizuma-san's reproducer can cause to deadlock with your
patch. And then any problems didn't hit while the reproducer was running.

I think your patch solves the original deadlock problem which is reported by
Mizuma-san.

> Reported-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/super.c         |   40 ++++++++++++++++++++++++++++++++++------
>  include/linux/fs.h |    1 +
>  2 files changed, 35 insertions(+), 6 deletions(-)

However, I think a write which causes the deadlock is from mmapped dirty
pages. So, I guess we also need to fix in the mmap path while fsfreezing.

> I floated
>
> [PATCH, RFC] check for frozen filesystems in the mmap path
>
> a long time ago, but it went nowhere; maybe time to revive that approach.

Thanks,
Toshiyuki Okajima

