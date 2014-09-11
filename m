From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] mount doesn't clear usrjquota / grpjqouta options
Date: Thu, 11 Sep 2014 13:10:39 +0000
Message-ID: <bug-84201-13602-famhFotI0Y@https.bugzilla.kernel.org/>
References: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48955 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbaIKNKt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 09:10:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CA99F20263
	for <linux-ext4@vger.kernel.org>; Thu, 11 Sep 2014 13:10:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6D882201F7
	for <linux-ext4@vger.kernel.org>; Thu, 11 Sep 2014 13:10:39 +0000 (UTC)
In-Reply-To: <bug-84201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

--- Comment #4 from Robin <robinedgar@gmail.com> ---
Thanks, that's worked partially.

a space between the following the = and , worked to clear the usrjquota:
# mount -o remount,usrjquota= ,grpjquota= /

but doesn't clear the grpjquota.
I tried:

# mount  -o remount,grpjquota= ,usrjquota= /
mount: you must specify the filesystem type

# mount -t ext4 -o remount,grpjquota= ,usrjquota= /
# mount -t ext4 -o remount,grpjquota=,usrjquota=
/dev/disk/by-uuid/2ceaad1e-7ca8-42f9-b657-ce689beba638 /
# mount  -o remount,grpjquota= /
# mount  -o remount,grpjquota=" " /
# mount  -o remount,grpjquota=" ",usrjquota=" " /
# mount  -o remount,grpjquota="",usrjquota="" /
all lead to
mount: / not mounted or bad option

# mount -o remount,usrjquota= ,grpjquota=" " /
(no error, but doesn't clear)

so it's cleared the usrjquota, but not the grpjquota

/dev/disk/by-uuid/2ceaad1e-7ca8-42f9-b657-ce689beba638 on / type ext4
(rw,relatime,errors=remount-ro,user_xattr,barrier=1,data=ordered,jqfmt=vfsv1,grpjquota=aquota.user)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
