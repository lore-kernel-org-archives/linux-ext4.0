From: jon ernst <jonernst07@gmail.com>
Subject: Re: [Bug 60676] Stat system call gives permission denied to root for
 links under a sticky bit
Date: Fri, 2 Aug 2013 03:16:46 +0000
Message-ID: <CAGW2f1GKwjhpMTKmq6ypFovvSv4Ci_8mZGsmhcf+2AygGYqk0w@mail.gmail.com>
References: <bug-60676-13602@https.bugzilla.kernel.org/>
	<bug-60676-13602-zhtxmg3pVa@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45348 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3HBDQr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 23:16:47 -0400
Received: by mail-oa0-f51.google.com with SMTP id h1so324969oag.38
        for <linux-ext4@vger.kernel.org>; Thu, 01 Aug 2013 20:16:46 -0700 (PDT)
In-Reply-To: <bug-60676-13602-zhtxmg3pVa@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I checked the code. Seems like those 2 proc entries are 0 by default
in current tree. Maybe James are using kernel before that change. ()

int sysctl_protected_symlinks __read_mostly = 0;
int sysctl_protected_hardlinks __read_mostly = 0;

On Fri, Aug 2, 2013 at 12:44 AM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=60676
>
> --- Comment #3 from Theodore Tso <tytso@mit.edu> ---
> On Thu, Aug 01, 2013 at 11:21:16AM -0700, Christoph Hellwig wrote:
>> Try reverting 800179c9b8a1e796e441674776d11cd4c05d61d7
>
> Or just do:
>
> echo 0 > /proc/sys/fs/protected_hardlinks
> echo 0 > /proc/sys/fs/protected_symlinks
>
> (or put the equivalent in /etc/sysctl.conf).
>
> There is a **very** detailed description of the design decision behind
> this change (which went in as of 3.6) in the commit description.  See:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=800179c9b8a1e796e441674776d11cd4c05d61d7
>
> In any case, it's "working as designed".
>
>                         - Ted
>
> --
> You are receiving this mail because:
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
