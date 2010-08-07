From: Ted Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/mballoc.c:2993!
Date: Sat, 7 Aug 2010 02:45:14 -0400
Message-ID: <20100807064513.GD28087@thunk.org>
References: <AANLkTinPtkUsVz6GYBgYMfgGKTJ88cyRfvdLcjtE5m4x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gcc@gcc.gnu.org, linux-ext4@vger.kernel.org
To: Justin Mattock <justinmattock@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36530 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab0HGGpS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Aug 2010 02:45:18 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinPtkUsVz6GYBgYMfgGKTJ88cyRfvdLcjtE5m4x@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 06, 2010 at 10:48:40PM -0700, Justin Mattock wrote:
> hello,
> I just built a fresh clfs system using the tutorial.. right now Im
> able to boot and am able to login, the system seems to be running as
> it should except for when I try to install gmp and/or do a /sbin/lilo
> I see a message appear on screen(below) then if I do any kind of
> command(dmesg > dmesg) I get a stuck screen. has there been anything
> similar to the below message?
> 
> keep in mind the kernel I'm using is 2.6.35-rc6 which on other
> machines(same type of system) run just fine without such message.

Um, is this a completely modified 2.6.35-rc6 kernel?  The reason why I
ask is there is no BUG_ON at line fs/ext4/mballoc.c:2993 for that
kernel version.

There are two BUG_ON statements nearby, but given the line number
doesn't match up with either one, it's hard to say for sure which one
triggered it.  What were the kernel messages right before the BUG_ON?
was there a "start NNNNN size NNN, fe_logical NNNN" (where NNNN is
some number) right before the "cut here" message?

Have you tried forcing an fsck run on the file system to make sure
it's not caused by a file-system corruption?

And have you tried using a standard released gcc so we can determine
for sure whether this is a potential kernel bug, file system
corruption issue, or gcc issue?

							- Ted
