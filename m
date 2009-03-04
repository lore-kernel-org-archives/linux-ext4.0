From: Jan Kara <jack@suse.cz>
Subject: fsx-linux loosing mmap() writes under memory pressure
Date: Wed, 4 Mar 2009 15:51:09 +0100
Message-ID: <20090304145109.GA7140@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Cc: user-mode-linux-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38674 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZCDOvV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 09:51:21 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  first, I'd like to point out that this has happened under UML so it can
be just some obscure bug in that architecture but I belive it's worth
debugging anyway. Now to the problem:
  This has happened with today Linus's git snapshot. The filesystem is ext3
with *1KB* blocksize. I booted UML with 64MB of memory and run (these are
test's from Andrew Morton's torture tests):
  fsx-linux -l 8000000 /mnt/testfile
  bash-shared-mapping -t 8 /mnt/bashfile 50000000
(the second test just makes the UML under memory pressure and stresses the
filesystem, otherwise it does not interact with fsx-linux in any way).
  After some time (like an hour) fsx-linux reported the file is corrupted. I
tried again and it happened again so probably some debugging should be
possible.
  Both times it seems we've simply completely lost a write which happened
through mmap (2 pages in the first case, 3 pages in the second case). Also
I've checked and in the first case no blocks are allocated for the offsets
where the data should be so most probably we've lost the write before
block_write_full_page() called get_block().
  I'll debug this further but I wanted let people know there's some problem
and maybe somebody has some bright idea :).  I'm attaching the log from fsx
if someone is interested. 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--lrZ03NoBR/3+SXJZ
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
truncating to largest ever: 0x7a11a4
READ BAD DATA: offset = 0x207b56, size = 0x49da, fname = /mnt/testfile
OFFSET	GOOD	BAD	RANGE
0x20ad16	0x82b2	0x0000	0x    0
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad17	0xb282	0x0000	0x    1
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad18	0x822c	0x0000	0x    2
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad19	0x2c82	0x0000	0x    3
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad1a	0x8230	0x0000	0x    4
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad1b	0x3082	0x0000	0x    5
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad1c	0x821d	0x0000	0x    6
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad1d	0x1d82	0x0000	0x    7
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad1e	0x82e7	0x0000	0x    8
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad1f	0xe782	0x0000	0x    9
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad20	0x821b	0x0000	0x    a
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad21	0x1b82	0x0000	0x    b
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad22	0x8296	0x0000	0x    c
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad23	0x9682	0x0000	0x    d
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad24	0x82ef	0x0000	0x    e
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x20ad25	0xef82	0x0000	0x    f
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
LOG DUMP (292780 total operations):
292781(173 mod 256): MAPWRITE 0x6a3072 thru 0x6b15c7	(0xe556 bytes)
292782(174 mod 256): TRUNCATE DOWN	from 0x6b15c8 to 0x49fef5
292783(175 mod 256): READ	0xeffcd thru 0xfa9cc	(0xaa00 bytes)
292784(176 mod 256): WRITE	0x16ca03 thru 0x171aab	(0x50a9 bytes)
292785(177 mod 256): MAPREAD	0x2f2709 thru 0x2fdfc0	(0xb8b8 bytes)
292786(178 mod 256): MAPREAD	0x18c788 thru 0x18f608	(0x2e81 bytes)
292787(179 mod 256): WRITE	0x6cd183 thru 0x6d468c	(0x750a bytes) HOLE
292788(180 mod 256): READ	0xd7bd7 thru 0xda4a1	(0x28cb bytes)
292789(181 mod 256): TRUNCATE UP	from 0x6d468d to 0x71fc01
292790(182 mod 256): READ	0x20ebdd thru 0x21e652	(0xfa76 bytes)
292791(183 mod 256): MAPREAD	0x5c59ea thru 0x5cf08b	(0x96a2 bytes)
292792(184 mod 256): MAPWRITE 0x272ea8 thru 0x27dee8	(0xb041 bytes)
292793(185 mod 256): MAPREAD	0x2f49bb thru 0x2fd98f	(0x8fd5 bytes)
292794(186 mod 256): TRUNCATE DOWN	from 0x71fc01 to 0x547768
292795(187 mod 256): READ	0x4f8d7a thru 0x501f4f	(0x91d6 bytes)
292796(188 mod 256): MAPREAD	0x50dd35 thru 0x51363a	(0x5906 bytes)
292797(189 mod 256): WRITE	0x3351b4 thru 0x3389fe	(0x384b bytes)
292798(190 mod 256): WRITE	0x25aa3a thru 0x25ce27	(0x23ee bytes)
292799(191 mod 256): MAPWRITE 0x321506 thru 0x32e912	(0xd40d bytes)
292800(192 mod 256): MAPWRITE 0x45adde thru 0x462336	(0x7559 bytes)
292801(193 mod 256): WRITE	0x740eec thru 0x75088f	(0xf9a4 bytes) HOLE
292802(194 mod 256): WRITE	0x47c30c thru 0x47ec73	(0x2968 bytes)
292803(195 mod 256): MAPREAD	0x2ff2d thru 0x354e8	(0x55bc bytes)
292804(196 mod 256): WRITE	0x3f4c02 thru 0x4017f0	(0xcbef bytes)
292805(197 mod 256): MAPREAD	0x6eb0ea thru 0x6f80cf	(0xcfe6 bytes)
292806(198 mod 256): MAPWRITE 0x3f9d1 thru 0x4d1b9	(0xd7e9 bytes)
292807(199 mod 256): READ	0x2fc20c thru 0x30b4ab	(0xf2a0 bytes)
292808(200 mod 256): MAPWRITE 0x56a403 thru 0x57240a	(0x8008 bytes)
292809(201 mod 256): TRUNCATE DOWN	from 0x750890 to 0x4b63d7
292810(202 mod 256): MAPWRITE 0x507465 thru 0x511e35	(0xa9d1 bytes)
292811(203 mod 256): MAPREAD	0x21374d thru 0x21d861	(0xa115 bytes)
292812(204 mod 256): MAPREAD	0xffec0 thru 0x10f4ce	(0xf60f bytes)
292813(205 mod 256): READ	0x321e50 thru 0x32ab92	(0x8d43 bytes)
292814(206 mod 256): MAPWRITE 0x6ba5fa thru 0x6c8c3c	(0xe643 bytes)
292815(207 mod 256): MAPWRITE 0x161024 thru 0x161629	(0x606 bytes)
292816(208 mod 256): MAPREAD	0xa7a32 thru 0xb05ab	(0x8b7a bytes)
292817(209 mod 256): MAPWRITE 0x22f1a7 thru 0x23bde8	(0xcc42 bytes)
292818(210 mod 256): MAPWRITE 0x21ecd9 thru 0x226fb8	(0x82e0 bytes)
292819(211 mod 256): MAPWRITE 0x5f7f1a thru 0x5fe5fa	(0x66e1 bytes)
292820(212 mod 256): WRITE	0x767211 thru 0x772c6a	(0xba5a bytes) HOLE
292821(213 mod 256): TRUNCATE DOWN	from 0x772c6b to 0x394551
292822(214 mod 256): READ	0x301c9b thru 0x30790c	(0x5c72 bytes)
292823(215 mod 256): TRUNCATE UP	from 0x394551 to 0x4cf3de
292824(216 mod 256): MAPWRITE 0x1a921e thru 0x1b2828	(0x960b bytes)
292825(217 mod 256): WRITE	0x2311b4 thru 0x234765	(0x35b2 bytes)
292826(218 mod 256): TRUNCATE DOWN	from 0x4cf3de to 0x42ef04
292827(219 mod 256): READ	0x3ddc43 thru 0x3e4334	(0x66f2 bytes)
292828(220 mod 256): MAPWRITE 0x22316e thru 0x22fe87	(0xcd1a bytes)
292829(221 mod 256): WRITE	0x38e0d8 thru 0x398eca	(0xadf3 bytes)
292830(222 mod 256): MAPREAD	0x119a78 thru 0x11d4df	(0x3a68 bytes)
292831(223 mod 256): MAPWRITE 0x29d446 thru 0x2ad40b	(0xffc6 bytes)
292832(224 mod 256): MAPREAD	0x13cebd thru 0x148172	(0xb2b6 bytes)
292833(225 mod 256): WRITE	0x434f56 thru 0x43950a	(0x45b5 bytes) HOLE
292834(226 mod 256): WRITE	0x790ab1 thru 0x798bb7	(0x8107 bytes) HOLE
292835(227 mod 256): TRUNCATE DOWN	from 0x798bb8 to 0x571e92
292836(228 mod 256): READ	0x477292 thru 0x47d0dd	(0x5e4c bytes)
292837(229 mod 256): MAPWRITE 0x369061 thru 0x372212	(0x91b2 bytes)
292838(230 mod 256): READ	0x228065 thru 0x23353b	(0xb4d7 bytes)
292839(231 mod 256): MAPWRITE 0x648d84 thru 0x64ee4d	(0x60ca bytes)
292840(232 mod 256): READ	0x3c3f1d thru 0x3c62d0	(0x23b4 bytes)
292841(233 mod 256): MAPREAD	0xe8d06 thru 0xf385c	(0xab57 bytes)
292842(234 mod 256): WRITE	0x50542d thru 0x50d2e4	(0x7eb8 bytes)
292843(235 mod 256): READ	0x4467d5 thru 0x45157a	(0xada6 bytes)
292844(236 mod 256): READ	0x41468d thru 0x41f302	(0xac76 bytes)
292845(237 mod 256): WRITE	0x23ab38 thru 0x23b448	(0x911 bytes)
292846(238 mod 256): WRITE	0x5327d3 thru 0x542320	(0xfb4e bytes)
292847(239 mod 256): WRITE	0x3ccebf thru 0x3d72c6	(0xa408 bytes)
292848(240 mod 256): TRUNCATE DOWN	from 0x64ee4e to 0x1d96c9	******WWWW
292849(241 mod 256): MAPWRITE 0x63825a thru 0x63f5f1	(0x7398 bytes)
292850(242 mod 256): MAPWRITE 0x449826 thru 0x45177b	(0x7f56 bytes)
292851(243 mod 256): MAPREAD	0x1aca9 thru 0x1c7a0	(0x1af8 bytes)
292852(244 mod 256): READ	0x1903c thru 0x1f647	(0x660c bytes)
292853(245 mod 256): WRITE	0xd8a03 thru 0xd9a48	(0x1046 bytes)
292854(246 mod 256): MAPWRITE 0x26b82a thru 0x2767a4	(0xaf7b bytes)
292855(247 mod 256): TRUNCATE UP	from 0x63f5f2 to 0x6c961d
292856(248 mod 256): TRUNCATE DOWN	from 0x6c961d to 0x5bbcba
292857(249 mod 256): TRUNCATE UP	from 0x5bbcba to 0x6a3af7
292858(250 mod 256): READ	0x4acc93 thru 0x4b3723	(0x6a91 bytes)
292859(251 mod 256): MAPWRITE 0x2dfed3 thru 0x2eaf71	(0xb09f bytes)
292860(252 mod 256): MAPREAD	0x518fe4 thru 0x5201ac	(0x71c9 bytes)
292861(253 mod 256): WRITE	0x11db97 thru 0x122022	(0x448c bytes)
292862(254 mod 256): MAPREAD	0xa75e8 thru 0xb1a9a	(0xa4b3 bytes)
292863(255 mod 256): TRUNCATE DOWN	from 0x6a3af7 to 0x2a6a0e
292864(0 mod 256): WRITE	0x22c4b7 thru 0x22d2fb	(0xe45 bytes)
292865(1 mod 256): TRUNCATE UP	from 0x2a6a0e to 0x325aea
292866(2 mod 256): READ	0xf960b thru 0x106e3a	(0xd830 bytes)
292867(3 mod 256): MAPREAD	0x10b62c thru 0x118efb	(0xd8d0 bytes)
292868(4 mod 256): MAPREAD	0xae998 thru 0xb92e1	(0xa94a bytes)
292869(5 mod 256): MAPWRITE 0x5ffdf1 thru 0x6023f7	(0x2607 bytes)
292870(6 mod 256): WRITE	0x6d06b7 thru 0x6d3cfc	(0x3646 bytes) HOLE
292871(7 mod 256): TRUNCATE DOWN	from 0x6d3cfd to 0x6ae343
292872(8 mod 256): READ	0x57b015 thru 0x58a895	(0xf881 bytes)
292873(9 mod 256): READ	0x153255 thru 0x1591b9	(0x5f65 bytes)
292874(10 mod 256): TRUNCATE DOWN	from 0x6ae343 to 0x3f10d4
292875(11 mod 256): WRITE	0x70e3d7 thru 0x7141de	(0x5e08 bytes) HOLE
292876(12 mod 256): WRITE	0x4d2385 thru 0x4df89f	(0xd51b bytes)
292877(13 mod 256): MAPWRITE 0x5cfb10 thru 0x5d4579	(0x4a6a bytes)
292878(14 mod 256): MAPWRITE 0x256c1f thru 0x2653ee	(0xe7d0 bytes)
292879(15 mod 256): MAPWRITE 0x5d30ca thru 0x5dfe52	(0xcd89 bytes)
292880(16 mod 256): MAPREAD	0x131ea0 thru 0x13e210	(0xc371 bytes)
292881(17 mod 256): MAPWRITE 0x64cf45 thru 0x64d389	(0x445 bytes)
292882(18 mod 256): TRUNCATE DOWN	from 0x7141df to 0x12fb4d	******WWWW
292883(19 mod 256): READ	0x87447 thru 0x95de8	(0xe9a2 bytes)
292884(20 mod 256): READ	0x75226 thru 0x78c96	(0x3a71 bytes)
292885(21 mod 256): READ	0x11035f thru 0x117d47	(0x79e9 bytes)
292886(22 mod 256): MAPREAD	0x5d75e thru 0x68d01	(0xb5a4 bytes)
292887(23 mod 256): TRUNCATE UP	from 0x12fb4d to 0x394afc	******WWWW
292888(24 mod 256): MAPREAD	0xae626 thru 0xb8cf8	(0xa6d3 bytes)
292889(25 mod 256): MAPREAD	0x40de1 thru 0x41594	(0x7b4 bytes)
292890(26 mod 256): TRUNCATE UP	from 0x394afc to 0x581bcf
292891(27 mod 256): MAPREAD	0x24db43 thru 0x2525d2	(0x4a90 bytes)
292892(28 mod 256): TRUNCATE DOWN	from 0x581bcf to 0x433f37
292893(29 mod 256): TRUNCATE DOWN	from 0x433f37 to 0xd824a	******WWWW
292894(30 mod 256): TRUNCATE UP	from 0xd824a to 0x189b7c
292895(31 mod 256): MAPWRITE 0x6542d5 thru 0x654f08	(0xc34 bytes)
292896(32 mod 256): MAPWRITE 0x50c42b thru 0x512eaa	(0x6a80 bytes)
292897(33 mod 256): READ	0x2f61b1 thru 0x2ffdad	(0x9bfd bytes)
292898(34 mod 256): TRUNCATE DOWN	from 0x654f09 to 0x5d4e19
292899(35 mod 256): WRITE	0x5aa897 thru 0x5ba705	(0xfe6f bytes)
292900(36 mod 256): WRITE	0x28d2e5 thru 0x298a57	(0xb773 bytes)
292901(37 mod 256): TRUNCATE DOWN	from 0x5d4e19 to 0x5a4730
292902(38 mod 256): TRUNCATE DOWN	from 0x5a4730 to 0x388951
292903(39 mod 256): WRITE	0x4eb61f thru 0x4f5e8e	(0xa870 bytes) HOLE
292904(40 mod 256): READ	0x2a8db8 thru 0x2b56ef	(0xc938 bytes)
292905(41 mod 256): TRUNCATE DOWN	from 0x4f5e8f to 0x39e4e1
292906(42 mod 256): MAPREAD	0x26199b thru 0x26380a	(0x1e70 bytes)
292907(43 mod 256): MAPWRITE 0x73e76 thru 0x7dac2	(0x9c4d bytes)
292908(44 mod 256): MAPREAD	0x3534ef thru 0x357156	(0x3c68 bytes)
292909(45 mod 256): WRITE	0x5e1bbb thru 0x5f105f	(0xf4a5 bytes) HOLE
292910(46 mod 256): MAPREAD	0x9f012 thru 0xa3cd1	(0x4cc0 bytes)
292911(47 mod 256): MAPREAD	0x4034b4 thru 0x40cdc4	(0x9911 bytes)
292912(48 mod 256): MAPREAD	0x2f85e5 thru 0x2fc113	(0x3b2f bytes)
292913(49 mod 256): WRITE	0x12b4c9 thru 0x133388	(0x7ec0 bytes)
292914(50 mod 256): WRITE	0x3a480d thru 0x3a56b9	(0xead bytes)
292915(51 mod 256): MAPREAD	0x5cf650 thru 0x5de028	(0xe9d9 bytes)
292916(52 mod 256): READ	0x55674f thru 0x5601bb	(0x9a6d bytes)
292917(53 mod 256): TRUNCATE DOWN	from 0x5f1060 to 0x2edb8b
292918(54 mod 256): READ	0x6c7be thru 0x70649	(0x3e8c bytes)
292919(55 mod 256): MAPWRITE 0x2c610f thru 0x2cde6e	(0x7d60 bytes)
292920(56 mod 256): READ	0x24b86e thru 0x25a4bb	(0xec4e bytes)
292921(57 mod 256): READ	0x1708b5 thru 0x172402	(0x1b4e bytes)
292922(58 mod 256): MAPWRITE 0x194949 thru 0x196f75	(0x262d bytes)
292923(59 mod 256): MAPREAD	0x22e1d thru 0x30957	(0xdb3b bytes)
292924(60 mod 256): MAPREAD	0x21a99f thru 0x21de70	(0x34d2 bytes)
292925(61 mod 256): READ	0xc0eda thru 0xcccac	(0xbdd3 bytes)
292926(62 mod 256): WRITE	0x343633 thru 0x343a3b	(0x409 bytes) HOLE
292927(63 mod 256): TRUNCATE UP	from 0x343a3c to 0x5d953c
292928(64 mod 256): MAPWRITE 0x21699c thru 0x220369	(0x99ce bytes)
292929(65 mod 256): MAPWRITE 0x5a2680 thru 0x5afc20	(0xd5a1 bytes)
292930(66 mod 256): READ	0x3de0b0 thru 0x3ebde7	(0xdd38 bytes)
292931(67 mod 256): TRUNCATE DOWN	from 0x5d953c to 0x2e707d
292932(68 mod 256): MAPREAD	0x146937 thru 0x14772c	(0xdf6 bytes)
292933(69 mod 256): MAPREAD	0x1fa4 thru 0x572d	(0x378a bytes)
292934(70 mod 256): MAPREAD	0x14b5d8 thru 0x157a17	(0xc440 bytes)
292935(71 mod 256): WRITE	0x590790 thru 0x597f52	(0x77c3 bytes) HOLE
292936(72 mod 256): MAPWRITE 0x347ad2 thru 0x34c52c	(0x4a5b bytes)
292937(73 mod 256): TRUNCATE DOWN	from 0x597f53 to 0x3fa80	******WWWW
292938(74 mod 256): TRUNCATE UP	from 0x3fa80 to 0x5f6e33	******WWWW
292939(75 mod 256): WRITE	0x4769a thru 0x50ff4	(0x995b bytes)
292940(76 mod 256): WRITE	0x72501e thru 0x72774b	(0x272e bytes) HOLE
292941(77 mod 256): MAPREAD	0x532999 thru 0x538bc7	(0x622f bytes)
292942(78 mod 256): WRITE	0x3449d9 thru 0x34ab9c	(0x61c4 bytes)
292943(79 mod 256): WRITE	0x22cccc thru 0x23805c	(0xb391 bytes)
292944(80 mod 256): MAPREAD	0x2ef453 thru 0x2f4a32	(0x55e0 bytes)
292945(81 mod 256): MAPWRITE 0x174482 thru 0x177da7	(0x3926 bytes)
292946(82 mod 256): READ	0x7097e8 thru 0x70a7c9	(0xfe2 bytes)
292947(83 mod 256): MAPREAD	0x39b06c thru 0x3a3d00	(0x8c95 bytes)
292948(84 mod 256): READ	0x59f1ab thru 0x5a0c7d	(0x1ad3 bytes)
292949(85 mod 256): READ	0x1153df thru 0x12494f	(0xf571 bytes)
292950(86 mod 256): MAPREAD	0x1011d3 thru 0x1056e8	(0x4516 bytes)
292951(87 mod 256): READ	0x73bbb thru 0x78bad	(0x4ff3 bytes)
292952(88 mod 256): MAPWRITE 0x3ea4ea thru 0x3ebda8	(0x18bf bytes)
292953(89 mod 256): READ	0x3e29e1 thru 0x3e9143	(0x6763 bytes)
292954(90 mod 256): READ	0x3bb513 thru 0x3c8a40	(0xd52e bytes)
292955(91 mod 256): TRUNCATE DOWN	from 0x72774c to 0x1bb9db	******WWWW
292956(92 mod 256): READ	0x1928 thru 0xde8a	(0xc563 bytes)
292957(93 mod 256): READ	0x676c3 thru 0x687b2	(0x10f0 bytes)
292958(94 mod 256): MAPREAD	0x1b8891 thru 0x1bb9da	(0x314a bytes)
292959(95 mod 256): MAPWRITE 0x836cb thru 0x91806	(0xe13c bytes)
292960(96 mod 256): WRITE	0x28a34d thru 0x28b0cf	(0xd83 bytes) HOLE	***WWWW
292961(97 mod 256): MAPREAD	0x146025 thru 0x14b40b	(0x53e7 bytes)
292962(98 mod 256): WRITE	0x5575f6 thru 0x560578	(0x8f83 bytes) HOLE
292963(99 mod 256): READ	0x3246fc thru 0x326ae5	(0x23ea bytes)
292964(100 mod 256): READ	0x4a08fb thru 0x4aa6b5	(0x9dbb bytes)
292965(101 mod 256): TRUNCATE DOWN	from 0x560579 to 0x1f5c16	******WWWW
292966(102 mod 256): WRITE	0x114472 thru 0x119f23	(0x5ab2 bytes)
292967(103 mod 256): READ	0xd1d56 thru 0xd1f38	(0x1e3 bytes)
292968(104 mod 256): TRUNCATE UP	from 0x1f5c16 to 0x3e17b9	******WWWW
292969(105 mod 256): TRUNCATE DOWN	from 0x3e17b9 to 0x610e1	******WWWW
292970(106 mod 256): TRUNCATE UP	from 0x610e1 to 0x4b48d5	******WWWW
292971(107 mod 256): MAPWRITE 0x3021e4 thru 0x3024d0	(0x2ed bytes)
292972(108 mod 256): READ	0x55a3b thru 0x5e4b6	(0x8a7c bytes)
292973(109 mod 256): WRITE	0xe5000 thru 0xe5c66	(0xc67 bytes)
292974(110 mod 256): TRUNCATE DOWN	from 0x4b48d5 to 0x32cdc7
292975(111 mod 256): WRITE	0x55da62 thru 0x562cdf	(0x527e bytes) HOLE
292976(112 mod 256): WRITE	0x1e0da9 thru 0x1e7583	(0x67db bytes)
292977(113 mod 256): MAPREAD	0x4d43b4 thru 0x4ddfe5	(0x9c32 bytes)
292978(114 mod 256): TRUNCATE UP	from 0x562ce0 to 0x6b7532
292979(115 mod 256): WRITE	0x66aca1 thru 0x672641	(0x79a1 bytes)
292980(116 mod 256): TRUNCATE DOWN	from 0x6b7532 to 0x47ed60
292981(117 mod 256): READ	0x3b96b2 thru 0x3be94d	(0x529c bytes)
292982(118 mod 256): MAPWRITE 0x3f023c thru 0x3fdccb	(0xda90 bytes)
292983(119 mod 256): WRITE	0x493f85 thru 0x4a1a53	(0xdacf bytes) HOLE
292984(120 mod 256): MAPWRITE 0x1b06c8 thru 0x1bfc86	(0xf5bf bytes)
292985(121 mod 256): MAPREAD	0x8b66b thru 0x8dbf1	(0x2587 bytes)
292986(122 mod 256): READ	0x86a8a thru 0x8e282	(0x77f9 bytes)
292987(123 mod 256): MAPWRITE 0x32c733 thru 0x33bc7f	(0xf54d bytes)
292988(124 mod 256): MAPREAD	0x3d6c97 thru 0x3df111	(0x847b bytes)
292989(125 mod 256): WRITE	0x315140 thru 0x3197d6	(0x4697 bytes)
292990(126 mod 256): READ	0xfb584 thru 0x109fde	(0xea5b bytes)
292991(127 mod 256): MAPWRITE 0x73e186 thru 0x73e210	(0x8b bytes)
292992(128 mod 256): MAPREAD	0x339c1e thru 0x33acf8	(0x10db bytes)
292993(129 mod 256): MAPWRITE 0x314b50 thru 0x318c66	(0x4117 bytes)
292994(130 mod 256): MAPWRITE 0x49b8da thru 0x4aa1aa	(0xe8d1 bytes)
292995(131 mod 256): MAPWRITE 0x257469 thru 0x261a3c	(0xa5d4 bytes)
292996(132 mod 256): TRUNCATE DOWN	from 0x73e211 to 0x390ad4
292997(133 mod 256): READ	0x17efe3 thru 0x187d91	(0x8daf bytes)
292998(134 mod 256): TRUNCATE DOWN	from 0x390ad4 to 0xf1b89	******WWWW
292999(135 mod 256): WRITE	0x1006f4 thru 0x10179b	(0x10a8 bytes) HOLE
293000(136 mod 256): WRITE	0xafc71 thru 0xbf429	(0xf7b9 bytes)
292001(161 mod 256): WRITE	0x1cc87 thru 0x2a537	(0xd8b1 bytes)
292002(162 mod 256): READ	0x153f7 thru 0x23d4f	(0xe959 bytes)
292003(163 mod 256): WRITE	0x701160 thru 0x70bce4	(0xab85 bytes) HOLE	***WWWW
292004(164 mod 256): READ	0x5512dd thru 0x552a06	(0x172a bytes)
292005(165 mod 256): READ	0xabbf4 thru 0xb15ad	(0x59ba bytes)
292006(166 mod 256): WRITE	0x1beb5 thru 0x26700	(0xa84c bytes)
292007(167 mod 256): MAPREAD	0x15f46d thru 0x163bff	(0x4793 bytes)
292008(168 mod 256): READ	0x43631b thru 0x43e542	(0x8228 bytes)
292009(169 mod 256): MAPREAD	0x641a83 thru 0x64c68d	(0xac0b bytes)
292010(170 mod 256): WRITE	0x2fc690 thru 0x2fe8a5	(0x2216 bytes)
292011(171 mod 256): READ	0x687b97 thru 0x694b1c	(0xcf86 bytes)
292012(172 mod 256): MAPREAD	0x2a2c42 thru 0x2a7431	(0x47f0 bytes)
292013(173 mod 256): TRUNCATE DOWN	from 0x70bce5 to 0x312202
292014(174 mod 256): MAPREAD	0x168996 thru 0x168e0c	(0x477 bytes)
292015(175 mod 256): READ	0x2da785 thru 0x2e0554	(0x5dd0 bytes)
292016(176 mod 256): WRITE	0x62521c thru 0x634c0d	(0xf9f2 bytes) HOLE
292017(177 mod 256): MAPREAD	0x3d3c8d thru 0x3e1452	(0xd7c6 bytes)
292018(178 mod 256): TRUNCATE DOWN	from 0x634c0e to 0x2d85f	******WWWW
292019(179 mod 256): READ	0x6ab thru 0x5886	(0x51dc bytes)
292020(180 mod 256): MAPWRITE 0x7715fa thru 0x77c338	(0xad3f bytes)
292021(181 mod 256): TRUNCATE DOWN	from 0x77c339 to 0x40cacd
292022(182 mod 256): MAPREAD	0x1dac2a thru 0x1e14f5	(0x68cc bytes)
292023(183 mod 256): MAPWRITE 0x6b1cb thru 0x77d29	(0xcb5f bytes)
292024(184 mod 256): TRUNCATE DOWN	from 0x40cacd to 0x1b0773	******WWWW
292025(185 mod 256): READ	0x120559 thru 0x12d218	(0xccc0 bytes)
292026(186 mod 256): WRITE	0x1c5f8b thru 0x1cb3ff	(0x5475 bytes) HOLE
292027(187 mod 256): TRUNCATE UP	from 0x1cb400 to 0x3f6a1d	******WWWW
292028(188 mod 256): READ	0x101e95 thru 0x10d4d7	(0xb643 bytes)
292029(189 mod 256): WRITE	0x6ac7f4 thru 0x6af22a	(0x2a37 bytes) HOLE
292030(190 mod 256): TRUNCATE DOWN	from 0x6af22b to 0x1c32ca	******WWWW
292031(191 mod 256): READ	0x9a333 thru 0x9fe3f	(0x5b0d bytes)
292032(192 mod 256): WRITE	0x138398 thru 0x14476a	(0xc3d3 bytes)
292033(193 mod 256): READ	0x100728 thru 0x109241	(0x8b1a bytes)
292034(194 mod 256): TRUNCATE UP	from 0x1c32ca to 0x2064fb
292035(195 mod 256): MAPWRITE 0xcc05f thru 0xd57de	(0x9780 bytes)
292036(196 mod 256): TRUNCATE UP	from 0x2064fb to 0x44518c	******WWWW
292037(197 mod 256): MAPWRITE 0x55a013 thru 0x5682f4	(0xe2e2 bytes)
292038(198 mod 256): WRITE	0xf55db thru 0xfb87c	(0x62a2 bytes)
292039(199 mod 256): MAPWRITE 0x620a4b thru 0x628eaa	(0x8460 bytes)
292040(200 mod 256): TRUNCATE DOWN	from 0x628eab to 0x162c13	******WWWW
292041(201 mod 256): MAPREAD	0x143cc1 thru 0x1461a0	(0x24e0 bytes)
292042(202 mod 256): TRUNCATE UP	from 0x162c13 to 0x546c57	******WWWW
292043(203 mod 256): MAPREAD	0x2c9cc6 thru 0x2d0af4	(0x6e2f bytes)
292044(204 mod 256): TRUNCATE DOWN	from 0x546c57 to 0x1d6eec	******WWWW
292045(205 mod 256): TRUNCATE DOWN	from 0x1d6eec to 0x14eb92
292046(206 mod 256): READ	0xe88c2 thru 0xea4ec	(0x1c2b bytes)
292047(207 mod 256): TRUNCATE UP	from 0x14eb92 to 0x57eb43	******WWWW
292048(208 mod 256): MAPREAD	0x4c2bae thru 0x4cbaa3	(0x8ef6 bytes)
292049(209 mod 256): WRITE	0x396518 thru 0x39f0ce	(0x8bb7 bytes)
292050(210 mod 256): READ	0x1cd520 thru 0x1da6a3	(0xd184 bytes)
292051(211 mod 256): MAPWRITE 0x57819 thru 0x5ab12	(0x32fa bytes)
292052(212 mod 256): READ	0x2e965a thru 0x2f61d7	(0xcb7e bytes)
292053(213 mod 256): MAPREAD	0x50c3ef thru 0x51b398	(0xefaa bytes)
292054(214 mod 256): MAPWRITE 0x542f6 thru 0x60277	(0xbf82 bytes)
292055(215 mod 256): READ	0x2ca828 thru 0x2d5942	(0xb11b bytes)
292056(216 mod 256): READ	0x2aa831 thru 0x2ada4e	(0x321e bytes)
292057(217 mod 256): TRUNCATE UP	from 0x57eb43 to 0x6546c4
292058(218 mod 256): MAPREAD	0xdd252 thru 0xec897	(0xf646 bytes)
292059(219 mod 256): WRITE	0x6d7a26 thru 0x6dff6f	(0x854a bytes) HOLE
292060(220 mod 256): TRUNCATE DOWN	from 0x6dff70 to 0x6017ac
292061(221 mod 256): READ	0x1f28c0 thru 0x1ffeb6	(0xd5f7 bytes)
292062(222 mod 256): MAPWRITE 0x388c60 thru 0x38f8a8	(0x6c49 bytes)
292063(223 mod 256): MAPREAD	0x1bc9b9 thru 0x1bcf87	(0x5cf bytes)
292064(224 mod 256): MAPREAD	0x21df31 thru 0x227333	(0x9403 bytes)
292065(225 mod 256): MAPWRITE 0x5b3607 thru 0x5ba579	(0x6f73 bytes)
292066(226 mod 256): READ	0x6aace thru 0x73620	(0x8b53 bytes)
292067(227 mod 256): WRITE	0x296f56 thru 0x299e6c	(0x2f17 bytes)
292068(228 mod 256): MAPWRITE 0x761a7a thru 0x765b67	(0x40ee bytes)
292069(229 mod 256): WRITE	0x30f6ca thru 0x3177cb	(0x8102 bytes)
292070(230 mod 256): WRITE	0x36d751 thru 0x376e89	(0x9739 bytes)
292071(231 mod 256): READ	0x3cd321 thru 0x3d3902	(0x65e2 bytes)
292072(232 mod 256): MAPREAD	0x59d62 thru 0x60ef6	(0x7195 bytes)
292073(233 mod 256): TRUNCATE DOWN	from 0x765b68 to 0x576935
292074(234 mod 256): READ	0x43eb01 thru 0x44514d	(0x664d bytes)
292075(235 mod 256): WRITE	0x6c0d9e thru 0x6c9f2c	(0x918f bytes) HOLE
292076(236 mod 256): MAPWRITE 0x1eda2c thru 0x1f85d3	(0xaba8 bytes)
292077(237 mod 256): TRUNCATE DOWN	from 0x6c9f2d to 0x59b371
292078(238 mod 256): READ	0x3a878c thru 0x3b5636	(0xceab bytes)
292079(239 mod 256): TRUNCATE UP	from 0x59b371 to 0x64addd
292080(240 mod 256): TRUNCATE UP	from 0x64addd to 0x6b3e60
292081(241 mod 256): WRITE	0x16e87e thru 0x17c5e0	(0xdd63 bytes)
292082(242 mod 256): MAPREAD	0x338e12 thru 0x343482	(0xa671 bytes)
292083(243 mod 256): MAPWRITE 0x5d90d3 thru 0x5e35dc	(0xa50a bytes)
292084(244 mod 256): READ	0x2b3055 thru 0x2b5cf6	(0x2ca2 bytes)
292085(245 mod 256): TRUNCATE DOWN	from 0x6b3e60 to 0x1b6721	******WWWW
292086(246 mod 256): TRUNCATE UP	from 0x1b6721 to 0x425359	******WWWW
292087(247 mod 256): READ	0x115863 thru 0x11a879	(0x5017 bytes)
292088(248 mod 256): TRUNCATE DOWN	from 0x425359 to 0x2ede70
292089(249 mod 256): TRUNCATE DOWN	from 0x2ede70 to 0x6e56c	******WWWW
292090(250 mod 256): WRITE	0x379d9c thru 0x381d8b	(0x7ff0 bytes) HOLE	***WWWW
292091(251 mod 256): READ	0x785e1 thru 0x7c777	(0x4197 bytes)
292092(252 mod 256): MAPWRITE 0x47d321 thru 0x486b1e	(0x97fe bytes)
292093(253 mod 256): MAPWRITE 0x10826e thru 0x10db46	(0x58d9 bytes)
292094(254 mod 256): READ	0x19de6a thru 0x1a604d	(0x81e4 bytes)
292095(255 mod 256): MAPREAD	0x398e3d thru 0x39bad7	(0x2c9b bytes)
292096(0 mod 256): MAPWRITE 0x556ba2 thru 0x55ef33	(0x8392 bytes)
292097(1 mod 256): MAPWRITE 0x78f36 thru 0x7f5b8	(0x6683 bytes)
292098(2 mod 256): READ	0x40491f thru 0x4126d2	(0xddb4 bytes)
292099(3 mod 256): MAPREAD	0x506633 thru 0x50c724	(0x60f2 bytes)
292100(4 mod 256): WRITE	0x78ebf3 thru 0x799e4b	(0xb259 bytes) HOLE
292101(5 mod 256): READ	0x5c66c5 thru 0x5cfdfb	(0x9737 bytes)
292102(6 mod 256): MAPWRITE 0x6a3167 thru 0x6a9bae	(0x6a48 bytes)
292103(7 mod 256): TRUNCATE DOWN	from 0x799e4c to 0x118b92	******WWWW
292104(8 mod 256): READ	0xa8cb2 thru 0xb2023	(0x9372 bytes)
292105(9 mod 256): MAPREAD	0xda8e6 thru 0xe9eec	(0xf607 bytes)
292106(10 mod 256): MAPWRITE 0x5125f6 thru 0x515100	(0x2b0b bytes)
292107(11 mod 256): READ	0x25012b thru 0x25a558	(0xa42e bytes)
292108(12 mod 256): MAPWRITE 0x68dec thru 0x6b291	(0x24a6 bytes)
292109(13 mod 256): READ	0xcf35e thru 0xd711f	(0x7dc2 bytes)
292110(14 mod 256): MAPREAD	0x4f0c thru 0xd982	(0x8a77 bytes)
292111(15 mod 256): READ	0x5042a9 thru 0x50bcc6	(0x7a1e bytes)
292112(16 mod 256): TRUNCATE DOWN	from 0x515101 to 0x1237c9	******WWWW
292113(17 mod 256): MAPREAD	0xf9cc8 thru 0xfb015	(0x134e bytes)
292114(18 mod 256): WRITE	0x64cfab thru 0x654d67	(0x7dbd bytes) HOLE	***WWWW
292115(19 mod 256): TRUNCATE DOWN	from 0x654d68 to 0x4663c1
292116(20 mod 256): MAPWRITE 0x5606d2 thru 0x56cba5	(0xc4d4 bytes)
292117(21 mod 256): WRITE	0x4e8f90 thru 0x4f2e73	(0x9ee4 bytes)
292118(22 mod 256): WRITE	0x17f4c thru 0x25572	(0xd627 bytes)
292119(23 mod 256): READ	0x23bc00 thru 0x24abd4	(0xefd5 bytes)
292120(24 mod 256): TRUNCATE UP	from 0x56cba6 to 0x61e3a0
292121(25 mod 256): MAPWRITE 0x3130ad thru 0x316adc	(0x3a30 bytes)
292122(26 mod 256): MAPREAD	0x3f53f9 thru 0x404e84	(0xfa8c bytes)
292123(27 mod 256): READ	0x4c491c thru 0x4c8187	(0x386c bytes)
292124(28 mod 256): TRUNCATE DOWN	from 0x61e3a0 to 0x2e657b
292125(29 mod 256): READ	0x243486 thru 0x249eee	(0x6a69 bytes)
292126(30 mod 256): MAPWRITE 0x26008d thru 0x263b26	(0x3a9a bytes)
292127(31 mod 256): MAPWRITE 0x1a1e51 thru 0x1ad96e	(0xbb1e bytes)
292128(32 mod 256): WRITE	0x69149e thru 0x6980cd	(0x6c30 bytes) HOLE
292129(33 mod 256): MAPWRITE 0x3b7e11 thru 0x3b7f30	(0x120 bytes)
292130(34 mod 256): WRITE	0x291e42 thru 0x299799	(0x7958 bytes)
292131(35 mod 256): MAPREAD	0xe123a thru 0xe4f78	(0x3d3f bytes)
292132(36 mod 256): READ	0x21c402 thru 0x22a1ee	(0xdded bytes)
292133(37 mod 256): TRUNCATE UP	from 0x6980ce to 0x6e70b0
292134(38 mod 256): MAPWRITE 0x97812 thru 0xa24cb	(0xacba bytes)
292135(39 mod 256): TRUNCATE DOWN	from 0x6e70b0 to 0x4005b	******WWWW
292136(40 mod 256): MAPWRITE 0x5d31e0 thru 0x5ddff7	(0xae18 bytes)
292137(41 mod 256): MAPWRITE 0x1939ab thru 0x1961f9	(0x284f bytes)
292138(42 mod 256): READ	0x244558 thru 0x24ca96	(0x853f bytes)
292139(43 mod 256): TRUNCATE DOWN	from 0x5ddff8 to 0x1c55e0	******WWWW
292140(44 mod 256): MAPREAD	0x15db7 thru 0x16183	(0x3cd bytes)
292141(45 mod 256): WRITE	0x3c0a91 thru 0x3c74b8	(0x6a28 bytes) HOLE	***WWWW
292142(46 mod 256): MAPREAD	0x179e09 thru 0x183dfa	(0x9ff2 bytes)
292143(47 mod 256): MAPWRITE 0x4b2e73 thru 0x4b625d	(0x33eb bytes)
292144(48 mod 256): WRITE	0x3702a4 thru 0x37b39b	(0xb0f8 bytes)
292145(49 mod 256): WRITE	0x2520f9 thru 0x25693e	(0x4846 bytes)
292146(50 mod 256): MAPREAD	0x2cd1be thru 0x2d09b1	(0x37f4 bytes)
292147(51 mod 256): TRUNCATE DOWN	from 0x4b625e to 0x1c020c	******WWWW
292148(52 mod 256): MAPREAD	0x92488 thru 0xa2468	(0xffe1 bytes)
292149(53 mod 256): MAPREAD	0x1270e8 thru 0x132aca	(0xb9e3 bytes)
292150(54 mod 256): TRUNCATE UP	from 0x1c020c to 0x3b54d1	******WWWW
292151(55 mod 256): MAPWRITE 0x70b487 thru 0x719a39	(0xe5b3 bytes)
292152(56 mod 256): MAPWRITE 0x39af31 thru 0x3a312c	(0x81fc bytes)
292153(57 mod 256): MAPWRITE 0x12fb52 thru 0x1367af	(0x6c5e bytes)
292154(58 mod 256): TRUNCATE DOWN	from 0x719a3a to 0xbc1fd	******WWWW
292155(59 mod 256): MAPREAD	0x325a thru 0xcdbe	(0x9b65 bytes)
292156(60 mod 256): MAPWRITE 0x8fa5a thru 0x9da42	(0xdfe9 bytes)
292157(61 mod 256): MAPWRITE 0x4c1df2 thru 0x4ca522	(0x8731 bytes)
292158(62 mod 256): READ	0x47d804 thru 0x48662b	(0x8e28 bytes)
292159(63 mod 256): MAPREAD	0x1f4351 thru 0x1ffe9f	(0xbb4f bytes)
292160(64 mod 256): WRITE	0x640d82 thru 0x645e7d	(0x50fc bytes) HOLE
292161(65 mod 256): MAPREAD	0x2bca9a thru 0x2c5d96	(0x92fd bytes)
292162(66 mod 256): WRITE	0x66320 thru 0x6e2bd	(0x7f9e bytes)
292163(67 mod 256): READ	0x16edbb thru 0x175a69	(0x6caf bytes)
292164(68 mod 256): READ	0xc8bb3 thru 0xcef19	(0x6367 bytes)
292165(69 mod 256): WRITE	0x1f48c7 thru 0x1fe6ff	(0x9e39 bytes)
292166(70 mod 256): WRITE	0x3d6c58 thru 0x3e32de	(0xc687 bytes)
292167(71 mod 256): READ	0x29fb1f thru 0x2a8dd3	(0x92b5 bytes)
292168(72 mod 256): TRUNCATE DOWN	from 0x645e7e to 0x31354	******WWWW
292169(73 mod 256): MAPWRITE 0x3653e6 thru 0x370299	(0xaeb4 bytes)
292170(74 mod 256): WRITE	0x98feb thru 0x9d47f	(0x4495 bytes)
292171(75 mod 256): MAPWRITE 0x69e705 thru 0x6aa87b	(0xc177 bytes)
292172(76 mod 256): MAPREAD	0x29d3ac thru 0x2a128b	(0x3ee0 bytes)
292173(77 mod 256): TRUNCATE DOWN	from 0x6aa87c to 0x1f173b	******WWWW
292174(78 mod 256): MAPWRITE 0x40d41e thru 0x41815e	(0xad41 bytes)
292175(79 mod 256): READ	0xde8bc thru 0xe25c3	(0x3d08 bytes)
292176(80 mod 256): MAPREAD	0x2095d4 thru 0x217c31	(0xe65e bytes)	***RRRR***
292177(81 mod 256): MAPWRITE 0x4aeac0 thru 0x4b2dbf	(0x4300 bytes)
292178(82 mod 256): MAPWRITE 0x4149b thru 0x4f171	(0xdcd7 bytes)
292179(83 mod 256): TRUNCATE DOWN	from 0x4b2dc0 to 0x68ea5	******WWWW
292180(84 mod 256): READ	0x8355 thru 0x89e6	(0x692 bytes)
292181(85 mod 256): READ	0x196cd thru 0x251d4	(0xbb08 bytes)
292182(86 mod 256): MAPWRITE 0x721204 thru 0x729052	(0x7e4f bytes)
292183(87 mod 256): READ	0xbcb2b thru 0xc52fd	(0x87d3 bytes)
292184(88 mod 256): MAPREAD	0x6733a2 thru 0x682ed6	(0xfb35 bytes)
292185(89 mod 256): READ	0x2c9ead thru 0x2cdf16	(0x406a bytes)
292186(90 mod 256): TRUNCATE DOWN	from 0x729053 to 0x68da2b
292187(91 mod 256): MAPREAD	0x640ab thru 0x6ee2e	(0xad84 bytes)
292188(92 mod 256): WRITE	0x6cbad1 thru 0x6da86e	(0xed9e bytes) HOLE
292189(93 mod 256): TRUNCATE UP	from 0x6da86f to 0x76737f
292190(94 mod 256): TRUNCATE DOWN	from 0x76737f to 0x22adb5
292191(95 mod 256): WRITE	0x5a4d2c thru 0x5ae347	(0x961c bytes) HOLE
292192(96 mod 256): WRITE	0x77f04f thru 0x787ced	(0x8c9f bytes) HOLE
292193(97 mod 256): MAPWRITE 0xb669d thru 0xb7b92	(0x14f6 bytes)
292194(98 mod 256): MAPREAD	0x1e066b thru 0x1e9ae1	(0x9477 bytes)
292195(99 mod 256): MAPWRITE 0x6556df thru 0x661423	(0xbd45 bytes)
292196(100 mod 256): READ	0xcd3c9 thru 0xd7df2	(0xaa2a bytes)
292197(101 mod 256): WRITE	0x2bdf51 thru 0x2c09ad	(0x2a5d bytes)
292198(102 mod 256): TRUNCATE DOWN	from 0x787cee to 0x74bc4c
292199(103 mod 256): WRITE	0x193b54 thru 0x19d810	(0x9cbd bytes)
292200(104 mod 256): MAPWRITE 0x9f844 thru 0xa0192	(0x94f bytes)
292201(105 mod 256): READ	0x9cbe9 thru 0xa9873	(0xcc8b bytes)
292202(106 mod 256): READ	0x457227 thru 0x463834	(0xc60e bytes)
292203(107 mod 256): MAPREAD	0x30c5cc thru 0x30d4f5	(0xf2a bytes)
292204(108 mod 256): MAPWRITE 0x7591e7 thru 0x76280f	(0x9629 bytes)
292205(109 mod 256): MAPWRITE 0x2cbc0c thru 0x2d19e1	(0x5dd6 bytes)
292206(110 mod 256): READ	0xf922f thru 0xff335	(0x6107 bytes)
292207(111 mod 256): MAPREAD	0x583f1d thru 0x584046	(0x12a bytes)
292208(112 mod 256): READ	0x690ec7 thru 0x6954f5	(0x462f bytes)
292209(113 mod 256): MAPWRITE 0x2b6a43 thru 0x2c6898	(0xfe56 bytes)
292210(114 mod 256): MAPREAD	0x4c15a6 thru 0x4c2561	(0xfbc bytes)
292211(115 mod 256): MAPWRITE 0x53152e thru 0x53efd5	(0xdaa8 bytes)
292212(116 mod 256): TRUNCATE DOWN	from 0x762810 to 0x2b8946
292213(117 mod 256): MAPREAD	0x121b45 thru 0x12c7d7	(0xac93 bytes)
292214(118 mod 256): WRITE	0x6f3e9b thru 0x701f2a	(0xe090 bytes) HOLE
292215(119 mod 256): READ	0x2bb2dc thru 0x2bdad2	(0x27f7 bytes)
292216(120 mod 256): READ	0x518bc3 thru 0x51973e	(0xb7c bytes)
292217(121 mod 256): READ	0x27774e thru 0x27a048	(0x28fb bytes)
292218(122 mod 256): WRITE	0x3bc50c thru 0x3bee7d	(0x2972 bytes)
292219(123 mod 256): MAPREAD	0x3a7175 thru 0x3b065b	(0x94e7 bytes)
292220(124 mod 256): MAPWRITE 0x20e78e thru 0x212844	(0x40b7 bytes)
292221(125 mod 256): TRUNCATE DOWN	from 0x701f2b to 0x5a342a
292222(126 mod 256): READ	0x59905a thru 0x5a3429	(0xa3d0 bytes)
292223(127 mod 256): READ	0x58a9c7 thru 0x58cbd3	(0x220d bytes)
292224(128 mod 256): MAPWRITE 0x488c0d thru 0x490e6a	(0x825e bytes)
292225(129 mod 256): MAPWRITE 0x36ecb1 thru 0x3757da	(0x6b2a bytes)
292226(130 mod 256): TRUNCATE DOWN	from 0x5a342a to 0x1fe7fe	******WWWW
292227(131 mod 256): TRUNCATE UP	from 0x1fe7fe to 0x6ecd8b	******WWWW
292228(132 mod 256): TRUNCATE DOWN	from 0x6ecd8b to 0x4ea8a2
292229(133 mod 256): TRUNCATE DOWN	from 0x4ea8a2 to 0x20d362
292230(134 mod 256): READ	0x810f6 thru 0x88d5e	(0x7c69 bytes)
292231(135 mod 256): MAPREAD	0x932f1 thru 0xa1943	(0xe653 bytes)
292232(136 mod 256): MAPWRITE 0x72a55f thru 0x72e873	(0x4315 bytes)
292233(137 mod 256): TRUNCATE DOWN	from 0x72e874 to 0x6216c	******WWWW
292234(138 mod 256): MAPWRITE 0x10e573 thru 0x11d25d	(0xeceb bytes)
292235(139 mod 256): READ	0x2ff37 thru 0x3996e	(0x9a38 bytes)
292236(140 mod 256): READ	0xa152d thru 0xa504b	(0x3b1f bytes)
292237(141 mod 256): TRUNCATE DOWN	from 0x11d25e to 0xa7da4
292238(142 mod 256): TRUNCATE UP	from 0xa7da4 to 0x2b0ef8	******WWWW
292239(143 mod 256): MAPWRITE 0x59e519 thru 0x5ac273	(0xdd5b bytes)
292240(144 mod 256): TRUNCATE DOWN	from 0x5ac274 to 0x5590b2
292241(145 mod 256): READ	0x220b2f thru 0x22eb85	(0xe057 bytes)
292242(146 mod 256): WRITE	0x36fd48 thru 0x3780f6	(0x83af bytes)
292243(147 mod 256): TRUNCATE DOWN	from 0x5590b2 to 0x11270f	******WWWW
292244(148 mod 256): MAPREAD	0x9a688 thru 0x9ecd6	(0x464f bytes)
292245(149 mod 256): WRITE	0x3e4f08 thru 0x3eecea	(0x9de3 bytes) HOLE	***WWWW
292246(150 mod 256): WRITE	0x10e904 thru 0x117630	(0x8d2d bytes)
292247(151 mod 256): TRUNCATE DOWN	from 0x3eeceb to 0x3e5cc0
292248(152 mod 256): READ	0x16f13b thru 0x17ddb5	(0xec7b bytes)
292249(153 mod 256): WRITE	0x11b001 thru 0x12519e	(0xa19e bytes)
292250(154 mod 256): TRUNCATE DOWN	from 0x3e5cc0 to 0x37dcc9
292251(155 mod 256): READ	0x233653 thru 0x23e781	(0xb12f bytes)
292252(156 mod 256): TRUNCATE UP	from 0x37dcc9 to 0x757a77
292253(157 mod 256): WRITE	0x2901bc thru 0x29f36a	(0xf1af bytes)
292254(158 mod 256): READ	0x20bb38 thru 0x21628a	(0xa753 bytes)	***RRRR***
292255(159 mod 256): READ	0x4fa097 thru 0x4fc24d	(0x21b7 bytes)
292256(160 mod 256): WRITE	0x34a653 thru 0x355d04	(0xb6b2 bytes)
292257(161 mod 256): WRITE	0x2557f6 thru 0x25ffca	(0xa7d5 bytes)
292258(162 mod 256): WRITE	0x158190 thru 0x160368	(0x81d9 bytes)
292259(163 mod 256): READ	0x3d209e thru 0x3dd48f	(0xb3f2 bytes)
292260(164 mod 256): WRITE	0xa6212 thru 0xadbd9	(0x79c8 bytes)
292261(165 mod 256): WRITE	0x718f97 thru 0x720a51	(0x7abb bytes)
292262(166 mod 256): WRITE	0x2590e3 thru 0x25b821	(0x273f bytes)
292263(167 mod 256): MAPREAD	0x5d6a41 thru 0x5e0acc	(0xa08c bytes)
292264(168 mod 256): READ	0x48863f thru 0x48e992	(0x6354 bytes)
292265(169 mod 256): TRUNCATE DOWN	from 0x757a77 to 0x2f30da
292266(170 mod 256): MAPWRITE 0x568b48 thru 0x56f52b	(0x69e4 bytes)
292267(171 mod 256): TRUNCATE DOWN	from 0x56f52c to 0x3a5b0	******WWWW
292268(172 mod 256): READ	0x2c60 thru 0x5c35	(0x2fd6 bytes)
292269(173 mod 256): READ	0x7463 thru 0x7c24	(0x7c2 bytes)
292270(174 mod 256): MAPREAD	0x671a thru 0x111a4	(0xaa8b bytes)
292271(175 mod 256): WRITE	0x3ca000 thru 0x3ca680	(0x681 bytes) HOLE	***WWWW
292272(176 mod 256): MAPWRITE 0x64797d thru 0x648f2a	(0x15ae bytes)
292273(177 mod 256): WRITE	0x486334 thru 0x493e8f	(0xdb5c bytes)
292274(178 mod 256): TRUNCATE DOWN	from 0x648f2b to 0x357581
292275(179 mod 256): READ	0x14faba thru 0x15b651	(0xbb98 bytes)
292276(180 mod 256): MAPWRITE 0x3ca63a thru 0x3cdf64	(0x392b bytes)
292277(181 mod 256): MAPWRITE 0x1e8f21 thru 0x1f5f40	(0xd020 bytes)
292278(182 mod 256): READ	0xa0ad5 thru 0xa21a7	(0x16d3 bytes)
292279(183 mod 256): MAPWRITE 0x1db557 thru 0x1e7ee7	(0xc991 bytes)
292280(184 mod 256): READ	0x2f2208 thru 0x2fde7f	(0xbc78 bytes)
292281(185 mod 256): MAPREAD	0x2aae thru 0x5c89	(0x31dc bytes)
292282(186 mod 256): TRUNCATE UP	from 0x3cdf65 to 0x74468f
292283(187 mod 256): READ	0xacfb2 thru 0xb09d2	(0x3a21 bytes)
292284(188 mod 256): MAPWRITE 0x266a20 thru 0x26a08f	(0x3670 bytes)
292285(189 mod 256): WRITE	0x3c018e thru 0x3cf2f0	(0xf163 bytes)
292286(190 mod 256): READ	0x726940 thru 0x728525	(0x1be6 bytes)
292287(191 mod 256): TRUNCATE DOWN	from 0x74468f to 0x63791f
292288(192 mod 256): MAPWRITE 0x73052b thru 0x7366ca	(0x61a0 bytes)
292289(193 mod 256): READ	0x696fee thru 0x6a22dd	(0xb2f0 bytes)
292290(194 mod 256): READ	0x464e8d thru 0x46869a	(0x380e bytes)
292291(195 mod 256): MAPREAD	0x723349 thru 0x730fcf	(0xdc87 bytes)
292292(196 mod 256): TRUNCATE DOWN	from 0x7366cb to 0x2b0ce	******WWWW
292293(197 mod 256): MAPREAD	0x28b7c thru 0x2b0cd	(0x2552 bytes)
292294(198 mod 256): READ	0x2c6a thru 0x5471	(0x2808 bytes)
292295(199 mod 256): WRITE	0x30949 thru 0x351c8	(0x4880 bytes) HOLE
292296(200 mod 256): WRITE	0xbb508 thru 0xc1e9d	(0x6996 bytes) HOLE
292297(201 mod 256): TRUNCATE UP	from 0xc1e9e to 0x2576dc	******WWWW
292298(202 mod 256): MAPWRITE 0x31a9ad thru 0x327928	(0xcf7c bytes)
292299(203 mod 256): READ	0x2af8b3 thru 0x2b3061	(0x37af bytes)
292300(204 mod 256): MAPREAD	0x207302 thru 0x209187	(0x1e86 bytes)
292301(205 mod 256): READ	0x829f7 thru 0x87dd3	(0x53dd bytes)
292302(206 mod 256): READ	0x2630bd thru 0x266717	(0x365b bytes)
292303(207 mod 256): WRITE	0x19239c thru 0x19ece0	(0xc945 bytes)
292304(208 mod 256): TRUNCATE UP	from 0x327929 to 0x4fd8ad
292305(209 mod 256): MAPWRITE 0x2b8d1 thru 0x358ec	(0xa01c bytes)
292306(210 mod 256): MAPREAD	0x19dd44 thru 0x19f354	(0x1611 bytes)
292307(211 mod 256): TRUNCATE DOWN	from 0x4fd8ad to 0x4fad76
292308(212 mod 256): WRITE	0x10c70e thru 0x117cbe	(0xb5b1 bytes)
292309(213 mod 256): MAPWRITE 0x406c74 thru 0x415013	(0xe3a0 bytes)
292310(214 mod 256): MAPWRITE 0x310b6e thru 0x311f95	(0x1428 bytes)
292311(215 mod 256): WRITE	0x3e4736 thru 0x3e8437	(0x3d02 bytes)
292312(216 mod 256): TRUNCATE UP	from 0x4fad76 to 0x75e374
292313(217 mod 256): MAPREAD	0x663bec thru 0x66fa98	(0xbead bytes)
292314(218 mod 256): MAPREAD	0x70db29 thru 0x715468	(0x7940 bytes)
292315(219 mod 256): MAPREAD	0x552c87 thru 0x558924	(0x5c9e bytes)
292316(220 mod 256): MAPWRITE 0x1e4844 thru 0x1ea785	(0x5f42 bytes)
292317(221 mod 256): WRITE	0x53df35 thru 0x544286	(0x6352 bytes)
292318(222 mod 256): MAPWRITE 0xe4484 thru 0xf0a09	(0xc586 bytes)
292319(223 mod 256): MAPWRITE 0x31eb6c thru 0x3203ae	(0x1843 bytes)
292320(224 mod 256): WRITE	0x67e906 thru 0x682385	(0x3a80 bytes)
292321(225 mod 256): READ	0x63a357 thru 0x63a770	(0x41a bytes)
292322(226 mod 256): TRUNCATE DOWN	from 0x75e374 to 0x245c13
292323(227 mod 256): WRITE	0x26339d thru 0x2703e7	(0xd04b bytes) HOLE
292324(228 mod 256): MAPWRITE 0x13055f thru 0x13c2af	(0xbd51 bytes)
292325(229 mod 256): MAPREAD	0xbe013 thru 0xc91e9	(0xb1d7 bytes)
292326(230 mod 256): READ	0x61dbf thru 0x6b007	(0x9249 bytes)
292327(231 mod 256): MAPWRITE 0x1df893 thru 0x1e4606	(0x4d74 bytes)
292328(232 mod 256): WRITE	0x2dd2d8 thru 0x2e9fb1	(0xccda bytes) HOLE
292329(233 mod 256): WRITE	0x494acf thru 0x49c0b8	(0x75ea bytes) HOLE
292330(234 mod 256): TRUNCATE DOWN	from 0x49c0b9 to 0x29037b
292331(235 mod 256): TRUNCATE UP	from 0x29037b to 0x36fd1b
292332(236 mod 256): MAPREAD	0x2cea82 thru 0x2d322c	(0x47ab bytes)
292333(237 mod 256): MAPREAD	0x175bec thru 0x176ed1	(0x12e6 bytes)
292334(238 mod 256): READ	0x2c26d2 thru 0x2d253f	(0xfe6e bytes)
292335(239 mod 256): READ	0x3623df thru 0x36269d	(0x2bf bytes)
292336(240 mod 256): READ	0x1c92e0 thru 0x1d1246	(0x7f67 bytes)
292337(241 mod 256): WRITE	0x5e7970 thru 0x5ee9c1	(0x7052 bytes) HOLE
292338(242 mod 256): WRITE	0x6514a7 thru 0x65f17a	(0xdcd4 bytes) HOLE
292339(243 mod 256): WRITE	0x3f8b94 thru 0x401800	(0x8c6d bytes)
292340(244 mod 256): MAPWRITE 0x62ab93 thru 0x637904	(0xcd72 bytes)
292341(245 mod 256): MAPREAD	0x616a42 thru 0x623dcd	(0xd38c bytes)
292342(246 mod 256): TRUNCATE DOWN	from 0x65f17b to 0x55f252
292343(247 mod 256): MAPWRITE 0x39fd85 thru 0x3ab388	(0xb604 bytes)
292344(248 mod 256): MAPWRITE 0x41728a thru 0x4202da	(0x9051 bytes)
292345(249 mod 256): MAPWRITE 0x2e05fd thru 0x2e6d93	(0x6797 bytes)
292346(250 mod 256): READ	0x1809ab thru 0x18944b	(0x8aa1 bytes)
292347(251 mod 256): TRUNCATE UP	from 0x55f252 to 0x689c5e
292348(252 mod 256): TRUNCATE DOWN	from 0x689c5e to 0x1d63a0	******WWWW
292349(253 mod 256): TRUNCATE UP	from 0x1d63a0 to 0x36fe41	******WWWW
292350(254 mod 256): MAPREAD	0x2458a5 thru 0x2469be	(0x111a bytes)
292351(255 mod 256): TRUNCATE DOWN	from 0x36fe41 to 0x1d2ca1	******WWWW
292352(0 mod 256): MAPREAD	0x21975 thru 0x2b2c2	(0x994e bytes)
292353(1 mod 256): TRUNCATE UP	from 0x1d2ca1 to 0x45b4c0	******WWWW
292354(2 mod 256): TRUNCATE UP	from 0x45b4c0 to 0x5016aa
292355(3 mod 256): WRITE	0x414677 thru 0x41dc76	(0x9600 bytes)
292356(4 mod 256): TRUNCATE DOWN	from 0x5016aa to 0x4b7945
292357(5 mod 256): READ	0x1303f4 thru 0x1371d7	(0x6de4 bytes)
292358(6 mod 256): MAPWRITE 0xe6d35 thru 0xede96	(0x7162 bytes)
292359(7 mod 256): MAPREAD	0x4a1b39 thru 0x4a699a	(0x4e62 bytes)
292360(8 mod 256): TRUNCATE DOWN	from 0x4b7945 to 0x2d49f4
292361(9 mod 256): MAPWRITE 0x65b7f4 thru 0x6685a5	(0xcdb2 bytes)
292362(10 mod 256): READ	0x649e6c thru 0x6557f2	(0xb987 bytes)
292363(11 mod 256): MAPREAD	0x1b18b4 thru 0x1b6bdd	(0x532a bytes)
292364(12 mod 256): MAPWRITE 0x6d931e thru 0x6e73e1	(0xe0c4 bytes)
292365(13 mod 256): MAPWRITE 0x306b0a thru 0x30d72c	(0x6c23 bytes)
292366(14 mod 256): TRUNCATE UP	from 0x6e73e2 to 0x70e856
292367(15 mod 256): MAPWRITE 0xac57b thru 0xae48a	(0x1f10 bytes)
292368(16 mod 256): MAPWRITE 0x683db1 thru 0x686d30	(0x2f80 bytes)
292369(17 mod 256): WRITE	0x6d6237 thru 0x6d89bb	(0x2785 bytes)
292370(18 mod 256): MAPWRITE 0x3b89ba thru 0x3c14ed	(0x8b34 bytes)
292371(19 mod 256): READ	0x565d08 thru 0x56e1ed	(0x84e6 bytes)
292372(20 mod 256): MAPREAD	0x2cafb7 thru 0x2ce888	(0x38d2 bytes)
292373(21 mod 256): READ	0x5114d9 thru 0x5138b7	(0x23df bytes)
292374(22 mod 256): WRITE	0x5d15c8 thru 0x5d1e6e	(0x8a7 bytes)
292375(23 mod 256): MAPWRITE 0x6de63 thru 0x6e552	(0x6f0 bytes)
292376(24 mod 256): TRUNCATE DOWN	from 0x70e856 to 0x41395f
292377(25 mod 256): WRITE	0x93322 thru 0x9e3f7	(0xb0d6 bytes)
292378(26 mod 256): WRITE	0x1e006 thru 0x2be02	(0xddfd bytes)
292379(27 mod 256): TRUNCATE UP	from 0x41395f to 0x625dc5
292380(28 mod 256): WRITE	0x1f0992 thru 0x1fd86a	(0xced9 bytes)
292381(29 mod 256): MAPREAD	0x421f9e thru 0x42cd7f	(0xade2 bytes)
292382(30 mod 256): MAPWRITE 0x6e01f8 thru 0x6ea6b2	(0xa4bb bytes)
292383(31 mod 256): READ	0x301f42 thru 0x3038b8	(0x1977 bytes)
292384(32 mod 256): MAPREAD	0x29b8b1 thru 0x29c783	(0xed3 bytes)
292385(33 mod 256): MAPWRITE 0x3f4b29 thru 0x401184	(0xc65c bytes)
292386(34 mod 256): MAPWRITE 0x5e8450 thru 0x5f4a29	(0xc5da bytes)
292387(35 mod 256): READ	0x6bce28 thru 0x6bf60b	(0x27e4 bytes)
292388(36 mod 256): MAPREAD	0x56e2fb thru 0x575065	(0x6d6b bytes)
292389(37 mod 256): READ	0x39cd5e thru 0x3a1c10	(0x4eb3 bytes)
292390(38 mod 256): TRUNCATE DOWN	from 0x6ea6b3 to 0x1ba887	******WWWW
292391(39 mod 256): TRUNCATE DOWN	from 0x1ba887 to 0x8ba9b
292392(40 mod 256): TRUNCATE UP	from 0x8ba9b to 0x6e8969	******WWWW
292393(41 mod 256): TRUNCATE DOWN	from 0x6e8969 to 0x1e049c	******WWWW
292394(42 mod 256): WRITE	0x6d529a thru 0x6e3bc4	(0xe92b bytes) HOLE	***WWWW
292395(43 mod 256): MAPWRITE 0x27dfac thru 0x2836dc	(0x5731 bytes)
292396(44 mod 256): WRITE	0x12178d thru 0x12f480	(0xdcf4 bytes)
292397(45 mod 256): READ	0x226891 thru 0x22f70f	(0x8e7f bytes)
292398(46 mod 256): READ	0x25de3e thru 0x2649d1	(0x6b94 bytes)
292399(47 mod 256): WRITE	0x513cdc thru 0x52388c	(0xfbb1 bytes)
292400(48 mod 256): READ	0x2a8298 thru 0x2b3a85	(0xb7ee bytes)
292401(49 mod 256): WRITE	0x73fe30 thru 0x7421aa	(0x237b bytes) HOLE
292402(50 mod 256): TRUNCATE DOWN	from 0x7421ab to 0x71e679
292403(51 mod 256): READ	0x6bf9b2 thru 0x6ccaf2	(0xd141 bytes)
292404(52 mod 256): WRITE	0x73ddd2 thru 0x744ee4	(0x7113 bytes) HOLE
292405(53 mod 256): MAPREAD	0x234e8a thru 0x23a388	(0x54ff bytes)
292406(54 mod 256): READ	0xc9ab4 thru 0xccd88	(0x32d5 bytes)
292407(55 mod 256): TRUNCATE DOWN	from 0x744ee5 to 0x34d60e
292408(56 mod 256): MAPREAD	0x21a721 thru 0x22a417	(0xfcf7 bytes)
292409(57 mod 256): MAPREAD	0x2d530e thru 0x2dccb6	(0x79a9 bytes)
292410(58 mod 256): MAPWRITE 0x24c599 thru 0x24c60e	(0x76 bytes)
292411(59 mod 256): READ	0x12835a thru 0x137424	(0xf0cb bytes)
292412(60 mod 256): MAPWRITE 0x3e2cc6 thru 0x3e3840	(0xb7b bytes)
292413(61 mod 256): MAPREAD	0x56264 thru 0x5bf28	(0x5cc5 bytes)
292414(62 mod 256): TRUNCATE UP	from 0x3e3841 to 0x3fd1f1
292415(63 mod 256): WRITE	0x34c8da thru 0x35878e	(0xbeb5 bytes)
292416(64 mod 256): TRUNCATE UP	from 0x3fd1f1 to 0x65ff81
292417(65 mod 256): READ	0x521d5d thru 0x523da5	(0x2049 bytes)
292418(66 mod 256): TRUNCATE DOWN	from 0x65ff81 to 0x2f2114
292419(67 mod 256): WRITE	0x76f3d7 thru 0x77e144	(0xed6e bytes) HOLE
292420(68 mod 256): WRITE	0x389092 thru 0x397f3f	(0xeeae bytes)
292421(69 mod 256): READ	0x6433c3 thru 0x648e0f	(0x5a4d bytes)
292422(70 mod 256): READ	0x3ba08c thru 0x3bfa48	(0x59bd bytes)
292423(71 mod 256): READ	0x6dedcd thru 0x6e4cfb	(0x5f2f bytes)
292424(72 mod 256): MAPREAD	0x6cd519 thru 0x6dbcb6	(0xe79e bytes)
292425(73 mod 256): MAPWRITE 0x25e1e1 thru 0x263c2c	(0x5a4c bytes)
292426(74 mod 256): MAPWRITE 0x4db8bf thru 0x4ea008	(0xe74a bytes)
292427(75 mod 256): TRUNCATE DOWN	from 0x77e145 to 0x4ce066
292428(76 mod 256): WRITE	0x69bd87 thru 0x6a341d	(0x7697 bytes) HOLE
292429(77 mod 256): WRITE	0x4aec46 thru 0x4bd80e	(0xebc9 bytes)
292430(78 mod 256): TRUNCATE DOWN	from 0x6a341e to 0x11084d	******WWWW
292431(79 mod 256): READ	0xf275a thru 0xf6fc9	(0x4870 bytes)
292432(80 mod 256): WRITE	0x4e01c4 thru 0x4e147d	(0x12ba bytes) HOLE	***WWWW
292433(81 mod 256): MAPREAD	0x49bba0 thru 0x49bccc	(0x12d bytes)
292434(82 mod 256): MAPWRITE 0x61783e thru 0x6234d5	(0xbc98 bytes)
292435(83 mod 256): READ	0x55558c thru 0x55d3c3	(0x7e38 bytes)
292436(84 mod 256): TRUNCATE DOWN	from 0x6234d6 to 0x2ca260
292437(85 mod 256): TRUNCATE UP	from 0x2ca260 to 0x6b5171
292438(86 mod 256): MAPREAD	0x51ab15 thru 0x52118c	(0x6678 bytes)
292439(87 mod 256): MAPWRITE 0x8b5fd thru 0x8ec3c	(0x3640 bytes)
292440(88 mod 256): MAPWRITE 0x3552a1 thru 0x35a28c	(0x4fec bytes)
292441(89 mod 256): TRUNCATE DOWN	from 0x6b5171 to 0x1314c4	******WWWW
292442(90 mod 256): WRITE	0x60ba99 thru 0x6113ac	(0x5914 bytes) HOLE	***WWWW
292443(91 mod 256): MAPWRITE 0x798260 thru 0x7a11ff	(0x8fa0 bytes)
292444(92 mod 256): MAPREAD	0x689e8d thru 0x68f25d	(0x53d1 bytes)
292445(93 mod 256): WRITE	0x74b788 thru 0x74c964	(0x11dd bytes)
292446(94 mod 256): MAPWRITE 0x738976 thru 0x7416da	(0x8d65 bytes)
292447(95 mod 256): MAPREAD	0x7986dd thru 0x79c00a	(0x392e bytes)
292448(96 mod 256): TRUNCATE DOWN	from 0x7a1200 to 0x275349
292449(97 mod 256): MAPREAD	0x19ecf0 thru 0x1a4efe	(0x620f bytes)
292450(98 mod 256): WRITE	0x56e677 thru 0x573bf1	(0x557b bytes) HOLE
292451(99 mod 256): WRITE	0x2a0142 thru 0x2a53f8	(0x52b7 bytes)
292452(100 mod 256): MAPREAD	0x3bac44 thru 0x3bd125	(0x24e2 bytes)
292453(101 mod 256): WRITE	0x1fe1bf thru 0x20433c	(0x617e bytes)
292454(102 mod 256): MAPREAD	0x5110b0 thru 0x51acc4	(0x9c15 bytes)
292455(103 mod 256): TRUNCATE UP	from 0x573bf2 to 0x5aad19
292456(104 mod 256): WRITE	0x2012b0 thru 0x209e48	(0x8b99 bytes)
292457(105 mod 256): READ	0x3e4f38 thru 0x3e861d	(0x36e6 bytes)
292458(106 mod 256): WRITE	0x25c01c thru 0x260f09	(0x4eee bytes)
292459(107 mod 256): READ	0xb8f53 thru 0xc0915	(0x79c3 bytes)
292460(108 mod 256): MAPWRITE 0x384529 thru 0x3922b3	(0xdd8b bytes)
292461(109 mod 256): READ	0x3767e2 thru 0x37caf4	(0x6313 bytes)
292462(110 mod 256): MAPWRITE 0x24885e thru 0x24cbf8	(0x439b bytes)
292463(111 mod 256): MAPWRITE 0x4a7837 thru 0x4ae679	(0x6e43 bytes)
292464(112 mod 256): MAPWRITE 0xa4f56 thru 0xa5752	(0x7fd bytes)
292465(113 mod 256): WRITE	0x640cc8 thru 0x6456d9	(0x4a12 bytes) HOLE
292466(114 mod 256): READ	0x5b459d thru 0x5c06d2	(0xc136 bytes)
292467(115 mod 256): TRUNCATE DOWN	from 0x6456da to 0x5275f1
292468(116 mod 256): READ	0x453d0e thru 0x45ecf8	(0xafeb bytes)
292469(117 mod 256): TRUNCATE UP	from 0x5275f1 to 0x57eff4
292470(118 mod 256): MAPWRITE 0x15d983 thru 0x169e5a	(0xc4d8 bytes)
292471(119 mod 256): WRITE	0x6342a4 thru 0x636c9a	(0x29f7 bytes) HOLE
292472(120 mod 256): TRUNCATE DOWN	from 0x636c9b to 0x4798c4
292473(121 mod 256): WRITE	0x5f572b thru 0x6032de	(0xdbb4 bytes) HOLE
292474(122 mod 256): READ	0x230e9a thru 0x239587	(0x86ee bytes)
292475(123 mod 256): TRUNCATE DOWN	from 0x6032df to 0x19b7ec	******WWWW
292476(124 mod 256): TRUNCATE DOWN	from 0x19b7ec to 0x69286
292477(125 mod 256): TRUNCATE UP	from 0x69286 to 0x117e03
292478(126 mod 256): WRITE	0x17efdd thru 0x18850f	(0x9533 bytes) HOLE
292479(127 mod 256): WRITE	0x772c31 thru 0x7759e4	(0x2db4 bytes) HOLE	***WWWW
292480(128 mod 256): MAPWRITE 0x361a8b thru 0x363d99	(0x230f bytes)
292481(129 mod 256): MAPREAD	0x197f60 thru 0x1a6714	(0xe7b5 bytes)
292482(130 mod 256): WRITE	0x273559 thru 0x276c96	(0x373e bytes)
292483(131 mod 256): MAPREAD	0x43027c thru 0x43dda7	(0xdb2c bytes)
292484(132 mod 256): READ	0x2f220f thru 0x2f85d2	(0x63c4 bytes)
292485(133 mod 256): TRUNCATE DOWN	from 0x7759e5 to 0x352768
292486(134 mod 256): MAPWRITE 0x74f4b1 thru 0x75522b	(0x5d7b bytes)
292487(135 mod 256): WRITE	0x7c460 thru 0x81155	(0x4cf6 bytes)
292488(136 mod 256): WRITE	0x635885 thru 0x63ed51	(0x94cd bytes)
292489(137 mod 256): MAPWRITE 0x420e56 thru 0x424137	(0x32e2 bytes)
292490(138 mod 256): READ	0x39f181 thru 0x3a07ed	(0x166d bytes)
292491(139 mod 256): WRITE	0x6cedf2 thru 0x6d0587	(0x1796 bytes)
292492(140 mod 256): READ	0x648e51 thru 0x64b260	(0x2410 bytes)
292493(141 mod 256): MAPWRITE 0x2cbd1f thru 0x2cdb3e	(0x1e20 bytes)
292494(142 mod 256): MAPREAD	0x220c95 thru 0x2280f5	(0x7461 bytes)
292495(143 mod 256): MAPREAD	0x1cfcfc thru 0x1d72b7	(0x75bc bytes)
292496(144 mod 256): TRUNCATE DOWN	from 0x75522c to 0x529ca5
292497(145 mod 256): MAPREAD	0x3de24f thru 0x3df9ac	(0x175e bytes)
292498(146 mod 256): READ	0x43709a thru 0x43fd87	(0x8cee bytes)
292499(147 mod 256): READ	0x4ccdbc thru 0x4ce12e	(0x1373 bytes)
292500(148 mod 256): WRITE	0x695f1c thru 0x6a1de8	(0xbecd bytes) HOLE
292501(149 mod 256): TRUNCATE DOWN	from 0x6a1de9 to 0xe58cd	******WWWW
292502(150 mod 256): TRUNCATE UP	from 0xe58cd to 0x3b45f6	******WWWW
292503(151 mod 256): READ	0x3054f5 thru 0x309901	(0x440d bytes)
292504(152 mod 256): WRITE	0xb7231 thru 0xb83cb	(0x119b bytes)
292505(153 mod 256): MAPREAD	0x275ff3 thru 0x282cfa	(0xcd08 bytes)
292506(154 mod 256): READ	0x163d84 thru 0x16ba45	(0x7cc2 bytes)
292507(155 mod 256): READ	0x28829c thru 0x28d4d2	(0x5237 bytes)
292508(156 mod 256): READ	0x15ea27 thru 0x16b7bf	(0xcd99 bytes)
292509(157 mod 256): TRUNCATE UP	from 0x3b45f6 to 0x45137b
292510(158 mod 256): MAPREAD	0x43349c thru 0x43b61f	(0x8184 bytes)
292511(159 mod 256): MAPREAD	0x399e65 thru 0x3a728c	(0xd428 bytes)
292512(160 mod 256): MAPWRITE 0x48d5e1 thru 0x494d55	(0x7775 bytes)
292513(161 mod 256): WRITE	0x5b706 thru 0x671b9	(0xbab4 bytes)
292514(162 mod 256): TRUNCATE DOWN	from 0x494d56 to 0xbe2c7	******WWWW
292515(163 mod 256): MAPWRITE 0x37d1ee thru 0x38a4d2	(0xd2e5 bytes)
292516(164 mod 256): MAPWRITE 0x66b7d7 thru 0x675fe0	(0xa80a bytes)
292517(165 mod 256): WRITE	0x3c2cf3 thru 0x3d06c5	(0xd9d3 bytes)
292518(166 mod 256): MAPREAD	0x25a44b thru 0x268134	(0xdcea bytes)
292519(167 mod 256): MAPREAD	0x40262b thru 0x40531b	(0x2cf1 bytes)
292520(168 mod 256): WRITE	0x740d99 thru 0x742cec	(0x1f54 bytes) HOLE
292521(169 mod 256): MAPWRITE 0x5ca09d thru 0x5d2afd	(0x8a61 bytes)
292522(170 mod 256): WRITE	0x3443 thru 0x845b	(0x5019 bytes)
292523(171 mod 256): MAPREAD	0x57cfff thru 0x58ce69	(0xfe6b bytes)
292524(172 mod 256): TRUNCATE DOWN	from 0x742ced to 0x67b695
292525(173 mod 256): READ	0x4fe8de thru 0x5009bb	(0x20de bytes)
292526(174 mod 256): TRUNCATE DOWN	from 0x67b695 to 0x5ece35
292527(175 mod 256): READ	0x44a972 thru 0x457408	(0xca97 bytes)
292528(176 mod 256): WRITE	0xa685 thru 0xe265	(0x3be1 bytes)
292529(177 mod 256): MAPREAD	0x200289 thru 0x20fb37	(0xf8af bytes)	***RRRR***
292530(178 mod 256): WRITE	0x61bb7e thru 0x627f02	(0xc385 bytes) HOLE
292531(179 mod 256): MAPREAD	0x46549 thru 0x4c8df	(0x6397 bytes)
292532(180 mod 256): MAPREAD	0x95524 thru 0xa1b69	(0xc646 bytes)
292533(181 mod 256): READ	0x17049e thru 0x172a8a	(0x25ed bytes)
292534(182 mod 256): TRUNCATE UP	from 0x627f03 to 0x6b5b7e
292535(183 mod 256): WRITE	0x3e3862 thru 0x3e38d7	(0x76 bytes)
292536(184 mod 256): TRUNCATE DOWN	from 0x6b5b7e to 0x4c4461
292537(185 mod 256): MAPREAD	0x224999 thru 0x2324b5	(0xdb1d bytes)
292538(186 mod 256): TRUNCATE DOWN	from 0x4c4461 to 0x2e2500
292539(187 mod 256): TRUNCATE DOWN	from 0x2e2500 to 0x2cd437
292540(188 mod 256): MAPREAD	0xf4d26 thru 0xfc756	(0x7a31 bytes)
292541(189 mod 256): READ	0x4aae1 thru 0x5a334	(0xf854 bytes)
292542(190 mod 256): MAPWRITE 0x423ca7 thru 0x430010	(0xc36a bytes)
292543(191 mod 256): WRITE	0x74102f thru 0x74a9bc	(0x998e bytes) HOLE
292544(192 mod 256): TRUNCATE DOWN	from 0x74a9bd to 0x96fb1	******WWWW
292545(193 mod 256): TRUNCATE DOWN	from 0x96fb1 to 0x23301
292546(194 mod 256): MAPREAD	0x1de74 thru 0x23300	(0x548d bytes)
292547(195 mod 256): MAPREAD	0x20033 thru 0x23300	(0x32ce bytes)
292548(196 mod 256): MAPWRITE 0x44b1ec thru 0x458bd2	(0xd9e7 bytes)
292549(197 mod 256): TRUNCATE UP	from 0x458bd3 to 0x5bef70
292550(198 mod 256): READ	0x582e2e thru 0x5843d3	(0x15a6 bytes)
292551(199 mod 256): READ	0x4f0c26 thru 0x4f43d0	(0x37ab bytes)
292552(200 mod 256): MAPWRITE 0x5f2872 thru 0x5f6dc7	(0x4556 bytes)
292553(201 mod 256): MAPWRITE 0x71902 thru 0x7f552	(0xdc51 bytes)
292554(202 mod 256): MAPWRITE 0x64ed16 thru 0x65c877	(0xdb62 bytes)
292555(203 mod 256): MAPREAD	0x18c00c thru 0x19ad78	(0xed6d bytes)
292556(204 mod 256): TRUNCATE DOWN	from 0x65c878 to 0x18ecee	******WWWW
292557(205 mod 256): WRITE	0x3aafa5 thru 0x3ae494	(0x34f0 bytes) HOLE	***WWWW
292558(206 mod 256): MAPWRITE 0x233dc0 thru 0x2367c2	(0x2a03 bytes)
292559(207 mod 256): READ	0xb40fb thru 0xbb40f	(0x7315 bytes)
292560(208 mod 256): WRITE	0x2c359a thru 0x2d09dc	(0xd443 bytes)
292561(209 mod 256): WRITE	0x43e9b9 thru 0x4451c0	(0x6808 bytes) HOLE
292562(210 mod 256): TRUNCATE DOWN	from 0x4451c1 to 0x3391b	******WWWW
292563(211 mod 256): READ	0x2118f thru 0x2d3f8	(0xc26a bytes)
292564(212 mod 256): TRUNCATE UP	from 0x3391b to 0x49364e	******WWWW
292565(213 mod 256): WRITE	0x4581ba thru 0x4586d7	(0x51e bytes)
292566(214 mod 256): READ	0x1966b thru 0x1b706	(0x209c bytes)
292567(215 mod 256): MAPWRITE 0xc667a thru 0xc6951	(0x2d8 bytes)
292568(216 mod 256): WRITE	0x11acdb thru 0x126c35	(0xbf5b bytes)
292569(217 mod 256): READ	0x415bdf thru 0x422f00	(0xd322 bytes)
292570(218 mod 256): MAPWRITE 0x33329 thru 0x33561	(0x239 bytes)
292571(219 mod 256): TRUNCATE DOWN	from 0x49364e to 0x2e1497
292572(220 mod 256): MAPWRITE 0x26e9b9 thru 0x278a95	(0xa0dd bytes)
292573(221 mod 256): TRUNCATE DOWN	from 0x2e1497 to 0xb1ec5	******WWWW
292574(222 mod 256): WRITE	0x2eb58d thru 0x2f6f5f	(0xb9d3 bytes) HOLE	***WWWW
292575(223 mod 256): MAPWRITE 0xeb565 thru 0xf1ebf	(0x695b bytes)
292576(224 mod 256): MAPREAD	0x207797 thru 0x20e5ff	(0x6e69 bytes)	***RRRR***
292577(225 mod 256): MAPWRITE 0x3848b4 thru 0x390266	(0xb9b3 bytes)
292578(226 mod 256): TRUNCATE UP	from 0x390267 to 0x55bdb8
292579(227 mod 256): WRITE	0x1f64d3 thru 0x1fdaa0	(0x75ce bytes)
292580(228 mod 256): MAPREAD	0x1bdf20 thru 0x1beedc	(0xfbd bytes)
292581(229 mod 256): TRUNCATE UP	from 0x55bdb8 to 0x616bdb
292582(230 mod 256): TRUNCATE DOWN	from 0x616bdb to 0x9d38a	******WWWW
292583(231 mod 256): READ	0x44772 thru 0x4dee2	(0x9771 bytes)
292584(232 mod 256): READ	0x82e9f thru 0x870b8	(0x421a bytes)
292585(233 mod 256): MAPREAD	0x275b9 thru 0x35bb9	(0xe601 bytes)
292586(234 mod 256): READ	0x8c9aa thru 0x8dcd5	(0x132c bytes)
292587(235 mod 256): WRITE	0xf1ee thru 0x1644e	(0x7261 bytes)
292588(236 mod 256): READ	0x9b510 thru 0x9d389	(0x1e7a bytes)
292589(237 mod 256): TRUNCATE UP	from 0x9d38a to 0xa2a42
292590(238 mod 256): MAPREAD	0x5cb1e thru 0x61183	(0x4666 bytes)
292591(239 mod 256): MAPREAD	0x7372f thru 0x782aa	(0x4b7c bytes)
292592(240 mod 256): MAPREAD	0x819d5 thru 0x85cb4	(0x42e0 bytes)
292593(241 mod 256): WRITE	0x24d102 thru 0x2554d8	(0x83d7 bytes) HOLE	***WWWW
292594(242 mod 256): READ	0x10796b thru 0x114e8b	(0xd521 bytes)
292595(243 mod 256): MAPREAD	0xd1a18 thru 0xdccfe	(0xb2e7 bytes)
292596(244 mod 256): TRUNCATE UP	from 0x2554d9 to 0x4ead71
292597(245 mod 256): READ	0x106e12 thru 0x10ac69	(0x3e58 bytes)
292598(246 mod 256): MAPWRITE 0x5358c thru 0x5fad9	(0xc54e bytes)
292599(247 mod 256): WRITE	0x47d2a thru 0x49ecc	(0x21a3 bytes)
292600(248 mod 256): MAPWRITE 0x65c978 thru 0x6681e4	(0xb86d bytes)
292601(249 mod 256): READ	0x5cc76a thru 0x5d66da	(0x9f71 bytes)
292602(250 mod 256): READ	0x375aac thru 0x37a065	(0x45ba bytes)
292603(251 mod 256): MAPWRITE 0x63b282 thru 0x63ca9e	(0x181d bytes)
292604(252 mod 256): TRUNCATE DOWN	from 0x6681e5 to 0x71c0b	******WWWW
292605(253 mod 256): TRUNCATE UP	from 0x71c0b to 0x755c11	******WWWW
292606(254 mod 256): MAPWRITE 0x5cdba2 thru 0x5d63df	(0x883e bytes)
292607(255 mod 256): WRITE	0x44feef thru 0x45c17d	(0xc28f bytes)
292608(0 mod 256): TRUNCATE DOWN	from 0x755c11 to 0x5b8c95
292609(1 mod 256): TRUNCATE DOWN	from 0x5b8c95 to 0x2ab2e7
292610(2 mod 256): READ	0x163a95 thru 0x170fdf	(0xd54b bytes)
292611(3 mod 256): READ	0x179dd9 thru 0x17a673	(0x89b bytes)
292612(4 mod 256): WRITE	0x3ba73 thru 0x451f3	(0x9781 bytes)
292613(5 mod 256): MAPWRITE 0x2103a1 thru 0x211f8d	(0x1bed bytes)
292614(6 mod 256): WRITE	0x2e7720 thru 0x2eb215	(0x3af6 bytes) HOLE
292615(7 mod 256): TRUNCATE DOWN	from 0x2eb216 to 0x2d5d58
292616(8 mod 256): MAPREAD	0xb7983 thru 0xc6903	(0xef81 bytes)
292617(9 mod 256): WRITE	0x6df39f thru 0x6ecf0f	(0xdb71 bytes) HOLE
292618(10 mod 256): TRUNCATE DOWN	from 0x6ecf10 to 0x33181c
292619(11 mod 256): TRUNCATE UP	from 0x33181c to 0x54b885
292620(12 mod 256): MAPREAD	0x42997 thru 0x5289b	(0xff05 bytes)
292621(13 mod 256): MAPREAD	0x2bd990 thru 0x2c53a3	(0x7a14 bytes)
292622(14 mod 256): TRUNCATE DOWN	from 0x54b885 to 0x2af2b9
292623(15 mod 256): MAPWRITE 0x23454d thru 0x23d8da	(0x938e bytes)
292624(16 mod 256): WRITE	0x55811b thru 0x55ab59	(0x2a3f bytes) HOLE
292625(17 mod 256): MAPWRITE 0x9e637 thru 0xad0d4	(0xea9e bytes)
292626(18 mod 256): READ	0x439f74 thru 0x443846	(0x98d3 bytes)
292627(19 mod 256): MAPWRITE 0xc7be1 thru 0xc8782	(0xba2 bytes)
292628(20 mod 256): TRUNCATE DOWN	from 0x55ab5a to 0x419170
292629(21 mod 256): TRUNCATE DOWN	from 0x419170 to 0x20a4e9	******WWWW
292630(22 mod 256): TRUNCATE DOWN	from 0x20a4e9 to 0xbaee4
292631(23 mod 256): MAPWRITE 0x2e1ebc thru 0x2ecc36	(0xad7b bytes)
292632(24 mod 256): MAPWRITE 0x69ac03 thru 0x69e07d	(0x347b bytes)
292633(25 mod 256): MAPWRITE 0x75e78d thru 0x76c57c	(0xddf0 bytes)
292634(26 mod 256): MAPWRITE 0x7750c3 thru 0x784fef	(0xff2d bytes)
292635(27 mod 256): MAPWRITE 0x5117f1 thru 0x51b8cb	(0xa0db bytes)
292636(28 mod 256): WRITE	0x5e9082 thru 0x5f455e	(0xb4dd bytes)
292637(29 mod 256): READ	0x56babe thru 0x57271f	(0x6c62 bytes)
292638(30 mod 256): TRUNCATE DOWN	from 0x784ff0 to 0x36b545
292639(31 mod 256): READ	0xbccf4 thru 0xbe24a	(0x1557 bytes)
292640(32 mod 256): MAPREAD	0x2aef49 thru 0x2b49e6	(0x5a9e bytes)
292641(33 mod 256): MAPREAD	0x2be1a5 thru 0x2c0204	(0x2060 bytes)
292642(34 mod 256): READ	0x5aa95 thru 0x5e940	(0x3eac bytes)
292643(35 mod 256): WRITE	0x185776 thru 0x18f92d	(0xa1b8 bytes)
292644(36 mod 256): WRITE	0x65246b thru 0x65269f	(0x235 bytes) HOLE
292645(37 mod 256): MAPWRITE 0x63f7b5 thru 0x6419e8	(0x2234 bytes)
292646(38 mod 256): TRUNCATE DOWN	from 0x6526a0 to 0x357f74
292647(39 mod 256): MAPWRITE 0x312e24 thru 0x314fb8	(0x2195 bytes)
292648(40 mod 256): READ	0x350b11 thru 0x357f73	(0x7463 bytes)
292649(41 mod 256): TRUNCATE UP	from 0x357f74 to 0x68337a
292650(42 mod 256): WRITE	0x744d98 thru 0x7521ec	(0xd455 bytes) HOLE
292651(43 mod 256): MAPWRITE 0x66da76 thru 0x67189b	(0x3e26 bytes)
292652(44 mod 256): READ	0x6a1177 thru 0x6aa92b	(0x97b5 bytes)
292653(45 mod 256): WRITE	0x201b3a thru 0x2041c6	(0x268d bytes)
292654(46 mod 256): TRUNCATE DOWN	from 0x7521ed to 0x2fd1f4
292655(47 mod 256): TRUNCATE UP	from 0x2fd1f4 to 0x497ae3
292656(48 mod 256): TRUNCATE DOWN	from 0x497ae3 to 0x2d1a6f
292657(49 mod 256): MAPWRITE 0x1a67c6 thru 0x1adce9	(0x7524 bytes)
292658(50 mod 256): TRUNCATE UP	from 0x2d1a6f to 0x407ac8
292659(51 mod 256): WRITE	0x5730df thru 0x57f7dd	(0xc6ff bytes) HOLE
292660(52 mod 256): MAPWRITE 0x2cf234 thru 0x2db7af	(0xc57c bytes)
292661(53 mod 256): WRITE	0x1ef696 thru 0x1f21d5	(0x2b40 bytes)
292662(54 mod 256): TRUNCATE UP	from 0x57f7de to 0x662b18
292663(55 mod 256): TRUNCATE DOWN	from 0x662b18 to 0xdc94a	******WWWW
292664(56 mod 256): TRUNCATE UP	from 0xdc94a to 0x7724fe	******WWWW
292665(57 mod 256): WRITE	0x1c84e6 thru 0x1ca5ff	(0x211a bytes)
292666(58 mod 256): READ	0x5d50ae thru 0x5d6d98	(0x1ceb bytes)
292667(59 mod 256): READ	0x4c7fea thru 0x4d083e	(0x8855 bytes)
292668(60 mod 256): MAPREAD	0x72e11f thru 0x73773f	(0x9621 bytes)
292669(61 mod 256): WRITE	0xbb887 thru 0xc7156	(0xb8d0 bytes)
292670(62 mod 256): WRITE	0x2d9e5d thru 0x2e6db1	(0xcf55 bytes)
292671(63 mod 256): READ	0xbe357 thru 0xc36da	(0x5384 bytes)
292672(64 mod 256): TRUNCATE DOWN	from 0x7724fe to 0x4c7e23
292673(65 mod 256): READ	0x3c8950 thru 0x3d317e	(0xa82f bytes)
292674(66 mod 256): TRUNCATE DOWN	from 0x4c7e23 to 0x20a888	******WWWW
292675(67 mod 256): MAPREAD	0x94e88 thru 0x9d45a	(0x85d3 bytes)
292676(68 mod 256): TRUNCATE UP	from 0x20a888 to 0x639d7a	******WWWW
292677(69 mod 256): READ	0xe456c thru 0xe9d7f	(0x5814 bytes)
292678(70 mod 256): TRUNCATE UP	from 0x639d7a to 0x75d9b6
292679(71 mod 256): MAPREAD	0x26b78a thru 0x274757	(0x8fce bytes)
292680(72 mod 256): MAPREAD	0x12d705 thru 0x134e8c	(0x7788 bytes)
292681(73 mod 256): TRUNCATE DOWN	from 0x75d9b6 to 0x5e961a
292682(74 mod 256): MAPWRITE 0x63262a thru 0x63db52	(0xb529 bytes)
292683(75 mod 256): MAPWRITE 0x48cf89 thru 0x497b1f	(0xab97 bytes)
292684(76 mod 256): READ	0x634b2d thru 0x63db52	(0x9026 bytes)
292685(77 mod 256): TRUNCATE DOWN	from 0x63db53 to 0x5edc5c
292686(78 mod 256): WRITE	0x2e24c7 thru 0x2ec21d	(0x9d57 bytes)
292687(79 mod 256): WRITE	0x1cd9bf thru 0x1d867f	(0xacc1 bytes)
292688(80 mod 256): TRUNCATE DOWN	from 0x5edc5c to 0x1de587	******WWWW
292689(81 mod 256): WRITE	0x6292ab thru 0x62faed	(0x6843 bytes) HOLE	***WWWW
292690(82 mod 256): MAPWRITE 0x2edfd2 thru 0x2f4de0	(0x6e0f bytes)
292691(83 mod 256): READ	0x281e49 thru 0x2879ad	(0x5b65 bytes)
292692(84 mod 256): WRITE	0x4886c0 thru 0x48fa78	(0x73b9 bytes)
292693(85 mod 256): TRUNCATE DOWN	from 0x62faee to 0x37fad1
292694(86 mod 256): MAPWRITE 0x41b705 thru 0x41ea58	(0x3354 bytes)
292695(87 mod 256): READ	0x24643b thru 0x247cb5	(0x187b bytes)
292696(88 mod 256): READ	0x16805b thru 0x175624	(0xd5ca bytes)
292697(89 mod 256): MAPREAD	0x1f075e thru 0x1f3b6c	(0x340f bytes)
292698(90 mod 256): TRUNCATE DOWN	from 0x41ea59 to 0x14ac5b	******WWWW
292699(91 mod 256): TRUNCATE UP	from 0x14ac5b to 0x1ceaac
292700(92 mod 256): MAPREAD	0x1b27a9 thru 0x1b4447	(0x1c9f bytes)
292701(93 mod 256): TRUNCATE UP	from 0x1ceaac to 0x498073	******WWWW
292702(94 mod 256): TRUNCATE UP	from 0x498073 to 0x70e1d5
292703(95 mod 256): MAPREAD	0x515b6a thru 0x52090b	(0xada2 bytes)
292704(96 mod 256): MAPREAD	0x2a4453 thru 0x2a9523	(0x50d1 bytes)
292705(97 mod 256): MAPWRITE 0x62f716 thru 0x634401	(0x4cec bytes)
292706(98 mod 256): WRITE	0x4442b0 thru 0x44dd3d	(0x9a8e bytes)
292707(99 mod 256): TRUNCATE DOWN	from 0x70e1d5 to 0x427348
292708(100 mod 256): TRUNCATE DOWN	from 0x427348 to 0x378101
292709(101 mod 256): READ	0x30720 thru 0x30e7e	(0x75f bytes)
292710(102 mod 256): READ	0x229cd2 thru 0x23810a	(0xe439 bytes)
292711(103 mod 256): MAPREAD	0x2b1861 thru 0x2bb8e7	(0xa087 bytes)
292712(104 mod 256): MAPREAD	0x173bc3 thru 0x1789c3	(0x4e01 bytes)
292713(105 mod 256): MAPWRITE 0x4d55e8 thru 0x4d98ca	(0x42e3 bytes)
292714(106 mod 256): READ	0xac06e thru 0xb2f3c	(0x6ecf bytes)
292715(107 mod 256): MAPREAD	0x1642d8 thru 0x16dbae	(0x98d7 bytes)
292716(108 mod 256): TRUNCATE DOWN	from 0x4d98cb to 0x3a1e71
292717(109 mod 256): TRUNCATE UP	from 0x3a1e71 to 0x58ff13
292718(110 mod 256): MAPWRITE 0x260646 thru 0x263f0c	(0x38c7 bytes)
292719(111 mod 256): TRUNCATE UP	from 0x58ff13 to 0x5b1421
292720(112 mod 256): READ	0x2f15c8 thru 0x2f3090	(0x1ac9 bytes)
292721(113 mod 256): MAPREAD	0x55ddee thru 0x561995	(0x3ba8 bytes)
292722(114 mod 256): WRITE	0x508c3b thru 0x5126ca	(0x9a90 bytes)
292723(115 mod 256): TRUNCATE DOWN	from 0x5b1421 to 0x3ec50e
292724(116 mod 256): MAPREAD	0x2f887e thru 0x2f9261	(0x9e4 bytes)
292725(117 mod 256): MAPWRITE 0x20dc8b thru 0x214b7d	(0x6ef3 bytes)
292726(118 mod 256): TRUNCATE UP	from 0x3ec50e to 0x742a01
292727(119 mod 256): MAPREAD	0x5f74ba thru 0x603bd5	(0xc71c bytes)
292728(120 mod 256): READ	0x3071bd thru 0x30d01a	(0x5e5e bytes)
292729(121 mod 256): READ	0x3c0eaf thru 0x3c26dd	(0x182f bytes)
292730(122 mod 256): WRITE	0x91bcc thru 0x9530a	(0x373f bytes)
292731(123 mod 256): MAPWRITE 0x727a20 thru 0x734d8c	(0xd36d bytes)
292732(124 mod 256): MAPREAD	0x1afcd1 thru 0x1bfae5	(0xfe15 bytes)
292733(125 mod 256): WRITE	0x347ca0 thru 0x34aa64	(0x2dc5 bytes)
292734(126 mod 256): MAPREAD	0x56c6ec thru 0x56d6fc	(0x1011 bytes)
292735(127 mod 256): WRITE	0x73aee8 thru 0x74073a	(0x5853 bytes)
292736(128 mod 256): WRITE	0x3c7257 thru 0x3c79ee	(0x798 bytes)
292737(129 mod 256): MAPWRITE 0x32ad05 thru 0x3394f4	(0xe7f0 bytes)
292738(130 mod 256): MAPWRITE 0x20ad16 thru 0x217624	(0xc90f bytes)	******WWWW
292739(131 mod 256): READ	0x31ad11 thru 0x32009b	(0x538b bytes)
292740(132 mod 256): READ	0x434d32 thru 0x4377f6	(0x2ac5 bytes)
292741(133 mod 256): MAPREAD	0x64078a thru 0x64e490	(0xdd07 bytes)
292742(134 mod 256): TRUNCATE DOWN	from 0x742a01 to 0x2eeb34
292743(135 mod 256): MAPREAD	0x9334 thru 0x12c04	(0x98d1 bytes)
292744(136 mod 256): TRUNCATE UP	from 0x2eeb34 to 0x3d1c69
292745(137 mod 256): TRUNCATE UP	from 0x3d1c69 to 0x4be58c
292746(138 mod 256): MAPREAD	0x101156 thru 0x106451	(0x52fc bytes)
292747(139 mod 256): WRITE	0xe8739 thru 0xf4d0e	(0xc5d6 bytes)
292748(140 mod 256): MAPREAD	0x267a44 thru 0x26ce2c	(0x53e9 bytes)
292749(141 mod 256): TRUNCATE UP	from 0x4be58c to 0x57abd3
292750(142 mod 256): TRUNCATE DOWN	from 0x57abd3 to 0x38751e
292751(143 mod 256): WRITE	0xbf2bf thru 0xc567e	(0x63c0 bytes)
292752(144 mod 256): TRUNCATE DOWN	from 0x38751e to 0x37756c
292753(145 mod 256): WRITE	0x253207 thru 0x25be2b	(0x8c25 bytes)
292754(146 mod 256): READ	0x321e60 thru 0x32d03f	(0xb1e0 bytes)
292755(147 mod 256): WRITE	0x11e268 thru 0x121181	(0x2f1a bytes)
292756(148 mod 256): MAPWRITE 0x16c02a thru 0x172db6	(0x6d8d bytes)
292757(149 mod 256): MAPWRITE 0x47b5d5 thru 0x47efa4	(0x39d0 bytes)
292758(150 mod 256): MAPWRITE 0x6a5d4d thru 0x6a658d	(0x841 bytes)
292759(151 mod 256): MAPREAD	0x22996e thru 0x2313b1	(0x7a44 bytes)
292760(152 mod 256): TRUNCATE DOWN	from 0x6a658e to 0x53ce82
292761(153 mod 256): MAPREAD	0x33c50f thru 0x345410	(0x8f02 bytes)
292762(154 mod 256): MAPWRITE 0x74085d thru 0x7438e7	(0x308b bytes)
292763(155 mod 256): TRUNCATE DOWN	from 0x7438e8 to 0x3b4359
292764(156 mod 256): MAPWRITE 0x4eefff thru 0x4f20e4	(0x30e6 bytes)
292765(157 mod 256): WRITE	0x46aa50 thru 0x46d5dd	(0x2b8e bytes)
292766(158 mod 256): READ	0x4255e3 thru 0x4270f7	(0x1b15 bytes)
292767(159 mod 256): MAPREAD	0x4968c7 thru 0x49ab3f	(0x4279 bytes)
292768(160 mod 256): WRITE	0x5317c4 thru 0x53e5d2	(0xce0f bytes) HOLE
292769(161 mod 256): WRITE	0x193469 thru 0x19f01e	(0xbbb6 bytes)
292770(162 mod 256): MAPWRITE 0x4b5be9 thru 0x4b6c50	(0x1068 bytes)
292771(163 mod 256): WRITE	0x3980a7 thru 0x39ba69	(0x39c3 bytes)
292772(164 mod 256): MAPWRITE 0x78fca0 thru 0x796b9e	(0x6eff bytes)
292773(165 mod 256): TRUNCATE DOWN	from 0x796b9f to 0x431bc1
292774(166 mod 256): WRITE	0x3509be thru 0x352972	(0x1fb5 bytes)
292775(167 mod 256): READ	0x1b9546 thru 0x1bf20c	(0x5cc7 bytes)
292776(168 mod 256): READ	0x158846 thru 0x1634d7	(0xac92 bytes)
292777(169 mod 256): MAPWRITE 0x675040 thru 0x680ab2	(0xba73 bytes)
292778(170 mod 256): TRUNCATE DOWN	from 0x680ab3 to 0x34cfa9
292779(171 mod 256): WRITE	0x4e4f8a thru 0x4ea1c6	(0x523d bytes) HOLE
292780(172 mod 256): MAPREAD	0x207b56 thru 0x20c52f	(0x49da bytes)	***RRRR***
Correct content saved for comparison
(maybe hexdump "/mnt/testfile" vs "/mnt/testfile.fsxgood")

--lrZ03NoBR/3+SXJZ--
