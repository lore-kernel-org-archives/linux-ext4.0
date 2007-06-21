From: "LIOU Payphone" <lioupayphone@gmail.com>
Subject: ask for help; hash-directory machanism of ext3 cannot work well
Date: Thu, 21 Jun 2007 16:40:55 +0800
Message-ID: <467a39a0.1997600a.2ec2.ffffd4d1@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.229]:22387 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXFUIlI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 04:41:08 -0400
Received: by qb-out-0506.google.com with SMTP id e7so516858qbe
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 01:41:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

firstly, with many thanks! ^-^

my problem :
(1) when i want to format /dev/sda1 to be ext3-filesystem, i  set
"s_def_hash_version" of "struct ext3_super_block" to be "DX_HASH_LEGACY".
when the filesystem was formatted successfully, i mounted it under a
directory named "/mnt". 
(2) subsequently, i created 40000 empty regular-files under "/mnt" named
from "0" to "39999".
(3) then , "ls -li  /mnt" was executed; i saw a puzzling thing : there are
two indentical entries of the directory named "mnt"!  both inode->i_ino and
filename are in the same. 

32203 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24010
32204 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24011
32205 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24012
32206 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24013 
32207 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24014
32208 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24015
32209 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24016
33220 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 25027
3220 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:31 3090
3350 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:31 3220
3350 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:31 3220

(4) when i change "DX_HASH_LEGACY" to be "DX_HASH_TEA", the problem listed
above not happend. 

i scratched my head over it, failed to find any reasonable answers.  :-(
so, i sent my question to u and expecting eagerly some help from you. 

thanks again! :-)
  Payphone LIOU
