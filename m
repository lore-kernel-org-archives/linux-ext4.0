From: Jan Kara <jack@suse.cz>
Subject: Re: fsx-linux loosing mmap() writes under memory pressure
Date: Wed, 4 Mar 2009 16:55:35 +0100
Message-ID: <20090304155535.GA23108@duck.suse.cz>
References: <20090304145109.GA7140@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Cc: user-mode-linux-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:40566 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbZCDPzk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 10:55:40 -0500
Content-Disposition: inline
In-Reply-To: <20090304145109.GA7140@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 04-03-09 15:51:09, Jan Kara wrote:
>   first, I'd like to point out that this has happened under UML so it can
> be just some obscure bug in that architecture but I belive it's worth
> debugging anyway. Now to the problem:
>   This has happened with today Linus's git snapshot. The filesystem is ext3
> with *1KB* blocksize. I booted UML with 64MB of memory and run (these are
> test's from Andrew Morton's torture tests):
>   fsx-linux -l 8000000 /mnt/testfile
>   bash-shared-mapping -t 8 /mnt/bashfile 50000000
> (the second test just makes the UML under memory pressure and stresses the
> filesystem, otherwise it does not interact with fsx-linux in any way).
>   After some time (like an hour) fsx-linux reported the file is corrupted. I
> tried again and it happened again so probably some debugging should be
> possible.
>   Both times it seems we've simply completely lost a write which happened
> through mmap (2 pages in the first case, 3 pages in the second case). Also
> I've checked and in the first case no blocks are allocated for the offsets
> where the data should be so most probably we've lost the write before
> block_write_full_page() called get_block().
>   I'll debug this further but I wanted let people know there's some problem
> and maybe somebody has some bright idea :).  I'm attaching the log from fsx
> if someone is interested. 
  Testing a bit more, I managed to reproduce the problem on ext2 and what's
more strange, now the lost page was written via ordinary write() (fsxlog
attached). So I believe this is more likely to be UML specific...

									Honza

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="testfile.fsxlog"

skipping zero size read
skipping zero size read
truncating to largest ever: 0x3b4510
truncating to largest ever: 0x659fa4
truncating to largest ever: 0x7052a4
truncating to largest ever: 0x773400
truncating to largest ever: 0x7786fc
truncating to largest ever: 0x782e54
truncating to largest ever: 0x788c5d
truncating to largest ever: 0x79b141
truncating to largest ever: 0x79ccc6
truncating to largest ever: 0x7a0e30
truncating to largest ever: 0x7a0f65
truncating to largest ever: 0x7a1024
truncating to largest ever: 0x7a109b
truncating to largest ever: 0x7a119a
READ BAD DATA: offset = 0x63cd2, size = 0x3236, fname = /mnt/testfile
OFFSET	GOOD	BAD	RANGE
0x65088	0x628e	0x0000	0x    0
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65089	0x8e62	0x0000	0x    1
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x6508a	0x6239	0x0000	0x    2
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x6508b	0x3962	0x0000	0x    3
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x6508c	0x6228	0x0000	0x    4
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x6508d	0x2862	0x0000	0x    5
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x6508e	0x62b1	0x0000	0x    6
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x6508f	0xb162	0x0000	0x    7
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65090	0x62d9	0x0000	0x    8
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65091	0xd962	0x0000	0x    9
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65092	0x62e9	0x0000	0x    a
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65093	0xe962	0x0000	0x    b
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65094	0x62d8	0x0000	0x    c
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65095	0xd862	0x0000	0x    d
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65096	0x621c	0x0000	0x    e
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x65097	0x1c62	0x0000	0x    f
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
LOG DUMP (198700 total operations):
198701(45 mod 256): MAPREAD	0x2d650 thru 0x39f7e	(0xc92f bytes)
198702(46 mod 256): MAPWRITE 0x5f0598 thru 0x5f9cc2	(0x972b bytes)
198703(47 mod 256): WRITE	0x33ac85 thru 0x3441df	(0x955b bytes)
198704(48 mod 256): WRITE	0x38eaef thru 0x391dd7	(0x32e9 bytes)
198705(49 mod 256): WRITE	0x4d0669 thru 0x4d7bc8	(0x7560 bytes)
198706(50 mod 256): MAPWRITE 0x15d1f1 thru 0x16cc9b	(0xfaab bytes)
198707(51 mod 256): READ	0x76d1c thru 0x79699	(0x297e bytes)
198708(52 mod 256): MAPWRITE 0x439726 thru 0x43be4f	(0x272a bytes)
198709(53 mod 256): READ	0x543170 thru 0x5521c7	(0xf058 bytes)
198710(54 mod 256): WRITE	0x4890be thru 0x4928ef	(0x9832 bytes)
198711(55 mod 256): READ	0x90349 thru 0x9e234	(0xdeec bytes)
198712(56 mod 256): MAPREAD	0x3207d9 thru 0x32b61c	(0xae44 bytes)
198713(57 mod 256): WRITE	0x32e281 thru 0x331f66	(0x3ce6 bytes)
198714(58 mod 256): MAPWRITE 0x257a4f thru 0x258abd	(0x106f bytes)
198715(59 mod 256): TRUNCATE DOWN	from 0x5f9cc3 to 0x5acd2e
198716(60 mod 256): WRITE	0x512e0 thru 0x57bf3	(0x6914 bytes)
198717(61 mod 256): MAPWRITE 0x54a7ef thru 0x54f8a1	(0x50b3 bytes)
198718(62 mod 256): READ	0x464f17 thru 0x46fbf0	(0xacda bytes)
198719(63 mod 256): READ	0xa65eb thru 0xb4536	(0xdf4c bytes)
198720(64 mod 256): MAPWRITE 0x6e4528 thru 0x6f09a5	(0xc47e bytes)
198721(65 mod 256): MAPREAD	0x32a4dc thru 0x3344e6	(0xa00b bytes)
198722(66 mod 256): MAPREAD	0x218e47 thru 0x21d010	(0x41ca bytes)
198723(67 mod 256): READ	0x34943 thru 0x3a816	(0x5ed4 bytes)
198724(68 mod 256): TRUNCATE DOWN	from 0x6f09a6 to 0xf2de3
198725(69 mod 256): WRITE	0x41b7fa thru 0x429c95	(0xe49c bytes) HOLE
198726(70 mod 256): MAPREAD	0x25018c thru 0x252cc6	(0x2b3b bytes)
198727(71 mod 256): MAPWRITE 0x3d3ecd thru 0x3dec5c	(0xad90 bytes)
198728(72 mod 256): WRITE	0x187533 thru 0x1973e2	(0xfeb0 bytes)
198729(73 mod 256): MAPWRITE 0x4f1c75 thru 0x4fdc07	(0xbf93 bytes)
198730(74 mod 256): TRUNCATE UP	from 0x4fdc08 to 0x645fd2
198731(75 mod 256): READ	0x29fd82 thru 0x2a76a3	(0x7922 bytes)
198732(76 mod 256): MAPREAD	0x17187a thru 0x17f1fb	(0xd982 bytes)
198733(77 mod 256): MAPWRITE 0x4d7fed thru 0x4e76da	(0xf6ee bytes)
198734(78 mod 256): WRITE	0x4a6ede thru 0x4b1d4a	(0xae6d bytes)
198735(79 mod 256): MAPREAD	0x5d3d0c thru 0x5de1e2	(0xa4d7 bytes)
198736(80 mod 256): READ	0x326228 thru 0x327e33	(0x1c0c bytes)
198737(81 mod 256): MAPREAD	0x4b505b thru 0x4bcdb4	(0x7d5a bytes)
198738(82 mod 256): READ	0x44e4e6 thru 0x45a511	(0xc02c bytes)
198739(83 mod 256): MAPWRITE 0x252bf7 thru 0x253b30	(0xf3a bytes)
198740(84 mod 256): READ	0x534eaa thru 0x53dca1	(0x8df8 bytes)
198741(85 mod 256): TRUNCATE DOWN	from 0x645fd2 to 0xa4dd0
198742(86 mod 256): WRITE	0x372ab0 thru 0x375bdc	(0x312d bytes) HOLE
198743(87 mod 256): MAPREAD	0xed5df thru 0xf1271	(0x3c93 bytes)
198744(88 mod 256): MAPWRITE 0x685a0b thru 0x68d34d	(0x7943 bytes)
198745(89 mod 256): READ	0x52ad76 thru 0x52f472	(0x46fd bytes)
198746(90 mod 256): WRITE	0xa1b54 thru 0xafd4e	(0xe1fb bytes)
198747(91 mod 256): TRUNCATE UP	from 0x68d34e to 0x74ed58
198748(92 mod 256): READ	0x4b692e thru 0x4c2971	(0xc044 bytes)
198749(93 mod 256): TRUNCATE DOWN	from 0x74ed58 to 0x34b105
198750(94 mod 256): MAPWRITE 0x16cd39 thru 0x172f68	(0x6230 bytes)
198751(95 mod 256): MAPWRITE 0x562cb7 thru 0x56658b	(0x38d5 bytes)
198752(96 mod 256): MAPWRITE 0x460faa thru 0x46fe2c	(0xee83 bytes)
198753(97 mod 256): MAPREAD	0x6bf5a thru 0x6f6ba	(0x3761 bytes)
198754(98 mod 256): TRUNCATE DOWN	from 0x56658c to 0x45da92
198755(99 mod 256): MAPWRITE 0x423dff thru 0x42a268	(0x646a bytes)
198756(100 mod 256): READ	0x357267 thru 0x366fa7	(0xfd41 bytes)
198757(101 mod 256): WRITE	0x64ec00 thru 0x65dbbf	(0xefc0 bytes) HOLE
198758(102 mod 256): MAPWRITE 0x5550b6 thru 0x56297d	(0xd8c8 bytes)
198759(103 mod 256): MAPREAD	0x20add5 thru 0x21a4ce	(0xf6fa bytes)
198760(104 mod 256): MAPREAD	0x15e9ce thru 0x16ba8a	(0xd0bd bytes)
198761(105 mod 256): WRITE	0x687d47 thru 0x69193c	(0x9bf6 bytes) HOLE
198762(106 mod 256): MAPWRITE 0x106cb7 thru 0x10b60c	(0x4956 bytes)
198763(107 mod 256): TRUNCATE UP	from 0x69193d to 0x7a0286
198764(108 mod 256): READ	0x844e7 thru 0x892b7	(0x4dd1 bytes)
198765(109 mod 256): READ	0x5ca90f thru 0x5da383	(0xfa75 bytes)
198766(110 mod 256): MAPWRITE 0x20c31f thru 0x21a823	(0xe505 bytes)
198767(111 mod 256): READ	0x1b1d3c thru 0x1be7e6	(0xcaab bytes)
198768(112 mod 256): READ	0x1114d0 thru 0x120d07	(0xf838 bytes)
198769(113 mod 256): READ	0x591254 thru 0x59b093	(0x9e40 bytes)
198770(114 mod 256): TRUNCATE DOWN	from 0x7a0286 to 0x385cd3
198771(115 mod 256): TRUNCATE DOWN	from 0x385cd3 to 0x25556	******WWWW
198772(116 mod 256): MAPREAD	0xd46d thru 0x1aa66	(0xd5fa bytes)
198773(117 mod 256): TRUNCATE UP	from 0x25556 to 0x53db61	******WWWW
198774(118 mod 256): MAPREAD	0x39ccbb thru 0x3a0f17	(0x425d bytes)
198775(119 mod 256): MAPWRITE 0x321acd thru 0x3260ff	(0x4633 bytes)
198776(120 mod 256): READ	0x4cbed thru 0x4e7d8	(0x1bec bytes)
198777(121 mod 256): MAPWRITE 0x2304b4 thru 0x23895c	(0x84a9 bytes)
198778(122 mod 256): TRUNCATE DOWN	from 0x53db61 to 0x109ea0
198779(123 mod 256): MAPREAD	0x321d1 thru 0x38c3c	(0x6a6c bytes)
198780(124 mod 256): WRITE	0x149494 thru 0x150b23	(0x7690 bytes) HOLE
198781(125 mod 256): MAPREAD	0xfca91 thru 0xfdbe5	(0x1155 bytes)
198782(126 mod 256): MAPREAD	0x13bde5 thru 0x14bdcb	(0xffe7 bytes)
198783(127 mod 256): MAPWRITE 0x138b6f thru 0x141af6	(0x8f88 bytes)
198784(128 mod 256): MAPREAD	0x4b4bb thru 0x4b97a	(0x4c0 bytes)
198785(129 mod 256): WRITE	0x80a82 thru 0x853b9	(0x4938 bytes)
198786(130 mod 256): WRITE	0x544bcf thru 0x549ad5	(0x4f07 bytes) HOLE
198787(131 mod 256): TRUNCATE UP	from 0x549ad6 to 0x5c7c6e
198788(132 mod 256): MAPWRITE 0x142c0b thru 0x14d745	(0xab3b bytes)
198789(133 mod 256): READ	0x283a19 thru 0x285627	(0x1c0f bytes)
198790(134 mod 256): TRUNCATE DOWN	from 0x5c7c6e to 0x4b9e40
198791(135 mod 256): MAPREAD	0x413e90 thru 0x41e04b	(0xa1bc bytes)
198792(136 mod 256): READ	0x33d03f thru 0x33f455	(0x2417 bytes)
198793(137 mod 256): WRITE	0x6aac95 thru 0x6b476e	(0x9ada bytes) HOLE
198794(138 mod 256): READ	0x6a5f52 thru 0x6b32de	(0xd38d bytes)
198795(139 mod 256): WRITE	0x650884 thru 0x66033a	(0xfab7 bytes)
198796(140 mod 256): WRITE	0x693a38 thru 0x69d262	(0x982b bytes)
198797(141 mod 256): READ	0x160340 thru 0x161496	(0x1157 bytes)
198798(142 mod 256): MAPREAD	0x68bb0a thru 0x692891	(0x6d88 bytes)
198799(143 mod 256): MAPWRITE 0x3a7d65 thru 0x3b652c	(0xe7c8 bytes)
198800(144 mod 256): TRUNCATE DOWN	from 0x6b476f to 0x460eb9
198801(145 mod 256): WRITE	0x6bb8c6 thru 0x6c38b2	(0x7fed bytes) HOLE
198802(146 mod 256): READ	0x3ff0de thru 0x403b8f	(0x4ab2 bytes)
198803(147 mod 256): READ	0x364c95 thru 0x3688d8	(0x3c44 bytes)
198804(148 mod 256): MAPREAD	0x498b9b thru 0x4a67f2	(0xdc58 bytes)
198805(149 mod 256): WRITE	0x6278b9 thru 0x63111b	(0x9863 bytes)
198806(150 mod 256): WRITE	0x40e66d thru 0x411abc	(0x3450 bytes)
198807(151 mod 256): WRITE	0xbdc77 thru 0xbf47f	(0x1809 bytes)
198808(152 mod 256): MAPWRITE 0x1fceae thru 0x1ff66b	(0x27be bytes)
198809(153 mod 256): WRITE	0x75c2a2 thru 0x769cca	(0xda29 bytes) HOLE
198810(154 mod 256): MAPWRITE 0x410d5f thru 0x415fb9	(0x525b bytes)
198811(155 mod 256): MAPWRITE 0x1954fb thru 0x19ffbe	(0xaac4 bytes)
198812(156 mod 256): TRUNCATE DOWN	from 0x769ccb to 0x1407c8
198813(157 mod 256): TRUNCATE UP	from 0x1407c8 to 0x78c75e
198814(158 mod 256): MAPWRITE 0x6cd977 thru 0x6d1971	(0x3ffb bytes)
198815(159 mod 256): MAPREAD	0x2f18e5 thru 0x2fdd5c	(0xc478 bytes)
198816(160 mod 256): READ	0x2139b2 thru 0x21e170	(0xa7bf bytes)
198817(161 mod 256): READ	0x789bd8 thru 0x78c75d	(0x2b86 bytes)
198818(162 mod 256): MAPWRITE 0x3950ae thru 0x397825	(0x2778 bytes)
198819(163 mod 256): WRITE	0x34b14c thru 0x34efa6	(0x3e5b bytes)
198820(164 mod 256): TRUNCATE DOWN	from 0x78c75e to 0x72362d
198821(165 mod 256): READ	0x658f67 thru 0x6630a9	(0xa143 bytes)
198822(166 mod 256): WRITE	0x2c2303 thru 0x2c9225	(0x6f23 bytes)
198823(167 mod 256): MAPWRITE 0x211179 thru 0x216cc8	(0x5b50 bytes)
198824(168 mod 256): MAPWRITE 0x6dc5df thru 0x6eb229	(0xec4b bytes)
198825(169 mod 256): WRITE	0x381ff5 thru 0x3901dd	(0xe1e9 bytes)
198826(170 mod 256): READ	0x560752 thru 0x5672df	(0x6b8e bytes)
198827(171 mod 256): TRUNCATE DOWN	from 0x72362d to 0x49cf02
198828(172 mod 256): READ	0x39b131 thru 0x39cdc4	(0x1c94 bytes)
198829(173 mod 256): TRUNCATE DOWN	from 0x49cf02 to 0x3a7a9f
198830(174 mod 256): WRITE	0x6dc28c thru 0x6ec201	(0xff76 bytes) HOLE
198831(175 mod 256): WRITE	0x5e148d thru 0x5e590a	(0x447e bytes)
198832(176 mod 256): TRUNCATE DOWN	from 0x6ec202 to 0x413012
198833(177 mod 256): TRUNCATE DOWN	from 0x413012 to 0x47654	******WWWW
198834(178 mod 256): READ	0x16d9b thru 0x2434d	(0xd5b3 bytes)
198835(179 mod 256): TRUNCATE UP	from 0x47654 to 0x24a5de	******WWWW
198836(180 mod 256): TRUNCATE DOWN	from 0x24a5de to 0x23bc35
198837(181 mod 256): MAPREAD	0x90392 thru 0x90b58	(0x7c7 bytes)
198838(182 mod 256): MAPWRITE 0x3c5535 thru 0x3c841f	(0x2eeb bytes)
198839(183 mod 256): MAPREAD	0x1fb36 thru 0x2a299	(0xa764 bytes)
198840(184 mod 256): TRUNCATE UP	from 0x3c8420 to 0x794870
198841(185 mod 256): READ	0x48fded thru 0x49386b	(0x3a7f bytes)
198842(186 mod 256): TRUNCATE DOWN	from 0x794870 to 0x790170
198843(187 mod 256): TRUNCATE DOWN	from 0x790170 to 0xd5030
198844(188 mod 256): WRITE	0x1fc742 thru 0x207fa5	(0xb864 bytes) HOLE
198845(189 mod 256): MAPREAD	0x17e25f thru 0x188d6f	(0xab11 bytes)
198846(190 mod 256): MAPREAD	0xea05e thru 0xf1d7b	(0x7d1e bytes)
198847(191 mod 256): MAPWRITE 0x1a01fb thru 0x1afbae	(0xf9b4 bytes)
198848(192 mod 256): MAPREAD	0x163829 thru 0x170d35	(0xd50d bytes)
198849(193 mod 256): READ	0xdeacb thru 0xec21a	(0xd750 bytes)
198850(194 mod 256): MAPREAD	0x7af4b thru 0x83423	(0x84d9 bytes)
198851(195 mod 256): READ	0x164063 thru 0x1650ac	(0x104a bytes)
198852(196 mod 256): READ	0xc923 thru 0x1b3e9	(0xeac7 bytes)
198853(197 mod 256): TRUNCATE DOWN	from 0x207fa6 to 0x1c3887
198854(198 mod 256): TRUNCATE UP	from 0x1c3887 to 0x24ea1f
198855(199 mod 256): MAPWRITE 0x661e31 thru 0x66e406	(0xc5d6 bytes)
198856(200 mod 256): MAPWRITE 0x70e4e1 thru 0x711c15	(0x3735 bytes)
198857(201 mod 256): MAPREAD	0x708fce thru 0x70d0df	(0x4112 bytes)
198858(202 mod 256): WRITE	0x786f7e thru 0x787b28	(0xbab bytes) HOLE
198859(203 mod 256): READ	0x5e7af5 thru 0x5f5b82	(0xe08e bytes)
198860(204 mod 256): TRUNCATE DOWN	from 0x787b29 to 0x3d77a8
198861(205 mod 256): TRUNCATE DOWN	from 0x3d77a8 to 0x31362	******WWWW
198862(206 mod 256): READ	0x158b2 thru 0x16f74	(0x16c3 bytes)
198863(207 mod 256): TRUNCATE UP	from 0x31362 to 0x4f6984	******WWWW
198864(208 mod 256): WRITE	0x4aca0 thru 0x52ea4	(0x8205 bytes)
198865(209 mod 256): TRUNCATE DOWN	from 0x4f6984 to 0x39e5b0
198866(210 mod 256): TRUNCATE UP	from 0x39e5b0 to 0x67383b
198867(211 mod 256): MAPWRITE 0x641afd thru 0x64b6ff	(0x9c03 bytes)
198868(212 mod 256): WRITE	0xe712f thru 0xe9b0c	(0x29de bytes)
198869(213 mod 256): TRUNCATE DOWN	from 0x67383b to 0xc9e02
198870(214 mod 256): TRUNCATE UP	from 0xc9e02 to 0x62f4a0
198871(215 mod 256): TRUNCATE DOWN	from 0x62f4a0 to 0x256af0
198872(216 mod 256): TRUNCATE DOWN	from 0x256af0 to 0xa0c3f
198873(217 mod 256): READ	0x1caf8 thru 0x20ee7	(0x43f0 bytes)
198874(218 mod 256): MAPWRITE 0x5d49d8 thru 0x5de492	(0x9abb bytes)
198875(219 mod 256): READ	0x32a2ef thru 0x32d66d	(0x337f bytes)
198876(220 mod 256): MAPREAD	0xf12b0 thru 0xfcd0b	(0xba5c bytes)
198877(221 mod 256): READ	0x112555 thru 0x11fce9	(0xd795 bytes)
198878(222 mod 256): TRUNCATE DOWN	from 0x5de493 to 0x20f926
198879(223 mod 256): MAPREAD	0x520e3 thru 0x5e379	(0xc297 bytes)
198880(224 mod 256): TRUNCATE UP	from 0x20f926 to 0x5f6445
198881(225 mod 256): MAPREAD	0x46e352 thru 0x4775ae	(0x925d bytes)
198882(226 mod 256): MAPREAD	0x29a42c thru 0x2a25ee	(0x81c3 bytes)
198883(227 mod 256): MAPREAD	0x39be85 thru 0x3ab22a	(0xf3a6 bytes)
198884(228 mod 256): MAPREAD	0x4eead3 thru 0x4f162c	(0x2b5a bytes)
198885(229 mod 256): MAPREAD	0x1751d thru 0x231ee	(0xbcd2 bytes)
198886(230 mod 256): MAPREAD	0x570082 thru 0x5767d8	(0x6757 bytes)
198887(231 mod 256): MAPWRITE 0x43de04 thru 0x443e77	(0x6074 bytes)
198888(232 mod 256): MAPREAD	0x2a5f5e thru 0x2a7f5e	(0x2001 bytes)
198889(233 mod 256): READ	0x57d336 thru 0x58bbd0	(0xe89b bytes)
198890(234 mod 256): TRUNCATE DOWN	from 0x5f6445 to 0xa8a6e
198891(235 mod 256): TRUNCATE UP	from 0xa8a6e to 0x434dac
198892(236 mod 256): WRITE	0x19f005 thru 0x1a3c1d	(0x4c19 bytes)
198893(237 mod 256): MAPWRITE 0x48cb77 thru 0x494bb5	(0x803f bytes)
198894(238 mod 256): MAPREAD	0x208500 thru 0x20c116	(0x3c17 bytes)
198895(239 mod 256): READ	0x23e0ea thru 0x23e6ae	(0x5c5 bytes)
198896(240 mod 256): READ	0x21882a thru 0x219bd9	(0x13b0 bytes)
198897(241 mod 256): WRITE	0xaeefa thru 0xb0a47	(0x1b4e bytes)
198898(242 mod 256): TRUNCATE DOWN	from 0x494bb6 to 0x3b8394
198899(243 mod 256): MAPREAD	0x28a7f6 thru 0x28ef2c	(0x4737 bytes)
198900(244 mod 256): WRITE	0x5e9557 thru 0x5edfe4	(0x4a8e bytes) HOLE
198901(245 mod 256): MAPWRITE 0x1ad293 thru 0x1bb4bc	(0xe22a bytes)
198902(246 mod 256): READ	0x5b6c46 thru 0x5c0c98	(0xa053 bytes)
198903(247 mod 256): WRITE	0x31b4d4 thru 0x31d89a	(0x23c7 bytes)
198904(248 mod 256): MAPWRITE 0x65cf6d thru 0x6609e4	(0x3a78 bytes)
198905(249 mod 256): WRITE	0x534e55 thru 0x543a13	(0xebbf bytes)
198906(250 mod 256): READ	0x4c666f thru 0x4d5aca	(0xf45c bytes)
198907(251 mod 256): TRUNCATE DOWN	from 0x6609e5 to 0xe6adc
198908(252 mod 256): MAPREAD	0x7bed thru 0x125ca	(0xa9de bytes)
198909(253 mod 256): WRITE	0x3d6e1d thru 0x3dd792	(0x6976 bytes) HOLE
198910(254 mod 256): WRITE	0x4a2dc4 thru 0x4a3ca3	(0xee0 bytes) HOLE
198911(255 mod 256): TRUNCATE DOWN	from 0x4a3ca4 to 0x20a592
198912(0 mod 256): MAPWRITE 0x388013 thru 0x388f3a	(0xf28 bytes)
198913(1 mod 256): MAPREAD	0x34f73 thru 0x3a183	(0x5211 bytes)
198914(2 mod 256): WRITE	0x2a797a thru 0x2adc1a	(0x62a1 bytes)
198915(3 mod 256): MAPWRITE 0x597cf thru 0x63bec	(0xa41e bytes)
198916(4 mod 256): WRITE	0x36aa4b thru 0x372ebd	(0x8473 bytes)
198917(5 mod 256): WRITE	0x64757d thru 0x6483c3	(0xe47 bytes) HOLE
198918(6 mod 256): MAPWRITE 0x4da393 thru 0x4e9249	(0xeeb7 bytes)
198919(7 mod 256): TRUNCATE UP	from 0x6483c4 to 0x6cd54e
198920(8 mod 256): READ	0x5b03db thru 0x5be915	(0xe53b bytes)
198921(9 mod 256): TRUNCATE UP	from 0x6cd54e to 0x75fdf7
198922(10 mod 256): WRITE	0x6cd418 thru 0x6d1029	(0x3c12 bytes)
198923(11 mod 256): READ	0x14b628 thru 0x14becb	(0x8a4 bytes)
198924(12 mod 256): TRUNCATE DOWN	from 0x75fdf7 to 0x1b4a	******WWWW
198925(13 mod 256): MAPWRITE 0x63c0cf thru 0x641b1b	(0x5a4d bytes)
198926(14 mod 256): WRITE	0x554a36 thru 0x55a767	(0x5d32 bytes)
198927(15 mod 256): MAPREAD	0x135fb9 thru 0x13838a	(0x23d2 bytes)
198928(16 mod 256): MAPWRITE 0x7fc76 thru 0x8ee37	(0xf1c2 bytes)
198929(17 mod 256): READ	0x618bc6 thru 0x61aed0	(0x230b bytes)
198930(18 mod 256): MAPWRITE 0x5b9f51 thru 0x5bf767	(0x5817 bytes)
198931(19 mod 256): MAPREAD	0x3cb116 thru 0x3d7aee	(0xc9d9 bytes)
198932(20 mod 256): WRITE	0x11f0c0 thru 0x129959	(0xa89a bytes)
198933(21 mod 256): MAPREAD	0x60f53f thru 0x6130ca	(0x3b8c bytes)
198934(22 mod 256): READ	0x57ec0d thru 0x588587	(0x997b bytes)
198935(23 mod 256): READ	0x504d73 thru 0x50a9cd	(0x5c5b bytes)
198936(24 mod 256): READ	0x5af832 thru 0x5b6d12	(0x74e1 bytes)
198937(25 mod 256): READ	0x30e83c thru 0x31dcd8	(0xf49d bytes)
198938(26 mod 256): TRUNCATE DOWN	from 0x641b1c to 0x38d7cf
198939(27 mod 256): MAPREAD	0x9415 thru 0xd065	(0x3c51 bytes)
198940(28 mod 256): WRITE	0x438d68 thru 0x440b00	(0x7d99 bytes) HOLE
198941(29 mod 256): MAPWRITE 0x41aee6 thru 0x4237e4	(0x88ff bytes)
198942(30 mod 256): WRITE	0x37e88a thru 0x38db4b	(0xf2c2 bytes)
198943(31 mod 256): TRUNCATE DOWN	from 0x440b01 to 0x19c9c	******WWWW
198944(32 mod 256): MAPWRITE 0x446a1 thru 0x45a68	(0x13c8 bytes)
198945(33 mod 256): MAPREAD	0x8020 thru 0x8ae4	(0xac5 bytes)
198946(34 mod 256): MAPREAD	0x1b7b3 thru 0x27989	(0xc1d7 bytes)
198947(35 mod 256): READ	0x229ec thru 0x28ece	(0x64e3 bytes)
198948(36 mod 256): WRITE	0x543e6d thru 0x5525e6	(0xe77a bytes) HOLE	***WWWW
198949(37 mod 256): TRUNCATE DOWN	from 0x5525e7 to 0x19964d
198950(38 mod 256): TRUNCATE UP	from 0x19964d to 0x3c0a66
198951(39 mod 256): MAPREAD	0x34c534 thru 0x352010	(0x5add bytes)
198952(40 mod 256): MAPWRITE 0x3f5aa2 thru 0x4009d8	(0xaf37 bytes)
198953(41 mod 256): WRITE	0x4f9213 thru 0x4fae7a	(0x1c68 bytes) HOLE
198954(42 mod 256): READ	0x1b58a3 thru 0x1bef69	(0x96c7 bytes)
198955(43 mod 256): MAPREAD	0x27f819 thru 0x28d54d	(0xdd35 bytes)
198956(44 mod 256): WRITE	0x6474da thru 0x65468f	(0xd1b6 bytes) HOLE
198957(45 mod 256): MAPREAD	0x46b984 thru 0x479474	(0xdaf1 bytes)
198958(46 mod 256): MAPREAD	0xe9230 thru 0xf5773	(0xc544 bytes)
198959(47 mod 256): TRUNCATE DOWN	from 0x654690 to 0x174a7e
198960(48 mod 256): READ	0x50f9c thru 0x5ab93	(0x9bf8 bytes)
198961(49 mod 256): READ	0x36375 thru 0x3a895	(0x4521 bytes)
198962(50 mod 256): TRUNCATE UP	from 0x174a7e to 0x4d7208
198963(51 mod 256): READ	0x2d7f19 thru 0x2dd799	(0x5881 bytes)
198964(52 mod 256): WRITE	0x16811f thru 0x168fe8	(0xeca bytes)
198965(53 mod 256): WRITE	0x7ad61 thru 0x84d0b	(0x9fab bytes)
198966(54 mod 256): MAPREAD	0x2c9e8b thru 0x2d30c8	(0x923e bytes)
198967(55 mod 256): TRUNCATE UP	from 0x4d7208 to 0x53116e
198968(56 mod 256): WRITE	0x67dd10 thru 0x689ff3	(0xc2e4 bytes) HOLE
198969(57 mod 256): READ	0x30076e thru 0x30b025	(0xa8b8 bytes)
198970(58 mod 256): READ	0x27f4f7 thru 0x28f01d	(0xfb27 bytes)
198971(59 mod 256): READ	0x1b2d49 thru 0x1c1952	(0xec0a bytes)
198972(60 mod 256): READ	0x44bca4 thru 0x457b26	(0xbe83 bytes)
198973(61 mod 256): READ	0x31c255 thru 0x32786e	(0xb61a bytes)
198974(62 mod 256): TRUNCATE UP	from 0x689ff4 to 0x6f71ef
198975(63 mod 256): READ	0x394a21 thru 0x396e4e	(0x242e bytes)
198976(64 mod 256): TRUNCATE DOWN	from 0x6f71ef to 0x3dd6cb
198977(65 mod 256): MAPREAD	0xd71c5 thru 0xe0850	(0x968c bytes)
198978(66 mod 256): MAPWRITE 0x6bdc17 thru 0x6c5f71	(0x835b bytes)
198979(67 mod 256): TRUNCATE DOWN	from 0x6c5f72 to 0x2e01e1
198980(68 mod 256): WRITE	0x1d23d4 thru 0x1d570a	(0x3337 bytes)
198981(69 mod 256): TRUNCATE DOWN	from 0x2e01e1 to 0x293e63
198982(70 mod 256): READ	0x1a21ab thru 0x1a255b	(0x3b1 bytes)
198983(71 mod 256): MAPWRITE 0x42124a thru 0x429514	(0x82cb bytes)
198984(72 mod 256): WRITE	0x70cf8f thru 0x70fd35	(0x2da7 bytes) HOLE
198985(73 mod 256): READ	0x587de0 thru 0x58e799	(0x69ba bytes)
198986(74 mod 256): TRUNCATE DOWN	from 0x70fd36 to 0x4e2482
198987(75 mod 256): READ	0x2616d6 thru 0x26a0eb	(0x8a16 bytes)
198988(76 mod 256): WRITE	0xf44e9 thru 0x101a0a	(0xd522 bytes)
198989(77 mod 256): READ	0x47939c thru 0x487698	(0xe2fd bytes)
198990(78 mod 256): MAPWRITE 0x74cc0d thru 0x74d806	(0xbfa bytes)
198991(79 mod 256): WRITE	0x4e0a87 thru 0x4e6eb5	(0x642f bytes)
198992(80 mod 256): READ	0x31e966 thru 0x322206	(0x38a1 bytes)
198993(81 mod 256): READ	0x255788 thru 0x255ecd	(0x746 bytes)
198994(82 mod 256): WRITE	0x36859b thru 0x36f4ce	(0x6f34 bytes)
198995(83 mod 256): TRUNCATE DOWN	from 0x74d807 to 0x28a215
198996(84 mod 256): WRITE	0x337cd2 thru 0x342aa3	(0xadd2 bytes) HOLE
198997(85 mod 256): READ	0x1f1b86 thru 0x1ff564	(0xd9df bytes)
198998(86 mod 256): TRUNCATE DOWN	from 0x342aa4 to 0x137773
198999(87 mod 256): WRITE	0x51d6d1 thru 0x521799	(0x40c9 bytes) HOLE
199000(88 mod 256): MAPWRITE 0x26d5fb thru 0x2711de	(0x3be4 bytes)
198001(113 mod 256): TRUNCATE DOWN	from 0x52179a to 0x2f8596
198002(114 mod 256): TRUNCATE UP	from 0x2f8596 to 0x6bfe7e
198003(115 mod 256): WRITE	0x54f51a thru 0x55193e	(0x2425 bytes)
198004(116 mod 256): TRUNCATE DOWN	from 0x6bfe7e to 0x33f1e	******WWWW
198005(117 mod 256): TRUNCATE UP	from 0x33f1e to 0x49cb5b	******WWWW
198006(118 mod 256): MAPREAD	0x30f629 thru 0x31c782	(0xd15a bytes)
198007(119 mod 256): READ	0xdd3f9 thru 0xde7d7	(0x13df bytes)
198008(120 mod 256): MAPWRITE 0x1bf6a thru 0x22b25	(0x6bbc bytes)
198009(121 mod 256): MAPREAD	0xc8260 thru 0xcdc2e	(0x59cf bytes)
198010(122 mod 256): READ	0x16286d thru 0x1697f8	(0x6f8c bytes)
198011(123 mod 256): TRUNCATE UP	from 0x49cb5b to 0x4a158f
198012(124 mod 256): WRITE	0x5c7c78 thru 0x5d03f6	(0x877f bytes) HOLE
198013(125 mod 256): MAPREAD	0x2ad08b thru 0x2b0d72	(0x3ce8 bytes)
198014(126 mod 256): MAPWRITE 0x56990 thru 0x5a7e9	(0x3e5a bytes)
198015(127 mod 256): TRUNCATE DOWN	from 0x5d03f7 to 0x25e91e
198016(128 mod 256): MAPWRITE 0xfe0e6 thru 0x100039	(0x1f54 bytes)
198017(129 mod 256): TRUNCATE UP	from 0x25e91e to 0x3a8da5
198018(130 mod 256): READ	0x15d5cb thru 0x16091e	(0x3354 bytes)
198019(131 mod 256): MAPWRITE 0x2a1651 thru 0x2b0195	(0xeb45 bytes)
198020(132 mod 256): TRUNCATE UP	from 0x3a8da5 to 0x720c40
198021(133 mod 256): READ	0x2ef6a1 thru 0x2f095b	(0x12bb bytes)
198022(134 mod 256): TRUNCATE DOWN	from 0x720c40 to 0x1a5bbf
198023(135 mod 256): MAPREAD	0x86e4d thru 0x8a987	(0x3b3b bytes)
198024(136 mod 256): MAPWRITE 0xe12a5 thru 0xed036	(0xbd92 bytes)
198025(137 mod 256): READ	0x172eae thru 0x173128	(0x27b bytes)
198026(138 mod 256): WRITE	0x1ef554 thru 0x1f926a	(0x9d17 bytes) HOLE
198027(139 mod 256): MAPREAD	0xf5f9b thru 0x105ba9	(0xfc0f bytes)
198028(140 mod 256): MAPREAD	0x19dec1 thru 0x1a4536	(0x6676 bytes)
198029(141 mod 256): MAPREAD	0x66586 thru 0x6dbff	(0x767a bytes)
198030(142 mod 256): TRUNCATE UP	from 0x1f926b to 0x4e3ab3
198031(143 mod 256): MAPREAD	0x2a456e thru 0x2b18fd	(0xd390 bytes)
198032(144 mod 256): READ	0x291ecd thru 0x294d02	(0x2e36 bytes)
198033(145 mod 256): TRUNCATE DOWN	from 0x4e3ab3 to 0x1edccc
198034(146 mod 256): MAPWRITE 0x3f19c thru 0x4c059	(0xcebe bytes)
198035(147 mod 256): TRUNCATE UP	from 0x1edccc to 0x3f7f73
198036(148 mod 256): TRUNCATE UP	from 0x3f7f73 to 0x526438
198037(149 mod 256): MAPREAD	0x4af57 thru 0x4c098	(0x1142 bytes)
198038(150 mod 256): READ	0x1fcbe6 thru 0x206035	(0x9450 bytes)
198039(151 mod 256): MAPWRITE 0x1fc1ad thru 0x1fedc4	(0x2c18 bytes)
198040(152 mod 256): WRITE	0x1b6106 thru 0x1b6779	(0x674 bytes)
198041(153 mod 256): TRUNCATE UP	from 0x526438 to 0x5d1678
198042(154 mod 256): WRITE	0x712b73 thru 0x71f691	(0xcb1f bytes) HOLE
198043(155 mod 256): MAPWRITE 0x57b973 thru 0x57e39f	(0x2a2d bytes)
198044(156 mod 256): MAPWRITE 0x40ec74 thru 0x41d4d9	(0xe866 bytes)
198045(157 mod 256): WRITE	0x1d4d8d thru 0x1d5805	(0xa79 bytes)
198046(158 mod 256): WRITE	0x247f34 thru 0x249287	(0x1354 bytes)
198047(159 mod 256): MAPWRITE 0x659ca7 thru 0x665348	(0xb6a2 bytes)
198048(160 mod 256): MAPREAD	0x6289ab thru 0x62e42e	(0x5a84 bytes)
198049(161 mod 256): TRUNCATE UP	from 0x71f692 to 0x7310f4
198050(162 mod 256): MAPREAD	0x1f1bd4 thru 0x1f4cc1	(0x30ee bytes)
198051(163 mod 256): MAPWRITE 0x462cfa thru 0x470644	(0xd94b bytes)
198052(164 mod 256): TRUNCATE DOWN	from 0x7310f4 to 0x44a5a4
198053(165 mod 256): WRITE	0x26a397 thru 0x26be2e	(0x1a98 bytes)
198054(166 mod 256): WRITE	0x6ac9d3 thru 0x6b9704	(0xcd32 bytes) HOLE
198055(167 mod 256): TRUNCATE DOWN	from 0x6b9705 to 0x689b93
198056(168 mod 256): MAPWRITE 0x5c4d91 thru 0x5cdc9d	(0x8f0d bytes)
198057(169 mod 256): TRUNCATE UP	from 0x689b93 to 0x71e9a4
198058(170 mod 256): READ	0x135a34 thru 0x143e03	(0xe3d0 bytes)
198059(171 mod 256): READ	0xa7d2a thru 0xb31f4	(0xb4cb bytes)
198060(172 mod 256): MAPREAD	0x60a9b3 thru 0x616b8c	(0xc1da bytes)
198061(173 mod 256): WRITE	0x5f5bcb thru 0x5fc898	(0x6cce bytes)
198062(174 mod 256): READ	0x405250 thru 0x4102cb	(0xb07c bytes)
198063(175 mod 256): READ	0x6177c7 thru 0x627716	(0xff50 bytes)
198064(176 mod 256): MAPREAD	0x3688a0 thru 0x3705fc	(0x7d5d bytes)
198065(177 mod 256): MAPWRITE 0xe4d40 thru 0xee57c	(0x983d bytes)
198066(178 mod 256): MAPWRITE 0xdcede thru 0xe03bc	(0x34df bytes)
198067(179 mod 256): MAPREAD	0x65cbbb thru 0x666955	(0x9d9b bytes)
198068(180 mod 256): READ	0x5a56e1 thru 0x5ac403	(0x6d23 bytes)
198069(181 mod 256): WRITE	0x39c511 thru 0x3aad1a	(0xe80a bytes)
198070(182 mod 256): MAPREAD	0x2eed4c thru 0x2f1781	(0x2a36 bytes)
198071(183 mod 256): TRUNCATE DOWN	from 0x71e9a4 to 0x403e05
198072(184 mod 256): TRUNCATE DOWN	from 0x403e05 to 0x3bd65c
198073(185 mod 256): MAPREAD	0x121052 thru 0x12c637	(0xb5e6 bytes)
198074(186 mod 256): WRITE	0x4b4c63 thru 0x4bf8ad	(0xac4b bytes) HOLE
198075(187 mod 256): MAPREAD	0x1c5fd9 thru 0x1c80ba	(0x20e2 bytes)
198076(188 mod 256): MAPWRITE 0x1599d thru 0x1a086	(0x46ea bytes)
198077(189 mod 256): MAPREAD	0x3407bf thru 0x34dcad	(0xd4ef bytes)
198078(190 mod 256): READ	0x27ac00 thru 0x289a00	(0xee01 bytes)
198079(191 mod 256): READ	0x24794b thru 0x253202	(0xb8b8 bytes)
198080(192 mod 256): READ	0x256a60 thru 0x265602	(0xeba3 bytes)
198081(193 mod 256): READ	0x5850 thru 0x9f38	(0x46e9 bytes)
198082(194 mod 256): TRUNCATE UP	from 0x4bf8ae to 0x5289ad
198083(195 mod 256): READ	0x15838c thru 0x168318	(0xff8d bytes)
198084(196 mod 256): MAPWRITE 0x4cf2b1 thru 0x4dc0bf	(0xce0f bytes)
198085(197 mod 256): READ	0x1ef374 thru 0x1ff2d5	(0xff62 bytes)
198086(198 mod 256): TRUNCATE DOWN	from 0x5289ad to 0x3bc262
198087(199 mod 256): MAPWRITE 0x373f8c thru 0x376b2b	(0x2ba0 bytes)
198088(200 mod 256): TRUNCATE UP	from 0x3bc262 to 0x41437f
198089(201 mod 256): MAPREAD	0x98dd thru 0xd07a	(0x379e bytes)
198090(202 mod 256): MAPWRITE 0x337581 thru 0x33fff9	(0x8a79 bytes)
198091(203 mod 256): MAPREAD	0x33996f thru 0x33be7c	(0x250e bytes)
198092(204 mod 256): MAPWRITE 0x2513da thru 0x25d513	(0xc13a bytes)
198093(205 mod 256): TRUNCATE UP	from 0x41437f to 0x4ff0c8
198094(206 mod 256): MAPWRITE 0x5b002d thru 0x5b0e15	(0xde9 bytes)
198095(207 mod 256): MAPWRITE 0x3dab30 thru 0x3e903a	(0xe50b bytes)
198096(208 mod 256): WRITE	0xb2f0b thru 0xbf4b7	(0xc5ad bytes)
198097(209 mod 256): WRITE	0x50ba74 thru 0x50e14b	(0x26d8 bytes)
198098(210 mod 256): WRITE	0x2f99e6 thru 0x306a61	(0xd07c bytes)
198099(211 mod 256): MAPWRITE 0xa028b thru 0xab85d	(0xb5d3 bytes)
198100(212 mod 256): MAPREAD	0x3a43ca thru 0x3afb3f	(0xb776 bytes)
198101(213 mod 256): MAPWRITE 0x373327 thru 0x382d43	(0xfa1d bytes)
198102(214 mod 256): TRUNCATE UP	from 0x5b0e16 to 0x6e8faa
198103(215 mod 256): TRUNCATE DOWN	from 0x6e8faa to 0x4763c7
198104(216 mod 256): MAPWRITE 0x22f07e thru 0x23055e	(0x14e1 bytes)
198105(217 mod 256): TRUNCATE UP	from 0x4763c7 to 0x6b980d
198106(218 mod 256): MAPREAD	0x2ac872 thru 0x2b26ef	(0x5e7e bytes)
198107(219 mod 256): READ	0x525806 thru 0x525aa7	(0x2a2 bytes)
198108(220 mod 256): MAPREAD	0x52e2d8 thru 0x5308c1	(0x25ea bytes)
198109(221 mod 256): READ	0x27ee50 thru 0x28454f	(0x5700 bytes)
198110(222 mod 256): TRUNCATE DOWN	from 0x6b980d to 0x23eae	******WWWW
198111(223 mod 256): WRITE	0x32ad83 thru 0x338c80	(0xdefe bytes) HOLE	***WWWW
198112(224 mod 256): READ	0x18d0eb thru 0x1946ab	(0x75c1 bytes)
198113(225 mod 256): READ	0x2de98b thru 0x2e039f	(0x1a15 bytes)
198114(226 mod 256): READ	0x3f14a thru 0x48f8b	(0x9e42 bytes)
198115(227 mod 256): READ	0xff108 thru 0x10977c	(0xa675 bytes)
198116(228 mod 256): READ	0x1fbabc thru 0x1fe1ec	(0x2731 bytes)
198117(229 mod 256): WRITE	0x480858 thru 0x48ca96	(0xc23f bytes) HOLE
198118(230 mod 256): TRUNCATE DOWN	from 0x48ca97 to 0x218c42
198119(231 mod 256): WRITE	0x65db21 thru 0x6618a3	(0x3d83 bytes) HOLE
198120(232 mod 256): MAPWRITE 0x4c1161 thru 0x4ca851	(0x96f1 bytes)
198121(233 mod 256): TRUNCATE DOWN	from 0x6618a4 to 0x5cd715
198122(234 mod 256): TRUNCATE DOWN	from 0x5cd715 to 0x56418c
198123(235 mod 256): MAPWRITE 0x3a3548 thru 0x3a7be0	(0x4699 bytes)
198124(236 mod 256): READ	0x3e84a3 thru 0x3f380e	(0xb36c bytes)
198125(237 mod 256): WRITE	0x3bf3ca thru 0x3c7d7a	(0x89b1 bytes)
198126(238 mod 256): MAPREAD	0x38257f thru 0x382651	(0xd3 bytes)
198127(239 mod 256): MAPREAD	0x286700 thru 0x28b4e1	(0x4de2 bytes)
198128(240 mod 256): READ	0x52819d thru 0x537c0a	(0xfa6e bytes)
198129(241 mod 256): READ	0x18ea59 thru 0x198ed8	(0xa480 bytes)
198130(242 mod 256): TRUNCATE UP	from 0x56418c to 0x670c34
198131(243 mod 256): MAPWRITE 0x1dd8bb thru 0x1e7e92	(0xa5d8 bytes)
198132(244 mod 256): WRITE	0x3ec9ec thru 0x3f3d3c	(0x7351 bytes)
198133(245 mod 256): MAPREAD	0x4cd75d thru 0x4ce6ce	(0xf72 bytes)
198134(246 mod 256): TRUNCATE DOWN	from 0x670c34 to 0x5a0b7d
198135(247 mod 256): MAPWRITE 0x36e373 thru 0x374a12	(0x66a0 bytes)
198136(248 mod 256): WRITE	0x2e45fa thru 0x2e67fc	(0x2203 bytes)
198137(249 mod 256): MAPWRITE 0x6b0444 thru 0x6b6912	(0x64cf bytes)
198138(250 mod 256): READ	0x11f3e6 thru 0x11f646	(0x261 bytes)
198139(251 mod 256): WRITE	0x68eba5 thru 0x6992c1	(0xa71d bytes)
198140(252 mod 256): READ	0x501f0d thru 0x5086d8	(0x67cc bytes)
198141(253 mod 256): TRUNCATE DOWN	from 0x6b6913 to 0x61b756
198142(254 mod 256): TRUNCATE DOWN	from 0x61b756 to 0x5ce02b
198143(255 mod 256): TRUNCATE DOWN	from 0x5ce02b to 0x1ef3ce
198144(0 mod 256): MAPWRITE 0x45df73 thru 0x46abae	(0xcc3c bytes)
198145(1 mod 256): MAPREAD	0x19fb32 thru 0x1a5a4d	(0x5f1c bytes)
198146(2 mod 256): TRUNCATE UP	from 0x46abaf to 0x4b30c6
198147(3 mod 256): TRUNCATE DOWN	from 0x4b30c6 to 0x41d7c	******WWWW
198148(4 mod 256): TRUNCATE UP	from 0x41d7c to 0xf2919	******WWWW
198149(5 mod 256): MAPREAD	0x8c17f thru 0x94f30	(0x8db2 bytes)
198150(6 mod 256): WRITE	0x401643 thru 0x40f02d	(0xd9eb bytes) HOLE
198151(7 mod 256): TRUNCATE UP	from 0x40f02e to 0x5fcfdb
198152(8 mod 256): TRUNCATE DOWN	from 0x5fcfdb to 0x17e259
198153(9 mod 256): TRUNCATE UP	from 0x17e259 to 0x7a0885
198154(10 mod 256): WRITE	0x32bc27 thru 0x32c143	(0x51d bytes)
198155(11 mod 256): MAPWRITE 0x3d24c8 thru 0x3d85a9	(0x60e2 bytes)
198156(12 mod 256): MAPWRITE 0x6ca974 thru 0x6d384b	(0x8ed8 bytes)
198157(13 mod 256): MAPREAD	0x5e37c4 thru 0x5ef28c	(0xbac9 bytes)
198158(14 mod 256): MAPREAD	0x3168bb thru 0x318927	(0x206d bytes)
198159(15 mod 256): MAPREAD	0x599885 thru 0x59c6c4	(0x2e40 bytes)
198160(16 mod 256): READ	0x207e4 thru 0x284ba	(0x7cd7 bytes)
198161(17 mod 256): READ	0x26ffb9 thru 0x278b1c	(0x8b64 bytes)
198162(18 mod 256): READ	0x8eadf thru 0x96cc6	(0x81e8 bytes)
198163(19 mod 256): TRUNCATE DOWN	from 0x7a0885 to 0x3f9621
198164(20 mod 256): WRITE	0x11f135 thru 0x1215d4	(0x24a0 bytes)
198165(21 mod 256): READ	0x36f8e6 thru 0x37df37	(0xe652 bytes)
198166(22 mod 256): READ	0xaa706 thru 0xb2306	(0x7c01 bytes)
198167(23 mod 256): WRITE	0x20d8f8 thru 0x21ae95	(0xd59e bytes)
198168(24 mod 256): WRITE	0x40fc11 thru 0x4167ec	(0x6bdc bytes) HOLE
198169(25 mod 256): WRITE	0x6e5606 thru 0x6e81fb	(0x2bf6 bytes) HOLE
198170(26 mod 256): READ	0xd7f74 thru 0xe5b6e	(0xdbfb bytes)
198171(27 mod 256): WRITE	0x557da2 thru 0x5666fc	(0xe95b bytes)
198172(28 mod 256): READ	0x5738d0 thru 0x57c546	(0x8c77 bytes)
198173(29 mod 256): MAPREAD	0x1682fe thru 0x17326e	(0xaf71 bytes)
198174(30 mod 256): TRUNCATE DOWN	from 0x6e81fc to 0x5c4f4c
198175(31 mod 256): MAPREAD	0x92995 thru 0xa1db3	(0xf41f bytes)
198176(32 mod 256): WRITE	0x345663 thru 0x35004f	(0xa9ed bytes)
198177(33 mod 256): MAPREAD	0x55047c thru 0x555cda	(0x585f bytes)
198178(34 mod 256): MAPWRITE 0x7f842 thru 0x880e8	(0x88a7 bytes)
198179(35 mod 256): MAPREAD	0xbd7a9 thru 0xc0a29	(0x3281 bytes)
198180(36 mod 256): MAPREAD	0x32a843 thru 0x32ecff	(0x44bd bytes)
198181(37 mod 256): TRUNCATE DOWN	from 0x5c4f4c to 0x4f11cc
198182(38 mod 256): WRITE	0x2da739 thru 0x2e30ff	(0x89c7 bytes)
198183(39 mod 256): READ	0x23a897 thru 0x23e6e9	(0x3e53 bytes)
198184(40 mod 256): WRITE	0xdde07 thru 0xe1001	(0x31fb bytes)
198185(41 mod 256): WRITE	0x2f40c7 thru 0x2fe40d	(0xa347 bytes)
198186(42 mod 256): TRUNCATE UP	from 0x4f11cc to 0x67b44f
198187(43 mod 256): MAPWRITE 0x5aabe7 thru 0x5b0114	(0x552e bytes)
198188(44 mod 256): MAPREAD	0x6836f thru 0x7510c	(0xcd9e bytes)
198189(45 mod 256): MAPWRITE 0x3abc0e thru 0x3affd1	(0x43c4 bytes)
198190(46 mod 256): TRUNCATE UP	from 0x67b44f to 0x67bef2
198191(47 mod 256): MAPWRITE 0x63f806 thru 0x641cb6	(0x24b1 bytes)
198192(48 mod 256): MAPREAD	0x49d6da thru 0x4a5880	(0x81a7 bytes)
198193(49 mod 256): READ	0x2c1fb7 thru 0x2c589f	(0x38e9 bytes)
198194(50 mod 256): MAPREAD	0x4ff582 thru 0x509027	(0x9aa6 bytes)
198195(51 mod 256): MAPREAD	0x3b1201 thru 0x3bc373	(0xb173 bytes)
198196(52 mod 256): TRUNCATE DOWN	from 0x67bef2 to 0x12edfc
198197(53 mod 256): WRITE	0x6ed4f3 thru 0x6f6c21	(0x972f bytes) HOLE
198198(54 mod 256): MAPWRITE 0x4d6984 thru 0x4d9e21	(0x349e bytes)
198199(55 mod 256): WRITE	0x4943a2 thru 0x496494	(0x20f3 bytes)
198200(56 mod 256): MAPREAD	0x1daebc thru 0x1e2634	(0x7779 bytes)
198201(57 mod 256): MAPREAD	0x577d93 thru 0x579379	(0x15e7 bytes)
198202(58 mod 256): MAPWRITE 0x29fa31 thru 0x2ab959	(0xbf29 bytes)
198203(59 mod 256): MAPREAD	0x72c99 thru 0x77777	(0x4adf bytes)
198204(60 mod 256): WRITE	0x5d32bf thru 0x5d466f	(0x13b1 bytes)
198205(61 mod 256): MAPWRITE 0x354783 thru 0x3558d1	(0x114f bytes)
198206(62 mod 256): MAPREAD	0xd957 thru 0x17d41	(0xa3eb bytes)
198207(63 mod 256): MAPREAD	0x43e95c thru 0x446cb0	(0x8355 bytes)
198208(64 mod 256): TRUNCATE DOWN	from 0x6f6c22 to 0xade99
198209(65 mod 256): WRITE	0x23c2b1 thru 0x2475e5	(0xb335 bytes) HOLE
198210(66 mod 256): TRUNCATE DOWN	from 0x2475e6 to 0x2148ba
198211(67 mod 256): WRITE	0x22c35a thru 0x2334ff	(0x71a6 bytes) HOLE
198212(68 mod 256): WRITE	0x4d28d4 thru 0x4e198e	(0xf0bb bytes) HOLE
198213(69 mod 256): READ	0x1eede8 thru 0x1fd168	(0xe381 bytes)
198214(70 mod 256): WRITE	0x6b6e8d thru 0x6c32d0	(0xc444 bytes) HOLE
198215(71 mod 256): TRUNCATE DOWN	from 0x6c32d1 to 0x2d97fb
198216(72 mod 256): MAPREAD	0xb8c76 thru 0xc72c1	(0xe64c bytes)
198217(73 mod 256): TRUNCATE UP	from 0x2d97fb to 0x55e602
198218(74 mod 256): WRITE	0x27fdd0 thru 0x28c5ab	(0xc7dc bytes)
198219(75 mod 256): MAPWRITE 0x79beef thru 0x7a11ff	(0x5311 bytes)
198220(76 mod 256): MAPREAD	0x5eb8fc thru 0x5f33d1	(0x7ad6 bytes)
198221(77 mod 256): READ	0xe7cc9 thru 0xeda13	(0x5d4b bytes)
198222(78 mod 256): MAPREAD	0x3a38a8 thru 0x3b2131	(0xe88a bytes)
198223(79 mod 256): TRUNCATE DOWN	from 0x7a1200 to 0x20265b
198224(80 mod 256): TRUNCATE UP	from 0x20265b to 0x64e113
198225(81 mod 256): READ	0x52a061 thru 0x537f29	(0xdec9 bytes)
198226(82 mod 256): WRITE	0x3644fa thru 0x3702c9	(0xbdd0 bytes)
198227(83 mod 256): TRUNCATE UP	from 0x64e113 to 0x67676a
198228(84 mod 256): TRUNCATE DOWN	from 0x67676a to 0x1f8ebd
198229(85 mod 256): TRUNCATE UP	from 0x1f8ebd to 0x4f8455
198230(86 mod 256): READ	0x54dac thru 0x6021f	(0xb474 bytes)
198231(87 mod 256): TRUNCATE UP	from 0x4f8455 to 0x6d1368
198232(88 mod 256): TRUNCATE DOWN	from 0x6d1368 to 0x618ae2
198233(89 mod 256): TRUNCATE DOWN	from 0x618ae2 to 0x584805
198234(90 mod 256): MAPWRITE 0x43e4c8 thru 0x44cb30	(0xe669 bytes)
198235(91 mod 256): WRITE	0x2a8b90 thru 0x2aba8d	(0x2efe bytes)
198236(92 mod 256): WRITE	0x25e834 thru 0x26d947	(0xf114 bytes)
198237(93 mod 256): MAPREAD	0x55c1f1 thru 0x5694d7	(0xd2e7 bytes)
198238(94 mod 256): MAPWRITE 0x3391a9 thru 0x33bed3	(0x2d2b bytes)
198239(95 mod 256): TRUNCATE DOWN	from 0x584805 to 0x491ac7
198240(96 mod 256): WRITE	0x419677 thru 0x421352	(0x7cdc bytes)
198241(97 mod 256): TRUNCATE DOWN	from 0x491ac7 to 0x3f0d2f
198242(98 mod 256): TRUNCATE DOWN	from 0x3f0d2f to 0x1d11fd
198243(99 mod 256): READ	0xb6048 thru 0xb83b0	(0x2369 bytes)
198244(100 mod 256): TRUNCATE UP	from 0x1d11fd to 0x798662
198245(101 mod 256): TRUNCATE DOWN	from 0x798662 to 0x5ebdc4
198246(102 mod 256): READ	0xcb18a thru 0xd5629	(0xa4a0 bytes)
198247(103 mod 256): TRUNCATE DOWN	from 0x5ebdc4 to 0x310ee0
198248(104 mod 256): TRUNCATE DOWN	from 0x310ee0 to 0x130a5b
198249(105 mod 256): MAPWRITE 0x193fa9 thru 0x19edcb	(0xae23 bytes)
198250(106 mod 256): WRITE	0xc18a9 thru 0xc7621	(0x5d79 bytes)
198251(107 mod 256): WRITE	0x3dadaf thru 0x3dbf8d	(0x11df bytes) HOLE
198252(108 mod 256): WRITE	0x2ed3f8 thru 0x2fa325	(0xcf2e bytes)
198253(109 mod 256): MAPWRITE 0x3edb1 thru 0x45926	(0x6b76 bytes)
198254(110 mod 256): READ	0x3d3666 thru 0x3dadbd	(0x7758 bytes)
198255(111 mod 256): MAPWRITE 0xb79b thru 0xf194	(0x39fa bytes)
198256(112 mod 256): MAPREAD	0x1ceec0 thru 0x1d2439	(0x357a bytes)
198257(113 mod 256): TRUNCATE UP	from 0x3dbf8e to 0x3def66
198258(114 mod 256): MAPWRITE 0x47c130 thru 0x48af9e	(0xee6f bytes)
198259(115 mod 256): WRITE	0x76f6f5 thru 0x776082	(0x698e bytes) HOLE
198260(116 mod 256): WRITE	0x36e484 thru 0x3776fe	(0x927b bytes)
198261(117 mod 256): MAPWRITE 0x2d8308 thru 0x2e32e5	(0xafde bytes)
198262(118 mod 256): MAPREAD	0x4c0bc thru 0x579c0	(0xb905 bytes)
198263(119 mod 256): READ	0x2539e8 thru 0x253b41	(0x15a bytes)
198264(120 mod 256): TRUNCATE DOWN	from 0x776083 to 0x3aeb27
198265(121 mod 256): MAPREAD	0x58698 thru 0x619d3	(0x933c bytes)
198266(122 mod 256): MAPREAD	0x3a3199 thru 0x3a8159	(0x4fc1 bytes)
198267(123 mod 256): MAPWRITE 0x3b2557 thru 0x3bc29a	(0x9d44 bytes)
198268(124 mod 256): MAPWRITE 0x6e5b1e thru 0x6e628a	(0x76d bytes)
198269(125 mod 256): MAPREAD	0x692789 thru 0x69d5a7	(0xae1f bytes)
198270(126 mod 256): MAPWRITE 0x463de7 thru 0x46843b	(0x4655 bytes)
198271(127 mod 256): MAPWRITE 0x55a064 thru 0x560705	(0x66a2 bytes)
198272(128 mod 256): MAPWRITE 0x495692 thru 0x4994c4	(0x3e33 bytes)
198273(129 mod 256): READ	0x4c81f9 thru 0x4cc0a7	(0x3eaf bytes)
198274(130 mod 256): TRUNCATE DOWN	from 0x6e628b to 0x239d1a
198275(131 mod 256): MAPREAD	0x1db13f thru 0x1e7ca2	(0xcb64 bytes)
198276(132 mod 256): READ	0x456c4 thru 0x54880	(0xf1bd bytes)
198277(133 mod 256): MAPWRITE 0x32a905 thru 0x330360	(0x5a5c bytes)
198278(134 mod 256): TRUNCATE DOWN	from 0x330361 to 0x4b650	******WWWW
198279(135 mod 256): MAPREAD	0x343bf thru 0x38bb8	(0x47fa bytes)
198280(136 mod 256): READ	0xb503 thru 0x11d95	(0x6893 bytes)
198281(137 mod 256): WRITE	0x47541f thru 0x480916	(0xb4f8 bytes) HOLE	***WWWW
198282(138 mod 256): TRUNCATE DOWN	from 0x480917 to 0x38c8e2
198283(139 mod 256): TRUNCATE UP	from 0x38c8e2 to 0x46c2cb
198284(140 mod 256): TRUNCATE UP	from 0x46c2cb to 0x7308b8
198285(141 mod 256): WRITE	0x1a59d7 thru 0x1afc7b	(0xa2a5 bytes)
198286(142 mod 256): WRITE	0x71af thru 0x1337f	(0xc1d1 bytes)
198287(143 mod 256): MAPWRITE 0x68dfb2 thru 0x694687	(0x66d6 bytes)
198288(144 mod 256): WRITE	0x3abb09 thru 0x3b428a	(0x8782 bytes)
198289(145 mod 256): MAPWRITE 0x2f39d1 thru 0x2f4efe	(0x152e bytes)
198290(146 mod 256): TRUNCATE DOWN	from 0x7308b8 to 0x27cc3a
198291(147 mod 256): WRITE	0x448e51 thru 0x4510ef	(0x829f bytes) HOLE
198292(148 mod 256): READ	0x1a9334 thru 0x1b1df3	(0x8ac0 bytes)
198293(149 mod 256): MAPWRITE 0x6bba57 thru 0x6cb754	(0xfcfe bytes)
198294(150 mod 256): WRITE	0x21f261 thru 0x225190	(0x5f30 bytes)
198295(151 mod 256): TRUNCATE UP	from 0x6cb755 to 0x6f8b40
198296(152 mod 256): MAPWRITE 0x32f1f9 thru 0x3301e8	(0xff0 bytes)
198297(153 mod 256): MAPREAD	0x45f2ca thru 0x4622e2	(0x3019 bytes)
198298(154 mod 256): READ	0xa892f thru 0xaa47e	(0x1b50 bytes)
198299(155 mod 256): MAPREAD	0x431728 thru 0x43322e	(0x1b07 bytes)
198300(156 mod 256): MAPREAD	0xded0e thru 0xea059	(0xb34c bytes)
198301(157 mod 256): READ	0x5a957a thru 0x5b5dc2	(0xc849 bytes)
198302(158 mod 256): MAPREAD	0x42a957 thru 0x42c5d1	(0x1c7b bytes)
198303(159 mod 256): WRITE	0x38098b thru 0x388b3b	(0x81b1 bytes)
198304(160 mod 256): WRITE	0x25383c thru 0x25aedf	(0x76a4 bytes)
198305(161 mod 256): MAPREAD	0x697890 thru 0x6a2a7b	(0xb1ec bytes)
198306(162 mod 256): TRUNCATE DOWN	from 0x6f8b40 to 0x3963b9
198307(163 mod 256): MAPREAD	0x3f82e thru 0x437cc	(0x3f9f bytes)
198308(164 mod 256): WRITE	0x369bed thru 0x36cccd	(0x30e1 bytes)
198309(165 mod 256): MAPREAD	0x2261d1 thru 0x235af0	(0xf920 bytes)
198310(166 mod 256): MAPREAD	0x186a53 thru 0x18ef03	(0x84b1 bytes)
198311(167 mod 256): MAPREAD	0x11f70c thru 0x12485f	(0x5154 bytes)
198312(168 mod 256): TRUNCATE UP	from 0x3963b9 to 0x51b42d
198313(169 mod 256): MAPREAD	0x18d056 thru 0x190e31	(0x3ddc bytes)
198314(170 mod 256): MAPREAD	0x3f63db thru 0x4037c2	(0xd3e8 bytes)
198315(171 mod 256): MAPREAD	0x5c3d7 thru 0x5fbf7	(0x3821 bytes)
198316(172 mod 256): READ	0x434b77 thru 0x443f09	(0xf393 bytes)
198317(173 mod 256): MAPREAD	0x64f2b thru 0x70fcf	(0xc0a5 bytes)	***RRRR***
198318(174 mod 256): WRITE	0x25a5ce thru 0x25e5f1	(0x4024 bytes)
198319(175 mod 256): WRITE	0x6fa24e thru 0x701a50	(0x7803 bytes) HOLE
198320(176 mod 256): READ	0x26c0d2 thru 0x2752f8	(0x9227 bytes)
198321(177 mod 256): MAPWRITE 0x76bd1 thru 0x7fad7	(0x8f07 bytes)
198322(178 mod 256): TRUNCATE DOWN	from 0x701a51 to 0x60f268
198323(179 mod 256): MAPWRITE 0x496102 thru 0x49d10c	(0x700b bytes)
198324(180 mod 256): WRITE	0xc319e thru 0xc5369	(0x21cc bytes)
198325(181 mod 256): READ	0x418659 thru 0x41bfa5	(0x394d bytes)
198326(182 mod 256): MAPREAD	0x10898f thru 0x1108a9	(0x7f1b bytes)
198327(183 mod 256): TRUNCATE DOWN	from 0x60f268 to 0x11d6cb
198328(184 mod 256): MAPWRITE 0x5166d5 thru 0x51a25a	(0x3b86 bytes)
198329(185 mod 256): READ	0x4f05a8 thru 0x4fd11f	(0xcb78 bytes)
198330(186 mod 256): MAPREAD	0x321544 thru 0x322f45	(0x1a02 bytes)
198331(187 mod 256): WRITE	0x68db69 thru 0x68f1bb	(0x1653 bytes) HOLE
198332(188 mod 256): MAPREAD	0x290f97 thru 0x29d952	(0xc9bc bytes)
198333(189 mod 256): WRITE	0x491fa1 thru 0x492f5f	(0xfbf bytes)
198334(190 mod 256): TRUNCATE DOWN	from 0x68f1bc to 0x5bfc1	******WWWW
198335(191 mod 256): MAPWRITE 0x4e9102 thru 0x4ec463	(0x3362 bytes)
198336(192 mod 256): MAPREAD	0x296d7f thru 0x29aa75	(0x3cf7 bytes)
198337(193 mod 256): TRUNCATE DOWN	from 0x4ec464 to 0x5356	******WWWW
198338(194 mod 256): TRUNCATE UP	from 0x5356 to 0x454799	******WWWW
198339(195 mod 256): READ	0x3030f8 thru 0x3080b1	(0x4fba bytes)
198340(196 mod 256): TRUNCATE DOWN	from 0x454799 to 0x18d751
198341(197 mod 256): MAPWRITE 0x6ad9a8 thru 0x6afa18	(0x2071 bytes)
198342(198 mod 256): MAPWRITE 0x2559bd thru 0x26521b	(0xf85f bytes)
198343(199 mod 256): MAPREAD	0x68a64 thru 0x6c017	(0x35b4 bytes)
198344(200 mod 256): MAPWRITE 0x292d3e thru 0x2983e3	(0x56a6 bytes)
198345(201 mod 256): WRITE	0x7501b1 thru 0x75f8df	(0xf72f bytes) HOLE
198346(202 mod 256): MAPREAD	0x4affb1 thru 0x4ba55f	(0xa5af bytes)
198347(203 mod 256): TRUNCATE DOWN	from 0x75f8e0 to 0x6e8b17
198348(204 mod 256): TRUNCATE DOWN	from 0x6e8b17 to 0x5a1a55
198349(205 mod 256): MAPREAD	0x188578 thru 0x188a76	(0x4ff bytes)
198350(206 mod 256): MAPREAD	0xb9dd7 thru 0xc2b8d	(0x8db7 bytes)
198351(207 mod 256): READ	0x2b0fb3 thru 0x2b23ae	(0x13fc bytes)
198352(208 mod 256): MAPREAD	0x4936c4 thru 0x4a10ef	(0xda2c bytes)
198353(209 mod 256): MAPWRITE 0x620b29 thru 0x626288	(0x5760 bytes)
198354(210 mod 256): MAPREAD	0x2cbc9 thru 0x36198	(0x95d0 bytes)
198355(211 mod 256): WRITE	0x637792 thru 0x646403	(0xec72 bytes) HOLE
198356(212 mod 256): READ	0x476360 thru 0x482042	(0xbce3 bytes)
198357(213 mod 256): TRUNCATE UP	from 0x646404 to 0x6a366d
198358(214 mod 256): TRUNCATE DOWN	from 0x6a366d to 0x29b3ad
198359(215 mod 256): TRUNCATE UP	from 0x29b3ad to 0x2fdfd2
198360(216 mod 256): READ	0x885 thru 0xeecf	(0xe64b bytes)
198361(217 mod 256): TRUNCATE DOWN	from 0x2fdfd2 to 0x104e4f
198362(218 mod 256): WRITE	0x661a56 thru 0x66bfe2	(0xa58d bytes) HOLE
198363(219 mod 256): MAPWRITE 0x583a72 thru 0x59097b	(0xcf0a bytes)
198364(220 mod 256): MAPWRITE 0x6e9a8d thru 0x6ed91c	(0x3e90 bytes)
198365(221 mod 256): MAPREAD	0x54a837 thru 0x5557da	(0xafa4 bytes)
198366(222 mod 256): WRITE	0x15984d thru 0x166180	(0xc934 bytes)
198367(223 mod 256): WRITE	0x5c59f3 thru 0x5cb28f	(0x589d bytes)
198368(224 mod 256): READ	0x261d08 thru 0x270549	(0xe842 bytes)
198369(225 mod 256): TRUNCATE UP	from 0x6ed91d to 0x7181b2
198370(226 mod 256): MAPWRITE 0x6b6c74 thru 0x6c201b	(0xb3a8 bytes)
198371(227 mod 256): WRITE	0xe6700 thru 0xf52d2	(0xebd3 bytes)
198372(228 mod 256): WRITE	0x25cb66 thru 0x26bcd7	(0xf172 bytes)
198373(229 mod 256): MAPWRITE 0x219d89 thru 0x226a07	(0xcc7f bytes)
198374(230 mod 256): TRUNCATE DOWN	from 0x7181b2 to 0x3dd0af
198375(231 mod 256): WRITE	0x361ffc thru 0x36c4a6	(0xa4ab bytes)
198376(232 mod 256): TRUNCATE DOWN	from 0x3dd0af to 0x156878
198377(233 mod 256): MAPREAD	0x1056af thru 0x10c618	(0x6f6a bytes)
198378(234 mod 256): TRUNCATE UP	from 0x156878 to 0x61147c
198379(235 mod 256): WRITE	0x69454e thru 0x6a2611	(0xe0c4 bytes) HOLE
198380(236 mod 256): MAPREAD	0x27d6bd thru 0x282300	(0x4c44 bytes)
198381(237 mod 256): READ	0x513363 thru 0x51dced	(0xa98b bytes)
198382(238 mod 256): MAPREAD	0xabfb0 thru 0xb2eda	(0x6f2b bytes)
198383(239 mod 256): MAPWRITE 0x185ee8 thru 0x193c14	(0xdd2d bytes)
198384(240 mod 256): READ	0x109a45 thru 0x10c433	(0x29ef bytes)
198385(241 mod 256): READ	0x2563a2 thru 0x256a37	(0x696 bytes)
198386(242 mod 256): WRITE	0x3015ca thru 0x30c75b	(0xb192 bytes)
198387(243 mod 256): TRUNCATE UP	from 0x6a2612 to 0x6f080b
198388(244 mod 256): TRUNCATE DOWN	from 0x6f080b to 0x5f7c0d
198389(245 mod 256): MAPWRITE 0x566304 thru 0x56bd99	(0x5a96 bytes)
198390(246 mod 256): WRITE	0x481af6 thru 0x488a78	(0x6f83 bytes)
198391(247 mod 256): WRITE	0x372a8a thru 0x380a98	(0xe00f bytes)
198392(248 mod 256): MAPWRITE 0x34657 thru 0x3ffa2	(0xb94c bytes)
198393(249 mod 256): MAPWRITE 0xe471d thru 0xe53c9	(0xcad bytes)
198394(250 mod 256): MAPWRITE 0x4e0e35 thru 0x4e64bd	(0x5689 bytes)
198395(251 mod 256): READ	0x241d76 thru 0x24e34f	(0xc5da bytes)
198396(252 mod 256): TRUNCATE UP	from 0x5f7c0d to 0x7970b4
198397(253 mod 256): WRITE	0x7449e6 thru 0x75142b	(0xca46 bytes)
198398(254 mod 256): READ	0x3446bb thru 0x34f90f	(0xb255 bytes)
198399(255 mod 256): WRITE	0x41bfe5 thru 0x42260f	(0x662b bytes)
198400(0 mod 256): MAPWRITE 0x2f124 thru 0x32ed6	(0x3db3 bytes)
198401(1 mod 256): MAPREAD	0x6264b thru 0x6bc66	(0x961c bytes)	***RRRR***
198402(2 mod 256): WRITE	0x6578df thru 0x65b3ec	(0x3b0e bytes)
198403(3 mod 256): MAPWRITE 0x2cb4d7 thru 0x2cdf6d	(0x2a97 bytes)
198404(4 mod 256): WRITE	0x275cfd thru 0x27867b	(0x297f bytes)
198405(5 mod 256): TRUNCATE DOWN	from 0x7970b4 to 0x336f1e
198406(6 mod 256): READ	0x18560a thru 0x18bca8	(0x669f bytes)
198407(7 mod 256): READ	0x293de6 thru 0x29e2b0	(0xa4cb bytes)
198408(8 mod 256): READ	0xd36c5 thru 0xd4b36	(0x1472 bytes)
198409(9 mod 256): TRUNCATE UP	from 0x336f1e to 0x5bb917
198410(10 mod 256): WRITE	0x3af25e thru 0x3bbbcd	(0xc970 bytes)
198411(11 mod 256): READ	0x435706 thru 0x438a51	(0x334c bytes)
198412(12 mod 256): MAPWRITE 0x6d277a thru 0x6d761c	(0x4ea3 bytes)
198413(13 mod 256): TRUNCATE DOWN	from 0x6d761d to 0x175b09
198414(14 mod 256): TRUNCATE UP	from 0x175b09 to 0x45c254
198415(15 mod 256): MAPWRITE 0x479ed4 thru 0x480a2f	(0x6b5c bytes)
198416(16 mod 256): WRITE	0x2d1682 thru 0x2d64b7	(0x4e36 bytes)
198417(17 mod 256): WRITE	0x68abdb thru 0x6902a8	(0x56ce bytes) HOLE
198418(18 mod 256): TRUNCATE DOWN	from 0x6902a9 to 0x2131aa
198419(19 mod 256): READ	0x1da9d0 thru 0x1de5ff	(0x3c30 bytes)
198420(20 mod 256): MAPWRITE 0x1f234f thru 0x1f4d02	(0x29b4 bytes)
198421(21 mod 256): MAPREAD	0x1d9534 thru 0x1e1343	(0x7e10 bytes)
198422(22 mod 256): MAPREAD	0x522e6 thru 0x5d2f2	(0xb00d bytes)
198423(23 mod 256): TRUNCATE UP	from 0x2131aa to 0x6bd64d
198424(24 mod 256): MAPREAD	0x4f9eb4 thru 0x507602	(0xd74f bytes)
198425(25 mod 256): MAPWRITE 0x2fea0e thru 0x308f34	(0xa527 bytes)
198426(26 mod 256): WRITE	0x6b0b3b thru 0x6bdf0f	(0xd3d5 bytes) EXTEND
198427(27 mod 256): WRITE	0x4c0acc thru 0x4c757f	(0x6ab4 bytes)
198428(28 mod 256): TRUNCATE DOWN	from 0x6bdf10 to 0x1b1523
198429(29 mod 256): TRUNCATE UP	from 0x1b1523 to 0x3be668
198430(30 mod 256): MAPREAD	0x293d5d thru 0x299351	(0x55f5 bytes)
198431(31 mod 256): READ	0x11ba2 thru 0x1c2c1	(0xa720 bytes)
198432(32 mod 256): MAPWRITE 0x62ae76 thru 0x62e62d	(0x37b8 bytes)
198433(33 mod 256): MAPREAD	0x50bf3f thru 0x50d910	(0x19d2 bytes)
198434(34 mod 256): WRITE	0x44d125 thru 0x453e4b	(0x6d27 bytes)
198435(35 mod 256): READ	0x36bdee thru 0x372110	(0x6323 bytes)
198436(36 mod 256): MAPREAD	0x455440 thru 0x458723	(0x32e4 bytes)
198437(37 mod 256): TRUNCATE DOWN	from 0x62e62e to 0x1ece99
198438(38 mod 256): READ	0x1b27c7 thru 0x1bf6c7	(0xcf01 bytes)
198439(39 mod 256): MAPREAD	0x176445 thru 0x1789b8	(0x2574 bytes)
198440(40 mod 256): READ	0x106402 thru 0x10ff50	(0x9b4f bytes)
198441(41 mod 256): MAPREAD	0x13918b thru 0x141b87	(0x89fd bytes)
198442(42 mod 256): WRITE	0x4ed2ea thru 0x4ef8b0	(0x25c7 bytes) HOLE
198443(43 mod 256): MAPREAD	0x265b7b thru 0x26a38e	(0x4814 bytes)
198444(44 mod 256): MAPWRITE 0x4fcab thru 0x59192	(0x94e8 bytes)
198445(45 mod 256): READ	0x52212 thru 0x5ba6c	(0x985b bytes)
198446(46 mod 256): WRITE	0x3a65f6 thru 0x3aa2a9	(0x3cb4 bytes)
198447(47 mod 256): READ	0x423d60 thru 0x4284a2	(0x4743 bytes)
198448(48 mod 256): WRITE	0x6e4b90 thru 0x6eb817	(0x6c88 bytes) HOLE
198449(49 mod 256): MAPREAD	0x6e5c2d thru 0x6e7b7d	(0x1f51 bytes)
198450(50 mod 256): MAPREAD	0x56e7e thru 0x58b0a	(0x1c8d bytes)
198451(51 mod 256): MAPWRITE 0x5760d3 thru 0x585767	(0xf695 bytes)
198452(52 mod 256): READ	0x4af0be thru 0x4bde24	(0xed67 bytes)
198453(53 mod 256): MAPREAD	0x3d2f90 thru 0x3e013a	(0xd1ab bytes)
198454(54 mod 256): TRUNCATE DOWN	from 0x6eb818 to 0x3c381f
198455(55 mod 256): TRUNCATE DOWN	from 0x3c381f to 0x10f850
198456(56 mod 256): TRUNCATE UP	from 0x10f850 to 0x2dd401
198457(57 mod 256): MAPWRITE 0x6a9ef7 thru 0x6b797d	(0xda87 bytes)
198458(58 mod 256): MAPREAD	0x31367b thru 0x32324f	(0xfbd5 bytes)
198459(59 mod 256): WRITE	0x85c4b thru 0x92ba4	(0xcf5a bytes)
198460(60 mod 256): TRUNCATE DOWN	from 0x6b797e to 0x382490
198461(61 mod 256): TRUNCATE DOWN	from 0x382490 to 0x4dfbe	******WWWW
198462(62 mod 256): WRITE	0x3d7023 thru 0x3e2487	(0xb465 bytes) HOLE	***WWWW
198463(63 mod 256): READ	0x22704e thru 0x233c77	(0xcc2a bytes)
198464(64 mod 256): WRITE	0x5e176 thru 0x6211f	(0x3faa bytes)
198465(65 mod 256): MAPREAD	0x240c5a thru 0x24d21e	(0xc5c5 bytes)
198466(66 mod 256): WRITE	0x1e7efe thru 0x1e8595	(0x698 bytes)
198467(67 mod 256): TRUNCATE DOWN	from 0x3e2488 to 0x34f758
198468(68 mod 256): MAPWRITE 0x4b0178 thru 0x4b0481	(0x30a bytes)
198469(69 mod 256): READ	0xcaeef thru 0xd7847	(0xc959 bytes)
198470(70 mod 256): TRUNCATE DOWN	from 0x4b0482 to 0x1824bb
198471(71 mod 256): MAPREAD	0xc9530 thru 0xd0813	(0x72e4 bytes)
198472(72 mod 256): READ	0x10e03c thru 0x10e7ab	(0x770 bytes)
198473(73 mod 256): TRUNCATE UP	from 0x1824bb to 0x406c4b
198474(74 mod 256): READ	0x247888 thru 0x254634	(0xcdad bytes)
198475(75 mod 256): TRUNCATE UP	from 0x406c4b to 0x47b7e6
198476(76 mod 256): MAPREAD	0x2eb737 thru 0x2efd56	(0x4620 bytes)
198477(77 mod 256): TRUNCATE UP	from 0x47b7e6 to 0x6fff42
198478(78 mod 256): MAPREAD	0x2e66aa thru 0x2e8ab8	(0x240f bytes)
198479(79 mod 256): TRUNCATE DOWN	from 0x6fff42 to 0x21a51	******WWWW
198480(80 mod 256): MAPWRITE 0x6cd58a thru 0x6d8e87	(0xb8fe bytes)
198481(81 mod 256): MAPWRITE 0xc2beb thru 0xcc31c	(0x9732 bytes)
198482(82 mod 256): MAPWRITE 0x4af6ad thru 0x4bae92	(0xb7e6 bytes)
198483(83 mod 256): TRUNCATE DOWN	from 0x6d8e88 to 0x3ce0ab
198484(84 mod 256): TRUNCATE UP	from 0x3ce0ab to 0x795740
198485(85 mod 256): MAPREAD	0x8033c thru 0x80ec1	(0xb86 bytes)
198486(86 mod 256): READ	0x630241 thru 0x6381c0	(0x7f80 bytes)
198487(87 mod 256): READ	0x3cb248 thru 0x3ccc52	(0x1a0b bytes)
198488(88 mod 256): MAPREAD	0x23a36e thru 0x23c721	(0x23b4 bytes)
198489(89 mod 256): MAPREAD	0x67e36e thru 0x683b8f	(0x5822 bytes)
198490(90 mod 256): WRITE	0x42d8bf thru 0x43b8f4	(0xe036 bytes)
198491(91 mod 256): READ	0x65b72 thru 0x71727	(0xbbb6 bytes)	***RRRR***
198492(92 mod 256): TRUNCATE DOWN	from 0x795740 to 0x3fe54c
198493(93 mod 256): WRITE	0x3ca7f2 thru 0x3ce548	(0x3d57 bytes)
198494(94 mod 256): WRITE	0x4c682b thru 0x4d0de4	(0xa5ba bytes) HOLE
198495(95 mod 256): TRUNCATE DOWN	from 0x4d0de5 to 0x3a7d2	******WWWW
198496(96 mod 256): TRUNCATE UP	from 0x3a7d2 to 0x3dc4d4	******WWWW
198497(97 mod 256): MAPWRITE 0x35bcd9 thru 0x36ba01	(0xfd29 bytes)
198498(98 mod 256): WRITE	0x65088 thru 0x69c12	(0x4b8b bytes)	***WWWW
198499(99 mod 256): MAPREAD	0x8b191 thru 0x9ac31	(0xfaa1 bytes)
198500(100 mod 256): MAPWRITE 0x21642d thru 0x21aa4a	(0x461e bytes)
198501(101 mod 256): READ	0x3005d8 thru 0x307230	(0x6c59 bytes)
198502(102 mod 256): TRUNCATE DOWN	from 0x3dc4d4 to 0x22fba2
198503(103 mod 256): MAPWRITE 0x469bf3 thru 0x469c6a	(0x78 bytes)
198504(104 mod 256): TRUNCATE UP	from 0x469c6b to 0x6a979a
198505(105 mod 256): WRITE	0x4f56b8 thru 0x4fdd74	(0x86bd bytes)
198506(106 mod 256): MAPWRITE 0x5c7871 thru 0x5ce25d	(0x69ed bytes)
198507(107 mod 256): TRUNCATE DOWN	from 0x6a979a to 0x22de60
198508(108 mod 256): MAPWRITE 0x56dfce thru 0x5737a1	(0x57d4 bytes)
198509(109 mod 256): MAPREAD	0x1a5767 thru 0x1a722e	(0x1ac8 bytes)
198510(110 mod 256): TRUNCATE UP	from 0x5737a2 to 0x7005e6
198511(111 mod 256): TRUNCATE DOWN	from 0x7005e6 to 0x6557f0
198512(112 mod 256): READ	0x403344 thru 0x411570	(0xe22d bytes)
198513(113 mod 256): TRUNCATE DOWN	from 0x6557f0 to 0x3a0f3c
198514(114 mod 256): WRITE	0x4efd21 thru 0x4f2f28	(0x3208 bytes) HOLE
198515(115 mod 256): WRITE	0x100f44 thru 0x10842a	(0x74e7 bytes)
198516(116 mod 256): READ	0x313911 thru 0x31c558	(0x8c48 bytes)
198517(117 mod 256): MAPREAD	0x313bdb thru 0x31a242	(0x6668 bytes)
198518(118 mod 256): TRUNCATE DOWN	from 0x4f2f29 to 0x476834
198519(119 mod 256): READ	0x2d234 thru 0x3855e	(0xb32b bytes)
198520(120 mod 256): WRITE	0x75a520 thru 0x760af5	(0x65d6 bytes) HOLE
198521(121 mod 256): MAPWRITE 0x606c97 thru 0x607c53	(0xfbd bytes)
198522(122 mod 256): MAPWRITE 0x6d6d4c thru 0x6dfaee	(0x8da3 bytes)
198523(123 mod 256): READ	0x467951 thru 0x46ddb6	(0x6466 bytes)
198524(124 mod 256): MAPWRITE 0x46e770 thru 0x471cc0	(0x3551 bytes)
198525(125 mod 256): TRUNCATE DOWN	from 0x760af6 to 0x626011
198526(126 mod 256): READ	0x5c2a6 thru 0x5e447	(0x21a2 bytes)
198527(127 mod 256): MAPREAD	0x230aec thru 0x240582	(0xfa97 bytes)
198528(128 mod 256): WRITE	0x465123 thru 0x474037	(0xef15 bytes)
198529(129 mod 256): READ	0x4b08d2 thru 0x4b0d0e	(0x43d bytes)
198530(130 mod 256): READ	0x5d2c17 thru 0x5df29d	(0xc687 bytes)
198531(131 mod 256): READ	0x12f5e6 thru 0x133fe9	(0x4a04 bytes)
198532(132 mod 256): READ	0x53d334 thru 0x544c70	(0x793d bytes)
198533(133 mod 256): TRUNCATE UP	from 0x626011 to 0x75935e
198534(134 mod 256): WRITE	0x1c91cb thru 0x1d2a71	(0x98a7 bytes)
198535(135 mod 256): WRITE	0x3335fa thru 0x338cc9	(0x56d0 bytes)
198536(136 mod 256): MAPREAD	0x5275cd thru 0x53031c	(0x8d50 bytes)
198537(137 mod 256): READ	0x59aee4 thru 0x5a5276	(0xa393 bytes)
198538(138 mod 256): MAPWRITE 0x4e4687 thru 0x4ec3ad	(0x7d27 bytes)
198539(139 mod 256): READ	0x30a810 thru 0x31597b	(0xb16c bytes)
198540(140 mod 256): READ	0x3c29d7 thru 0x3cd526	(0xab50 bytes)
198541(141 mod 256): MAPREAD	0x29dee thru 0x2ea2c	(0x4c3f bytes)
198542(142 mod 256): WRITE	0x4dfd70 thru 0x4e1103	(0x1394 bytes)
198543(143 mod 256): WRITE	0x461048 thru 0x462168	(0x1121 bytes)
198544(144 mod 256): WRITE	0x77b648 thru 0x77c90b	(0x12c4 bytes) HOLE
198545(145 mod 256): MAPREAD	0x53ff83 thru 0x54ea33	(0xeab1 bytes)
198546(146 mod 256): WRITE	0x28eb13 thru 0x2999c2	(0xaeb0 bytes)
198547(147 mod 256): READ	0x2d2758 thru 0x2e0bef	(0xe498 bytes)
198548(148 mod 256): TRUNCATE DOWN	from 0x77c90c to 0x2614c7
198549(149 mod 256): MAPWRITE 0xc91a0 thru 0xcc0e5	(0x2f46 bytes)
198550(150 mod 256): MAPWRITE 0x4619b6 thru 0x46ce1c	(0xb467 bytes)
198551(151 mod 256): MAPWRITE 0x7eaa3 thru 0x81ce3	(0x3241 bytes)
198552(152 mod 256): MAPWRITE 0x37a5aa thru 0x37e074	(0x3acb bytes)
198553(153 mod 256): WRITE	0x769acc thru 0x76ef8e	(0x54c3 bytes) HOLE
198554(154 mod 256): TRUNCATE DOWN	from 0x76ef8f to 0x252cd5
198555(155 mod 256): MAPWRITE 0x30f332 thru 0x3164e2	(0x71b1 bytes)
198556(156 mod 256): READ	0x23345f thru 0x2389fe	(0x55a0 bytes)
198557(157 mod 256): TRUNCATE DOWN	from 0x3164e3 to 0xb18db
198558(158 mod 256): WRITE	0x13719e thru 0x144cd8	(0xdb3b bytes) HOLE
198559(159 mod 256): READ	0x10cec3 thru 0x1171b6	(0xa2f4 bytes)
198560(160 mod 256): TRUNCATE UP	from 0x144cd9 to 0x7775a8
198561(161 mod 256): MAPREAD	0x46615 thru 0x4deb4	(0x78a0 bytes)
198562(162 mod 256): WRITE	0x6c2434 thru 0x6c6ca1	(0x486e bytes)
198563(163 mod 256): READ	0x127f8c thru 0x12cdb1	(0x4e26 bytes)
198564(164 mod 256): TRUNCATE DOWN	from 0x7775a8 to 0x694e8a
198565(165 mod 256): MAPWRITE 0x431e02 thru 0x436d6d	(0x4f6c bytes)
198566(166 mod 256): TRUNCATE DOWN	from 0x694e8a to 0x688173
198567(167 mod 256): MAPWRITE 0x1c18b5 thru 0x1c493c	(0x3088 bytes)
198568(168 mod 256): READ	0x4fd1b9 thru 0x5088e2	(0xb72a bytes)
198569(169 mod 256): WRITE	0x63cfc6 thru 0x649a5c	(0xca97 bytes)
198570(170 mod 256): WRITE	0x5de453 thru 0x5e6d5a	(0x8908 bytes)
198571(171 mod 256): MAPWRITE 0x66a7f3 thru 0x67296c	(0x817a bytes)
198572(172 mod 256): WRITE	0x6a84bf thru 0x6a9196	(0xcd8 bytes) HOLE
198573(173 mod 256): MAPWRITE 0x331da8 thru 0x33344b	(0x16a4 bytes)
198574(174 mod 256): MAPWRITE 0x3893f1 thru 0x399139	(0xfd49 bytes)
198575(175 mod 256): TRUNCATE DOWN	from 0x6a9197 to 0x44ea79
198576(176 mod 256): WRITE	0xe7d2b thru 0xf46e0	(0xc9b6 bytes)
198577(177 mod 256): TRUNCATE DOWN	from 0x44ea79 to 0x44d10c
198578(178 mod 256): TRUNCATE DOWN	from 0x44d10c to 0x1eab74
198579(179 mod 256): READ	0x170e5e thru 0x173a59	(0x2bfc bytes)
198580(180 mod 256): TRUNCATE UP	from 0x1eab74 to 0x31efc7
198581(181 mod 256): TRUNCATE DOWN	from 0x31efc7 to 0xa4dc8
198582(182 mod 256): TRUNCATE UP	from 0xa4dc8 to 0x58cd38
198583(183 mod 256): WRITE	0x2984ed thru 0x2a10ea	(0x8bfe bytes)
198584(184 mod 256): READ	0x683cf thru 0x75d38	(0xd96a bytes)
198585(185 mod 256): MAPWRITE 0xe062 thru 0x10a0f	(0x29ae bytes)
198586(186 mod 256): WRITE	0x174269 thru 0x1835a9	(0xf341 bytes)
198587(187 mod 256): MAPWRITE 0x12b626 thru 0x13194d	(0x6328 bytes)
198588(188 mod 256): MAPWRITE 0x67c422 thru 0x684b79	(0x8758 bytes)
198589(189 mod 256): TRUNCATE DOWN	from 0x684b7a to 0x534150
198590(190 mod 256): WRITE	0x2fe079 thru 0x3003ee	(0x2376 bytes)
198591(191 mod 256): MAPREAD	0x15540b thru 0x1600d0	(0xacc6 bytes)
198592(192 mod 256): TRUNCATE DOWN	from 0x534150 to 0x456835
198593(193 mod 256): WRITE	0x2fd998 thru 0x30cce4	(0xf34d bytes)
198594(194 mod 256): TRUNCATE DOWN	from 0x456835 to 0x1581ae
198595(195 mod 256): TRUNCATE UP	from 0x1581ae to 0x5e467f
198596(196 mod 256): READ	0x5821c7 thru 0x584607	(0x2441 bytes)
198597(197 mod 256): MAPREAD	0x23786e thru 0x2384fd	(0xc90 bytes)
198598(198 mod 256): MAPWRITE 0x5c15ab thru 0x5cbe4d	(0xa8a3 bytes)
198599(199 mod 256): MAPWRITE 0x276e5 thru 0x32218	(0xab34 bytes)
198600(200 mod 256): TRUNCATE DOWN	from 0x5e467f to 0x56ac04
198601(201 mod 256): MAPREAD	0xe5ca7 thru 0xed726	(0x7a80 bytes)
198602(202 mod 256): MAPWRITE 0x6cf01f thru 0x6d6e9b	(0x7e7d bytes)
198603(203 mod 256): MAPWRITE 0x207495 thru 0x2171d8	(0xfd44 bytes)
198604(204 mod 256): WRITE	0x2f6ac6 thru 0x3068ff	(0xfe3a bytes)
198605(205 mod 256): MAPREAD	0x49cbdf thru 0x4a0a70	(0x3e92 bytes)
198606(206 mod 256): TRUNCATE DOWN	from 0x6d6e9c to 0x1bcdb7
198607(207 mod 256): WRITE	0x632fa6 thru 0x63b409	(0x8464 bytes) HOLE
198608(208 mod 256): MAPREAD	0x20411d thru 0x2075d6	(0x34ba bytes)
198609(209 mod 256): WRITE	0x2fe120 thru 0x303fb0	(0x5e91 bytes)
198610(210 mod 256): READ	0x524da0 thru 0x5252b5	(0x516 bytes)
198611(211 mod 256): TRUNCATE DOWN	from 0x63b40a to 0x3987b0
198612(212 mod 256): MAPREAD	0x1ad828 thru 0x1b3db5	(0x658e bytes)
198613(213 mod 256): TRUNCATE UP	from 0x3987b0 to 0x5ef017
198614(214 mod 256): WRITE	0x1ec569 thru 0x1efad4	(0x356c bytes)
198615(215 mod 256): WRITE	0x5415d0 thru 0x544ebc	(0x38ed bytes)
198616(216 mod 256): WRITE	0xfd2ff thru 0xfe735	(0x1437 bytes)
198617(217 mod 256): READ	0xbd780 thru 0xc543c	(0x7cbd bytes)
198618(218 mod 256): READ	0x4e3786 thru 0x4eb3f0	(0x7c6b bytes)
198619(219 mod 256): WRITE	0x640d4b thru 0x64a3af	(0x9665 bytes) HOLE
198620(220 mod 256): MAPWRITE 0x6a80a3 thru 0x6b5396	(0xd2f4 bytes)
198621(221 mod 256): TRUNCATE UP	from 0x6b5397 to 0x76ddeb
198622(222 mod 256): TRUNCATE DOWN	from 0x76ddeb to 0x36e13d
198623(223 mod 256): TRUNCATE UP	from 0x36e13d to 0x67f4e6
198624(224 mod 256): WRITE	0xddbf0 thru 0xec1d8	(0xe5e9 bytes)
198625(225 mod 256): WRITE	0x42178c thru 0x423d85	(0x25fa bytes)
198626(226 mod 256): READ	0x547ee6 thru 0x556d75	(0xee90 bytes)
198627(227 mod 256): WRITE	0x6fa2df thru 0x6faf4f	(0xc71 bytes) HOLE
198628(228 mod 256): READ	0x23d9aa thru 0x24b588	(0xdbdf bytes)
198629(229 mod 256): MAPWRITE 0x3aa553 thru 0x3b162a	(0x70d8 bytes)
198630(230 mod 256): MAPWRITE 0x4a50f1 thru 0x4afc8e	(0xab9e bytes)
198631(231 mod 256): WRITE	0xb0724 thru 0xbde57	(0xd734 bytes)
198632(232 mod 256): MAPWRITE 0x35b732 thru 0x363172	(0x7a41 bytes)
198633(233 mod 256): WRITE	0x37cca8 thru 0x383b51	(0x6eaa bytes)
198634(234 mod 256): MAPREAD	0xf9b03 thru 0xff15e	(0x565c bytes)
198635(235 mod 256): READ	0xd6f1e thru 0xe60af	(0xf192 bytes)
198636(236 mod 256): WRITE	0xa0746 thru 0xb0487	(0xfd42 bytes)
198637(237 mod 256): WRITE	0x546076 thru 0x54bef3	(0x5e7e bytes)
198638(238 mod 256): READ	0x5aad04 thru 0x5b8844	(0xdb41 bytes)
198639(239 mod 256): READ	0x623c01 thru 0x630ca8	(0xd0a8 bytes)
198640(240 mod 256): MAPREAD	0x8dc49 thru 0x95b13	(0x7ecb bytes)
198641(241 mod 256): MAPREAD	0x3a2d95 thru 0x3a3531	(0x79d bytes)
198642(242 mod 256): MAPREAD	0x543bf3 thru 0x54ffa0	(0xc3ae bytes)
198643(243 mod 256): READ	0x2a13e4 thru 0x2ae14f	(0xcd6c bytes)
198644(244 mod 256): MAPREAD	0x23247a thru 0x23c07a	(0x9c01 bytes)
198645(245 mod 256): WRITE	0x5a6f7e thru 0x5b3a56	(0xcad9 bytes)
198646(246 mod 256): WRITE	0x41e6c thru 0x46ec2	(0x5057 bytes)
198647(247 mod 256): MAPREAD	0x22cb3c thru 0x237111	(0xa5d6 bytes)
198648(248 mod 256): TRUNCATE DOWN	from 0x6faf50 to 0x12b4ff
198649(249 mod 256): WRITE	0x366ff4 thru 0x3715f1	(0xa5fe bytes) HOLE
198650(250 mod 256): READ	0x2b73b7 thru 0x2c301f	(0xbc69 bytes)
198651(251 mod 256): TRUNCATE UP	from 0x3715f2 to 0x508fc4
198652(252 mod 256): MAPREAD	0x1bbcf4 thru 0x1c0882	(0x4b8f bytes)
198653(253 mod 256): MAPWRITE 0x51e5fc thru 0x5236a5	(0x50aa bytes)
198654(254 mod 256): MAPREAD	0x1f2044 thru 0x1fa872	(0x882f bytes)
198655(255 mod 256): TRUNCATE UP	from 0x5236a6 to 0x5241d5
198656(0 mod 256): MAPREAD	0x27accb thru 0x280230	(0x5566 bytes)
198657(1 mod 256): READ	0x2dda68 thru 0x2e712c	(0x96c5 bytes)
198658(2 mod 256): MAPWRITE 0x3c182e thru 0x3ce6bc	(0xce8f bytes)
198659(3 mod 256): WRITE	0x84e56 thru 0x90063	(0xb20e bytes)
198660(4 mod 256): MAPWRITE 0x2b25af thru 0x2c2024	(0xfa76 bytes)
198661(5 mod 256): READ	0x2b2c6b thru 0x2b52a6	(0x263c bytes)
198662(6 mod 256): MAPWRITE 0x64b892 thru 0x6514f3	(0x5c62 bytes)
198663(7 mod 256): MAPWRITE 0x70ab47 thru 0x711ff4	(0x74ae bytes)
198664(8 mod 256): TRUNCATE DOWN	from 0x711ff5 to 0x2440c1
198665(9 mod 256): READ	0xa633e thru 0xb56e8	(0xf3ab bytes)
198666(10 mod 256): TRUNCATE DOWN	from 0x2440c1 to 0x177399
198667(11 mod 256): TRUNCATE DOWN	from 0x177399 to 0x66aa6
198668(12 mod 256): MAPREAD	0x6c99 thru 0x10616	(0x997e bytes)
198669(13 mod 256): MAPREAD	0x5cbae thru 0x5e2bd	(0x1710 bytes)
198670(14 mod 256): READ	0x4a649 thru 0x4e070	(0x3a28 bytes)
198671(15 mod 256): WRITE	0x529006 thru 0x52e3f9	(0x53f4 bytes) HOLE
198672(16 mod 256): TRUNCATE DOWN	from 0x52e3fa to 0x26fd17
198673(17 mod 256): READ	0x4099a thru 0x44fd3	(0x463a bytes)
198674(18 mod 256): MAPREAD	0x17ba64 thru 0x186035	(0xa5d2 bytes)
198675(19 mod 256): MAPREAD	0x134b07 thru 0x14083e	(0xbd38 bytes)
198676(20 mod 256): MAPREAD	0xf24db thru 0xfb29f	(0x8dc5 bytes)
198677(21 mod 256): WRITE	0x52e64c thru 0x5311b2	(0x2b67 bytes) HOLE
198678(22 mod 256): READ	0x148a2f thru 0x157ef0	(0xf4c2 bytes)
198679(23 mod 256): READ	0x107841 thru 0x10f8e9	(0x80a9 bytes)
198680(24 mod 256): MAPREAD	0x4dd975 thru 0x4e4ba8	(0x7234 bytes)
198681(25 mod 256): READ	0x9ab1f thru 0xa6d70	(0xc252 bytes)
198682(26 mod 256): MAPWRITE 0x116c87 thru 0x11d846	(0x6bc0 bytes)
198683(27 mod 256): MAPREAD	0x4b60a5 thru 0x4b9e16	(0x3d72 bytes)
198684(28 mod 256): READ	0x3b001f thru 0x3b1c9a	(0x1c7c bytes)
198685(29 mod 256): MAPWRITE 0xd1a62 thru 0xd7c27	(0x61c6 bytes)
198686(30 mod 256): MAPWRITE 0x257d6d thru 0x258317	(0x5ab bytes)
198687(31 mod 256): TRUNCATE UP	from 0x5311b3 to 0x704067
198688(32 mod 256): MAPREAD	0x6b605e thru 0x6c27b1	(0xc754 bytes)
198689(33 mod 256): MAPREAD	0x2085ca thru 0x20fb2e	(0x7565 bytes)
198690(34 mod 256): MAPWRITE 0x5d8124 thru 0x5e7b07	(0xf9e4 bytes)
198691(35 mod 256): TRUNCATE DOWN	from 0x704067 to 0x5e49bd
198692(36 mod 256): TRUNCATE DOWN	from 0x5e49bd to 0x43339b
198693(37 mod 256): TRUNCATE DOWN	from 0x43339b to 0x112308
198694(38 mod 256): WRITE	0x59a05a thru 0x5a4797	(0xa73e bytes) HOLE
198695(39 mod 256): MAPWRITE 0x2aa571 thru 0x2b5d9e	(0xb82e bytes)
198696(40 mod 256): MAPWRITE 0x4d3871 thru 0x4d66da	(0x2e6a bytes)
198697(41 mod 256): TRUNCATE DOWN	from 0x5a4798 to 0x7c494
198698(42 mod 256): WRITE	0xeb0d0 thru 0xece99	(0x1dca bytes) HOLE
198699(43 mod 256): READ	0xdbcae thru 0xe7e06	(0xc159 bytes)
198700(44 mod 256): READ	0x63cd2 thru 0x66f07	(0x3236 bytes)	***RRRR***
Correct content saved for comparison
(maybe hexdump "/mnt/testfile" vs "/mnt/testfile.fsxgood")

--7AUc2qLy4jB3hD7Z--
