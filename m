From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH 2/2] make both atomic_write_lock and BTM lock acquirement
 sleepable at tty_write_message()
Date: Sat, 30 Jun 2012 21:35:32 +0800
Message-ID: <4FEF00A4.6050502@oracle.com>
References: <4FEEC973.4090905@oracle.com> <20120630134412.55eea39a@pyramind.ukuu.org.uk>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-serial@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	gregkh@linuxfoundation.org, Jan Kara <jack@suse.cz>,
	"Ted Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-serial-owner@vger.kernel.org>
In-Reply-To: <20120630134412.55eea39a@pyramind.ukuu.org.uk>
Sender: linux-serial-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hey Alan,

On 06/30/2012 08:44 PM, Alan Cox wrote:

>> +		 * tty_write_message() will invoked by print_warning()
>> +		 * at fs/quota/dquot.c if CONFIG_PRINT_QUOTA_WARNING
>> +		 * is enabled when a user running out of disk quota limits.
>> +		 * It will end up call tty_write().  Here is a potential race
> 
> tty->ops->write is the low level write method, not tty_write.

I was wondering if below call trace is come from tty_write_message()->tty->ops->write()?
[ 2739.802106] -> #1 (&mm->mmap_sem){++++++}:
[ 2739.802120]        [<c10fa825>] lock_acquire+0x14e/0x189
[ 2739.802133]        [<c11e3e83>] might_fault+0xbf/0xf8
[ 2739.802154]        [<c13bcbdf>] _copy_from_user+0x40/0x8a
[ 2739.802175]        [<c14addc3>] copy_from_user+0x16/0x26
[ 2739.802195]        [<c14b00b4>] tty_write+0x282/0x3c7
[ 2739.802212]        [<c14b02dd>] redirected_tty_write+0xe4/0xfd
[ 2739.802226]        [<c1231879>] vfs_write+0xf5/0x1a3
[ 2739.802239]        [<c1231bdc>] sys_write+0x6c/0xa9
[ 2739.802253]        [<c186281f>] sysenter_do_call+0x12/0x38

> 
> This appears to be even more wrong than the other one in other ways too -
> it uses interruptible sleeps but doesn't handle the signal case so will
> spin on a signal and kill the box.
> 
> NAK
> 
> Looking gat the traces I suspect what you've actually got is a much more
> complicated deadlock where a process doing perfectly normal I/O to the
> tty has faulted and there is a chain of dependancies through the file
> system code to the thread which is doing the dquot_alloc_inode.
> 
> If that is the case then dquot_alloc_inode shouldn't be making blocking
> calls to tty_write_message and probably the right thing to do is to queue
> work for it so the tty_write_message is done asynchronously.
> 
> There are a very limited number of events that need reporting so probably
> something like a per mount flags and workqueue would allow you to do
> 
> 	set_bit(DQUOT_INODEOVER, &foo->events);
> 	schedule_work()
> 
> and the work queue can just xchg the events long for 0 and spew any
> messages required.

Thanks for the teaching, I'll give a try. 

-Jeff

> 
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


