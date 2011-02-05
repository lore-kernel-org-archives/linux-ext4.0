From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 5 Feb 2011 08:53:06 GMT
Message-ID: <201102050853.p158r6Dh028127@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:51950 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1BEIxH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 03:53:07 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p158r6Jj028128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Feb 2011 08:53:06 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #11 from rocko <rockorequin@hotmail.com>  2011-02-05 08:52:58 ---
I've reproduced the original problem in 2.6.37 suspending/resuming from the
console. The log is quite short and looks cut off:

BUG: unable to handle kernel paging request at ffffffff8291cb60
IP: [<ffffffff8105165d>] task_rq_lock+0x4d/0xa0
PGD 1a05067 PUD 1a09063 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
CPU 1
Modules linked in: nls_utf8 udf ses enclosure usb_storage hidp binfmt_misc
frcomm sco bnep 12cap vboxnetadp vboxnetflt vboxdrv parport_pc ppdev_dm_crypt
btrfs zlib_deflate crc32c libcrc32c snd_hda_codec_idt snd_hda_intel nvidia(P)
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4
snd_seq_oss snd_seq_midi snd_rawmidi iwlagn iwlcore snd_seq_midi_event_

Hopefully I've typed it correctly.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
