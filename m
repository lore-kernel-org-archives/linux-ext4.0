From: Dustin Lundquist <dustin@null-ptr.net>
Subject: Re: kernel BUG at fs/buffer.c:1234!
Date: Thu, 20 Jun 2013 09:20:01 -0700
Message-ID: <51C32BB1.5070902@null-ptr.net>
References: <51C1DF40.7030708@null-ptr.net> <20130619185537.GB24587@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.overthere.org ([67.214.208.79]:58417 "EHLO
	mail.overthere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab3FTQUI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jun 2013 12:20:08 -0400
In-Reply-To: <20130619185537.GB24587@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/19/2013 11:55 AM, Theodore Ts'o wrote:
> On Wed, Jun 19, 2013 at 09:41:36AM -0700, Dustin Lundquist wrote:
>> I've run into the following oops several times with the 3.10-rc3
>> through -rc6, and they have not occurred under 3.9. Originally they
>> only occurred when running Google Chrome, but this is the first time
>> it has happened in another application.
>
> So this is very strange.  fs/buffer.c:1234 for 3.10-rc6 is this
> BUG_ON:
>
> static inline void check_irqs_on(void)
> {
> #ifdef irqs_disabled
> 	BUG_ON(irqs_disabled());
> #endif
> }
>
> The only place where ext4 turns off irq's is very briefly in
> fs/ext4/page-io.c, and it's pretty easy to visually inspect all of the
> calls to spin_lock_irqsave() and spin_lock_irqrestore() and
> lock_irq_save() and local_irq_restore() are properly bracketed --- and
> the stack trace does not have any of the functions that are defined in
> fs/ext4/page_io.c.
>
> I notice from the dmesg file that one of the ext4 file systems is
> mounted on a device mapper volume.  What kind of dm device is it?
This is an LVM volume on a single SSD. I've include fdisk, mount and lvm 
output at https://gist.github.com/dlundquist/1d94dd938f03c5d06a2b. 
Another clue might be that I'm using ecryptfs to encrypt my home directory.

Since the system is still half way responsive after this occurs, is 
there any other information I can gather after if occurs to aid in 
diagnosing this?

Thanks,


Dustin Lundquist

