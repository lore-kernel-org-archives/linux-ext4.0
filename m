From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: Add support for lazy journal initialization
Date: Mon, 7 Feb 2011 15:15:13 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102071506520.3927@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1102012025400.3559@dhcp-lab-213.englab.brq.redhat.com> <1296645377-18480-1-git-send-email-lczerner@redhat.com> <DFB0F581-2306-41A9-AD21-F6019C3AC3C5@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Ted Ts'o" <tytso@MIT.EDU>, Lukas Czerner <lczerner@redhat.com>,
	ext4 List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab1BGOPW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 09:15:22 -0500
In-Reply-To: <DFB0F581-2306-41A9-AD21-F6019C3AC3C5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Feb 2011, Andreas Dilger wrote:

> This patch adds the ability to skip zeroing the journal on disk.  This can
> significantly speed up mke2fs with large journals.  At worst the uninitialized
> journal is only a very short-term risk (if at all), because the journal will
> be overwritten on any new filesystem as soon as any significant amount of data
> is written to disk, unlike lazy_itable_init which can leave uninitialized
> itable blocks indefinitely (in the absence of the kernel init thread).
> 
> Cheers, Andreas
> 

Hi Andreas,

I think that we can skip the journal zeroing if the underlying device,
or the journal device supports discard, and advertise that discard
zeroes data. It is the same behavior as in the case of inode tables and
it would be nice to have the same thing for journal. Are you planning to
implement this as well ?

Thanks!
-Lukas
