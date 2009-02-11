From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem still has errors
Date: Wed, 11 Feb 2009 16:18:48 -0600
Message-ID: <49934EC8.7040800@redhat.com>
References: <loom.20090211T220951-175@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Raimund andersen <anderse@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40457 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbZBKWSx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 17:18:53 -0500
In-Reply-To: <loom.20090211T220951-175@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Raimund andersen wrote:
> Hi,
> 
> I'm using ext4 as a root fs on my 2.6.28-gentoo-r1 (x86_64), and after a few
> locks due to X misconfiguration, which forced me to hard-reset, I sometimes get
> the 'no space left on device' error message when trying to create new files. But
> that's not true:
> 
> #>df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> rootfs               201585632  16234952 175110680   9% /
> /dev/root            201585632  16234952 175110680   9% /
> (...)
> 
> #>df -i
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> rootfs               12804096  520672 12283424    5% /
> /dev/root            12804096  520672 12283424    5% /
> (...)
> 

snip ...

> The same is true with putting a '/forcefsck'; the filesystem is checked and no
> error message appears.
> But when invoking fsck manually after full bootup, fs is still corrupted. 
> 
> So what should I do?

You should expect that checking a live filesystem will produce errors,
actually.  So don't worry about that.  The filesystem is not quiesced,
and it's not consistent.  That is to be expected, and it's why you see
the different behavior w/ forcefsck vs. e2fsck -n on the live fs.

As for the spurious ENOSPC, I'm not certain.  Do you still get the error?

> Any help is greatly apreciated.
> 
> Raimund

