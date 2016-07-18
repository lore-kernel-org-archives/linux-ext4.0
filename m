From: Johannes Stezenbach <js@sig21.net>
Subject: 4.7.0-rc7 ext4 error in dx_probe
Date: Mon, 18 Jul 2016 12:57:07 +0200
Message-ID: <20160718105707.GA4253@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I'm running 4.7.0-rc7 with ext4 on lvm on dm-crypt on SSD
and out of the blue on idle machine the following error
message appeared:

[373851.683131] EXT4-fs (dm-3): error count since last fsck: 1
[373851.683151] EXT4-fs (dm-3): initial error at time 1468438194: dx_probe:740: inode 22288562
[373851.683158] EXT4-fs (dm-3): last error at time 1468438194: dx_probe:740: inode 22288562

inode 22288562 is a directory with ~800 small files in it,
but AFAICT nothing was accessing it, no cron job running etc.
No further error message was logged.  Accessing the directory
and the files in it also gives no further errors.

Searching back in the log at date -d @1468438194 I found:

Jul 13 21:29:54 foo kernel: EXT4-fs error (device dm-3): dx_probe:740: inode #22288562: comm git: Directory index failed checksum


Time to run fsck?  Is it the consequence of a previous crash
(I had many recently)?


Johannes
