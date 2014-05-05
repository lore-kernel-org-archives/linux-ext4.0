From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: info about filesystem errors in /sys/fs/ext4/... ?
Date: Mon, 5 May 2014 13:03:17 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051253400.2223@localhost.localdomain>
References: <20140505070823.GM3017@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaEELDl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 07:03:41 -0400
In-Reply-To: <20140505070823.GM3017@pcnci.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 May 2014, Nikola Ciprich wrote:

> Date: Mon, 5 May 2014 09:08:23 +0200
> From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> To: linux-ext4@vger.kernel.org
> Subject: info about filesystem errors in /sys/fs/ext4/... ?
> 
> Hello,
> 
> I was wondering, is it possible to find out whether some filesystem with
> errors in mounted apart from parsing kernel log?
> 
> Would it be too complicated to add such info to /sys/fs/ext4/.../ or to
> some other location? Would such change make sense to you?
> 
> with regards
> 
> nik

Currently I do not think there is a way to check whether mounted
file system contains errors (EXT2_ERROR_FS flag is set in super
block).

You either have to check the logs, or run fsck before mounting the
file system.

It really seems like a optimal thing to provide a way to inform user
space about this without the need to parse the log. I think that
sysfs is a perfect place for this.

However we might to go a step further, because I do not
really like the idea of allowing to mount the file system with
errors by default. It does not really make sense to me and I wonder
whether someone actually intend to do it this way.

What about having this scenario respect "errors=" setting ? Of
course it might not make sense to panic when mounting file system
with errors with "errors=panic" option, we can just fail the mount.

Will that help your case ?

Thanks!
-Lukas
