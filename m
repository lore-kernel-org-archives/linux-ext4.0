From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Sat, 13 May 2017 12:00:16 +0000
Message-ID: <bug-195561-13602-BFX2lJ5gMB@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51772 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751018AbdEMMAS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 May 2017 08:00:18 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 86217288E4
        for <linux-ext4@vger.kernel.org>; Sat, 13 May 2017 12:00:17 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #30 from Mauro Rossi (issor.oruam@gmail.com) ---
Hi,
I've checked with new installation of nougat-x86 from scratch and without
booting, so it is clean as per "installation just finished"
and the free blocks counts seem to be effectively tainted by make_ext4fs.

[1] seem to be Android's make_ext4fs patch for the problem
[2] is a commit where in Android master they move away from make_ext4fs


utente@utente-System-Product-Name:~$ e2fsck -fn /dev/sdb1
e2fsck 1.43.4 (31-Jan-2017)

Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(557056--557060) +(557066--557068) +557070 +557072
+(557074--557075) +(557077--557090) +557092 +(557094--557095) +557097
+(557099--557102) +557104 +557106 +(557108--557109) +(557111--557248)
+(557250--557280) +(557282--557326) +(557328--557358) +(557360--557379) +557381
+(557389--557488) +557490 +(557492--557503) +(557506--557507) +557509 +557511
+557516 +(557521--557536) +(557538--557566) -557664 -(557728--557729) -557731
-557768 -557776 -557780 -557782 -(557794--557796) -557825 -557830
-(557856--557857) -557860 -(557888--557889) -(557897--557901) -(557904--557907)
-(557911--557914) -(557918--557919) -(557922--557923) -557926 -(557929--557935)
-557938 -557940 -557943 -557946 -557948 -557950 -(557954--557957)
-(557959--557960) -(557963--557964) -557966 -(557968--557972) -(557974--557977)
-(557980--557982) -557984 -557987 -557989 -557993 -557995 -(557998--557999)
-(558001--558002) -(558007--558008) -(558010--558011) -558013 -558016 -558022
-(558025--558027) -(558029--558030) -558034 -(558037--558038) -558041
-(558044--558046) -(558048--558051) -(558053--558054) -558056 -558059
-(558061--558062) -558066 -(558069--558070) -558072 -(558074--558075) -558077
-(558083--558086) -(558091--558093) -(558097--558098) -(558100--558101) -558714
-558851 -559073 -559080 -559093 -(559842--559844) -(559858--559860) -559873
+(950272--950276) +(950282--950284) +950286 +950288 +(950290--950291)
+(950293--950306) +950308 +(950310--950311) +950313 +(950315--950318) +950320
+950322 +(950324--950325) +(950327--950464) +(950466--950496) +(950498--950542)
+(950544--950574) +(950576--950595) +950597 +(950605--950704) +950706
+(950708--950719) +(950722--950723) +950725 +950727 +950732 +(950737--950752)
+(950754--950782) -950880 -(950944--950945) -950947 -950984 -950992
-(950994--950998) -(951010--951012) -951041 -951046 -(951072--951073) -951076
-(951104--951105) -(951113--951117) -(951120--951123) -(951127--951130)
-(951134--951135) -(951138--951139) -951142 -(951145--951151) -951154 -951156
-951159 -951162 -951164 -951166 -(951170--951173) -(951175--951176)
-(951179--951180) -951182 -(951184--951188) -(951190--951193) -(951196--951198)
-951200 -951203 -951205 -951209 -951211 -(951214--951215) -(951217--951218)
-(951223--951224) -(951226--951227) -951229 -951232 -951238 -(951241--951243)
-(951245--951246) -951250 -(951253--951254) -951257 -(951260--951262)
-(951264--951267) -(951269--951270) -951272 -951275 -(951277--951278) -951282
-(951285--951286) -951288 -(951290--951291) -951293 -(951299--951302)
-(951307--951309) -(951313--951314) -(951316--951317) -951930 -952067 -952289
-952296 -952309 -(953058--953060) -(953074--953076) -953089
Fix? no

Free blocks count wrong for group #17 (32257, counted=32586).
Fix? no

Free blocks count wrong for group #29 (32257, counted=32583).
Fix? no

Free blocks count wrong (4763034, counted=4376260).
Fix? no

Free inodes count wrong (1221589, counted=1215139).
Fix? no


Android-x86: ********** WARNING: Filesystem still has errors **********

Android-x86: 11/1221600 files (254.5% non-contiguous), 120718/4883752 blocks



References:

[1]
https://android.googlesource.com/platform/system/extras/+/c71eaf37486bed9163ad528f51de29dd56b34fd2

[2]
https://android.googlesource.com/platform/system/extras/+/3f6ea671d55b0f8ba9bab8826c817327d67ee9bb

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
