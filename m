From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2 01/15] ext4: add a function which extends a group
 without checking parameters
Date: Tue, 8 Nov 2011 09:36:11 +0800
Message-ID: <CAGBYx2ay10nVDsTt=J3TkL06EKbYQEaMmBu+pfjtVtu3aHmQWg@mail.gmail.com>
References: <1314691825-12295-1-git-send-email-xiaoqiangnk@gmail.com>
	<1314691825-12295-2-git-send-email-xiaoqiangnk@gmail.com>
	<CAGBYx2aT6wGc1T+ijycua3+tbJo4_pxE2tt2q4c+yDogqNnLhQ@mail.gmail.com>
	<20111101222435.GF32161@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54561 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1KHBgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 20:36:12 -0500
Received: by vws1 with SMTP id 1so4214429vws.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 17:36:11 -0800 (PST)
In-Reply-To: <20111101222435.GF32161@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 2, 2011 at 6:24 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Oct 30, 2011 at 09:48:43PM +0800, Yongqiang Yang wrote:
>> ping?
>
> I was very tempted to integrate this during this merge window, since
> it only touches the online resize code, and it was pretty easy to tes=
t
> it. =A0And, it would have been nice to have the new online resize
> support released at about the same time as e2fsprogs 1.42, especially
> it's much faster and handles flex_bg correctly.
>
> Unfortunately, I tried testing both with the old and new resize2fs
> binaries, and in both cases after created a stock ext4 filesystem
> using the mke2fs.conf defaults as shipped with e2fsprogs, resized the
> file system, and umounted the file system, the e2fsck reported file
> system corruption.
Sorry for troubles.  I have fixed the problem and post the patches out.

Yongqiang.
>
> I'm guesing you didn't test with the uninit_bg feature? =A0And it loo=
ks
> like something is going wrong with the block bitmap in the last block
> group.
>
> I've put the online-resize patches with some cleanup work and some
> changes so it would patch cleanly and compile into the end of the ext=
4
> patch tree in the ext4 patch queue repository:
>
> =A0 =A0 =A0git://repo.or.cz/ext4-patch-queue.git
>
> On the whole the patch series seemed well written, but it looks like
> it needs just a bit more polishing. =A0Hopefully we can get this fixe=
d
> up after the current merge window closes, and we can put it at the
> beginning of the patches for the next merge window.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> # e2fsck -f /dev/vdc
> e2fsck 1.42-WIP (16-Oct-2011)
> Last group block bitmap uninitialized. =A0Fix<y>? yes
>
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences: =A0+(26206211--26206213) +26206215 +(262062=
19--26206221) +26206223 +(26206227--26206229) +26206231 +(26206235--262=
06237) +26206239 +(26206243--26206245) +26206247 +(26206251--26206253) =
+26206255 +(26206259--26206261) +26206263 +(26206267--26206269) +262062=
71 +(26206275--26206277) +26206279 +(26206283--26206285) +26206287 +(26=
206291--26206293) +26206295 +(26206299--26206301) +26206303 +(26206307-=
-26206309) +26206311 +(26206315--26206317) +26206319 +(26206323--262063=
25) +26206327 +(26206331--26206333) +26206335 +(26206339--26206341) +26=
206343 +(26206347--26206349) +26206351 +(26206355--26206357) +26206359 =
+(26206363--26206365) +26206367 +(26206371--26206373) +26206375 +(26206=
379--26206381) +26206383 +(26206387--26206389) +26206391 +(26206395--26=
206397) +26206399 +(26206403--26206405) +26206407 +(26206411--26206413)=
 +26206415 +(26206419--26206421) +26206423 +(26206427--26206429) +26206=
431 +(26206435--26206437) +26206439 +(26206443--26206445) +26206447 +(2=
6206451--26206453) +26206455 +(26206459--26206461) +26206463 -(26206465=
--26206466) -26206470 -(26206472--26206474) -26206478 -(26206480--26206=
482) -26206486 -(26206488--26206490) -26206494 -(26206496--26206498) -2=
6206502 -(26206504--26206506) -26206510 -(26206512--26206514) -26206518=
 -(26206520--26206522) -26206526 -(26206528--26206530) -26206534 -(2620=
6536--26206538) -26206542 -(26206544--26206546) -26206550 -(26206552--2=
6206554) -26206558 -(26206560--26206562) -26206566 -(26206568--26206570=
) -26206574 -(26206576--26206578) -26206582 -(26206584--26206586) -2620=
6590 -(26206592--26206594) -26206598 -(26206600--26206602) -26206606 -(=
26206608--26206610) -26206614 -(26206616--26206618) -26206622 -(2620662=
4--26206626) -26206630 -(26206632--26206634) -26206638 -(26206640--2620=
6642) -26206646 -(26206648--26206650) -26206654 -26206656 -26206662 -(2=
6206664--26206666) -26206670 -(26206672--26206674) -26206678 -(26206680=
--26206682) -26206686 -(26206688--26206690) -26206694 -(26206696--26206=
698) -26206702 -(26206704--26206706) -26206710 -(26206712--26206714) -2=
6206718 -(26206720--26206722) -26206726 -(26206728--26206730) -26206734=
 -(26206736--26206738) -26206742 -(26206744--26206746) -26206750 -(2620=
6752--26206754) -26206758 -(26206760--26206762) -26206766 -(26206768--2=
6206770) -26206774 -(26206776--26206778) -26206782 -(26206784--26206786=
) -26206790 -(26206792--26206794) -26206798 -(26206800--26206802) -2620=
6806 -(26206808--26206810) -26206814 -(26206816--26206818) -26206822 -(=
26206824--26206826) -26206830 -(26206832--26206834) -26206838 -(2620684=
0--26206842) -26206846 -(26206848--26206850) -26206854 -(26206856--2620=
6858) -26206862 -(26206864--26206866) -26206870 -(26206872--26206874) -=
26206878 -(26206880--26206882) -26206886 -(26206888--26206890) -2620689=
4 -(26206896--26206898) -26206902 -(26206904--26206906) -26206910 -(262=
06912--26206914) -26206918 -(26206920--26206922) -26206926 -(26206928--=
26206930) -26206934 -(26206936--26206938) -26206942 -(26206944--2620694=
6) -26206950 -(26206952--26206954) -26206958 -(26206960--26206962) -262=
06966 -(26206968--26206970) -26206974 -(26206976--26206978) -26206982 -=
(26206984--26206986) -26206990 -(26206992--26206994) -26206998 -(262070=
00--26207002) -26207006 -(26207008--26207010) -26207014 -(26207016--262=
07018) -26207022 -(26207024--26207026) -26207030 -(26207032--26207034) =
-26207038 -(26207040--26207042) -26207046 -(26207048--26207050) -262070=
54 -(26207056--26207058) -26207062 -(26207064--26207066) -26207070 -(26=
207072--26207074) -26207078 -(26207080--26207082) -26207086 -(26207088-=
-26207090) -26207094 -(26207096--26207098) -26207102 -(26207104--262071=
06) -26207110 -(26207112--26207114) -26207118 -(26207120--26207122) -26=
207126 -(26207128--26207130) -26207134 -(26207136--26207138) -26207142 =
-(26207144--26207146) -26207150 ....
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
