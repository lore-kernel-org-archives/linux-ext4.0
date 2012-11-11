From: Roger Niva <rogerniva@gmail.com>
Subject: Ext4 file corruption using cp
Date: Sun, 11 Nov 2012 12:37:35 +0100
Message-ID: <CAH3VSLw_spHkb27VbRUG-81Rc=hwPDnhfGOe9LqExs0bFveujQ@mail.gmail.com>
References: <CAH3VSLyZvtHC5G_Hx6oHr_jR43+vYz46nXLkifuD3gXGLd21yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:36446 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2KKLhg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Nov 2012 06:37:36 -0500
Received: by mail-ia0-f174.google.com with SMTP id y32so3783374iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 11 Nov 2012 03:37:35 -0800 (PST)
In-Reply-To: <CAH3VSLyZvtHC5G_Hx6oHr_jR43+vYz46nXLkifuD3gXGLd21yQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

We are trying to pin down a file corruption issue we have on 5
productionservers and would like some suggestions about how to proceed
to find the culprit. It may or may not be ext4-related, but as that is
the only clue we have so far, we're trying here first.

The productionservers are running Slackware 13.37 with a selfcompiled
kernel (no patches or external modules).
We have a script running daily that copies files from one folder to
another using cp. On occasion (once or twice a week) the
destinationfile will not match the original file. The first bytes of
the files will be ok, but the rest of the file will be filled with
nullbytes (the file size matches, though). We had to create a loop in
the script that uses cmp to check if the cp failed and retry if it
did. After 20-25 attempts (sleep 1 between the cps), the cp normally
succeeds.

If we copy the files from ext3 to ext3, the problem goes away. If we
copy it from ext3 to ext4 or from ext4 to ext4, the files will
sometimes be corrupt.

The servers are not being rebooted and the filesystems are not being
remounted, so it's probably not linked to the recent ext4 corruption.

The kernel is x86_64, but the OS is 32-bit. The filesystems reside on
an aacraid controller (hw RAID-5) with batterybackup and an SSD cache
(we tried to remove the SSD, but it still failed). ext4 is mounted
with noatime,data=writeback. There are no kernel errormessages and
there does not appear to be any hardwareissues.

We have verified the corruption on 3.2.9 and 3.5.3. 2.6.35.6 seems to
not be affected.

Since these are productionservers (we haven't been able to reproduce
it inhouse), there is only so much testing we can do, but we're
currently trying to figure out what we can do to narrow it down. I am
aware that I'm not neccessary providing much information, but as this
point we're just looking for suggestions about how to proceed to
figure out what may be the issue.

Any help would be much appreciated.


--
Vennlig hilsen,
Roger Niva
