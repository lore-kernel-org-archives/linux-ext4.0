From: Ravi Pinjala <ravi@p-static.net>
Subject: e4defrag doesn't work on root filesystem
Date: Mon, 07 Sep 2009 10:48:01 -0500
Message-ID: <4AA52B31.5090205@p-static.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from irongate.mail.utexas.edu ([146.6.25.6]:7429 "EHLO
	irongate.mail.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbZIGQAq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 12:00:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm playing with e4defrag from e2frprogs git, and I've run into a bug.
When I try to defragment files on my root filesystem, it refuses to
acknowledge that the filesystem is ext4. I believe the problem is that
it checks the filesystem type by parsing /etc/mtab, but the root
filesystem shows up there like this:

rootfs on / type rootfs (rw)
/dev/root on / type ext4 (rw,noatime,barrier=1,data=ordered)

so it gets confused by the bogus first entry. It works just fine on
other ext4 filesystems I have.

(If this is the wrong mailing list, I apologize; I couldn't find one for
e2fsprogs, so I thought this was the next best thing.)

--Ravi
