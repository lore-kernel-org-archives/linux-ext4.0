From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Subject: About strange behaviour of ext4 allocation algorithm
Date: Tue, 22 Dec 2009 13:42:51 +0300
Message-ID: <41BA663C8B2F72499F48B0EF991C188E047890DF84@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from edge1.acronis.com ([91.195.23.132]:18429 "EHLO
	edge1.acronis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZLVKoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Dec 2009 05:44:38 -0500
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

I think that I found some strange behaviour in ext4 allocation algorithm. Maybe I wrong or use not actual code but such allocation policy is strange from my point of view.

First of all, I has created ext4 volume of 100 Mb in size (mkfs.ext4 -b 1024 -L ext4 /dev/sdb1). And I have such free space map after volume creation ([group; begin; end]):
[group=0; begin=3815; end=8192],
[group=1; begin=8451; end=16384],
[group=2; begin=16385; end=24576],
[group=3; begin=24835; end=32768],
[group=4; begin=32769; end=40960],
[group=5; begin=41219; end=49152],
[group=6; begin=53249; end=57344],
[group=7; begin=57603; end=65536],
[group=8; begin=65537; end=73728],
[group=9; begin=73987; end=81920],
[group=10; begin=81921; end=90112],
[group=11; begin=90113; end=98304],
[group=12; begin=98305; end=106495],
[group=13; begin=106497; end=112419].

Then I mount created volume and has generated a regular file of 95 Mb in size on it by command: dd if=/dev/urandom of=/ext4/001.bin bs=1048576 count=95. And for the file I have such extents' tree ([LogicalBlock; PhysicalBlock; NumberOfBlocks]):

Depth = 1: [logical=0; physical=92161; size=1]
Depth = 0: 
[logical=0; physical=4097; size=4096],
[logical=4096; physical=10241; size=14336],
[logical=18432; physical=26625; size=14336],
[logical=32768; physical=43009; size=6144],
[logical=38912; physical=53249; size=4096],
[logical=43008; physical=59393; size=14336],
[logical=57344; physical=75777; size=14336],
[logical=71680; physical=109569; size=2048],
[logical=73728; physical=92162; size=2047],
[logical=75775; physical=94753; size=1],
[logical=75776; physical=8451; size=1790],
[logical=77566; physical=24835; size=258],
[logical=77824; physical=41219; size=1790],
[logical=79614; physical=57603; size=970],
[logical=80584; physical=90825; size=1336],
[logical=81920; physical=94209; size=112],
[logical=82032; physical=111617; size=436],
[logical=82468; physical=94757; size=14812].

Such used space allocation map for file is strange.

Firstly, I can see that extents [0; 4097; 4096], [4096; 10241; 14336], [18432; 26625; 14336], [32768; 43009; 6144], [43008; 59393; 14336], [57344; 75777; 14336], [71680; 109569; 2048] begins inside free spaces (not from begin of free space). But why? If it is a reserve policy for metadata blocks then I don't understand why index block of extents' tree [0; 92161; 1] allocates such far from volume begin.

Secondly, it is strange that after extent [71680; 109569; 2048] allocation algorithm has found firstly [73728; 92162; 2047], [75775; 94753; 1] and only then try to search from volume begin [75776; 8451; 1790] (however, free space [group=0; begin=3815; end=4096] has excluded from search).

Thirdly, I can't understand why during "first search cycle" ([0; 4097; 4096] - [71680; 109569; 2048]) allocation algorithm can't find [82032; 111617; 436] extent. And why after [81920; 94209; 112] extent it is found [82032; 111617; 436] instead of [82468; 94757; 14812]? Such strange block allocations is not rare occurence for files of greater size.

As I can see existing allocation algorithm grows extents count in tree. The file of 95 Mb has 18 extents in the tree. But volume initially (before allocation) had 13 free spaces (that enough for file allocation). Is it bug or feature?

--
Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Acronis
