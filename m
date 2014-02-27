From: Rohan Puri <rohan.puri15@gmail.com>
Subject: Re: Reset due to emergency remount r/o
Date: Thu, 27 Feb 2014 09:21:22 +0530
Message-ID: <CALJfu6N+4MwtrjXzxB2ENFZU-Cmm8tBe2bRdR-TUW0h-XqDj5g@mail.gmail.com>
References: <CAMNxYsx=fe5zgj99jJSmp=q30HaOA5JweTEN6_3T1R026cnwFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>
To: Priyaranjan Das <priyaranjan456789@gmail.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:63029 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaB0DvX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Feb 2014 22:51:23 -0500
Received: by mail-la0-f42.google.com with SMTP id ec20so1305416lab.29
        for <linux-ext4@vger.kernel.org>; Wed, 26 Feb 2014 19:51:22 -0800 (PST)
In-Reply-To: <CAMNxYsx=fe5zgj99jJSmp=q30HaOA5JweTEN6_3T1R026cnwFQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 19, 2014 at 6:14 PM, Priyaranjan Das
<priyaranjan456789@gmail.com> wrote:
> Hi All,
>
> I am facing an kernel restart due to emergency remount. Could anybody tell
> me general techniques to go head with the debugging?
>
> Below are the logs which are seen during a reboot.
>
> [ 425.832395,1] SysRq : Emergency Remount R/O
> [ 425.876210,1] EXT4-fs (mmcblk0p36): re-mounted. Opts: (null)
> [ 425.925899,1] EXT4-fs (mmcblk0p33): re-mounted. Opts: (null)
> [ 425.928731,1] EXT4-fs (mmcblk0p29): re-mounted. Opts: (null)
> [ 425.955762,1] Emergency Remount complete
>
> [ 426.187136,0] Restarting system with command 'bootloader'.
> [ 426.187327,0] Current task:init(1) Parent task:swapper/0(0)
> [ 426.187430,0] Going down for restart now
>
>
> Regards,
>
> Priyaranjan
>
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>

Adding the linux-ext4 mailing list too.

- Regards,
      Rohan
