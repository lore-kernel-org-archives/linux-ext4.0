From: "kyle" <kylewong@southa.com>
Subject: need help with getting into a corrupted sub directory
Date: Sat, 30 Jan 2010 14:07:50 +0800
Message-ID: <004d01caa172$8d846c10$6401a8c0@kyle>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xylophone.i-cable.com ([203.83.115.99]:58622 "HELO
	xylophone.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751320Ab0A3GOg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 01:14:36 -0500
Received: from kyle (cm203-168-245-60.hkcable.com.hk [203.168.245.60])
	by xenon.i-cable.com (8.13.5/8.13.5) with SMTP id o0U67puZ009701
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jan 2010 14:07:52 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have a ext3 filesystem created inside a problematic seagate ST3500320AS
drive. The drive will just shut itself down automatically whenever it hits
any read error. Only way to wake it up it to cold power off / on the
computer.

Now, my ext3 fs is /dev/sde2

I can mount it without any error:
mount /dev/sde2 /tmp

then, I can 'cd' into /tmp to get a sub directory listing.
let's says there's

Hello
World
users
public

now when I do 'ls public',  I get:
EXT3-fs error (device sde2): ext3_get_inode_loc: unable to read inode
block - inode: 26181633, block=26181634
ls: cannot access /tmp/public: Input/output error

'sde' will disappeared from the system, need power off / on can get it back.

After cold boot, I know there's a subdirectory called "EL" inside "public",
if I do a 'ls public/EL',
I get:
EXT3-fs error (device sde2): ext3_get_inode_loc: unable to read inode
block - inode: 26181633, block=26181634
ls: cannot access /tmp/public/EL: Input/output error

Is there any way I can get into subdirectory of "public" without the need of
read inode block 26181633/26181634 ?
Is it still possible to get a full subdirectory listing of "public" ?

Thanks a lot,
kyle

