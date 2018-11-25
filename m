Return-Path: <SRS0=jmd0=OE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48108 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbeKYSuW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 25 Nov 2018 13:50:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C0CE22931C
        for <linux-ext4@vger.kernel.org>; Sun, 25 Nov 2018 07:59:52 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 25 Nov 2018 07:59:32 +0000
Message-ID: <bug-201685-13602-UhyoYQhRdQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

HB (hb@testwelt.deneb.uberspace.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hb@testwelt.deneb.uberspace
                   |                            |.de

--- Comment #41 from HB (hb@testwelt.deneb.uberspace.de) ---
I have this bug with ubuntu 18.04 kernel 4.15.0-39, too.

My Desktop: 
SSD (Samsung 840) with three partions:
/boot : ext2
/     : ext4
swap

HDD1: one ext4 partition
HDD2: luks encrypted, never mounted at boot time and not used when the error
happens.

No Raid-Stuff used.

The problems only occurs on the ext4 part. from the ssd.

Sometimes at booting there are some message like "could not access ata
devices", there are some timeouts with ATA-commands. It retries several times
until it gives up, I dont reach the busy box command line.

Sometimes I reach the busybox command line but cant fix it there, because there
is no fsck in busybox.

I have to connect the ssh to a notebook via usb2sata Adapter, the two partions
were recognised without problems and are in most cases automounted. If I force
a fsck there are some orphaned inodes discovered and the fs is fixed.

After this I can boot from this SSD in the desktop without problems until it
happens again.

The weired thing is that sometimes the SSD is not recognised after this and has
this ATA-Timeouts above.

Even turning the desktop completeley powerless (disconnecting from power socket
and waiting some minutes then doing a cold boot) it gets stuck the same way.

On the notbook were I fix the SSD is the same OS installed and there never
occured this type of problem. Maybe I had only luck until now, I dont use the
notebook very much.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
