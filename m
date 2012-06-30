From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] make both atomic_write_lock and BTM lock
 acquirement sleepable at tty_write_message()
Date: Sat, 30 Jun 2012 13:44:12 +0100
Message-ID: <20120630134412.55eea39a@pyramind.ukuu.org.uk>
References: <4FEEC973.4090905@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-serial@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	gregkh@linuxfoundation.org, Jan Kara <jack@suse.cz>,
	"Ted Ts'o" <tytso@mit.edu>
To: jeff.liu@oracle.com
Return-path: <linux-serial-owner@vger.kernel.org>
In-Reply-To: <4FEEC973.4090905@oracle.com>
Sender: linux-serial-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> +		 * tty_write_message() will invoked by print_warning()
> +		 * at fs/quota/dquot.c if CONFIG_PRINT_QUOTA_WARNING
> +		 * is enabled when a user running out of disk quota limits.
> +		 * It will end up call tty_write().  Here is a potential race

tty->ops->write is the low level write method, not tty_write.

This appears to be even more wrong than the other one in other ways too -
it uses interruptible sleeps but doesn't handle the signal case so will
spin on a signal and kill the box.

NAK

Looking gat the traces I suspect what you've actually got is a much more
complicated deadlock where a process doing perfectly normal I/O to the
tty has faulted and there is a chain of dependancies through the file
system code to the thread which is doing the dquot_alloc_inode.

If that is the case then dquot_alloc_inode shouldn't be making blocking
calls to tty_write_message and probably the right thing to do is to queue
work for it so the tty_write_message is done asynchronously.

There are a very limited number of events that need reporting so probably
something like a per mount flags and workqueue would allow you to do

	set_bit(DQUOT_INODEOVER, &foo->events);
	schedule_work()

and the work queue can just xchg the events long for 0 and spew any
messages required.

Alan
