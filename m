From: Eric Sandeen <sandeen@redhat.com>
Subject: more resize breakage
Date: Thu, 29 May 2014 00:22:37 -0500
Message-ID: <5386C41D.2090006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbaE2FWf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2014 01:22:35 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4T5MZnp018568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 01:22:35 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s4T5MYbd007497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 01:22:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After considering how many resize2fs corruptions we've had, I decided to try to write a resize fuzzer which picks random parameters and sizes, and sees what happens with online & offline grow & offline shrink.  When I get it cleaner, I'll send it out to play with.

But it is indeed finding resize issues; for example, with e2fsprogs git master & v3.15-rc3,

# truncate --size=11g fsfile
# mke2fs -t ext4 -O 64bit,^bigalloc,extent,^flex_bg,^meta_bg,resize_inode,sparse_super,^uninit_bg, -E packed_meta_blocks=0 -b 1024 -I 512 -g 3648 fsfile
mke2fs 1.43-WIP (18-May-2014)
Discarding device blocks: done                            
Creating filesystem with 11534336 1k blocks and 708288 inodes
Filesystem UUID: 25a71d26-0a54-4732-bcb5-d08bdb0878ab
Superblock backups stored on blocks: 
	3649, 10945, 18241, 25537, 32833, 91201, 98497, 178753, 295489, 456001, 
	886465, 1251265, 2280001, 2659393, 7978177, 8758849, 11400001

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

# truncate --size=35g fsfile
# mount -o loop fsfile mnt/
# resize2fs /dev/loop0
resize2fs 1.43-WIP (18-May-2014)
Filesystem at /dev/loop0 is mounted on /mnt/test2/resizefuzzer/mnt; on-line resizing required
old_desc_blocks = 198, new_desc_blocks = 629
The filesystem on /dev/loop0 is now 36700160 blocks long.

# umount mnt
# e2fsck -fn fsfile 
e2fsck 1.43-WIP (18-May-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +54721 +(54723--54732) +54734 +54736 +54741 +(54743--54745) +(54747--54752) +(54755--54764) +54766 +54768 +54773 +(54775--54777) +(54779--54786) +(54788--54796) +54798 +54800 +54805 +(54807--54809) +(54811--54816) +54818 +(54821--54822) +54826 +(54829--54834) -(54838--54840) -54867 -55234 -55239 -(55242--55245) -55247 -(55249--55252) -55254 -55258 -(55265--55266) -55271 -(55274--55277) -55279 -(55281--55284) -55286 -55290 -55299 -55303 -(55306--55309) -55311 -(55313--55316) -55318 -55322 -55329 -(55331--55332) -(55335--55337) -(55339--55340) -(55350--55352) -55379 -55745 -55752 -(55755--55756) -(55758--55759) -(55761--55764) -55766 -55770 -55778 -55784 -(55787--55788) -(55790--55791) -(55793--55796) -55798 -55802 -(55809--55810) -55816 -(55819--55820) -(55822--55
 823) -(55825--55828) -55830 -55834 -(55842--55844) -(55847--55849) -(55851--55852) -(55862--55864) -55891 -56257 -(56263--56264) -56266 -(56268--56271) -(56273--56276) -56278 -56282 -56290 !
 -(56295--5
6296) -56298 -(56300--56303) -(56305--56308) -56310 -56314 -(56321--56322) -(56327--56328) -56330 -(56332--56335) -(56337--56340) -56342 -56346 -(56354--56356) -(56359--56361) -(56363--56364) -(56374--56376) -56403 -56769 -56777 -56780 -(56784--56788) -56790 -56794 -56802 -56809 -56812 -(56816--56820) -56822 -56826 -(56833--56834) -56841 -56844 -(56848--56852) -56854 -56858 -(56866--56868) -(56871--56873) -(56875--56876) -(56886--56888) -56915 -57281 -57287 -(57289--57291) -57293 -(57296--57300) -57302 -57306 -57314 -57319 -(57321--57323) -57325 -(57328--57332) -57334 -57338 -(57345--57346) -57351 -(57353--57355) -57357 -(57360--57364) -57366 -57370 -(57378--57380) -(57383--57385) -(57387--57388) -(57398--57400) -57427 -57793 -(57800--57801) -57803 -57806 -(57808--57812) -57814 -57818 -578
 26 -(57832--57833) -57835 -57838 -(57840--57844) -57846 -57850 -(57857--57858) -(57864--57865) -57867 -57870 -(57872--57876) -57878 -57882 -(57890--57892) -(57895--57897) -(57899--57900) -(!
 57910--579
12) -57939 -58305 -(58311--58314) -(58317--58318) -(58320--58324) -58326 -58330 -58338 -(58343--58346) -(58349--58350) -(58352--58356) -58358 -58362
Fix? no

Free blocks count wrong for group #15 (3534, counted=3280).
Fix? no

Free blocks count wrong (35511254, counted=35511000).
Fix? no


fsfile: ********** WARNING: Filesystem still has errors **********

fsfile: 11/2253664 files (0.0% non-contiguous), 1188906/36700160 blocks

Sad face.  :(

I haven't looked into these failures, but it seems clear that "we're not there, yet."

Resize seems to be getting so fiendishly complex with all the format options it must cope with.

-Eric
