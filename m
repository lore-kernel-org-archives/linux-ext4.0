From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Problem found in punch patch series
Date: Tue, 24 May 2011 14:21:36 -0700
Message-ID: <4DDC2160.3060907@linux.vnet.ibm.com>
References: <E1QOx7h-0004Yz-AZ@tytso-glaptop> <4DDC1275.7080902@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:36973 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1EXVVu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2011 17:21:50 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4OL4WQK026100
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 15:04:32 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4OLLfB4174574
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 15:21:41 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4OFLbb5027755
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 09:21:37 -0600
In-Reply-To: <4DDC1275.7080902@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/24/2011 1:17 PM, Allison Henderson wrote:
> On 5/24/2011 12:18 PM, Theodore Ts'o wrote:
>> Hi Allison,
>>
>> I was finally able to track down the source of the regression with a
>> stable repro case, and a git bisect pointed at this commit:
>>
>> b1235954684b05c945ab08defe1547b8ffa1a759 is the first bad commit
>> commit b1235954684b05c945ab08defe1547b8ffa1a759
>> Author: Allison Henderson<achender@linux.vnet.ibm.com>
>> Date: Mon May 16 16:04:13 2011 -0400
>>
>> ext4: add support for "hole punch" out in the truncate routines for
>> extents
>>
>> This patch modifies the truncate routines to support hole punching
>> Below is a brief summary of the patches changes:
>>
>> - Added end param to ext_ext4_rm_leaf
>> This function has been modified to accept an end parameter
>> which enables it to punch holes in leafs instead of just
>> truncating them.
>>
>> - Implemented the "remove head" case in the ext_remove_blocks routine
>> This routine is used by ext_ext4_rm_leaf to remove the tail
>> of an extent during a truncate. The new ext_ext4_rm_leaf
>> routine will now also use it to remove the head of an extent in the
>> case that the hole covers a region of blocks at the beginning
>> of an extent.
>>
>> - Added "end" param to ext4_ext_remove_space routine
>> This function has been modified to accept a stop parameter, which
>> is passed through to ext4_ext_rm_leaf.
>>
>> [ext4 punch hole patch series 3/5 v7]
>>
>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>> Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
>> Reviewed-by: Mingming Cao<cmm@us.ibm.com>
>>
>> (This commit can be found on the dev-save branch of ext4.git).
>>
>> Here's the reproduction information. Use the following[1] as the image
>> for TEST_DEV for xfstests, and run xfstests #213. You will get a
>> message indicating that the file system was corrupted after the test
>> completes.
>>
>> [1]
>> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-testcases/test-4k-213-bug-report.img.bz2
>>
>>
>> In case this is significant, I was running my kernels under KVM, using
>> the following parameters:
>>
>> /usr/local/bin/qemu-system-x86_64 -boot order=c \
>> -drive file=/kbuild/root_fs.img,if=virtio \
>> -drive file=/dev/funarg/test-4k,cache=none,if=virtio \
>> -drive file=/dev/funarg/big-scratch,cache=none,if=virtio \
>> -drive file=/dev/funarg/test-1k,cache=none,if=virtio \
>> -serial telnet::4445,server -smp 2 -m 1024 \
>> --kernel /kbuild/ext4/arch/x86/boot/bzImage \
>> --append "root=fe00 console=ttyS0,115200 console=tty0"&
>> sleep 0.5
>> exec xterm -e script -c "telnet 127.0.0.1 4445" /tmp/kvm-console&
>>
>> The file system corruption is quite distinctive; I will attach it at the
>> end of this message.
>>
>> What to do --- what I am currently thinking about doing is to drop
>> patches 3/5, 4/5, and 5/5 from the punch series, since we're running out
>> of time in this short merge window. I've already tried building a patch
>> series with these patches dropped, and (a) none of the patches needed
>> modification, and (b) this problem disappeared. So it seems pretty
>> clear it's a problem with patch 3/5 in the punch patch series.
>>
>> If we can figure out what is going quickly, we can try to add revised
>> patches back to the merge window. Does that sound fair?
>>
>> - Ted
>>
>> e2fsck 1.41.14 (22-Dec-2010)
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Pass 3: Checking directory connectivity
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>> Block bitmap differences: -(8562--8595) -(8606--8615) -(8620--8839)
>> -(8852--8874) -(8888--8919) -(8929--8959) -(8986--8999) -(9008--9208)
>> -(9236--9246) -(9260--9373) -(33090--33091) -(33218--33223)
>> -(33246--33247) -(33280--33283) -(33300--33303) -(33348--33349)
>> -(33454--33455) -(33516--33517) -(33528--33529) -(33582--33583)
>> -(33615--33621) -(33628--33633) -(33665--33666) -(33670--33671)
>> -(33680--33684) -(33710--33717) -(33752--33759) -(33807--33809)
>> -(33857--33858) -33882 -(33952--33956) -(34034--34035) -34090
>> -(34105--34126) -(34157--34167) -34175 -(34192--34194) -(34207--34209)
>> -(34233--34240) -(34252--34282) -(34302--34303) -(34368--34404)
>> -(34435--34436) -(34462--34495) -(34560--34577) -(34611--34667)
>> -(34696--34730) -(34754--34801) -(34807--34822) -(34842--34898)
>> -(34926--34973) -(34978--35054) -35056 -(35082--35106) -(35124--35191)
>> -(35201--35252) -(35266--35348) -(35359--35397) -(35413--35461)
>> -(35466--35536) -(35560--35589) -(35601--35627) -(35646--35681) -(35711-
> -3!
>> 5754) -(35776--35780) -(35782--35862) -(35866--35918) -(35927--35990)
>> -(36016--36146) -(36149--36232) -(36243--36293) -(36322--36420)
>> -(36443--36532) -(36560--36579) -(36603--36726) -(36731--36836)
>> -(36853--36987) -(37021--37115) -(37142--37216) -(37269--37301)
>> -(37320--37375) -(37377--37499) -(37505--37579) -(37601--37752)
>> -(37762--37890) -(37895--38027) -(38031--38118) -(38129--38202)
>> -(38264--38287) -(38315--38399) -(38401--38579) -(38581--38714)
>> -(38740--38761) -(38783--38816) -(38822--38975) -(38986--38997)
>> -(39028--39154) -(39173--39243) -(39274--39379) -39393 -(39413--39509)
>> -(39541--39615) -(39622--39729) -(39737--39818) -(39840--39943)
>> -(39974--40083) -(40112--40183) -(40201--40289) -(40316--40383)
>> -(40399--40519) -(40525--40635) -(40640--40671) -(40705--40744)
>> -(40764--40806) -(40812--40982) -(40989--41006) -(41028--41087)
>> -(41096--41332) -(41344--41442) -(41468--41696) -(41717--41848)
>> -(41882--42075) -(42107--42268) -(42298--42661) -(42688--42782)
>> -(42784--429
> 16)!
>> -(42946--43117) -(43147--43391) -(43398--43631) -(43636--4378!
>> 3) -(43815--44031) -(44288--44517) -(44530--44543) -(45492--45765)
>> -(45786--45848) -(45856--45881) -(45899--46095) -(46947--46973)
>> -(46989--47372) -(47380--47407) -(47437--47679) -(47690--48297)
>> -(48318--48400) -(48425--48639) -(65546--65551) -(65578--65579)
>> -(65600--65663) -(65690--65693) -(65727--65741) -65767 -(65789--65841)
>> -(65865--65905) -(65907--65908) -(65951--66007) -(66015--66034)
>> -(66048--66122) -(66136--66144) -(66157--66231) -(66243--66292)
>> -(66323--66393) -(66426--66437) -(66464--66516) -(66532--66576)
>> -(66582--66610) -(66624--66679) -(66684--66706) -(66739--66800)
>> -(66808--66828) -(66832--66897) -(66924--66932) -(66937--66985)
>> -(67015--67108) -(67118--67151) -(67176--67192) -(67209--67337)
>> -(67352--67382) -(67404--67412) -(67414--67521) -(67551--67667)
>> -(67693--67752) -(67776--67901) -(67929--67947) -(67975--67989)
>> -(68017--68055) -(68075--68190) -(68217--68232) -(68252--68268)
>> -(68286--68334) -(68364--68450) -(68470--68600) -(68602--68614)
>> -(68633--68772)
> -(!
>> 68800--68824) -(68831--68838) -(68878--69038) -(69059--69135)
>> -(69161--69238) -(69256--69298) -(69314--69377) -(69398--69477)
>> -(69491--69578) -(69610--69750) -(69779--69908) -(69937--70038)
>> -(70044--70084) -(70115--70198) -(70217--70468) -(70494--70869)
>> -(70899--71024) -(98625--163839) -(196608--229375) -(230988--231167)
>> -(231424--294911) -(295233--360437) -(360439--524277) -534050 -534078
>> -534167 -534180 -(534182--534184) -(534191--557055) -590943 -591071
>> -597695 -597737 -597781 -(597943--597944) -597988 -598123 -598215
>> -598240 -598368 -598489 -598647 -598686 -598783 -598838 -598955
>> -598960 -599103 -(599163--599164) -599315 -599367 -599440
>> -(599479--599480) -599529 -(599576--599578) -599711 -599808
>> -(599823--599826) -599839 -(599900--599903) -(599969--599972)
>> -(600041--600043) -600123 -(600260--600262) -(600480--600481)
>> -(600492--600494) -(600523--600525) -(600548--600551)
>> -(600569--600571) -(600607--600609) -(600690--600693) -600750 -600991
>> -601178 -(601251--601252) -6
> 013!
>> 27 -(601425--601427) -601482 -(601517--601519) -601600 -(601625--601626!
>> ) -(601726--601728) -(601738--601741) -(601756--601767)
>> -(601780--601783) -(601842--601853) -(601868--601886)
>> -(601912--601932) -(601986--601990) -(602122--602124)
>> -(602147--602151) -602335 -(602428--602431) -(602479--602485)
>> -(602715--753653) -(753655--819199) -(819521--884735)
>> -(885057--983029) -(983040--1048575) -(1048584--1048591)
>> -(1048600--1048607) -(1081344--1146869) -(1146871--1310709)
>> Fix? yes
>>
>> Free blocks count wrong for group #0 (23379, counted=24069).
>> Fix? yes
>>
>> Free blocks count wrong for group #1 (18867, counted=29461).
>> Fix? yes
>>
>> Free blocks count wrong for group #2 (27266, counted=31479).
>> Fix? yes
>>
>> Free blocks count wrong for group #3 (0, counted=32447).
>> Fix? yes
>>
>> Free blocks count wrong for group #4 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #6 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #7 (1547, counted=32447).
>> Fix? yes
>>
>> Free blocks count wrong for group #8 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #9 (0, counted=32447).
>> Fix? yes
>>
>> Free blocks count wrong for group #10 (1, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #11 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #12 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #13 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #14 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #15 (10, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #16 (0, counted=22872).
>> Fix? yes
>>
>> Free blocks count wrong for group #18 (0, counted=20068).
>> Fix? yes
>>
>> Free blocks count wrong for group #19 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #20 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #21 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #22 (1, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #23 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #24 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #25 (0, counted=32447).
>> Fix? yes
>>
>> Free blocks count wrong for group #26 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #27 (0, counted=32447).
>> Fix? yes
>>
>> Free blocks count wrong for group #28 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #29 (10, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #30 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #31 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #32 (28640, counted=28656).
>> Fix? yes
>>
>> Free blocks count wrong for group #33 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #34 (1, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #35 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #36 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #37 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #38 (0, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong for group #39 (10, counted=32768).
>> Fix? yes
>>
>> Free blocks count wrong (132179, counted=1236023).
>> Fix? yes
>>
>>
>> /dev/funarg/test-4k: ***** FILE SYSTEM WAS MODIFIED *****
>> /dev/funarg/test-4k: 5541/327680 files (2.9% non-contiguous),
>> 74697/1310720 blocks
>
> Hi Ted,
>
> I have recreated the problem and am checking into it now. Thx!
>
> Allison Henderson
>

Hi again,

I believe I have narrowed down the problem to a loop optimization that 
we added in 3/5v7.  Substituting 3/5v6 for 3/5v7 appears to correct the 
problem.  Should I make a new v8 then for the whole set, or would it be 
easier for you to just pick up the 3/5v6?  I was also able to reverse 
apply 3/5v7 and reapply 3/5v6 with out problems.  Let me know what is 
easiest for you.  Thx!

Allison Henderson


> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

