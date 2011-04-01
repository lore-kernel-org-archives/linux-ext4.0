From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Fri, 1 Apr 2011 15:09:06 GMT
Message-ID: <201104011509.p31F96vv020503@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56836 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab1DAPJH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 11:09:07 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p31F96ml020504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Apr 2011 15:09:06 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #53 from Theodore Tso <tytso@mit.edu>  2011-04-01 15:09:03 ---
Folks who are experiencing this problem might want to try 2.6.38.2.   There was
a fix that was committed to mainline and backported to the stable kernels that
may fix this problem:

commit 95f28604a65b1c40b6c6cd95e58439cd7ded3add
Author: Jens Axboe <jaxboe@fusionio.com>
Date:   Thu Mar 17 11:13:12 2011 +0100

    fs: assign sb->s_bdi to default_backing_dev_info if the bdi is going away

    We don't have proper reference counting for this yet, so we run into
    cases where the device is pulled and we OOPS on flushing the fs data.
    This happens even though the dirty inodes have already been
    migrated to the default_backing_dev_info.

    Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
    Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
    Cc: stable@kernel.org
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

Sorry for not responding to this bug sooner, but I've been crazy busy in the
last couple of weeks; troubleshooting and discussion was taking place on LKML,
and I was pretty sure this wasn't an ext4 specific issue.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
