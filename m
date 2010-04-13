From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Q wrt LVM snapshot of ext4 w/ external journal
Date: Tue, 13 Apr 2010 13:22:35 -0500
Message-ID: <4BC4B66B.9000205@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([209.40.204.131]:54012 "EHLO
	titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0DMTIf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 15:08:35 -0400
Received: from [10.0.0.100] (c-98-196-242-36.hsd1.tx.comcast.net [98.196.242.36])
	(authenticated bits=0)
	by titan.nuclearwinter.com (8.14.1/8.14.1) with ESMTP id o3DILZon030712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 13:21:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is it safe to mount an LVM2 snapshot of an ext4 fs that has an external
journal?

My googling has revealed only that the snapshot procedure will cause the
fs to checkpoint the journal (if that's the right term) but also that
the fs will want to replay the journal when mounted, even if -o ro. If
my journal is on an external device (NVRAM device in my case) I don't
want the snapshot instance to interfere with the main on-line fs's use
of the journal.

Is there any documentation, other than code, that describes this scenario?

If there is another, more appropriate, venue for my question please let
me know.

Thank you,

--Larkin
