From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Fri, 12 Aug 2011 21:34:46 +0400
Message-ID: <4E456436.8070107@msgid.tls.msk.ru>
References: <4E4262A5.6030903@msgid.tls.msk.ru> <20110811115943.GF4755@quack.suse.cz> <4E43C956.3060507@msgid.tls.msk.ru> <20110811140101.GA18802@quack.suse.cz> <4E4435F4.6000406@msgid.tls.msk.ru> <CAFgt=MCgfN-6_uBm=pDaeLqJKJQkSHry91XbYwWq=iBXip3D-w@mail.gmail.com> <4E44C6ED.2030506@msgid.tls.msk.ru> <20110812130729.GC28324@quack.suse.cz> <4E454CD4.3080505@msgid.tls.msk.ru> <4E455C72.4030907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Jiaying Zhang <jiayingz@google.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:46842 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab1HLRes (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 13:34:48 -0400
In-Reply-To: <4E455C72.4030907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

12.08.2011 21:01, Eric Sandeen wrote:
[]
>> And yes, 18446744073709551199 aios sounds quite alot ;)
> 
> looks like it went negative.
> 
> I see that in one case we set EXT4_IO_END_UNWRITTEN, but don't increment the counter.
> We decrement the counter for every EXT4_IO_END_UNWRITTEN completion, I think.
> 
> I'm not quite sure if that was intentional or not, but it might be a place to start.
> I haven't though hard about this, in the middle of something else right now,
> but this looks like it's a probllem in my code from that unaligned AIO patch,
> perhaps...
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3e5191f..7366488 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3640,6 +3640,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
>  
>         io_end->flag = EXT4_IO_END_UNWRITTEN;
>         inode = io_end->inode;
> +       atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
>  
>         /* Add the io_end to per-inode completed io list*/
>         spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);

This patch does not change thing (unfortunately I forgot to reapply
the debugging patch posted by Jan so don't know how many aiocbs it
wants to wait).

But reverting e9e3bcecf44c04b9e6b505fd8e2eb9cea58fb94d
(ext4: serialize unaligned asynchronous DIO) helps, the thing
goes fine without that patch.

And this refcounting - I can't see why in my case the problem only
happens with hot cache and only with dioread_nolock mount option
(so far anyway - I weren't able to trigger it without at least
one of the two conditions).

BTW, ext4_end_io_buffer_write() is declared twice in fs/ext4/inode.c

Thanks,

/mjt
