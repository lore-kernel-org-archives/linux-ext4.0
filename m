From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Can someone confirm ext4 BUG_ON on latest kernel build?
Date: Sun, 19 Jun 2011 21:42:19 -0400
Message-ID: <20110620014219.GA32133@thunk.org>
References: <4DFDCBE0.5020806@halfdog.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: halfdog <me@halfdog.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DFDCBE0.5020806@halfdog.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jun 19, 2011 at 10:13:52AM +0000, halfdog wrote:
> 
> Sorry, I do not have latest kernel. Can someone confirm this on latest?
> At least bugtracker does not know about it, and to my understanding of
> source, should be still here.
> 
> dd if=/dev/zero bs=1M count=64 of=test
> mkfs.ext4 -F test
> echo -n " " | dd of=test bs=1 count=1 seek=297195 conv=notrunc
> mount -o loop test /mnt/test
> dmesg -c
> 
> On ubuntu natty with latest kernel, it seems, that
> fs/ext4/super.c:__save_error_info calls mod_timer before timer->function
> is set at end of fs/ext4/super.c:ext4_fill_super via
>   sbi->s_err_report.function = print_daily_error_info;
> 
> This causes BUG_ON(!timer->function) in kernel/timer.c:__mod_timer
> Device is stuck, not usable any more.

This problem is fixed in 2.6.39 (via commit 0449641130f5, which landed
in mainline in 2.6.39-rc3).

Regards,

					- Ted
