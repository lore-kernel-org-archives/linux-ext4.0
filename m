From: Olaf Hering <olaf@aepfle.de>
Subject: ext4 errors with full filesystem
Date: Thu, 13 Aug 2015 10:23:07 +0200
Message-ID: <20150813082307.GA32614@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:22250 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbHMI3Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Aug 2015 04:29:25 -0400
Received: from probook.fritz.box ([2001:a62:eb:9301:1ec1:deff:feb9:bb48])
	by smtp.strato.de (RZmta 37.8 AUTH)
	with ESMTPSA id C008dbr7D8N9BpX
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate)
	for <linux-ext4@vger.kernel.org>;
	Thu, 13 Aug 2015 10:23:09 +0200 (CEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I just got the output below in syslog with a full filesystem.
Should I be worried about inconsistent filesystem now, or is that just =
an
overly verbose message about ENOSPC?  This is a 4.1.5 kernel.

Olaf


root@probook:/dist/iso/sles11 # wget -m -np 'http://cdn.novell.com/prot=
/La2AdJJ4-Ok~/SLED-11-SP4-DVD-i586-GM-DVD1.iso'
=2E..
Cannot write to =E2=80=98cdn.novell.com/prot/La2AdJJ4-Ok~/SLED-11-SP4-D=
VD-i586-GM-DVD1.iso=E2=80=99 (No space left on device).
root@probook:/dist/iso/sles11 # Aug 13 10:13:35 probook.fritz.box kerne=
l: EXT4-fs (sda5): Delayed block allocation failed for inode 15695873 a=
t logical offset 1942120 with max blocks 221 with error 28
Aug 13 10:13:49 probook.fritz.box kernel: EXT4-fs (sda5): This should n=
ot happen!! Data will be lost
Aug 13 10:14:06 probook.fritz.box kernel: EXT4-fs (sda5): Total free bl=
ocks count 0
Aug 13 10:14:06 probook.fritz.box kernel: EXT4-fs (sda5): Free/Dirty bl=
ock details
Aug 13 10:14:07 probook.fritz.box kernel: EXT4-fs (sda5): free_blocks=3D=
0
Aug 13 10:14:07 probook.fritz.box kernel: EXT4-fs (sda5): dirty_blocks=3D=
221
Aug 13 10:14:07 probook.fritz.box kernel: EXT4-fs (sda5): Block reserva=
tion details
Aug 13 10:14:08 probook.fritz.box kernel: EXT4-fs (sda5): i_reserved_da=
ta_blocks=3D221

=46ilesystem volume name:   DBG1S82E_dist
Last mounted on:          /dist
=46ilesystem UUID:          62c145ba-e2ba-4592-b355-7bba833fc396
=46ilesystem magic number:  0xEF53
=46ilesystem revision #:    1 (dynamic)
=46ilesystem features:      has_journal ext_attr resize_inode dir_index=
 filetype needs_recovery sparse_super large_file
=46ilesystem flags:         signed_directory_hash=20
Default mount options:    user_xattr acl
=46ilesystem state:         clean
Errors behavior:          Continue
=46ilesystem OS type:       Linux
Inode count:              33554432
Block count:              268433408
Reserved block count:     26843
=46ree blocks:              2038421
=46ree inodes:              32683679
=46irst block:              0
Block size:               2048
=46ragment size:            2048
Reserved GDT blocks:      512
Blocks per group:         16384
=46ragments per group:      16384
Inodes per group:         2048
Inode blocks per group:   256
=46ilesystem created:       Sun Nov 10 14:01:47 2013
Last mount time:          Wed Aug 12 08:49:02 2015
Last write time:          Wed Aug 12 08:49:02 2015
Mount count:              285
Maximum mount count:      -1
Last checked:             Tue Apr 22 09:12:00 2014
Check interval:           0 (<none>)
Lifetime writes:          4960 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
=46irst inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      19e1770c-aa3c-4aba-8108-e9a5c8792e09
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             64M
Journal length:           32768
Journal sequence:         0x0006a56b
Journal start:            10216

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
