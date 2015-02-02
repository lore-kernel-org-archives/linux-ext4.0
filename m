From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Mon, 02 Feb 2015 08:32:54 +0000
Message-ID: <bug-92271-13602-55FQuIts5D@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48864 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbbBBIc7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Feb 2015 03:32:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0C2EA201F2
	for <linux-ext4@vger.kernel.org>; Mon,  2 Feb 2015 08:32:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CEDC920212
	for <linux-ext4@vger.kernel.org>; Mon,  2 Feb 2015 08:32:54 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org

--- Comment #19 from Dmitry Monakhov <dmonakhov@openvz.org> ---
(In reply to Theodore Tso from comment #10)
> The problem is for flash based devices, there ultimately is no way to be
> completely sure.   Even in the case of eMMC devices that support secure
> trim, that is only going to trim most recent flash page where the data was
> located.   The FTL could have copied the data to another flash page, and not
> gotten around to erasing the older flash page.  And most flash devices don't
> even have secure trim, and trim is a discretionary command that the flash
> device is free to ignore whenever it feels like it.  So ultimately, this is
> a Very Hard Problem.
> 
> It's true that we could try to do better at it, but ultimately most users
> will never know if they can actually trust a file that has been "securely
> unlinked", whether you do this with a system call or by honoring the 's'
> chattr bit.   It will depend on the file system you are using, the sort of
> storage stack used by the file system, and so in practice having such a
> "secure unlink" feature could do more harm than good, because it many users
> could end up trusting it when they really shouldn't.
> 
> In terms of your original use case, the simplest solution is to simply not
> let the signing keys hit a storage device at all.  So for example, you could
> use a ramdisk.  Perhaps more convenient for users who are not running as
> root is to use tmpfs.   Try seeing if /var/run/$UID is present, or if not,
> fall back to a directory in /tmp.   Yes, it's possible for tmpfs to be
> written to swap, but you can get around that problem by forking a process
> which mmap's the private keys, and then calls mlock(2) to make sure they
> stay in memory.   Each user is allowed to mlock 64k of memory by default,
> which should be plenty for storing some private keys that you want to
> discard when you're done with the kernel compile.
> 
> This has the advantage of working for *everyone*, whereas most SSD's don't
> have secure trim. and most kernel developers, not having the patience of
> saints, and not trusting the reliability of cheap flash, are unlikely to be
> building on top of eMMC flash.
> 
> The final thing to consider is what exactly is your threat environment.   If
> the attacker has sufficient privilegs to steal deleted files from your build
> machine, you have much bigger problems.   The attacker would be much better
> served to try compromise the C compiler, or simply make a copy of the keys
> during the build process.   Sure, there are scenarios where the bad guy
> might be able to steal the disk after the build was finished, and before the
> disk blocks gets reused, and somehow didn't have the privileges to play
> monkey business during the build.   Such scenarios can be imagined.  But is
> it worth it to spend huge amounts of engineering time creating a "secure
> unlink" that is only guaranteed to work on storage devices which are highly
> unlikely to be used for kernel builds in the first place?
> 
> This is, of course, open source, so if you want to send patches, we'll be
> happy to review them.    But in terms of a feature request, this is going to
> be extremely low priority, especially since there are workarounds which are
> much better, more applicable, and more secure than your proposed solution.

I always want to implement reliable (but 100% secure) way to delete inodes.
Main idea is to append freed space to special inode (similar to what we do with
orphan list) and reliably cleanup that blocks in background (actual logic
depends on lower device: perform multiple rewrites or sec-trim).  I'll back
with the proof of concept patch-set.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
