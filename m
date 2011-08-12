From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Fri, 12 Aug 2011 12:01:38 -0500
Message-ID: <4E455C72.4030907@redhat.com>
References: <4E4262A5.6030903@msgid.tls.msk.ru> <20110811115943.GF4755@quack.suse.cz> <4E43C956.3060507@msgid.tls.msk.ru> <20110811140101.GA18802@quack.suse.cz> <4E4435F4.6000406@msgid.tls.msk.ru> <CAFgt=MCgfN-6_uBm=pDaeLqJKJQkSHry91XbYwWq=iBXip3D-w@mail.gmail.com> <4E44C6ED.2030506@msgid.tls.msk.ru> <20110812130729.GC28324@quack.suse.cz> <4E454CD4.3080505@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Jiaying Zhang <jiayingz@google.com>,
	linux-ext4@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1HLRBv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 13:01:51 -0400
In-Reply-To: <4E454CD4.3080505@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/12/11 10:55 AM, Michael Tokarev wrote:
> 12.08.2011 17:07, Jan Kara wrote:
> []
>>>>> [   76.982985] EXT4-fs (dm-1): Unaligned AIO/DIO on inode 3407879 by oracle; performance will be poor.
>>>>> [ 1469.734114] SysRq : Show Blocked State
>>>>> [ 1469.734157]   task                        PC stack   pid father
>>>>> [ 1469.734473] oracle          D 0000000000000000     0  6146      1 0x00000000
>>>>> [ 1469.734525]  ffff88103f604810 0000000000000082 ffff881000000000 ffff881079791040
>>>>> [ 1469.734603]  ffff880432c19fd8 ffff880432c19fd8 ffff880432c19fd8 ffff88103f604810
>>>>> [ 1469.734681]  ffffea000ec13590 ffffffff00000000 ffff881438c8dad8 ffffffff810eeda2
>>>>> [ 1469.734760] Call Trace:
>>>>> [ 1469.734800]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
>>>>> [ 1469.734863]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
>>>>> [ 1469.734909]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
>>>>> [ 1469.734956]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
>>>>> [ 1469.734999]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
>>>>> [ 1469.735039]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
>>>>> [ 1469.735078]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
>>>>> [ 1469.735122]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
> []
>>   Probably not, just garbage on stack confuses the stack unwinder. Note
>> that e.g. ext4_llseek() is at the end of function as well as
>> abort_exclusive_wait() which probably means these functions have already
>> finished and just left their addresses on stack. Could you disasseble
>> your ext4_file_write() function and check where offset 0x20d is? Sadly you
>> won't see where calls are going when ext4 is compiled as a module (module
>> is linked when loaded into kernel) so it might be easier to compile ext4
>> into the kernel and disassemble the function in vmlinux file.
>>
>>> Btw, does ext4_llseek() look sane here?  Note it's called from
>>> aio_submit() -- does it _ever_ implement SEEKs?
>>>
>>> Maybe some debugging is neecessary here?
>>   Yes. The trouble is I'm not completely sure where we are hanging yet.
>> We should know more from your disassembly. But you can try running with
>> attached debug patch - maybe it shows something interesting.
> 
> With ext4 built-in and your patch applied:
> 
> [  429.061524] EXT4-fs (sda11): Unaligned AIO/DIO on inode 5767181 by oracle; performance will be poor.
> [  429.061669] Going to wait for 18446744073709551199 aios
> [  437.717942] SysRq : Show Blocked State
> [  437.718109]   task                        PC stack   pid father
> [  437.718528] oracle          D 0000000000000000     0  3844      1 0x00000000
> [  437.718767]  ffff88203e330080 0000000000000082 0000000000000000 ffff881078e3f7d0
> [  437.719156]  ffff88203dc15fd8 ffff88203dc15fd8 ffff88203dc15fd8 ffff88203e330080
> [  437.719546]  0000001e0000000f 0000000000000246 205b88103f806680 3136302e39323420
> [  437.719935] Call Trace:
> [  437.720043]  [<ffffffff8139b976>] ? printk+0x43/0x48
> [  437.720155]  [<ffffffff8118e16d>] ? ext4_file_write+0x21d/0x290
> [  437.720267]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
> [  437.720376]  [<ffffffff8118df50>] ? ext4_llseek+0x120/0x120
> [  437.720485]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> [  437.720593]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> [  437.720699]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> [  437.720811]  [<ffffffff813a3152>] ? system_call_fastpath+0x16/0x1b
> 
> Trying to find how to disassemble things now...
> And yes, 18446744073709551199 aios sounds quite alot ;)

looks like it went negative.

I see that in one case we set EXT4_IO_END_UNWRITTEN, but don't increment the counter.
We decrement the counter for every EXT4_IO_END_UNWRITTEN completion, I think.

I'm not quite sure if that was intentional or not, but it might be a place to start.
I haven't though hard about this, in the middle of something else right now,
but this looks like it's a probllem in my code from that unaligned AIO patch,
perhaps...

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e5191f..7366488 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3640,6 +3640,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 
        io_end->flag = EXT4_IO_END_UNWRITTEN;
        inode = io_end->inode;
+       atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
 
        /* Add the io_end to per-inode completed io list*/
        spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);


> Thanks,
> 
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

