From: "George Spelvin" <linux@horizon.com>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: 8 Aug 2012 18:34:27 -0400
Message-ID: <20120808223427.26158.qmail@science.horizon.com>
References: <20120806232512.GE30677@thunk.org>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:65180 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757205Ab2HHWea (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Aug 2012 18:34:30 -0400
In-Reply-To: <20120806232512.GE30677@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yay!  It happened again!

[397113.459309] EXT4-fs error (device md0): ext4_iget:3821: inode #100691970: comm updatedb.mlocat: checksum invalid
[397113.459315] Aborting journal on device md0-8.
[397113.496222] EXT4-fs (md0): Remounting filesystem read-only

However, trying to preserve the evidence runs into a problem:

/root# e2image -Q /dev/md0 md0.qcow2
e2image 1.43-WIP (1-Aug-2012)
e2image: Inode checksum does not match inode while getting next inode
/root# ls -l md0.qcow2
-rw------- 1 root root 0 Aug  8 18:30 md0.qcow2

e2image aborts on the checksum error, preventing me from capturing a useful
image.

Can someone find a workaround QUICKLY?  I can't keep this FS read-only
for long.

Thanks!
