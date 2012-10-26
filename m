From: Martin <marogge@onlinehome.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sat, 27 Oct 2012 01:15:38 +0200
Message-ID: <508B199A.8050108@onlinehome.de>
References: <jXNl8-5m5-13@gated-at.bofh.it> <jXNOa-5MR-23@gated-at.bofh.it> <jXPGh-87s-5@gated-at.bofh.it> <jXTJW-4CH-55@gated-at.bofh.it> <jXUZj-6mo-13@gated-at.bofh.it> <jXVLH-7kO-5@gated-at.bofh.it> <jXW53-7CC-5@gated-at.bofh.it> <jXWeJ-7Lk-1@gated-at.bofh.it> <50882787.3030504@onlinehome.de> <508AEEF7.8060301@onlinehome.de> <20121026211033.GD8614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org, gregkh@linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934204Ab2JZXPs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 19:15:48 -0400
In-Reply-To: <20121026211033.GD8614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/2012 11:10 PM, Theodore Ts'o wrote:
> This looks very different.  The symptoms are quite different, and it's
> most likely that an unclean shutdown is involved.  In your case,
> you're doing clean shutdowns, with some suspend/resume cycles thrown
> in.

No no, the case I reported was triggered by an unclean shutdown: my son 
hitting the power button after a system crash, or more likely when the 
graphics subsystem became unresponsive.

> Are you running e2fsck to fix the file system consistency problems;
> what is e2fsck reporting?

by now it attests a bill of clean health. at first it reported issues 
the precise nature of which escaping my memory, fixed them, and after 
the next reboot reported some more issues which again were fixed. Had I 
known this will look similar to a prominent issue I would have paid more 
attention.

> Do you need to have a suspend/resume in order to trigger the problem?

no, I just mentioned the suspend/resume cycles to explain what is going 
on in the syslog, which I didn't attach in the end. During the period of 
the problem building up there was no suspend/resume event.

> This could very be some kind of hardware problem or kernel bug related
> to suspend/resume.  Unfortunately, many different problems get noticed
> by the file system, but the root cause is can often be something else;
> a hardware problem, or a bug somewhere else in the kernel.

I hear what you are saying. I just want to add that the hardware has 
survived the past two or three years despite suspend/resume and the odd 
abusive treatment (like unclean shutdown by non-techie users). I tend to 
keep the kernel, patches, modules and user land up to date.

>
> Regards,
>
> 						- Ted
>
> P.S.  Can you do us a favor and start a separate mail thread with the
> information reposted?  It's can get hard to track different cases when
> a lot of people assume that their random failure (some of which are
> hardware problems) are related to the issue we are trying to track
> down in this mail thread and then they all pile onto the same mail
> thread or the same web forum --- one of the reasons why I detest
> Ubuntu Launchpad.  Thanks!!

Shall do.

cu Martin

