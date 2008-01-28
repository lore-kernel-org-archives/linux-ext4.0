From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Mon, 28 Jan 2008 22:07:38 +0900
Message-ID: <01c801c861ae$c2349990$41a8400a@bsd.tnes.nec.co.jp>
References: <20080125195938t-sato@mail.jp.nec.com> <20080126053526.GN155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: "David Chinner" <dgc@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Thank you for your comments.

> That's inherently unsafe - you can have multiple unfreezes
> running in parallel which seriously screws with the bdev semaphore
> count that is used to lock the device due to doing multiple up()s
> for every down.
> 
> Your timeout thingy guarantee that at some point you will get
> multiple up()s occuring due to the timer firing racing with
> a thaw ioctl. 
> 
> If this interface is to be more widely exported, then it needs
> a complete revamp of the bdev is locked while it is frozen so
> that there is no chance of a double up() ever occuring on the
> bd_mount_sem due to racing thaws.....

My patch has the race condition as you said.
I will fix it.

Cheers, Takashi 

