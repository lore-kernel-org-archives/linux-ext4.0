From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 11:14:59 -0600
Message-ID: <50AA6913.2090104@redhat.com>
References: <CAPAnFc9axLdcQ0xsGKsqQ5jMVs13JjYv7JdJkc_Q6Kdwa56JiQ@mail.gmail.com> <20121119083245.18044.qmail@science.horizon.com> <CAPAnFc_BdHCOB0iPwPdfPt_aiJ1PLNgnCAGaZwmOEX32j5LM7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab2KSRoV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 12:44:21 -0500
In-Reply-To: <CAPAnFc_BdHCOB0iPwPdfPt_aiJ1PLNgnCAGaZwmOEX32j5LM7Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/19/12 10:57 AM, Drew Reusser wrote:
> On Mon, Nov 19, 2012 at 8:32 AM, George Spelvin <linux@horizon.com> wrote:

...


>> Another thing that would be useful is "dd if=/dev/md0 skip=2 count=2 | xxd"
>> (or od -x if you don't have xxd).  That will give a hex dump of the
>> primary superblock, which might show the extent of the damage.
>>
>>
> 
> 
> mint mnt # dd if=/dev/md0 skip=2 count=2 | xxd
> 0000000: 3a3a 6b4e fd9b a66c 6467 f7a6 9fb0 9183  ::kN...ldg......
> 2+0 records in
> 2+0 records out

I'd actually start looking at block 0 too.  Can you do that again,
and drop the "skip?"

as an aside - any chance there was supposed to be an encryption
layer in there somewhere?  The below looks pretty random.

-Eric

> 0000010: 3fc6 11aa 0cec 0441 6bc8 6b55 ff4d f2ba  ?......Ak.kU.M..
> 0000020: a475 15d9 ea5d 6833 5608 df95 60cd 4f76  .u...]h3V...`.Ov
> 0000030: 5490 5c22 e564 c91b 1913 a519 807a 8986  T.\".d.......z..
> 0000040: f3ba 3c8a 6c11 f78a bc94 5947 b55d d83f  ..<.l.....YG.].?
> 0000050: 2eac 0f3c ab20 d88d 1820 d5bc 0f97 aaf6  ...<. ... ......
> 0000060: 81f5 63cc 6eff 8e2e 54ad 50fe 291f 17f8  ..c.n...T.P.)...
> 0000070: be01 67ad b9ec 49f7 fa60 953b 7348 9730  ..g...I..`.;sH.0
> 0000080: 6105 8f4d da9c 3ef3 e90e c190 6471 a766  a..M..>.....dq.f
> 0000090: c90a 77f6 1196 3b74 9121 e89c 19bd 29f4  ..w...;t.!....).
> 00000a0: 808c 3342 16e7 0c80 e8c3 3a6a 5560 78eb  ..3B......:jU`x.
> 00000b0: c0d9 c6d5 b386 a3a9 5275 7f5a f572 218b  ........Ru.Z.r!.
> 00000c0: 63d5 28f8 71aa 4f6f e716 060a 4a50 70cb  c.(.q.Oo....JPp.
> 00000d0: a740 8c5f e2df 2e65 11cd a88f c4ed c9bb  .@._...e........
> 00000e0: d444 2da5 7e5d 7bb4 38f6 5fd0 60a8 d2cf  .D-.~]{.8._.`...
> 00000f0: 813f 9afd 26b8 8cc0 6e6a 59a2 e1f6 32ce  .?..&...njY...2.
> 0000100: 8c01 5928 5661 9687 fb9c b07d b412 4a57  ..Y(Va.....}..JW
> 0000110: 2626 7099 c350 a893 3f76 1953 c34b 7ddf  &&p..P..?v.S.K}.
> 0000120: d73d 5e7f 9d3c f4fe dac9 e2d7 8eaf da94  .=^..<..........
> 0000130: 86fb cbfe 7866 45fa 72c9 a687 ea83 3b71  ....xfE.r.....;q
> 0000140: 80cc 3320 59c3 c653 977d b6e3 79c4 5c3b  ..3 Y..S.}..y.\;
> 0000150: b36b c978 6824 d4b9 9252 04dd 39de 4c05  .k.xh$...R..9.L.
> 0000160: d331 951b 3dff 8974 4ac1 1950 f6bd 5586  .1..=..tJ..P..U.
> 0000170: 1095 f62c e7b3 d9d6 fbee 8cfb 5bd0 959e  ...,........[...
> 0000180: f6ae f551 1b41 a8cf ae40 435a ff05 c38e  ...Q.A...@CZ....
> 0000190: 903d 2258 689e b64c f49d b7b3 593d f55c  .="Xh..L....Y=.\
> 00001a0: fd4f f395 4ecd 6653 e46d 66b6 a046 a9cb  .O..N.fS.mf..F..
> 00001b0: ee90 58d8 e876 5f63 5014 cbfe b0e1 cd53  ..X..v_cP......S
> 00001c0: 12ac 43c5 2996 4a15 014e 3c7d a5c2 5842  ..C.).J..N<}..XB
> 00001d0: 2e00 f2ea 3e12 fbe6 1403 e240 0e01 80d0  ....>......@....
> 00001e0: 1a03 c0c0 37fb 3cae df51 1818 987f e03b  ....7.<..Q.....;
> 00001f0: 718f b339 63e7 8495 56b4 045a 0091 7382  q..9c...V..Z..s.
> 0000200: 9828 187e 5eab e288 a4c6 fd95 3950 f868  .(.~^.......9P.h
> 0000210: 3ee5 5fe0 4943 8e1d 2315 41a7 0989 c97c  >._.IC..#.A....|
> 0000220: 992a c47b 9ccd e08a cfea 4603 2f51 e5e3  .*.{......F./Q..
> 0000230: 04c3 3224 bfaa f0fa 79ae 13db d774 8c87  ..2$....y....t..
> 0000240: fad8 93b1 ddc6 ce8c 90f3 e754 c6a4 ece3  ...........T....
> 0000250: 13ab 59e8 b5cc f5d1 c9ab 297f ba63 84a7  ..Y.......)..c..
> 0000260: c8ed bff6 9e55 a191 cfef c79e 6cd0 8ccd  .....U......l...
> 0000270: 83b1 de5a 3c26 1f81 e1fa b2ed 503a 2445  ...Z<&......P:$E
> 0000280: 7212 2b2e 1242 18fb cac7 c3e5 73de fb2a  r.+..B......s..*
> 0000290: c0ed 2318 01ba 1f04 22f1 fb3d f356 c0a0  ..#....."..=.V..
> 00002a0: 258f 0184 6653 7814 e3ff b4ab 3276 7b9d  %...fSx.....2v{.
> 00002b0: 6c68 0b00 8024 68f0 47e6 2aad e447 674b  lh...$h.G.*..GgK
> 00002c0: 1a0c 0f85 e11d 5275 6d58 9940 e738 a3a8  ......RumX.@.8..
> 00002d0: 490f cdbc e710 9099 9dbd a688 00d8 a530  I..............0
> 00002e0: 843c 6665 a912 abdb 6c95 9e96 70dc f409  .<fe....l...p...
> 00002f0: f27a 3c12 15b0 c168 29a7 c190 f9ac 90c0  .z<....h).......
> 0000300: cd58 20ff 0461 ddcf 6617 9764 c352 a0de  .X ..a..f..d.R..
> 0000310: 3818 e5e0 a168 49aa 8b98 2e6d 92f9 b575  8....hI....m...u
> 0000320: d7dd 4651 1c54 c5e9 f96a d0f0 14c0 240a  ..FQ.T...j....$.
> 0000330: 3193 00e1 f895 6aba 0780 37c1 0f3a 3b3e  1.....j...7..:;>
> 0000340: a8bb c25f 8148 0140 1825 7814 0a68 8e5e  ..._.H.@.%x..h.^
> 0000350: 237b db47 9e5f 573c acbd 5d54 a1ae ce9c  #{.G._W<..]T....
> 0000360: b498 c8cd e0dd 4c34 ee8a bf32 b7cf 0cca  ......L4...2....
> 0000370: ba69 e0a7 e9ef 09c6 7c20 5007 7662 9c36  .i......| P.vb.6
> 0000380: f053 fda0 41f6 e560 1f2b ffbc 5344 407c  .S..A..`.+..SD@|
> 0000390: 9801 ee74 a1ef 236f 6b6c 50c0 2acf 8ebf  ...t..#oklP.*...
> 00003a0: f6ec 5049 7633 d215 1b35 af46 44e0 a7db  ..PIv3...5.FD...
> 00003b0: fd01 43ef c03d 2d44 7c21 d12c 75a3 f1f2  ..C..=-D|!.,u...
> 00003c0: a459 e196 ce0f 6de0 19f1 d086 2504 2f09  .Y....m.....%./.
> 00003d0: 6abe 5f04 4277 86c9 6b20 a054 bf82 0b5d  j._.Bw..k .T...]
> 00003e0: 3525 32b4 051a af5e 34af 1b29 0083 4987  5%2....^4..)..I.
> 00003f0: c071 ab38 2567 0dff 54bc 2f8e 130e 33e2  .q.8%g..T./...3.
> 
>
