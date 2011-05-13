From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Strange (varying) limit on number files in directory ?
Date: Fri, 13 May 2011 13:36:00 +0200
Message-ID: <201105131336.00979.mateusz-lists@ant.gliwice.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from beauty.ant.gliwice.pl ([91.123.210.7]:33952 "EHLO
	beauty.ant.gliwice.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1EMLmQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 07:42:16 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by beauty.ant.gliwice.pl (Postfix) with ESMTP id 3ACF036A50F
	for <linux-ext4@vger.kernel.org>; Fri, 13 May 2011 13:36:02 +0200 (CEST)
Received: from beauty.ant.gliwice.pl ([127.0.0.1])
	by localhost (beauty.ant.gliwice.pl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J5xztwHb8n-x for <linux-ext4@vger.kernel.org>;
	Fri, 13 May 2011 13:36:02 +0200 (CEST)
Received: from laptop-hp.localnet (unknown [192.168.3.131])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by beauty.ant.gliwice.pl (Postfix) with ESMTPSA id F0A2436A50E
	for <linux-ext4@vger.kernel.org>; Fri, 13 May 2011 13:36:01 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi !
I am hitting strange number of files inside directory limitation.
I am able to create only around 120k files.
Number varies [1] as seems I am able to add files with some filenames but with 
other creation fails [2].

Files have structure <small_ind><sha/md5sum> [3].
All on linux box [4],[5], having plenty of frees space [6].
Filesystem fscked  - everything ok.

Any hints ?
Thanks in advance.


[1]:
ls | wc --words
129737
Some deletions and adding again:
ls | wc --words
122227

[2]:
Mar 16 04:55:26 s10 kernel: [772429.729185] EXT4-fs warning (device md7): 
ext4_dx_add_entry:1546: Directory index full!
Mar 16 04:55:26 s10 kernel: [772429.761683] EXT4-fs warning (device md7): 
ext4_dx_add_entry:1546: Directory index full!

[3]:
494_0cf1500e1ecbeecb3282b1e68b2df53b77d06665  
494_40654eec2dd15e4065e49faa2ea226dd25191457  
494_7340a2159a9e256038bbab81f8a86b1a13c034d4  
494_a658dcec5fc6c93af7882b571a67dc6571e2e8d2  
494_d9cca801e9cd966a23a0e05d7ca90d796fb13a63
494_0cf17d9ba63b0fa796850a01c7f551f37fa25acb  
494_406590f1b7ca409f21173c8973d2f606025dd8e4  
494_7340ace8f8a535a02f3a91e42d83fd942252c998  
494_a658fe6cc4aedcbb98c0d99963a76326da5ec192  
494_d9ccce88b83254e541c6f0fc07f0c3c95cdc46eb

[4]:
uname -a
Linux s10 2.6.36-1 #1 SMP Tue Nov 9 09:56:02 CET 2010 x86_64 
Intel(R)_Core(TM)2_Quad__CPU___Q8200__@_2.33GHz PLD Linux

[5]:
tune2fs -l /dev/md7
tune2fs 1.41.11 (14-Mar-2010)
Filesystem volume name:   s10_image_cacher
Last mounted on:          /var/cache/abbon/image_cacher
Filesystem UUID:          963dd2f3-d0f6-41bd-9d80-baac7b78e216
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype 
needs_recovery extent flex_bg sparse_super huge_file uninit_bg dir_nlink 
extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              29298688
Block count:              117190656
Reserved block count:     5859532
Free blocks:              72813652
Free inodes:              23814062
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      256
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         2048
Inode blocks per group:   256
RAID stride:              512
RAID stripe width:        2048
Flex block group size:    16
Filesystem created:       Sat Feb 26 09:19:07 2011
Last mount time:          Fri May 13 12:11:21 2011
Last write time:          Fri May 13 12:11:21 2011
Mount count:              1
Maximum mount count:      26
Last checked:             Fri May 13 12:04:42 2011
Check interval:           15552000 (6 months)
Next check after:         Wed Nov  9 11:04:42 2011
Lifetime writes:          252 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      72905729-3b0b-4bb5-8a3a-6a0d88f5fa37
Journal backup:           inode blocks

[6]:
df /dev/md7
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md7             113491176  39425775  68205869  37% 
df -i /dev/md7
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md7             29298688 5354264 23944424   19% 

-- 
Mateusz Korniak
