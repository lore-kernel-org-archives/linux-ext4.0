From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 11:10:50 -0700 (PDT)
Message-ID: <20090318181050.6491B10800E@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101AbZCRSLb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 14:11:31 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2IIAoil031235
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 11:11:26 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #10 from andy-kernelbugzilla@splashground.de  2009-03-18 11:10 -------
(In reply to comment #7)
> It's good to know that you can reproduce it easily on that particular ext3 file
> system.   One interesting question is whether you can reproduce it on some
> other ext3 file system (since then we might be able to reproduce it on our
> end); although I haven't played with LUKS at all, and I don't know how much
> effort it would take for me to set it up on my system.

That should be rather easy, follow:
http://wiki.archlinux.org/index.php/LUKS

Basically:

$ cryptsetup -c aes-xts-plain -y -s 512 luksFormat /dev/sda3
$ cryptsetup luksOpen /dev/sda3 test
$ mkfs.ext3 /dev/mapper/test

> How are you backing up the data?   tar?  Amanda?   Some other backup system?

I just tried to cp -rp the data away. There was no write to the fs at the time
I think. 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
