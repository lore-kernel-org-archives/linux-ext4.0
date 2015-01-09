From: Dexuan Cui <decui@microsoft.com>
Subject: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 03:44:16 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "stefanha@redhat.com" <stefanha@redhat.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The 'mount' utility allows me to mount 1 file systems multiple times at different
mount points, like "mount /dev/sdb1 /a; mount /dev/sdb1 /b".

I tried to write from /a and /b at the same time and it seems everything is OK
and no data corruption happens.
I tried only  ext4 only.

Can somebody please tell me if this usage is safe?

I'm not familiar with the internals of fs.
googling can't find an affirmative answer, I think.

Thanks,
-- Dexuan

