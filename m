From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] ext4 without journal reproductible file corruption
Date: Wed, 13 May 2009 23:10:15 GMT
Message-ID: <200905132310.n4DNAFjk025025@demeter.kernel.org>
References: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58533 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZEMXKO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 19:10:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4DNAFRe025026
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 23:10:15 GMT
In-Reply-To: <bug-13292-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13292


Frank Mayhar <fmayhar@google.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |fmayhar@google.com




--- Comment #1 from Frank Mayhar <fmayhar@google.com>  2009-05-13 23:10:14 ---
I would be interested to know what your actual output looks like.  I've tried
to reproduce this and don't seem to be able to, at least not in my environment.

My attempts looked like:
[/root]# mount -t ext4 -o loop
/foo/archlinux_64_minimal_ext4_without_journal.img /mnt
[/root]# chroot /mnt
bash-3.2# locale-gen
Generating locales...
  fr_FR.UTF-8... done
  fr_FR.ISO-8859-1... done
  fr_FR.ISO-8859-15@euro... done
Generation complete.
bash-3.2# locale
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory
LANG=en_US
LC_CTYPE="en_US"
LC_NUMERIC="en_US"
LC_TIME="en_US"
LC_COLLATE="en_US"
LC_MONETARY="en_US"
LC_MESSAGES="en_US"
LC_PAPER="en_US"
LC_NAME="en_US"
LC_ADDRESS="en_US"
LC_TELEPHONE="en_US"
LC_MEASUREMENT="en_US"
LC_IDENTIFICATION="en_US"
LC_ALL=
bash-3.2# LANG=fr_FR
bash-3.2# locale
LANG=fr_FR
LC_CTYPE="fr_FR"
LC_NUMERIC="fr_FR"
LC_TIME="fr_FR"
LC_COLLATE="fr_FR"
LC_MONETARY="fr_FR"
LC_MESSAGES="fr_FR"
LC_PAPER="fr_FR"
LC_NAME="fr_FR"
LC_ADDRESS="fr_FR"
LC_TELEPHONE="fr_FR"
LC_MEASUREMENT="fr_FR"
LC_IDENTIFICATION="fr_FR"
LC_ALL=
bash-3.2# exit
[/root]# umount /mnt
[/root]# mount -t ext4 -o loop
/foo/archlinux_64_minimal_ext4_without_journal.img /mnt
[/root]# chroot /mnt
bash-3.2# locale
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory
LANG=en_US
LC_CTYPE="en_US"
LC_NUMERIC="en_US"
LC_TIME="en_US"
LC_COLLATE="en_US"
LC_MONETARY="en_US"
LC_MESSAGES="en_US"
LC_PAPER="en_US"
LC_NAME="en_US"
LC_ADDRESS="en_US"
LC_TELEPHONE="en_US"
LC_MEASUREMENT="en_US"
LC_IDENTIFICATION="en_US"
LC_ALL=
bash-3.2# LANG=fr_FR
bash-3.2# locale
LANG=fr_FR
LC_CTYPE="fr_FR"
LC_NUMERIC="fr_FR"
LC_TIME="fr_FR"
LC_COLLATE="fr_FR"
LC_MONETARY="fr_FR"
LC_MESSAGES="fr_FR"
LC_PAPER="fr_FR"
LC_NAME="fr_FR"
LC_ADDRESS="fr_FR"
LC_TELEPHONE="fr_FR"
LC_MEASUREMENT="fr_FR"
LC_IDENTIFICATION="fr_FR"
LC_ALL=
bash-3.2#

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
