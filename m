Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54988 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387839AbeKPC1f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 21:27:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6E9422C9D7
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2018 16:19:06 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 15 Nov 2018 16:19:06 +0000
Message-ID: <bug-201685-13602-sFa3VWNVzG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #3 from Jason Gambrel (jaygambrel@gmail.com) ---
(In reply to Theodore Tso from comment #2)
> I'm using a 4.19.0 based kernel (with some ext4 patches for the 4.20
> mainline) and I'm not noticing any file system problems.   I'm running a
> Dell XPS 13 with an NVME SSD, and Debian testing as my userspace.
> 
> It's hard to do anything with a "my file system is corrupted" report without
> any kind of reliable reproduction information.   Remember that file system
> corruptions can be caused by any number of things --- buggy device drivers,
> buggy Nvidia binary modules that dereference wild pointers and randomly
> corrupt kernel memory, RAID code if you are using RAID, etc., etc.
> 
> Also, the symptoms reported by Claude and Jason are very different.  Claude
> has reported that a data block in a shared library file has gotten
> corrupted.  Jason has reported that file system metadata corruption.   This
> could very well be coming from different root causes.
> 
> So it's better with these sorts of things to file separate bugs, and to
> include detailed hardware configuration details, kernel configuration,
> dumpe2fs outputs of the file system in question, as well as e2fsck logs.

Thank you for your reply Theodore and I apologize for my unhelpful post.  I am
relatively new to this space so I find your advice very helpful.  If the file
system corruption happens a 3rd time (hopefully it won't), I will post a
separate bug report.  I also wasn't previously aware of dumpe2fs, so I will
provide that helpful information next time. I have also searched to find any
additional logs and it looks like fsck logs the boot info under
/var/logs/boot.log and potentially /var/logs/syslog.  Unfortunately the
information from my last boot requiring fixation had already been overwritten. 
I will keep this in mind for the future.

If it helps, my system uses an i7 with integrated Intel graphics.  I am not
running any proprietary drivers.  No Raid. 500gb SSD. 16gb ram with a 4gb swap
file (not a swap partition).  I have been using ukuu to install mainline
kernels.  I did not change anything else on my system.  When I jumped from
4.18.17 to 4.19.0 this problem first appeared.  Then it occurred again after
updating to 4.19.1.

I'm uncertain as to whether it would be helpful or not, but while trying to
figure out why this happened to me, I came across a post on Ask Ubuntu with a
few others reporting similar problems.  They did provide some debugging
information in their post at:
https://askubuntu.com/questions/1092558/ubuntu-18-04-4-19-1-kernel-after-closing-the-lid-for-the-night-not-logging-ou

Again it might be a different problem from what Claude Heiland-Allen is
experiencing.

Thank you very much for your advice and I will try and provide some useful
information including logs in a separate bug report if it happens again.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
