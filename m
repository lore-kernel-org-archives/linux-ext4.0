From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Sun, 14 May 2017 18:20:46 +0000
Message-ID: <bug-195561-13602-EfMnXGqtgZ@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51720 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759122AbdENSVG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 May 2017 14:21:06 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AAABD28956
        for <linux-ext4@vger.kernel.org>; Sun, 14 May 2017 18:21:05 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #34 from Mauro Rossi (issor.oruam@gmail.com) ---
(In reply to Theodore Tso from comment #33)
> Well, the commit seems to imply that it's only for 32-bit platforms.   I am
> not an expert on make_ext4fs, and I don't have the AOSP sources on my
> laptop, so it's not something I can easily investigate at the moment.  But
> it would explain a lot of things; the Android team at the time would have
> been only focusing on 64-bit devices, and while e2fsck and mke2fs in
> e2fsprogs has plenty of regression tests, and I *do* run them on 32-bit
> platforms from time to time for e2fsprogs, make_ext4fs.... not so much.  
> (As far as I know it has no regression tests.)
> 
> Which brings me to my next question I'm asking out of curiosity.   Why, in
> 2017, are you trying to build 32-bit x86?    Is it just to try to save RAM? 
> Are you trying to selflessly try to find 32-bit bugs when most device
> manufacturers are focusing on 64-bit architectures?   :-)

The reason for x86 builds in android-x86 is that x86_64 builds require SSE4_1
and SSE4_2 and unlike in linux OS, there is no way to avoid it.
Also, Android Media Player (Fugu) images are 32 bit user space.

So it is still relatively pretty much used 

> 
> (Don't get me wrong; I do KVM kernel testing for ext4 using a 32-bit x86
> platform partially because it's more RAM economical, and because as an
> upstream developer I am interesting in sanity checking to make sure we
> haven't introduced any 32-bit regressions.   So there are good reasons to do
> it, but for me I'm primarily *looking* to find problems --- in other words,
> I'm knowingly asking for it.  :-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
