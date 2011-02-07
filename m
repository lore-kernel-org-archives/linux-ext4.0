From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] mke2fs: Add support for lazy journal initialization
Date: Mon, 7 Feb 2011 08:29:09 -0800
Message-ID: <7925BD53-B86D-4ED6-8EA1-20A00DB7D4C0@dilger.ca>
References: <alpine.LFD.2.00.1102012025400.3559@dhcp-lab-213.englab.brq.redhat.com> <1296645377-18480-1-git-send-email-lczerner@redhat.com> <DFB0F581-2306-41A9-AD21-F6019C3AC3C5@dilger.ca> <alpine.LFD.2.00.1102071506520.3927@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@MIT.EDU>, ext4 List <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:8858 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1BGQ3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 11:29:12 -0500
In-Reply-To: <alpine.LFD.2.00.1102071506520.3927@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-07, at 06:15, Lukas Czerner wrote:
> On Thu, 3 Feb 2011, Andreas Dilger wrote:
>> This patch adds the ability to skip zeroing the journal on disk.  This can
>> significantly speed up mke2fs with large journals.  At worst the uninitialized
>> journal is only a very short-term risk (if at all), because the journal will
>> be overwritten on any new filesystem as soon as any significant amount of data
>> is written to disk, unlike lazy_itable_init which can leave uninitialized
>> itable blocks indefinitely (in the absence of the kernel init thread).
> 
> I think that we can skip the journal zeroing if the underlying device,
> or the journal device supports discard, and advertise that discard
> zeroes data. It is the same behavior as in the case of inode tables and
> it would be nice to have the same thing for journal. Are you planning to
> implement this as well ?

That detection didn't exist when I originally wrote that patch.  It definitely makes sense to default to not zeroing the journal if discard has been done.

Cheers, Andreas





