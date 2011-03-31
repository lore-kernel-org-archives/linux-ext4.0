From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Thu, 31 Mar 2011 10:25:30 -0500
Message-ID: <4D949CEA.9060102@redhat.com>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>	<20110215160630.GH17313@quack.suse.cz>	<20110215170352.GE4255@thunk.org>	<20110215172954.GK17313@quack.suse.cz>	<20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>	<20110216145627.GB5592@quack.suse.cz>	<4D5C9B1B.2050304@jp.fujitsu.com>	<20110217104552.GD4947@quack.suse.cz>	<20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>	<20110330141205.GC22349@quack.suse.cz>	<AANLkTi=jTSEXsRJE+zzNvvTfFmqdAY42na8vm22NJefz@mail.gmail.com>	<4D9489DD.6080602@redhat.com> <AANLkTi=3HT-n4-4Q0RhWLGq0PSAgY68MPUa2zxU_uDY4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab1CaPZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Mar 2011 11:25:39 -0400
In-Reply-To: <AANLkTi=3HT-n4-4Q0RhWLGq0PSAgY68MPUa2zxU_uDY4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/31/11 9:36 AM, Yongqiang Yang wrote:
> On Thu, Mar 31, 2011 at 10:04 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 3/31/11 3:37 AM, Yongqiang Yang wrote:
>>
>>> in ext3, ext3_freeze() prevents journal from being updated by
>>> lock_journal_updates(), ext3_unfreeze() allow journal to be updated by
>>> unlock_journal_updates().
>>>
>>> in ext4, however, before ext4_freeze() returns, it unlock journal, and
>>> ext4 prevents journal from being updated by s_frozen. s_frozen is in
>>> an upper layer, so it is out control of ext4 and deadlock is easy to
>>> happen.
>>>
>>> Could someone explain why ext4 does like above but not follow ext3?
>>>
>>> Yongqiang.
>>
>> That was me, I think ...
> 
> Thank you, Eric.
> 
> I think ext4_journal_start() should check if current thread has an
> active handle before  vfs_check_frozen(), if so, current handle will
> be returned. Thus, we can avoid deadlocks.
> 
> Do you agree with me?  If I am right, I will send a patch.

If you have a testcase to test it with, sure.  plus a patch would help me know for sure what you propose :)

Sorry for breaking it (if I did!)  But holding a mutex and returning to userspace was pretty bad, too :(

Thanks,
-Eric

>>
>> commit 6b0310fbf087ad6e9e3b8392adca97cd77184084
>> Author: Eric Sandeen <sandeen@redhat.com>
>> Date:   Sun May 16 02:00:00 2010 -0400
>>
>>    ext4: don't return to userspace after freezing the fs with a mutex held
>>
>>    ext4_freeze() used jbd2_journal_lock_updates() which takes
>>    the j_barrier mutex, and then returns to userspace.  The
>>    kernel does not like this:
>>
>>    ================================================
>>    [ BUG: lock held when returning to user space! ]
>>    ------------------------------------------------
>>    lvcreate/1075 is leaving the kernel with locks still held!
>>    1 lock held by lvcreate/1075:
>>     #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
>>    jbd2_journal_lock_updates+0xe1/0xf0
>>
>>    Use vfs_check_frozen() added to ext4_journal_start_sb() and
>>    ext4_force_commit() instead.
>>
>>    Addresses-Red-Hat-Bugzilla: #568503
>>
>>
>>    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
> 
> 
> 

