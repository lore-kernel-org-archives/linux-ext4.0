From: Tao Ma <tao.ma@oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync
 performance when using CFQ
Date: Wed, 30 Jun 2010 08:31:16 +0800
Message-ID: <4C2A9054.20500@oracle.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>	<4C21D442.8080703@oracle.com>
	<4C22F316.3080009@oracle.com>	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>	<4C284419.3000905@oracle.com>
	<x49wrthlwfk.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        linux-ext4@vger.kernel.org, vgoyal@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <x49wrthlwfk.fsf@segfault.boston.devel.redhat.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

Hi Jeff,

On 06/29/2010 10:56 PM, Jeff Moyer wrote:
> Tao Ma<tao.ma@oracle.com>  writes:
>
>> Hi Jeff,
>>
>> On 06/27/2010 09:48 PM, Jeff Moyer wrote:
>>> Tao Ma<tao.ma@oracle.com>   writes:
>>>> I am sorry to say that the patch make jbd2 locked up when I tested
>>>> fs_mark using ocfs2.
>>>> I have attached the log from my netconsole server. After I reverted
>>>> the patch [3/3], the box works again.
>>>
>>> I can't reproduce this, unfortunately.  Also, when building with the
>>> .config you sent me, the disassembly doesn't line up with the stack
>>> trace you posted.
>>>
>>> I'm not sure why yielding the queue would cause a deadlock.  The only
>>> explanation I can come up with is that I/O is not being issued.  I'm
>>> assuming that no other I/O will be completed to the file system in
>>> question.  Is that right?  Could you send along the output from sysrq-t?
>> yes, I just mounted it and begin the test, so there should be no
>> outstanding I/O. So do you need me to setup another disk for test?
>> I have attached the sysrq output in sysrq.log. please check.
>
> Well, if it doesn't take long to reproduce, then it might be helpful to
> see a blktrace of the run.  However, it might also just be worth waiting
> for the next version of the patch to see if that fixes your issue.
>
>> btw, I also met with a NULL pointer deference in cfq_yield. I have
>> attached the null.log also. This seems to be related to the previous
>> deadlock and happens when I try to remount the same volume after
>> reboot and ocfs2 try to do some recovery.
>
>   Pid: 4130, comm: ocfs2_wq Not tainted 2.6.35-rc3+ #5 0MM599/OptiPlex 745
>   RIP: 0010:[<ffffffff82161537>]
>    [<ffffffff82161537>] cfq_yield+0x5f/0x135
>   RSP: 0018:ffff880123061c60  EFLAGS: 00010246
>   RAX: 0000000000000000 RBX: ffff88012c2b5ea8 RCX: ffff88012c3a30d0
>
> ffffffff82161528:	e8 69 eb ff ff       	callq  ffffffff82160096<cfq_cic_lookup>
> ffffffff8216152d:	49 89 c6             	mov    %rax,%r14
> ffffffff82161530:	48 8b 85 00 06 00 00 	mov    0x600(%rbp),%rax
> ffffffff82161537:	f0 48 ff 00          	lock incq (%rax)
>
> I'm pretty sure that's a NULL pointer deref of the tsk->iocontext that
> was passed into the yield function.  I've since fixed that, so your
> recovery code should be safe in the newest version (which I've not yet
> posted).
ok, so could you please cc me when the new patches are out? It would be 
easier for me to track it. Thanks.

Regards,
Tao
