From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Wed, 24 Nov 2010 18:41:33 GMT
Message-ID: <201011241841.oAOIfXjL025584@demeter2.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48797 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0KXSle (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Nov 2010 13:41:34 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAOIfXg5025585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Nov 2010 18:41:33 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902





--- Comment #18 from Justin Maggard <jmaggard10@gmail.com>  2010-11-24 18:41:31 ---
Created an attachment (id=38102)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=38102)
tune2fs -l output

Yep, the trace covers the entire test, starting at mount.

The writes are done in series, buffered IO, same subdir, without a sync. 
Here's all I'm doing:

for i in $(seq 1 10); do
  dd if=/dev/zero of=$testdir/test.$i bs=1M count=128
done

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
