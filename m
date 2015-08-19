From: Karel Zak <kzak@redhat.com>
Subject: nolazytime remount
Date: Wed, 19 Aug 2015 10:21:44 +0200
Message-ID: <20150819082144.GB1689@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbbHSIVr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2015 04:21:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


We had issue with "lazytime" remount two mouths ago. This is already
fixed by Ted's patch a2fd66d06. So, now you can enable lazytime by
remount with MS_LAZYTIME flag, but how I can disable lazytime?

enable lazytime (works as expected):

 # findmnt /mnt/test
 TARGET    SOURCE    FSTYPE OPTIONS
 /mnt/test /dev/sdc1 ext4   rw,relatime,stripe=32,data=ordered

 # mount -o remount,lazytime /mnt/test

 # findmnt /mnt/test
 TARGET    SOURCE    FSTYPE OPTIONS
 /mnt/test /dev/sdc1 ext4   rw,relatime,lazytime,stripe=32,data=ordered


disable lazytime by "nolazytime":

 # mount -o remount,nolazytime /mnt/test
 # findmnt /mnt/test
 TARGET    SOURCE    FSTYPE OPTIONS
 /mnt/test /dev/sdc1 ext4   rw,relatime,lazytime,stripe=32,data=ordered
                                        ^^^^^^^^

In this case mount(8) command generates:
  mount("/dev/sdc1", "/mnt/test", 0x562ed2f7e210, MS_REMOUNT|MS_RELATIME, "stripe=32,data=ordered") = 0
syscall.


It seems that ext4_remount() allows to enable the option by MS_LAZYTIME,
but there is no sb->s_flags &= ~MS_LAZYTIME at all. It seems like a
regression, because old string based solution (handle_mount_opt()) contains:

  case Opt_nolazytime:
       sb->s_flags &= ~MS_LAZYTIME;
       return 1;


>From my point of view, a2fd66d06 commit is insufficient, for ext4_remount()
we also need "else" for MS_LAZYTIME:

	if (*flags & MS_LAZYTIME)
		sb->s_flags |= MS_LAZYTIME;
    else
        sb->s_flags &= ~MS_LAZYTIME;


The another possibility is that "lazytime" is possible enable only --
if yes, then handle_mount_opt() should be fixed to not provide
Opt_nolazytime.

Ted?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
