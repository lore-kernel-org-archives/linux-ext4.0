From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1
 device
Date: Thu, 2 Aug 2012 17:58:19 +0800
Message-ID: <20120802095818.GA4651@gmail.com>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
 <20120801071935.GA12929@gmail.com>
 <5018D7D9.6080709@wpkg.org>
 <20120801074845.GA13030@gmail.com>
 <5018E00F.1000207@wpkg.org>
 <20120801081744.GA13335@gmail.com>
 <CAFepXZjgihKhAOpF3KJ8dKfHGpip-Kaf8+xvwrpTOqWB8Zs9rQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-ext4@vger.kernel.org,
	semenko@alum.mit.edu, tytso@mit.edu, djwong@us.ibm.com
To: semenko@syndetics.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34466 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2HBJtj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2012 05:49:39 -0400
Received: by yhmm54 with SMTP id m54so8469368yhm.19
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2012 02:49:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFepXZjgihKhAOpF3KJ8dKfHGpip-Kaf8+xvwrpTOqWB8Zs9rQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 10:43:05PM -0500, Nick Semenkovich wrote:
[-- snip --]
> Sorry for the slow reply --
> 
> 
> I hadn't seen any "Corrupt dir inode" errors until now.
> 
> Before running the one-line patch above, I resynced the MD array and
> ran a quick fsck (via "touch /forcefsck" & reboot).
> 
> 
> Then,
> $ sudo misc/tune2fs -O metadata_csum /dev/md1
> 
> [says something about running e2fsck -D]
> 
> 
> Then I got a few dmesg errors like:
> 
> [128700.816091] JBD2: Spotted dirty metadata buffer (dev = md1,
> blocknr = 5243385). There's a risk of filesystem corruption in case of
> system crash.
> [128700.816106] JBD2: Spotted dirty metadata buffer (dev = md1,
> blocknr = 1057). There's a risk of filesystem corruption in case of
> system crash.
> 
> then a lot of
> 
> [128711.000677] EXT4-fs warning (device md1): dx_probe:647: dx entry:
> limit != root limit
> [128711.000679] EXT4-fs warning (device md1): dx_probe:732: Corrupt
> dir inode 7733251, running e2fsck is recommended.
> 
> 
> On my next command (sudo -s), I got an immediate kernel panic:
> 
> [128713.776475] EXT4-fs warning (device md1): dx_probe:732: Corrupt
> dir inode 7733251, running e2fsck is recommended.
> [128761.137143] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [128761.137195] IP: [<ffffffff8121d448>] ext4_iget+0x498/0xa50
> [128761.137231] PGD 106651067 PUD 11cf41067 PMD 0
> [128761.137258] Oops: 0000 [#1] SMP
> [128761.137279] CPU 0
> [snip...]
> 
> Full panic @ http://web.mit.edu/semenko/Public/panic.txt

Hi Nick,

Thanks for testing my patch.  As you described above, it seems that
there still has some bugs when metadata_csum feature enabled.  I tried
to reproduce this bug, but I couldn't reproduce it in my sandbox.  I see
the full panic file, and it seems that the kernel is running on Ubuntu
distribution and it doesn't use a generic mainline kernel.  So IMHO
would you like to try a latest upstream kernel?  At least when the
problem happens again, it is easy for me to find out where goes wrong.
Thanks for your patient.

Regards,
Zheng
