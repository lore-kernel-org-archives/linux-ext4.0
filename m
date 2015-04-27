From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: [ext4 crypto] feature request "lockable directories"
Date: Mon, 27 Apr 2015 23:57:58 +0200
Message-ID: <553EB0E6.3020607@mutluit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43399 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965593AbbD0WAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2015 18:00:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Ymr4O-0000Dj-9R
	for linux-ext4@vger.kernel.org; Tue, 28 Apr 2015 00:00:04 +0200
Received: from ip4d1523f6.dynamic.kabel-deutschland.de ([77.21.35.246])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2015 00:00:04 +0200
Received: from for-gmane by ip4d1523f6.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2015 00:00:04 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I think an option to lock (and unlock; like locking a door)
would be a useful feature with encrypted directories.

By this the user could "lock" a sensitive directory
and "unlock" it only when needed.

This could be integrated in an ext4 user tool, or in a new tool, for example
   lockdir -l mydir   # locking
   lockdir -u mydir   # unlocking

A locked directory cannot be accessed.
Both locking and unlocking shall ask for a password for just that directory.
The password could be saved in an internal file within the directory,
and auto-deleted after successful unlocking.

Thx
Uenal

