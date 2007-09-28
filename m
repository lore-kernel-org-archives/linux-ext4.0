From: Norbert Preining <preining@logic.at>
Subject: Re: kernel Oops in ext3 code
Date: Fri, 28 Sep 2007 17:00:31 +0200
Message-ID: <20070928150031.GF27873@gamma.logic.tuwien.ac.at>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at> <1190927903.3872.12.camel@localhost.localdomain> <20070928045456.GM23215@gamma.logic.tuwien.ac.at> <1190991464.10145.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Cc: Mingming Cao <cmm@us.ibm.com>, ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761582AbXI1PBR@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1190991464.10145.0.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fr, 28 Sep 2007, Badari Pulavarty wrote:
> objdump -DlS balloc.o 

Here it is

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
DREBLEY (n.)
Name for a shop which is supposed to be witty but is in fact
wearisome, e.g. 'The Frock Exchange', 'Hair Apparent', etc.
			--- Douglas Adams, The Meaning of Liff

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="balloc.objdump.txt"


balloc.o:     file format elf32-i386

Disassembly of section .text:

00000000 <goal_in_my_reservation>:
goal_in_my_reservation():
       0:	57                   	push   %edi
       1:	89 d7                	mov    %edx,%edi
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
       5:	89 c3                	mov    %eax,%ebx
       7:	8b 44 24 10          	mov    0x10(%esp),%eax
       b:	8b 33                	mov    (%ebx),%esi
       d:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
      13:	8b 50 10             	mov    0x10(%eax),%edx
      16:	8b 40 34             	mov    0x34(%eax),%eax
      19:	0f af ca             	imul   %edx,%ecx
      1c:	03 48 14             	add    0x14(%eax),%ecx
      1f:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
      23:	39 d6                	cmp    %edx,%esi
      25:	77 20                	ja     47 <goal_in_my_reservation+0x47>
      27:	8b 5b 04             	mov    0x4(%ebx),%ebx
      2a:	39 cb                	cmp    %ecx,%ebx
      2c:	72 19                	jb     47 <goal_in_my_reservation+0x47>
      2e:	85 ff                	test   %edi,%edi
      30:	b8 01 00 00 00       	mov    $0x1,%eax
      35:	78 12                	js     49 <goal_in_my_reservation+0x49>
      37:	8d 14 39             	lea    (%ecx,%edi,1),%edx
      3a:	39 f2                	cmp    %esi,%edx
      3c:	72 09                	jb     47 <goal_in_my_reservation+0x47>
      3e:	31 c0                	xor    %eax,%eax
      40:	39 da                	cmp    %ebx,%edx
      42:	0f 96 c0             	setbe  %al
      45:	eb 02                	jmp    49 <goal_in_my_reservation+0x49>
      47:	31 c0                	xor    %eax,%eax
      49:	5b                   	pop    %ebx
      4a:	5e                   	pop    %esi
      4b:	5f                   	pop    %edi
      4c:	c3                   	ret    

0000004d <ext3_group_sparse>:
ext3_group_sparse():
      4d:	83 f8 01             	cmp    $0x1,%eax
      50:	b9 01 00 00 00       	mov    $0x1,%ecx
      55:	7e 46                	jle    9d <ext3_group_sparse+0x50>
      57:	30 c9                	xor    %cl,%cl
      59:	a8 01                	test   $0x1,%al
      5b:	ba 07 00 00 00       	mov    $0x7,%edx
      60:	75 05                	jne    67 <ext3_group_sparse+0x1a>
      62:	eb 39                	jmp    9d <ext3_group_sparse+0x50>
      64:	6b d2 07             	imul   $0x7,%edx,%edx
      67:	39 d0                	cmp    %edx,%eax
      69:	7f f9                	jg     64 <ext3_group_sparse+0x17>
      6b:	39 c2                	cmp    %eax,%edx
      6d:	b9 05 00 00 00       	mov    $0x5,%ecx
      72:	75 05                	jne    79 <ext3_group_sparse+0x2c>
      74:	eb 22                	jmp    98 <ext3_group_sparse+0x4b>
      76:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
      79:	39 c8                	cmp    %ecx,%eax
      7b:	7f f9                	jg     76 <ext3_group_sparse+0x29>
      7d:	39 c1                	cmp    %eax,%ecx
      7f:	ba 03 00 00 00       	mov    $0x3,%edx
      84:	75 05                	jne    8b <ext3_group_sparse+0x3e>
      86:	eb 10                	jmp    98 <ext3_group_sparse+0x4b>
      88:	8d 14 52             	lea    (%edx,%edx,2),%edx
      8b:	39 d0                	cmp    %edx,%eax
      8d:	7f f9                	jg     88 <ext3_group_sparse+0x3b>
      8f:	31 c9                	xor    %ecx,%ecx
      91:	39 c2                	cmp    %eax,%edx
      93:	0f 94 c1             	sete   %cl
      96:	eb 05                	jmp    9d <ext3_group_sparse+0x50>
      98:	b9 01 00 00 00       	mov    $0x1,%ecx
      9d:	89 c8                	mov    %ecx,%eax
      9f:	c3                   	ret    

000000a0 <ext3_get_group_desc>:
ext3_get_group_desc():
      a0:	55                   	push   %ebp
      a1:	57                   	push   %edi
      a2:	56                   	push   %esi
      a3:	89 c6                	mov    %eax,%esi
      a5:	53                   	push   %ebx
      a6:	89 d3                	mov    %edx,%ebx
      a8:	83 ec 1c             	sub    $0x1c,%esp
      ab:	89 4c 24 18          	mov    %ecx,0x18(%esp)
      af:	8b a8 78 01 00 00    	mov    0x178(%eax),%ebp
      b5:	8b 45 24             	mov    0x24(%ebp),%eax
      b8:	39 c2                	cmp    %eax,%edx
      ba:	72 22                	jb     de <ext3_get_group_desc+0x3e>
      bc:	89 44 24 10          	mov    %eax,0x10(%esp)
      c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
      c4:	89 34 24             	mov    %esi,(%esp)
      c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
      ce:	00 
      cf:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
      d6:	00 
      d7:	e8 fc ff ff ff       	call   d8 <ext3_get_group_desc+0x38>
      dc:	eb 46                	jmp    124 <ext3_get_group_desc+0x84>
      de:	f0 83 04 24 00       	lock addl $0x0,(%esp)
      e3:	8b 86 78 01 00 00    	mov    0x178(%esi),%eax
      e9:	89 d7                	mov    %edx,%edi
      eb:	8b 48 50             	mov    0x50(%eax),%ecx
      ee:	8b 50 20             	mov    0x20(%eax),%edx
      f1:	8b 45 38             	mov    0x38(%ebp),%eax
      f4:	d3 ef                	shr    %cl,%edi
      f6:	4a                   	dec    %edx
      f7:	8b 0c b8             	mov    (%eax,%edi,4),%ecx
      fa:	21 da                	and    %ebx,%edx
      fc:	85 c9                	test   %ecx,%ecx
      fe:	75 28                	jne    128 <ext3_get_group_desc+0x88>
     100:	89 54 24 14          	mov    %edx,0x14(%esp)
     104:	89 7c 24 10          	mov    %edi,0x10(%esp)
     108:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     10c:	c7 44 24 08 57 00 00 	movl   $0x57,0x8(%esp)
     113:	00 
     114:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
     11b:	00 
     11c:	89 34 24             	mov    %esi,(%esp)
     11f:	e8 fc ff ff ff       	call   120 <ext3_get_group_desc+0x80>
     124:	31 c0                	xor    %eax,%eax
     126:	eb 15                	jmp    13d <ext3_get_group_desc+0x9d>
     128:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
     12d:	8b 41 14             	mov    0x14(%ecx),%eax
     130:	74 06                	je     138 <ext3_get_group_desc+0x98>
     132:	8b 5c 24 18          	mov    0x18(%esp),%ebx
     136:	89 0b                	mov    %ecx,(%ebx)
     138:	c1 e2 05             	shl    $0x5,%edx
     13b:	01 d0                	add    %edx,%eax
     13d:	83 c4 1c             	add    $0x1c,%esp
     140:	5b                   	pop    %ebx
     141:	5e                   	pop    %esi
     142:	5f                   	pop    %edi
     143:	5d                   	pop    %ebp
     144:	c3                   	ret    

00000145 <ext3_has_free_blocks>:
ext3_has_free_blocks():
     145:	53                   	push   %ebx
     146:	89 c3                	mov    %eax,%ebx
     148:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
     14e:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
     154:	85 c9                	test   %ecx,%ecx
     156:	79 05                	jns    15d <ext3_has_free_blocks+0x18>
     158:	ba 01 00 00 00       	mov    $0x1,%edx
     15d:	8b 43 34             	mov    0x34(%ebx),%eax
     160:	8b 40 08             	mov    0x8(%eax),%eax
     163:	40                   	inc    %eax
     164:	39 d0                	cmp    %edx,%eax
     166:	76 37                	jbe    19f <ext3_has_free_blocks+0x5a>
     168:	b8 18 00 00 00       	mov    $0x18,%eax
     16d:	e8 fc ff ff ff       	call   16e <ext3_has_free_blocks+0x29>
     172:	85 c0                	test   %eax,%eax
     174:	75 29                	jne    19f <ext3_has_free_blocks+0x5a>
     176:	8b 43 40             	mov    0x40(%ebx),%eax
     179:	64 8b 15 00 00 00 00 	mov    %fs:0x0,%edx
     180:	3b 82 90 01 00 00    	cmp    0x190(%edx),%eax
     186:	74 17                	je     19f <ext3_has_free_blocks+0x5a>
     188:	8b 43 44             	mov    0x44(%ebx),%eax
     18b:	31 d2                	xor    %edx,%edx
     18d:	85 c0                	test   %eax,%eax
     18f:	74 13                	je     1a4 <ext3_has_free_blocks+0x5f>
     191:	e8 fc ff ff ff       	call   192 <ext3_has_free_blocks+0x4d>
     196:	31 d2                	xor    %edx,%edx
     198:	85 c0                	test   %eax,%eax
     19a:	0f 95 c2             	setne  %dl
     19d:	eb 05                	jmp    1a4 <ext3_has_free_blocks+0x5f>
     19f:	ba 01 00 00 00       	mov    $0x1,%edx
     1a4:	5b                   	pop    %ebx
     1a5:	89 d0                	mov    %edx,%eax
     1a7:	c3                   	ret    

000001a8 <read_block_bitmap>:
read_block_bitmap():
     1a8:	55                   	push   %ebp
     1a9:	31 c9                	xor    %ecx,%ecx
     1ab:	57                   	push   %edi
     1ac:	89 d5                	mov    %edx,%ebp
     1ae:	56                   	push   %esi
     1af:	89 c6                	mov    %eax,%esi
     1b1:	53                   	push   %ebx
     1b2:	31 ff                	xor    %edi,%edi
     1b4:	83 ec 14             	sub    $0x14,%esp
     1b7:	e8 fc ff ff ff       	call   1b8 <read_block_bitmap+0x10>
     1bc:	85 c0                	test   %eax,%eax
     1be:	89 c3                	mov    %eax,%ebx
     1c0:	74 38                	je     1fa <read_block_bitmap+0x52>
     1c2:	8b 4e 0c             	mov    0xc(%esi),%ecx
     1c5:	8b 86 9c 00 00 00    	mov    0x9c(%esi),%eax
     1cb:	8b 13                	mov    (%ebx),%edx
     1cd:	e8 fc ff ff ff       	call   1ce <read_block_bitmap+0x26>
     1d2:	85 c0                	test   %eax,%eax
     1d4:	89 c7                	mov    %eax,%edi
     1d6:	75 22                	jne    1fa <read_block_bitmap+0x52>
     1d8:	8b 03                	mov    (%ebx),%eax
     1da:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
     1de:	c7 44 24 08 a4 00 00 	movl   $0xa4,0x8(%esp)
     1e5:	00 
     1e6:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
     1ed:	00 
     1ee:	89 44 24 10          	mov    %eax,0x10(%esp)
     1f2:	89 34 24             	mov    %esi,(%esp)
     1f5:	e8 fc ff ff ff       	call   1f6 <read_block_bitmap+0x4e>
     1fa:	83 c4 14             	add    $0x14,%esp
     1fd:	89 f8                	mov    %edi,%eax
     1ff:	5b                   	pop    %ebx
     200:	5e                   	pop    %esi
     201:	5f                   	pop    %edi
     202:	5d                   	pop    %ebp
     203:	c3                   	ret    

00000204 <ext3_test_allocatable>:
ext3_test_allocatable():
     204:	55                   	push   %ebp
     205:	57                   	push   %edi
     206:	89 c7                	mov    %eax,%edi
     208:	56                   	push   %esi
     209:	53                   	push   %ebx
     20a:	89 d3                	mov    %edx,%ebx
     20c:	8b 6a 20             	mov    0x20(%edx),%ebp
     20f:	8b 42 14             	mov    0x14(%edx),%eax
     212:	0f a3 38             	bt     %edi,(%eax)
     215:	19 c0                	sbb    %eax,%eax
     217:	31 f6                	xor    %esi,%esi
     219:	85 c0                	test   %eax,%eax
     21b:	75 77                	jne    294 <ext3_test_allocatable+0x90>
     21d:	89 e0                	mov    %esp,%eax
     21f:	25 00 e0 ff ff       	and    $0xffffe000,%eax
     224:	ff 40 14             	incl   0x14(%eax)
     227:	89 c6                	mov    %eax,%esi
     229:	eb 1d                	jmp    248 <ext3_test_allocatable+0x44>
     22b:	ff 4e 14             	decl   0x14(%esi)
     22e:	8b 46 08             	mov    0x8(%esi),%eax
     231:	a8 04                	test   $0x4,%al
     233:	74 05                	je     23a <ext3_test_allocatable+0x36>
     235:	e8 fc ff ff ff       	call   236 <ext3_test_allocatable+0x32>
     23a:	f3 90                	pause  
     23c:	ff 46 14             	incl   0x14(%esi)
     23f:	8b 03                	mov    (%ebx),%eax
     241:	a9 00 00 20 00       	test   $0x200000,%eax
     246:	75 e3                	jne    22b <ext3_test_allocatable+0x27>
     248:	f0 0f ba 2b 15       	lock btsl $0x15,(%ebx)
     24d:	19 c0                	sbb    %eax,%eax
     24f:	85 c0                	test   %eax,%eax
     251:	75 ec                	jne    23f <ext3_test_allocatable+0x3b>
     253:	8b 45 14             	mov    0x14(%ebp),%eax
     256:	be 01 00 00 00       	mov    $0x1,%esi
     25b:	85 c0                	test   %eax,%eax
     25d:	74 0d                	je     26c <ext3_test_allocatable+0x68>
     25f:	0f a3 38             	bt     %edi,(%eax)
     262:	19 c0                	sbb    %eax,%eax
     264:	85 c0                	test   %eax,%eax
     266:	0f 94 c0             	sete   %al
     269:	0f b6 f0             	movzbl %al,%esi
     26c:	8b 03                	mov    (%ebx),%eax
     26e:	a9 00 00 20 00       	test   $0x200000,%eax
     273:	75 04                	jne    279 <ext3_test_allocatable+0x75>
     275:	0f 0b                	ud2a   
     277:	eb fe                	jmp    277 <ext3_test_allocatable+0x73>
     279:	f0 0f ba 33 15       	lock btrl $0x15,(%ebx)
     27e:	89 e0                	mov    %esp,%eax
     280:	25 00 e0 ff ff       	and    $0xffffe000,%eax
     285:	ff 48 14             	decl   0x14(%eax)
     288:	8b 40 08             	mov    0x8(%eax),%eax
     28b:	a8 04                	test   $0x4,%al
     28d:	74 05                	je     294 <ext3_test_allocatable+0x90>
     28f:	e8 fc ff ff ff       	call   290 <ext3_test_allocatable+0x8c>
     294:	89 f0                	mov    %esi,%eax
     296:	5b                   	pop    %ebx
     297:	5e                   	pop    %esi
     298:	5f                   	pop    %edi
     299:	5d                   	pop    %ebp
     29a:	c3                   	ret    

0000029b <bitmap_search_next_usable_block>:
bitmap_search_next_usable_block():
     29b:	55                   	push   %ebp
     29c:	89 cd                	mov    %ecx,%ebp
     29e:	57                   	push   %edi
     29f:	56                   	push   %esi
     2a0:	53                   	push   %ebx
     2a1:	89 d3                	mov    %edx,%ebx
     2a3:	83 ec 08             	sub    $0x8,%esp
     2a6:	89 04 24             	mov    %eax,(%esp)
     2a9:	8b 42 20             	mov    0x20(%edx),%eax
     2ac:	89 e6                	mov    %esp,%esi
     2ae:	81 e6 00 e0 ff ff    	and    $0xffffe000,%esi
     2b4:	89 44 24 04          	mov    %eax,0x4(%esp)
     2b8:	e9 83 00 00 00       	jmp    340 <bitmap_search_next_usable_block+0xa5>
     2bd:	8b 43 14             	mov    0x14(%ebx),%eax
     2c0:	89 ea                	mov    %ebp,%edx
     2c2:	8b 0c 24             	mov    (%esp),%ecx
     2c5:	e8 fc ff ff ff       	call   2c6 <bitmap_search_next_usable_block+0x2b>
     2ca:	39 e8                	cmp    %ebp,%eax
     2cc:	89 c7                	mov    %eax,%edi
     2ce:	7d 79                	jge    349 <bitmap_search_next_usable_block+0xae>
     2d0:	89 da                	mov    %ebx,%edx
     2d2:	e8 2d ff ff ff       	call   204 <ext3_test_allocatable>
     2d7:	85 c0                	test   %eax,%eax
     2d9:	75 71                	jne    34c <bitmap_search_next_usable_block+0xb1>
     2db:	ff 46 14             	incl   0x14(%esi)
     2de:	eb 1d                	jmp    2fd <bitmap_search_next_usable_block+0x62>
     2e0:	ff 4e 14             	decl   0x14(%esi)
     2e3:	8b 46 08             	mov    0x8(%esi),%eax
     2e6:	a8 04                	test   $0x4,%al
     2e8:	74 05                	je     2ef <bitmap_search_next_usable_block+0x54>
     2ea:	e8 fc ff ff ff       	call   2eb <bitmap_search_next_usable_block+0x50>
     2ef:	f3 90                	pause  
     2f1:	ff 46 14             	incl   0x14(%esi)
     2f4:	8b 03                	mov    (%ebx),%eax
     2f6:	a9 00 00 20 00       	test   $0x200000,%eax
     2fb:	75 e3                	jne    2e0 <bitmap_search_next_usable_block+0x45>
     2fd:	f0 0f ba 2b 15       	lock btsl $0x15,(%ebx)
     302:	19 c0                	sbb    %eax,%eax
     304:	85 c0                	test   %eax,%eax
     306:	75 ec                	jne    2f4 <bitmap_search_next_usable_block+0x59>
     308:	8b 54 24 04          	mov    0x4(%esp),%edx
     30c:	8b 42 14             	mov    0x14(%edx),%eax
     30f:	85 c0                	test   %eax,%eax
     311:	74 0c                	je     31f <bitmap_search_next_usable_block+0x84>
     313:	89 f9                	mov    %edi,%ecx
     315:	89 ea                	mov    %ebp,%edx
     317:	e8 fc ff ff ff       	call   318 <bitmap_search_next_usable_block+0x7d>
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	8b 03                	mov    (%ebx),%eax
     321:	a9 00 00 20 00       	test   $0x200000,%eax
     326:	75 04                	jne    32c <bitmap_search_next_usable_block+0x91>
     328:	0f 0b                	ud2a   
     32a:	eb fe                	jmp    32a <bitmap_search_next_usable_block+0x8f>
     32c:	f0 0f ba 33 15       	lock btrl $0x15,(%ebx)
     331:	ff 4e 14             	decl   0x14(%esi)
     334:	8b 46 08             	mov    0x8(%esi),%eax
     337:	a8 04                	test   $0x4,%al
     339:	74 05                	je     340 <bitmap_search_next_usable_block+0xa5>
     33b:	e8 fc ff ff ff       	call   33c <bitmap_search_next_usable_block+0xa1>
     340:	39 2c 24             	cmp    %ebp,(%esp)
     343:	0f 8c 74 ff ff ff    	jl     2bd <bitmap_search_next_usable_block+0x22>
     349:	83 cf ff             	or     $0xffffffff,%edi
     34c:	5a                   	pop    %edx
     34d:	89 f8                	mov    %edi,%eax
     34f:	59                   	pop    %ecx
     350:	5b                   	pop    %ebx
     351:	5e                   	pop    %esi
     352:	5f                   	pop    %edi
     353:	5d                   	pop    %ebp
     354:	c3                   	ret    

00000355 <rsv_window_remove>:
rsv_window_remove():
     355:	89 d1                	mov    %edx,%ecx
     357:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
     35e:	c7 42 18 00 00 00 00 	movl   $0x0,0x18(%edx)
     365:	c7 42 10 00 00 00 00 	movl   $0x0,0x10(%edx)
     36c:	8b 90 78 01 00 00    	mov    0x178(%eax),%edx
     372:	89 c8                	mov    %ecx,%eax
     374:	81 c2 08 03 00 00    	add    $0x308,%edx
     37a:	e9 fc ff ff ff       	jmp    37b <rsv_window_remove+0x26>

0000037f <__rsv_window_dump>:
__rsv_window_dump():
     37f:	55                   	push   %ebp
     380:	57                   	push   %edi
     381:	56                   	push   %esi
     382:	89 d6                	mov    %edx,%esi
     384:	53                   	push   %ebx
     385:	83 ec 1c             	sub    $0x1c,%esp
     388:	89 44 24 14          	mov    %eax,0x14(%esp)
     38c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
     390:	8b 44 24 14          	mov    0x14(%esp),%eax
     394:	31 ff                	xor    %edi,%edi
     396:	31 ed                	xor    %ebp,%ebp
     398:	e8 fc ff ff ff       	call   399 <__rsv_window_dump+0x1a>
     39d:	89 c3                	mov    %eax,%ebx
     39f:	8b 44 24 10          	mov    0x10(%esp),%eax
     3a3:	c7 04 24 12 01 00 00 	movl   $0x112,(%esp)
     3aa:	89 44 24 04          	mov    %eax,0x4(%esp)
     3ae:	e8 fc ff ff ff       	call   3af <__rsv_window_dump+0x30>
     3b3:	e9 94 00 00 00       	jmp    44c <__rsv_window_dump+0xcd>
     3b8:	85 f6                	test   %esi,%esi
     3ba:	89 5c 24 18          	mov    %ebx,0x18(%esp)
     3be:	74 1e                	je     3de <__rsv_window_dump+0x5f>
     3c0:	8b 43 18             	mov    0x18(%ebx),%eax
     3c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
     3c7:	8b 43 14             	mov    0x14(%ebx),%eax
     3ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     3ce:	c7 04 24 42 01 00 00 	movl   $0x142,(%esp)
     3d5:	89 44 24 08          	mov    %eax,0x8(%esp)
     3d9:	e8 fc ff ff ff       	call   3da <__rsv_window_dump+0x5b>
     3de:	8b 43 14             	mov    0x14(%ebx),%eax
     3e1:	85 c0                	test   %eax,%eax
     3e3:	74 1a                	je     3ff <__rsv_window_dump+0x80>
     3e5:	3b 43 18             	cmp    0x18(%ebx),%eax
     3e8:	72 15                	jb     3ff <__rsv_window_dump+0x80>
     3ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     3ee:	bd 01 00 00 00       	mov    $0x1,%ebp
     3f3:	c7 04 24 72 01 00 00 	movl   $0x172,(%esp)
     3fa:	e8 fc ff ff ff       	call   3fb <__rsv_window_dump+0x7c>
     3ff:	85 ff                	test   %edi,%edi
     401:	74 1f                	je     422 <__rsv_window_dump+0xa3>
     403:	8b 47 18             	mov    0x18(%edi),%eax
     406:	3b 43 14             	cmp    0x14(%ebx),%eax
     409:	72 17                	jb     422 <__rsv_window_dump+0xa3>
     40b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     40f:	bd 01 00 00 00       	mov    $0x1,%ebp
     414:	c7 04 24 95 01 00 00 	movl   $0x195,(%esp)
     41b:	e8 fc ff ff ff       	call   41c <__rsv_window_dump+0x9d>
     420:	eb 04                	jmp    426 <__rsv_window_dump+0xa7>
     422:	85 ed                	test   %ebp,%ebp
     424:	74 19                	je     43f <__rsv_window_dump+0xc0>
     426:	85 f6                	test   %esi,%esi
     428:	75 15                	jne    43f <__rsv_window_dump+0xc0>
     42a:	c7 04 24 be 01 00 00 	movl   $0x1be,(%esp)
     431:	66 be 01 00          	mov    $0x1,%si
     435:	e8 fc ff ff ff       	call   436 <__rsv_window_dump+0xb7>
     43a:	e9 51 ff ff ff       	jmp    390 <__rsv_window_dump+0x11>
     43f:	89 d8                	mov    %ebx,%eax
     441:	e8 fc ff ff ff       	call   442 <__rsv_window_dump+0xc3>
     446:	8b 7c 24 18          	mov    0x18(%esp),%edi
     44a:	89 c3                	mov    %eax,%ebx
     44c:	85 db                	test   %ebx,%ebx
     44e:	0f 85 64 ff ff ff    	jne    3b8 <__rsv_window_dump+0x39>
     454:	c7 04 24 eb 01 00 00 	movl   $0x1eb,(%esp)
     45b:	e8 fc ff ff ff       	call   45c <__rsv_window_dump+0xdd>
     460:	85 ed                	test   %ebp,%ebp
     462:	74 04                	je     468 <__rsv_window_dump+0xe9>
     464:	0f 0b                	ud2a   
     466:	eb fe                	jmp    466 <__rsv_window_dump+0xe7>
     468:	83 c4 1c             	add    $0x1c,%esp
     46b:	5b                   	pop    %ebx
     46c:	5e                   	pop    %esi
     46d:	5f                   	pop    %edi
     46e:	5d                   	pop    %ebp
     46f:	c3                   	ret    

00000470 <ext3_try_to_allocate>:
ext3_try_to_allocate():
     470:	55                   	push   %ebp
     471:	89 ca                	mov    %ecx,%edx
     473:	57                   	push   %edi
     474:	56                   	push   %esi
     475:	53                   	push   %ebx
     476:	83 ec 1c             	sub    $0x1c,%esp
     479:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
     47e:	89 44 24 04          	mov    %eax,0x4(%esp)
     482:	8b 6c 24 30          	mov    0x30(%esp),%ebp
     486:	8b 74 24 34          	mov    0x34(%esp),%esi
     48a:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
     490:	74 41                	je     4d3 <ext3_try_to_allocate+0x63>
     492:	8b 48 10             	mov    0x10(%eax),%ecx
     495:	31 ff                	xor    %edi,%edi
     497:	8b 40 34             	mov    0x34(%eax),%eax
     49a:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
     49e:	0f af d1             	imul   %ecx,%edx
     4a1:	03 50 14             	add    0x14(%eax),%edx
     4a4:	8b 03                	mov    (%ebx),%eax
     4a6:	89 c3                	mov    %eax,%ebx
     4a8:	29 d3                	sub    %edx,%ebx
     4aa:	39 d0                	cmp    %edx,%eax
     4ac:	0f 43 fb             	cmovae %ebx,%edi
     4af:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
     4b3:	8b 43 04             	mov    0x4(%ebx),%eax
     4b6:	40                   	inc    %eax
     4b7:	29 d0                	sub    %edx,%eax
     4b9:	39 c8                	cmp    %ecx,%eax
     4bb:	0f 47 c1             	cmova  %ecx,%eax
     4be:	39 f7                	cmp    %esi,%edi
     4c0:	89 44 24 08          	mov    %eax,0x8(%esp)
     4c4:	7f 08                	jg     4ce <ext3_try_to_allocate+0x5e>
     4c6:	39 c6                	cmp    %eax,%esi
     4c8:	7d 04                	jge    4ce <ext3_try_to_allocate+0x5e>
     4ca:	89 f7                	mov    %esi,%edi
     4cc:	eb 15                	jmp    4e3 <ext3_try_to_allocate+0x73>
     4ce:	83 ce ff             	or     $0xffffffff,%esi
     4d1:	eb 10                	jmp    4e3 <ext3_try_to_allocate+0x73>
     4d3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
     4d7:	85 f6                	test   %esi,%esi
     4d9:	8b 40 10             	mov    0x10(%eax),%eax
     4dc:	0f 49 fe             	cmovns %esi,%edi
     4df:	89 44 24 08          	mov    %eax,0x8(%esp)
     4e3:	8b 54 24 04          	mov    0x4(%esp),%edx
     4e7:	8b 82 78 01 00 00    	mov    0x178(%edx),%eax
     4ed:	3b 78 10             	cmp    0x10(%eax),%edi
     4f0:	76 04                	jbe    4f6 <ext3_try_to_allocate+0x86>
     4f2:	0f 0b                	ud2a   
     4f4:	eb fe                	jmp    4f4 <ext3_try_to_allocate+0x84>
     4f6:	8b 4c 24 08          	mov    0x8(%esp),%ecx
     4fa:	83 c1 07             	add    $0x7,%ecx
     4fd:	c1 f9 03             	sar    $0x3,%ecx
     500:	89 0c 24             	mov    %ecx,(%esp)
     503:	85 f6                	test   %esi,%esi
     505:	78 11                	js     518 <ext3_try_to_allocate+0xa8>
     507:	89 ea                	mov    %ebp,%edx
     509:	89 f0                	mov    %esi,%eax
     50b:	e8 f4 fc ff ff       	call   204 <ext3_test_allocatable>
     510:	85 c0                	test   %eax,%eax
     512:	0f 85 b7 00 00 00    	jne    5cf <ext3_try_to_allocate+0x15f>
     518:	85 ff                	test   %edi,%edi
     51a:	7e 2c                	jle    548 <ext3_try_to_allocate+0xd8>
     51c:	8d 5f 3f             	lea    0x3f(%edi),%ebx
     51f:	8b 45 14             	mov    0x14(%ebp),%eax
     522:	89 f9                	mov    %edi,%ecx
     524:	83 e3 c0             	and    $0xffffffc0,%ebx
     527:	3b 5c 24 08          	cmp    0x8(%esp),%ebx
     52b:	0f 4f 5c 24 08       	cmovg  0x8(%esp),%ebx
     530:	89 da                	mov    %ebx,%edx
     532:	e8 fc ff ff ff       	call   533 <ext3_try_to_allocate+0xc3>
     537:	39 d8                	cmp    %ebx,%eax
     539:	89 c6                	mov    %eax,%esi
     53b:	7d 0b                	jge    548 <ext3_try_to_allocate+0xd8>
     53d:	89 ea                	mov    %ebp,%edx
     53f:	e8 c0 fc ff ff       	call   204 <ext3_test_allocatable>
     544:	85 c0                	test   %eax,%eax
     546:	75 4d                	jne    595 <ext3_try_to_allocate+0x125>
     548:	31 db                	xor    %ebx,%ebx
     54a:	8b 45 14             	mov    0x14(%ebp),%eax
     54d:	85 ff                	test   %edi,%edi
     54f:	8b 0c 24             	mov    (%esp),%ecx
     552:	0f 49 df             	cmovns %edi,%ebx
     555:	89 da                	mov    %ebx,%edx
     557:	c1 fa 03             	sar    $0x3,%edx
     55a:	01 d0                	add    %edx,%eax
     55c:	29 d1                	sub    %edx,%ecx
     55e:	31 d2                	xor    %edx,%edx
     560:	e8 fc ff ff ff       	call   561 <ext3_try_to_allocate+0xf1>
     565:	2b 45 14             	sub    0x14(%ebp),%eax
     568:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
     56f:	3b 74 24 08          	cmp    0x8(%esp),%esi
     573:	7d 11                	jge    586 <ext3_try_to_allocate+0x116>
     575:	39 fe                	cmp    %edi,%esi
     577:	7c 0d                	jl     586 <ext3_try_to_allocate+0x116>
     579:	89 ea                	mov    %ebp,%edx
     57b:	89 f0                	mov    %esi,%eax
     57d:	e8 82 fc ff ff       	call   204 <ext3_test_allocatable>
     582:	85 c0                	test   %eax,%eax
     584:	75 0f                	jne    595 <ext3_try_to_allocate+0x125>
     586:	8b 4c 24 08          	mov    0x8(%esp),%ecx
     58a:	89 ea                	mov    %ebp,%edx
     58c:	89 d8                	mov    %ebx,%eax
     58e:	e8 08 fd ff ff       	call   29b <bitmap_search_next_usable_block>
     593:	89 c6                	mov    %eax,%esi
     595:	85 f6                	test   %esi,%esi
     597:	0f 88 d5 01 00 00    	js     772 <ext3_try_to_allocate+0x302>
     59d:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
     5a2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     5a9:	00 
     5aa:	74 08                	je     5b4 <ext3_try_to_allocate+0x144>
     5ac:	eb 21                	jmp    5cf <ext3_try_to_allocate+0x15f>
     5ae:	ff 44 24 10          	incl   0x10(%esp)
     5b2:	89 de                	mov    %ebx,%esi
     5b4:	83 7c 24 10 06       	cmpl   $0x6,0x10(%esp)
     5b9:	7f 14                	jg     5cf <ext3_try_to_allocate+0x15f>
     5bb:	39 fe                	cmp    %edi,%esi
     5bd:	7e 10                	jle    5cf <ext3_try_to_allocate+0x15f>
     5bf:	8d 5e ff             	lea    -0x1(%esi),%ebx
     5c2:	89 ea                	mov    %ebp,%edx
     5c4:	89 d8                	mov    %ebx,%eax
     5c6:	e8 39 fc ff ff       	call   204 <ext3_test_allocatable>
     5cb:	85 c0                	test   %eax,%eax
     5cd:	75 df                	jne    5ae <ext3_try_to_allocate+0x13e>
     5cf:	8b 7d 20             	mov    0x20(%ebp),%edi
     5d2:	8b 45 14             	mov    0x14(%ebp),%eax
     5d5:	f0 0f ab 30          	lock bts %esi,(%eax)
     5d9:	19 d2                	sbb    %edx,%edx
     5db:	85 d2                	test   %edx,%edx
     5dd:	0f 85 88 00 00 00    	jne    66b <ext3_try_to_allocate+0x1fb>
     5e3:	89 e0                	mov    %esp,%eax
     5e5:	25 00 e0 ff ff       	and    $0xffffe000,%eax
     5ea:	ff 40 14             	incl   0x14(%eax)
     5ed:	89 c3                	mov    %eax,%ebx
     5ef:	eb 1e                	jmp    60f <ext3_try_to_allocate+0x19f>
     5f1:	ff 4b 14             	decl   0x14(%ebx)
     5f4:	8b 43 08             	mov    0x8(%ebx),%eax
     5f7:	a8 04                	test   $0x4,%al
     5f9:	74 05                	je     600 <ext3_try_to_allocate+0x190>
     5fb:	e8 fc ff ff ff       	call   5fc <ext3_try_to_allocate+0x18c>
     600:	f3 90                	pause  
     602:	ff 43 14             	incl   0x14(%ebx)
     605:	8b 45 00             	mov    0x0(%ebp),%eax
     608:	a9 00 00 20 00       	test   $0x200000,%eax
     60d:	75 e2                	jne    5f1 <ext3_try_to_allocate+0x181>
     60f:	f0 0f ba 6d 00 15    	lock btsl $0x15,0x0(%ebp)
     615:	19 c0                	sbb    %eax,%eax
     617:	85 c0                	test   %eax,%eax
     619:	75 ea                	jne    605 <ext3_try_to_allocate+0x195>
     61b:	8b 47 14             	mov    0x14(%edi),%eax
     61e:	85 c0                	test   %eax,%eax
     620:	74 16                	je     638 <ext3_try_to_allocate+0x1c8>
     622:	0f a3 30             	bt     %esi,(%eax)
     625:	19 c0                	sbb    %eax,%eax
     627:	85 c0                	test   %eax,%eax
     629:	74 0d                	je     638 <ext3_try_to_allocate+0x1c8>
     62b:	8b 45 14             	mov    0x14(%ebp),%eax
     62e:	f0 0f b3 30          	lock btr %esi,(%eax)
     632:	19 d2                	sbb    %edx,%edx
     634:	31 db                	xor    %ebx,%ebx
     636:	eb 05                	jmp    63d <ext3_try_to_allocate+0x1cd>
     638:	bb 01 00 00 00       	mov    $0x1,%ebx
     63d:	8b 45 00             	mov    0x0(%ebp),%eax
     640:	a9 00 00 20 00       	test   $0x200000,%eax
     645:	75 04                	jne    64b <ext3_try_to_allocate+0x1db>
     647:	0f 0b                	ud2a   
     649:	eb fe                	jmp    649 <ext3_try_to_allocate+0x1d9>
     64b:	f0 0f ba 75 00 15    	lock btrl $0x15,0x0(%ebp)
     651:	89 e0                	mov    %esp,%eax
     653:	25 00 e0 ff ff       	and    $0xffffe000,%eax
     658:	ff 48 14             	decl   0x14(%eax)
     65b:	8b 40 08             	mov    0x8(%eax),%eax
     65e:	a8 04                	test   $0x4,%al
     660:	74 05                	je     667 <ext3_try_to_allocate+0x1f7>
     662:	e8 fc ff ff ff       	call   663 <ext3_try_to_allocate+0x1f3>
     667:	85 db                	test   %ebx,%ebx
     669:	75 14                	jne    67f <ext3_try_to_allocate+0x20f>
     66b:	8d 7e 01             	lea    0x1(%esi),%edi
     66e:	3b 7c 24 08          	cmp    0x8(%esp),%edi
     672:	89 fe                	mov    %edi,%esi
     674:	0f 8d f8 00 00 00    	jge    772 <ext3_try_to_allocate+0x302>
     67a:	e9 84 fe ff ff       	jmp    503 <ext3_try_to_allocate+0x93>
     67f:	89 e7                	mov    %esp,%edi
     681:	8d 5e 01             	lea    0x1(%esi),%ebx
     684:	81 e7 00 e0 ff ff    	and    $0xffffe000,%edi
     68a:	eb 01                	jmp    68d <ext3_try_to_allocate+0x21d>
     68c:	43                   	inc    %ebx
     68d:	8b 54 24 38          	mov    0x38(%esp),%edx
     691:	89 d8                	mov    %ebx,%eax
     693:	29 f0                	sub    %esi,%eax
     695:	89 44 24 0c          	mov    %eax,0xc(%esp)
     699:	3b 02                	cmp    (%edx),%eax
     69b:	0f 83 bf 00 00 00    	jae    760 <ext3_try_to_allocate+0x2f0>
     6a1:	3b 5c 24 08          	cmp    0x8(%esp),%ebx
     6a5:	0f 8d b5 00 00 00    	jge    760 <ext3_try_to_allocate+0x2f0>
     6ab:	89 ea                	mov    %ebp,%edx
     6ad:	89 d8                	mov    %ebx,%eax
     6af:	e8 50 fb ff ff       	call   204 <ext3_test_allocatable>
     6b4:	85 c0                	test   %eax,%eax
     6b6:	0f 84 a4 00 00 00    	je     760 <ext3_try_to_allocate+0x2f0>
     6bc:	8b 4d 20             	mov    0x20(%ebp),%ecx
     6bf:	89 4c 24 14          	mov    %ecx,0x14(%esp)
     6c3:	8b 45 14             	mov    0x14(%ebp),%eax
     6c6:	f0 0f ab 18          	lock bts %ebx,(%eax)
     6ca:	19 d2                	sbb    %edx,%edx
     6cc:	85 d2                	test   %edx,%edx
     6ce:	0f 85 8c 00 00 00    	jne    760 <ext3_try_to_allocate+0x2f0>
     6d4:	ff 47 14             	incl   0x14(%edi)
     6d7:	eb 1e                	jmp    6f7 <ext3_try_to_allocate+0x287>
     6d9:	ff 4f 14             	decl   0x14(%edi)
     6dc:	8b 47 08             	mov    0x8(%edi),%eax
     6df:	a8 04                	test   $0x4,%al
     6e1:	74 05                	je     6e8 <ext3_try_to_allocate+0x278>
     6e3:	e8 fc ff ff ff       	call   6e4 <ext3_try_to_allocate+0x274>
     6e8:	f3 90                	pause  
     6ea:	ff 47 14             	incl   0x14(%edi)
     6ed:	8b 45 00             	mov    0x0(%ebp),%eax
     6f0:	a9 00 00 20 00       	test   $0x200000,%eax
     6f5:	75 e2                	jne    6d9 <ext3_try_to_allocate+0x269>
     6f7:	f0 0f ba 6d 00 15    	lock btsl $0x15,0x0(%ebp)
     6fd:	19 c0                	sbb    %eax,%eax
     6ff:	85 c0                	test   %eax,%eax
     701:	75 ea                	jne    6ed <ext3_try_to_allocate+0x27d>
     703:	8b 54 24 14          	mov    0x14(%esp),%edx
     707:	8b 42 14             	mov    0x14(%edx),%eax
     70a:	85 c0                	test   %eax,%eax
     70c:	74 1c                	je     72a <ext3_try_to_allocate+0x2ba>
     70e:	0f a3 18             	bt     %ebx,(%eax)
     711:	19 c0                	sbb    %eax,%eax
     713:	85 c0                	test   %eax,%eax
     715:	74 13                	je     72a <ext3_try_to_allocate+0x2ba>
     717:	8b 45 14             	mov    0x14(%ebp),%eax
     71a:	f0 0f b3 18          	lock btr %ebx,(%eax)
     71e:	19 d2                	sbb    %edx,%edx
     720:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
     727:	00 
     728:	eb 08                	jmp    732 <ext3_try_to_allocate+0x2c2>
     72a:	c7 44 24 18 01 00 00 	movl   $0x1,0x18(%esp)
     731:	00 
     732:	8b 45 00             	mov    0x0(%ebp),%eax
     735:	a9 00 00 20 00       	test   $0x200000,%eax
     73a:	75 04                	jne    740 <ext3_try_to_allocate+0x2d0>
     73c:	0f 0b                	ud2a   
     73e:	eb fe                	jmp    73e <ext3_try_to_allocate+0x2ce>
     740:	f0 0f ba 75 00 15    	lock btrl $0x15,0x0(%ebp)
     746:	ff 4f 14             	decl   0x14(%edi)
     749:	8b 47 08             	mov    0x8(%edi),%eax
     74c:	a8 04                	test   $0x4,%al
     74e:	74 05                	je     755 <ext3_try_to_allocate+0x2e5>
     750:	e8 fc ff ff ff       	call   751 <ext3_try_to_allocate+0x2e1>
     755:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
     75a:	0f 85 2c ff ff ff    	jne    68c <ext3_try_to_allocate+0x21c>
     760:	8b 44 24 0c          	mov    0xc(%esp),%eax
     764:	8b 4c 24 38          	mov    0x38(%esp),%ecx
     768:	89 01                	mov    %eax,(%ecx)
     76a:	89 d8                	mov    %ebx,%eax
     76c:	2b 44 24 0c          	sub    0xc(%esp),%eax
     770:	eb 0d                	jmp    77f <ext3_try_to_allocate+0x30f>
     772:	8b 54 24 38          	mov    0x38(%esp),%edx
     776:	83 c8 ff             	or     $0xffffffff,%eax
     779:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
     77f:	83 c4 1c             	add    $0x1c,%esp
     782:	5b                   	pop    %ebx
     783:	5e                   	pop    %esi
     784:	5f                   	pop    %edi
     785:	5d                   	pop    %ebp
     786:	c3                   	ret    

00000787 <ext3_free_blocks_sb>:
ext3_free_blocks_sb():
     787:	55                   	push   %ebp
     788:	89 cd                	mov    %ecx,%ebp
     78a:	57                   	push   %edi
     78b:	56                   	push   %esi
     78c:	53                   	push   %ebx
     78d:	83 ec 40             	sub    $0x40,%esp
     790:	89 44 24 24          	mov    %eax,0x24(%esp)
     794:	8b 44 24 58          	mov    0x58(%esp),%eax
     798:	89 54 24 20          	mov    %edx,0x20(%esp)
     79c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     7a2:	8b 92 78 01 00 00    	mov    0x178(%edx),%edx
     7a8:	89 54 24 34          	mov    %edx,0x34(%esp)
     7ac:	8b 4a 34             	mov    0x34(%edx),%ecx
     7af:	89 4c 24 30          	mov    %ecx,0x30(%esp)
     7b3:	3b 69 14             	cmp    0x14(%ecx),%ebp
     7b6:	72 0f                	jb     7c7 <ext3_free_blocks_sb+0x40>
     7b8:	8b 44 24 54          	mov    0x54(%esp),%eax
     7bc:	01 e8                	add    %ebp,%eax
     7be:	39 e8                	cmp    %ebp,%eax
     7c0:	72 05                	jb     7c7 <ext3_free_blocks_sb+0x40>
     7c2:	3b 41 04             	cmp    0x4(%ecx),%eax
     7c5:	76 2d                	jbe    7f4 <ext3_free_blocks_sb+0x6d>
     7c7:	8b 44 24 54          	mov    0x54(%esp),%eax
     7cb:	8b 54 24 20          	mov    0x20(%esp),%edx
     7cf:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
     7d3:	c7 44 24 08 12 02 00 	movl   $0x212,0x8(%esp)
     7da:	00 
     7db:	89 44 24 10          	mov    %eax,0x10(%esp)
     7df:	89 14 24             	mov    %edx,(%esp)
     7e2:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
     7e9:	00 
     7ea:	e8 fc ff ff ff       	call   7eb <ext3_free_blocks_sb+0x64>
     7ef:	e9 8f 03 00 00       	jmp    b83 <ext3_free_blocks_sb+0x3fc>
     7f4:	89 e6                	mov    %esp,%esi
     7f6:	31 ff                	xor    %edi,%edi
     7f8:	31 db                	xor    %ebx,%ebx
     7fa:	81 e6 00 e0 ff ff    	and    $0xffffe000,%esi
     800:	8b 4c 24 20          	mov    0x20(%esp),%ecx
     804:	8b 54 24 30          	mov    0x30(%esp),%edx
     808:	8b 81 78 01 00 00    	mov    0x178(%ecx),%eax
     80e:	8b 40 10             	mov    0x10(%eax),%eax
     811:	89 44 24 14          	mov    %eax,0x14(%esp)
     815:	89 e8                	mov    %ebp,%eax
     817:	2b 42 14             	sub    0x14(%edx),%eax
     81a:	31 d2                	xor    %edx,%edx
     81c:	f7 74 24 14          	divl   0x14(%esp)
     820:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
     827:	00 
     828:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     82c:	89 d0                	mov    %edx,%eax
     82e:	03 44 24 54          	add    0x54(%esp),%eax
     832:	3b 44 24 14          	cmp    0x14(%esp),%eax
     836:	89 54 24 18          	mov    %edx,0x18(%esp)
     83a:	76 0c                	jbe    848 <ext3_free_blocks_sb+0xc1>
     83c:	2b 44 24 14          	sub    0x14(%esp),%eax
     840:	29 44 24 54          	sub    %eax,0x54(%esp)
     844:	89 44 24 28          	mov    %eax,0x28(%esp)
     848:	85 ff                	test   %edi,%edi
     84a:	74 07                	je     853 <ext3_free_blocks_sb+0xcc>
     84c:	89 f8                	mov    %edi,%eax
     84e:	e8 fc ff ff ff       	call   84f <ext3_free_blocks_sb+0xc8>
     853:	8b 54 24 1c          	mov    0x1c(%esp),%edx
     857:	8b 44 24 20          	mov    0x20(%esp),%eax
     85b:	e8 48 f9 ff ff       	call   1a8 <read_block_bitmap>
     860:	85 c0                	test   %eax,%eax
     862:	89 c7                	mov    %eax,%edi
     864:	0f 84 19 03 00 00    	je     b83 <ext3_free_blocks_sb+0x3fc>
     86a:	8b 54 24 1c          	mov    0x1c(%esp),%edx
     86e:	8d 4c 24 3c          	lea    0x3c(%esp),%ecx
     872:	8b 44 24 20          	mov    0x20(%esp),%eax
     876:	e8 fc ff ff ff       	call   877 <ext3_free_blocks_sb+0xf0>
     87b:	85 c0                	test   %eax,%eax
     87d:	89 44 24 2c          	mov    %eax,0x2c(%esp)
     881:	0f 84 e1 02 00 00    	je     b68 <ext3_free_blocks_sb+0x3e1>
     887:	8b 10                	mov    (%eax),%edx
     889:	39 ea                	cmp    %ebp,%edx
     88b:	72 0c                	jb     899 <ext3_free_blocks_sb+0x112>
     88d:	8b 4c 24 54          	mov    0x54(%esp),%ecx
     891:	8d 44 0d ff          	lea    -0x1(%ebp,%ecx,1),%eax
     895:	39 c2                	cmp    %eax,%edx
     897:	76 4a                	jbe    8e3 <ext3_free_blocks_sb+0x15c>
     899:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     89d:	8b 50 04             	mov    0x4(%eax),%edx
     8a0:	39 ea                	cmp    %ebp,%edx
     8a2:	72 0c                	jb     8b0 <ext3_free_blocks_sb+0x129>
     8a4:	8b 4c 24 54          	mov    0x54(%esp),%ecx
     8a8:	8d 44 0d ff          	lea    -0x1(%ebp,%ecx,1),%eax
     8ac:	39 c2                	cmp    %eax,%edx
     8ae:	76 33                	jbe    8e3 <ext3_free_blocks_sb+0x15c>
     8b0:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     8b4:	8b 50 08             	mov    0x8(%eax),%edx
     8b7:	39 d5                	cmp    %edx,%ebp
     8b9:	72 0e                	jb     8c9 <ext3_free_blocks_sb+0x142>
     8bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
     8bf:	89 d0                	mov    %edx,%eax
     8c1:	03 41 18             	add    0x18(%ecx),%eax
     8c4:	48                   	dec    %eax
     8c5:	39 c5                	cmp    %eax,%ebp
     8c7:	76 1a                	jbe    8e3 <ext3_free_blocks_sb+0x15c>
     8c9:	8b 44 24 54          	mov    0x54(%esp),%eax
     8cd:	8d 4c 05 ff          	lea    -0x1(%ebp,%eax,1),%ecx
     8d1:	39 d1                	cmp    %edx,%ecx
     8d3:	72 36                	jb     90b <ext3_free_blocks_sb+0x184>
     8d5:	8b 44 24 34          	mov    0x34(%esp),%eax
     8d9:	03 50 18             	add    0x18(%eax),%edx
     8dc:	8d 42 ff             	lea    -0x1(%edx),%eax
     8df:	39 c1                	cmp    %eax,%ecx
     8e1:	77 28                	ja     90b <ext3_free_blocks_sb+0x184>
     8e3:	8b 54 24 54          	mov    0x54(%esp),%edx
     8e7:	8b 4c 24 20          	mov    0x20(%esp),%ecx
     8eb:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
     8ef:	c7 44 24 08 5d 02 00 	movl   $0x25d,0x8(%esp)
     8f6:	00 
     8f7:	89 54 24 10          	mov    %edx,0x10(%esp)
     8fb:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
     902:	00 
     903:	89 0c 24             	mov    %ecx,(%esp)
     906:	e8 fc ff ff ff       	call   907 <ext3_free_blocks_sb+0x180>
     90b:	8b 54 24 24          	mov    0x24(%esp),%edx
     90f:	89 f9                	mov    %edi,%ecx
     911:	b8 30 00 00 00       	mov    $0x30,%eax
     916:	e8 fc ff ff ff       	call   917 <ext3_free_blocks_sb+0x190>
     91b:	85 c0                	test   %eax,%eax
     91d:	89 c3                	mov    %eax,%ebx
     91f:	0f 85 43 02 00 00    	jne    b68 <ext3_free_blocks_sb+0x3e1>
     925:	8b 4c 24 3c          	mov    0x3c(%esp),%ecx
     929:	b8 30 00 00 00       	mov    $0x30,%eax
     92e:	8b 54 24 24          	mov    0x24(%esp),%edx
     932:	e8 fc ff ff ff       	call   933 <ext3_free_blocks_sb+0x1ac>
     937:	85 c0                	test   %eax,%eax
     939:	89 c3                	mov    %eax,%ebx
     93b:	0f 85 27 02 00 00    	jne    b68 <ext3_free_blocks_sb+0x3e1>
     941:	ff 46 14             	incl   0x14(%esi)
     944:	eb 1d                	jmp    963 <ext3_free_blocks_sb+0x1dc>
     946:	ff 4e 14             	decl   0x14(%esi)
     949:	8b 46 08             	mov    0x8(%esi),%eax
     94c:	a8 04                	test   $0x4,%al
     94e:	74 05                	je     955 <ext3_free_blocks_sb+0x1ce>
     950:	e8 fc ff ff ff       	call   951 <ext3_free_blocks_sb+0x1ca>
     955:	f3 90                	pause  
     957:	ff 46 14             	incl   0x14(%esi)
     95a:	8b 07                	mov    (%edi),%eax
     95c:	a9 00 00 20 00       	test   $0x200000,%eax
     961:	75 e3                	jne    946 <ext3_free_blocks_sb+0x1bf>
     963:	f0 0f ba 2f 15       	lock btsl $0x15,(%edi)
     968:	19 c0                	sbb    %eax,%eax
     96a:	85 c0                	test   %eax,%eax
     96c:	75 ec                	jne    95a <ext3_free_blocks_sb+0x1d3>
     96e:	31 db                	xor    %ebx,%ebx
     970:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%esp)
     977:	00 
     978:	e9 26 01 00 00       	jmp    aa3 <ext3_free_blocks_sb+0x31c>
     97d:	8b 46 08             	mov    0x8(%esi),%eax
     980:	a8 04                	test   $0x4,%al
     982:	74 53                	je     9d7 <ext3_free_blocks_sb+0x250>
     984:	8b 07                	mov    (%edi),%eax
     986:	a9 00 00 20 00       	test   $0x200000,%eax
     98b:	75 04                	jne    991 <ext3_free_blocks_sb+0x20a>
     98d:	0f 0b                	ud2a   
     98f:	eb fe                	jmp    98f <ext3_free_blocks_sb+0x208>
     991:	f0 0f ba 37 15       	lock btrl $0x15,(%edi)
     996:	ff 4e 14             	decl   0x14(%esi)
     999:	8b 46 08             	mov    0x8(%esi),%eax
     99c:	a8 04                	test   $0x4,%al
     99e:	74 05                	je     9a5 <ext3_free_blocks_sb+0x21e>
     9a0:	e8 fc ff ff ff       	call   9a1 <ext3_free_blocks_sb+0x21a>
     9a5:	e8 fc ff ff ff       	call   9a6 <ext3_free_blocks_sb+0x21f>
     9aa:	ff 46 14             	incl   0x14(%esi)
     9ad:	eb 1d                	jmp    9cc <ext3_free_blocks_sb+0x245>
     9af:	ff 4e 14             	decl   0x14(%esi)
     9b2:	8b 46 08             	mov    0x8(%esi),%eax
     9b5:	a8 04                	test   $0x4,%al
     9b7:	74 05                	je     9be <ext3_free_blocks_sb+0x237>
     9b9:	e8 fc ff ff ff       	call   9ba <ext3_free_blocks_sb+0x233>
     9be:	f3 90                	pause  
     9c0:	ff 46 14             	incl   0x14(%esi)
     9c3:	8b 07                	mov    (%edi),%eax
     9c5:	a9 00 00 20 00       	test   $0x200000,%eax
     9ca:	75 e3                	jne    9af <ext3_free_blocks_sb+0x228>
     9cc:	f0 0f ba 2f 15       	lock btsl $0x15,(%edi)
     9d1:	19 c0                	sbb    %eax,%eax
     9d3:	85 c0                	test   %eax,%eax
     9d5:	75 ec                	jne    9c3 <ext3_free_blocks_sb+0x23c>
     9d7:	8b 47 20             	mov    0x20(%edi),%eax
     9da:	8b 48 14             	mov    0x14(%eax),%ecx
     9dd:	85 c9                	test   %ecx,%ecx
     9df:	75 30                	jne    a11 <ext3_free_blocks_sb+0x28a>
     9e1:	c7 44 24 10 97 02 00 	movl   $0x297,0x10(%esp)
     9e8:	00 
     9e9:	c7 44 24 0c 20 02 00 	movl   $0x220,0xc(%esp)
     9f0:	00 
     9f1:	c7 44 24 08 01 02 00 	movl   $0x201,0x8(%esp)
     9f8:	00 
     9f9:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
     a00:	00 
     a01:	c7 04 24 c9 02 00 00 	movl   $0x2c9,(%esp)
     a08:	e8 fc ff ff ff       	call   a09 <ext3_free_blocks_sb+0x282>
     a0d:	0f 0b                	ud2a   
     a0f:	eb fe                	jmp    a0f <ext3_free_blocks_sb+0x288>
     a11:	8b 54 24 18          	mov    0x18(%esp),%edx
     a15:	8d 04 13             	lea    (%ebx,%edx,1),%eax
     a18:	f0 0f ab 01          	lock bts %eax,(%ecx)
     a1c:	19 d2                	sbb    %edx,%edx
     a1e:	8b 57 14             	mov    0x14(%edi),%edx
     a21:	f0 0f b3 02          	lock btr %eax,(%edx)
     a25:	19 c0                	sbb    %eax,%eax
     a27:	85 c0                	test   %eax,%eax
     a29:	75 73                	jne    a9e <ext3_free_blocks_sb+0x317>
     a2b:	8b 07                	mov    (%edi),%eax
     a2d:	a9 00 00 20 00       	test   $0x200000,%eax
     a32:	75 04                	jne    a38 <ext3_free_blocks_sb+0x2b1>
     a34:	0f 0b                	ud2a   
     a36:	eb fe                	jmp    a36 <ext3_free_blocks_sb+0x2af>
     a38:	f0 0f ba 37 15       	lock btrl $0x15,(%edi)
     a3d:	ff 4e 14             	decl   0x14(%esi)
     a40:	8b 46 08             	mov    0x8(%esi),%eax
     a43:	a8 04                	test   $0x4,%al
     a45:	74 05                	je     a4c <ext3_free_blocks_sb+0x2c5>
     a47:	e8 fc ff ff ff       	call   a48 <ext3_free_blocks_sb+0x2c1>
     a4c:	8b 4c 24 20          	mov    0x20(%esp),%ecx
     a50:	8d 04 2b             	lea    (%ebx,%ebp,1),%eax
     a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
     a57:	c7 44 24 08 f6 02 00 	movl   $0x2f6,0x8(%esp)
     a5e:	00 
     a5f:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
     a66:	00 
     a67:	89 0c 24             	mov    %ecx,(%esp)
     a6a:	e8 fc ff ff ff       	call   a6b <ext3_free_blocks_sb+0x2e4>
     a6f:	ff 46 14             	incl   0x14(%esi)
     a72:	eb 1d                	jmp    a91 <ext3_free_blocks_sb+0x30a>
     a74:	ff 4e 14             	decl   0x14(%esi)
     a77:	8b 46 08             	mov    0x8(%esi),%eax
     a7a:	a8 04                	test   $0x4,%al
     a7c:	74 05                	je     a83 <ext3_free_blocks_sb+0x2fc>
     a7e:	e8 fc ff ff ff       	call   a7f <ext3_free_blocks_sb+0x2f8>
     a83:	f3 90                	pause  
     a85:	ff 46 14             	incl   0x14(%esi)
     a88:	8b 07                	mov    (%edi),%eax
     a8a:	a9 00 00 20 00       	test   $0x200000,%eax
     a8f:	75 e3                	jne    a74 <ext3_free_blocks_sb+0x2ed>
     a91:	f0 0f ba 2f 15       	lock btsl $0x15,(%edi)
     a96:	19 c0                	sbb    %eax,%eax
     a98:	85 c0                	test   %eax,%eax
     a9a:	75 ec                	jne    a88 <ext3_free_blocks_sb+0x301>
     a9c:	eb 04                	jmp    aa2 <ext3_free_blocks_sb+0x31b>
     a9e:	ff 44 24 38          	incl   0x38(%esp)
     aa2:	43                   	inc    %ebx
     aa3:	3b 5c 24 54          	cmp    0x54(%esp),%ebx
     aa7:	0f 85 d0 fe ff ff    	jne    97d <ext3_free_blocks_sb+0x1f6>
     aad:	8b 07                	mov    (%edi),%eax
     aaf:	a9 00 00 20 00       	test   $0x200000,%eax
     ab4:	75 04                	jne    aba <ext3_free_blocks_sb+0x333>
     ab6:	0f 0b                	ud2a   
     ab8:	eb fe                	jmp    ab8 <ext3_free_blocks_sb+0x331>
     aba:	f0 0f ba 37 15       	lock btrl $0x15,(%edi)
     abf:	ff 4e 14             	decl   0x14(%esi)
     ac2:	8b 46 08             	mov    0x8(%esi),%eax
     ac5:	a8 04                	test   $0x4,%al
     ac7:	74 05                	je     ace <ext3_free_blocks_sb+0x347>
     ac9:	e8 fc ff ff ff       	call   aca <ext3_free_blocks_sb+0x343>
     ace:	83 64 24 1c 07       	andl   $0x7,0x1c(%esp)
     ad3:	c1 64 24 1c 06       	shll   $0x6,0x1c(%esp)
     ad8:	8b 54 24 1c          	mov    0x1c(%esp),%edx
     adc:	8b 44 24 34          	mov    0x34(%esp),%eax
     ae0:	8d 9c 10 00 01 00 00 	lea    0x100(%eax,%edx,1),%ebx
     ae7:	89 d8                	mov    %ebx,%eax
     ae9:	e8 fc ff ff ff       	call   aea <ext3_free_blocks_sb+0x363>
     aee:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
     af2:	8b 44 24 38          	mov    0x38(%esp),%eax
     af6:	66 01 41 0c          	add    %ax,0xc(%ecx)
     afa:	89 d8                	mov    %ebx,%eax
     afc:	e8 fc ff ff ff       	call   afd <ext3_free_blocks_sb+0x376>
     b01:	8b 44 24 34          	mov    0x34(%esp),%eax
     b05:	8b 54 24 54          	mov    0x54(%esp),%edx
     b09:	83 c0 7c             	add    $0x7c,%eax
     b0c:	e8 fc ff ff ff       	call   b0d <ext3_free_blocks_sb+0x386>
     b11:	89 f9                	mov    %edi,%ecx
     b13:	b8 30 00 00 00       	mov    $0x30,%eax
     b18:	8b 54 24 24          	mov    0x24(%esp),%edx
     b1c:	e8 fc ff ff ff       	call   b1d <ext3_free_blocks_sb+0x396>
     b21:	8b 4c 24 3c          	mov    0x3c(%esp),%ecx
     b25:	8b 54 24 24          	mov    0x24(%esp),%edx
     b29:	89 c3                	mov    %eax,%ebx
     b2b:	b8 30 00 00 00       	mov    $0x30,%eax
     b30:	e8 fc ff ff ff       	call   b31 <ext3_free_blocks_sb+0x3aa>
     b35:	85 db                	test   %ebx,%ebx
     b37:	8b 54 24 58          	mov    0x58(%esp),%edx
     b3b:	8b 4c 24 38          	mov    0x38(%esp),%ecx
     b3f:	0f 44 d8             	cmove  %eax,%ebx
     b42:	01 0a                	add    %ecx,(%edx)
     b44:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
     b49:	74 15                	je     b60 <ext3_free_blocks_sb+0x3d9>
     b4b:	85 db                	test   %ebx,%ebx
     b4d:	75 11                	jne    b60 <ext3_free_blocks_sb+0x3d9>
     b4f:	8b 44 24 28          	mov    0x28(%esp),%eax
     b53:	03 6c 24 54          	add    0x54(%esp),%ebp
     b57:	89 44 24 54          	mov    %eax,0x54(%esp)
     b5b:	e9 a0 fc ff ff       	jmp    800 <ext3_free_blocks_sb+0x79>
     b60:	8b 54 24 20          	mov    0x20(%esp),%edx
     b64:	c6 42 11 01          	movb   $0x1,0x11(%edx)
     b68:	89 f8                	mov    %edi,%eax
     b6a:	e8 fc ff ff ff       	call   b6b <ext3_free_blocks_sb+0x3e4>
     b6f:	85 db                	test   %ebx,%ebx
     b71:	74 10                	je     b83 <ext3_free_blocks_sb+0x3fc>
     b73:	8b 44 24 20          	mov    0x20(%esp),%eax
     b77:	89 d9                	mov    %ebx,%ecx
     b79:	ba 30 00 00 00       	mov    $0x30,%edx
     b7e:	e8 fc ff ff ff       	call   b7f <ext3_free_blocks_sb+0x3f8>
     b83:	83 c4 40             	add    $0x40,%esp
     b86:	5b                   	pop    %ebx
     b87:	5e                   	pop    %esi
     b88:	5f                   	pop    %edi
     b89:	5d                   	pop    %ebp
     b8a:	c3                   	ret    

00000b8b <ext3_free_blocks>:
ext3_free_blocks():
     b8b:	57                   	push   %edi
     b8c:	56                   	push   %esi
     b8d:	89 c6                	mov    %eax,%esi
     b8f:	53                   	push   %ebx
     b90:	89 d3                	mov    %edx,%ebx
     b92:	83 ec 0c             	sub    $0xc,%esp
     b95:	8b 92 a4 00 00 00    	mov    0xa4(%edx),%edx
     b9b:	85 d2                	test   %edx,%edx
     b9d:	75 0e                	jne    bad <ext3_free_blocks+0x22>
     b9f:	c7 04 24 18 03 00 00 	movl   $0x318,(%esp)
     ba6:	e8 fc ff ff ff       	call   ba7 <ext3_free_blocks+0x1c>
     bab:	eb 55                	jmp    c02 <ext3_free_blocks+0x77>
     bad:	8d 44 24 08          	lea    0x8(%esp),%eax
     bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     bb9:	89 04 24             	mov    %eax,(%esp)
     bbc:	89 f0                	mov    %esi,%eax
     bbe:	e8 fc ff ff ff       	call   bbf <ext3_free_blocks+0x34>
     bc3:	8b 44 24 08          	mov    0x8(%esp),%eax
     bc7:	85 c0                	test   %eax,%eax
     bc9:	74 37                	je     c02 <ext3_free_blocks+0x77>
     bcb:	89 c6                	mov    %eax,%esi
     bcd:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
     bd3:	31 ff                	xor    %edi,%edi
     bd5:	0f b6 40 10          	movzbl 0x10(%eax),%eax
     bd9:	88 c1                	mov    %al,%cl
     bdb:	31 c0                	xor    %eax,%eax
     bdd:	0f a5 f7             	shld   %cl,%esi,%edi
     be0:	d3 e6                	shl    %cl,%esi
     be2:	f6 c1 20             	test   $0x20,%cl
     be5:	0f 45 fe             	cmovne %esi,%edi
     be8:	0f 45 f0             	cmovne %eax,%esi
     beb:	89 f2                	mov    %esi,%edx
     bed:	89 d8                	mov    %ebx,%eax
     bef:	89 f9                	mov    %edi,%ecx
     bf1:	e8 fc ff ff ff       	call   bf2 <ext3_free_blocks+0x67>
     bf6:	ba 07 00 00 00       	mov    $0x7,%edx
     bfb:	89 d8                	mov    %ebx,%eax
     bfd:	e8 fc ff ff ff       	call   bfe <ext3_free_blocks+0x73>
     c02:	83 c4 0c             	add    $0xc,%esp
     c05:	5b                   	pop    %ebx
     c06:	5e                   	pop    %esi
     c07:	5f                   	pop    %edi
     c08:	c3                   	ret    

00000c09 <ext3_rsv_window_add>:
ext3_rsv_window_add():
     c09:	57                   	push   %edi
     c0a:	56                   	push   %esi
     c0b:	31 f6                	xor    %esi,%esi
     c0d:	53                   	push   %ebx
     c0e:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
     c14:	89 d3                	mov    %edx,%ebx
     c16:	8b 7a 14             	mov    0x14(%edx),%edi
     c19:	05 08 03 00 00       	add    $0x308,%eax
     c1e:	89 c1                	mov    %eax,%ecx
     c20:	eb 27                	jmp    c49 <ext3_rsv_window_add+0x40>
     c22:	3b 7a 14             	cmp    0x14(%edx),%edi
     c25:	8d 4a 08             	lea    0x8(%edx),%ecx
     c28:	72 1d                	jb     c47 <ext3_rsv_window_add+0x3e>
     c2a:	3b 7a 18             	cmp    0x18(%edx),%edi
     c2d:	76 05                	jbe    c34 <ext3_rsv_window_add+0x2b>
     c2f:	8d 4a 04             	lea    0x4(%edx),%ecx
     c32:	eb 13                	jmp    c47 <ext3_rsv_window_add+0x3e>
     c34:	b9 44 00 00 00       	mov    $0x44,%ecx
     c39:	ba 01 00 00 00       	mov    $0x1,%edx
     c3e:	e8 3c f7 ff ff       	call   37f <__rsv_window_dump>
     c43:	0f 0b                	ud2a   
     c45:	eb fe                	jmp    c45 <ext3_rsv_window_add+0x3c>
     c47:	89 d6                	mov    %edx,%esi
     c49:	8b 11                	mov    (%ecx),%edx
     c4b:	85 d2                	test   %edx,%edx
     c4d:	75 d3                	jne    c22 <ext3_rsv_window_add+0x19>
     c4f:	89 33                	mov    %esi,(%ebx)
     c51:	89 c2                	mov    %eax,%edx
     c53:	89 d8                	mov    %ebx,%eax
     c55:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
     c5c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
     c63:	89 19                	mov    %ebx,(%ecx)
     c65:	5b                   	pop    %ebx
     c66:	5e                   	pop    %esi
     c67:	5f                   	pop    %edi
     c68:	e9 fc ff ff ff       	jmp    c69 <ext3_rsv_window_add+0x60>

00000c6d <ext3_try_to_allocate_with_rsv>:
ext3_try_to_allocate_with_rsv():
     c6d:	55                   	push   %ebp
     c6e:	57                   	push   %edi
     c6f:	56                   	push   %esi
     c70:	53                   	push   %ebx
     c71:	83 ec 3c             	sub    $0x3c,%esp
     c74:	89 54 24 1c          	mov    %edx,0x1c(%esp)
     c78:	8b 54 24 5c          	mov    0x5c(%esp),%edx
     c7c:	89 4c 24 18          	mov    %ecx,0x18(%esp)
     c80:	8b 4c 24 60          	mov    0x60(%esp),%ecx
     c84:	89 44 24 20          	mov    %eax,0x20(%esp)
     c88:	8b 7c 24 58          	mov    0x58(%esp),%edi
     c8c:	8b 02                	mov    (%edx),%eax
     c8e:	89 44 24 38          	mov    %eax,0x38(%esp)
     c92:	b8 10 00 00 00       	mov    $0x10,%eax
     c97:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
     c9d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
     ca1:	8b 54 24 1c          	mov    0x1c(%esp),%edx
     ca5:	e8 fc ff ff ff       	call   ca6 <ext3_try_to_allocate_with_rsv+0x39>
     caa:	85 c0                	test   %eax,%eax
     cac:	0f 85 46 03 00 00    	jne    ff8 <ext3_try_to_allocate_with_rsv+0x38b>
     cb2:	85 ff                	test   %edi,%edi
     cb4:	0f 84 f2 02 00 00    	je     fac <ext3_try_to_allocate_with_rsv+0x33f>
     cba:	8b 4c 24 20          	mov    0x20(%esp),%ecx
     cbe:	31 db                	xor    %ebx,%ebx
     cc0:	8b 81 78 01 00 00    	mov    0x178(%ecx),%eax
     cc6:	8b 4c 24 18          	mov    0x18(%esp),%ecx
     cca:	8b 50 10             	mov    0x10(%eax),%edx
     ccd:	0f af ca             	imul   %edx,%ecx
     cd0:	89 4c 24 24          	mov    %ecx,0x24(%esp)
     cd4:	8b 40 34             	mov    0x34(%eax),%eax
     cd7:	8b 48 14             	mov    0x14(%eax),%ecx
     cda:	01 4c 24 24          	add    %ecx,0x24(%esp)
     cde:	8b 44 24 24          	mov    0x24(%esp),%eax
     ce2:	8d 54 02 ff          	lea    -0x1(%edx,%eax,1),%edx
     ce6:	89 54 24 28          	mov    %edx,0x28(%esp)
     cea:	8d 57 14             	lea    0x14(%edi),%edx
     ced:	89 54 24 10          	mov    %edx,0x10(%esp)
     cf1:	8b 77 18             	mov    0x18(%edi),%esi
     cf4:	85 f6                	test   %esi,%esi
     cf6:	74 24                	je     d1c <ext3_try_to_allocate_with_rsv+0xaf>
     cf8:	85 db                	test   %ebx,%ebx
     cfa:	78 20                	js     d1c <ext3_try_to_allocate_with_rsv+0xaf>
     cfc:	8b 4c 24 20          	mov    0x20(%esp),%ecx
     d00:	8b 54 24 54          	mov    0x54(%esp),%edx
     d04:	8b 44 24 10          	mov    0x10(%esp),%eax
     d08:	89 0c 24             	mov    %ecx,(%esp)
     d0b:	8b 4c 24 18          	mov    0x18(%esp),%ecx
     d0f:	e8 ec f2 ff ff       	call   0 <goal_in_my_reservation>
     d14:	85 c0                	test   %eax,%eax
     d16:	0f 85 9e 01 00 00    	jne    eba <ext3_try_to_allocate_with_rsv+0x24d>
     d1c:	8b 54 24 5c          	mov    0x5c(%esp),%edx
     d20:	8b 02                	mov    (%edx),%eax
     d22:	39 47 0c             	cmp    %eax,0xc(%edi)
     d25:	73 03                	jae    d2a <ext3_try_to_allocate_with_rsv+0xbd>
     d27:	89 47 0c             	mov    %eax,0xc(%edi)
     d2a:	8b 4c 24 20          	mov    0x20(%esp),%ecx
     d2e:	8b 6c 24 18          	mov    0x18(%esp),%ebp
     d32:	8b b1 78 01 00 00    	mov    0x178(%ecx),%esi
     d38:	8b 46 10             	mov    0x10(%esi),%eax
     d3b:	8b 56 34             	mov    0x34(%esi),%edx
     d3e:	0f af e8             	imul   %eax,%ebp
     d41:	03 6a 14             	add    0x14(%edx),%ebp
     d44:	8d 44 05 ff          	lea    -0x1(%ebp,%eax,1),%eax
     d48:	89 eb                	mov    %ebp,%ebx
     d4a:	89 44 24 30          	mov    %eax,0x30(%esp)
     d4e:	8b 44 24 54          	mov    0x54(%esp),%eax
     d52:	8b 57 0c             	mov    0xc(%edi),%edx
     d55:	01 e8                	add    %ebp,%eax
     d57:	83 7c 24 54 00       	cmpl   $0x0,0x54(%esp)
     d5c:	0f 49 d8             	cmovns %eax,%ebx
     d5f:	8b 47 18             	mov    0x18(%edi),%eax
     d62:	85 c0                	test   %eax,%eax
     d64:	74 34                	je     d9a <ext3_try_to_allocate_with_rsv+0x12d>
     d66:	8b 4f 14             	mov    0x14(%edi),%ecx
     d69:	3b 4c 24 30          	cmp    0x30(%esp),%ecx
     d6d:	77 0e                	ja     d7d <ext3_try_to_allocate_with_rsv+0x110>
     d6f:	3b 44 24 30          	cmp    0x30(%esp),%eax
     d73:	76 08                	jbe    d7d <ext3_try_to_allocate_with_rsv+0x110>
     d75:	39 cb                	cmp    %ecx,%ebx
     d77:	0f 83 2b 01 00 00    	jae    ea8 <ext3_try_to_allocate_with_rsv+0x23b>
     d7d:	40                   	inc    %eax
     d7e:	29 c8                	sub    %ecx,%eax
     d80:	d1 e8                	shr    %eax
     d82:	39 47 10             	cmp    %eax,0x10(%edi)
     d85:	76 13                	jbe    d9a <ext3_try_to_allocate_with_rsv+0x12d>
     d87:	01 d2                	add    %edx,%edx
     d89:	b8 03 04 00 00       	mov    $0x403,%eax
     d8e:	81 fa 03 04 00 00    	cmp    $0x403,%edx
     d94:	0f 46 c2             	cmovbe %edx,%eax
     d97:	89 47 0c             	mov    %eax,0xc(%edi)
     d9a:	8d 86 00 03 00 00    	lea    0x300(%esi),%eax
     da0:	89 44 24 2c          	mov    %eax,0x2c(%esp)
     da4:	e8 fc ff ff ff       	call   da5 <ext3_try_to_allocate_with_rsv+0x138>
     da9:	8b 86 08 03 00 00    	mov    0x308(%esi),%eax
     daf:	31 f6                	xor    %esi,%esi
     db1:	85 c0                	test   %eax,%eax
     db3:	74 27                	je     ddc <ext3_try_to_allocate_with_rsv+0x16f>
     db5:	8b 50 14             	mov    0x14(%eax),%edx
     db8:	89 c6                	mov    %eax,%esi
     dba:	39 d3                	cmp    %edx,%ebx
     dbc:	73 05                	jae    dc3 <ext3_try_to_allocate_with_rsv+0x156>
     dbe:	8b 40 08             	mov    0x8(%eax),%eax
     dc1:	eb 08                	jmp    dcb <ext3_try_to_allocate_with_rsv+0x15e>
     dc3:	3b 58 18             	cmp    0x18(%eax),%ebx
     dc6:	76 14                	jbe    ddc <ext3_try_to_allocate_with_rsv+0x16f>
     dc8:	8b 40 04             	mov    0x4(%eax),%eax
     dcb:	85 c0                	test   %eax,%eax
     dcd:	75 e6                	jne    db5 <ext3_try_to_allocate_with_rsv+0x148>
     dcf:	39 da                	cmp    %ebx,%edx
     dd1:	76 09                	jbe    ddc <ext3_try_to_allocate_with_rsv+0x16f>
     dd3:	89 f0                	mov    %esi,%eax
     dd5:	e8 fc ff ff ff       	call   dd6 <ext3_try_to_allocate_with_rsv+0x169>
     dda:	89 c6                	mov    %eax,%esi
     ddc:	8b 44 24 30          	mov    0x30(%esp),%eax
     de0:	29 e8                	sub    %ebp,%eax
     de2:	40                   	inc    %eax
     de3:	89 44 24 14          	mov    %eax,0x14(%esp)
     de7:	8b 57 0c             	mov    0xc(%edi),%edx
     dea:	85 f6                	test   %esi,%esi
     dec:	89 54 24 34          	mov    %edx,0x34(%esp)
     df0:	74 79                	je     e6b <ext3_try_to_allocate_with_rsv+0x1fe>
     df2:	8b 46 18             	mov    0x18(%esi),%eax
     df5:	39 c3                	cmp    %eax,%ebx
     df7:	8d 50 01             	lea    0x1(%eax),%edx
     dfa:	0f 46 da             	cmovbe %edx,%ebx
     dfd:	3b 5c 24 30          	cmp    0x30(%esp),%ebx
     e01:	77 68                	ja     e6b <ext3_try_to_allocate_with_rsv+0x1fe>
     e03:	89 f0                	mov    %esi,%eax
     e05:	e8 fc ff ff ff       	call   e06 <ext3_try_to_allocate_with_rsv+0x199>
     e0a:	85 c0                	test   %eax,%eax
     e0c:	89 c2                	mov    %eax,%edx
     e0e:	74 10                	je     e20 <ext3_try_to_allocate_with_rsv+0x1b3>
     e10:	8b 4c 24 34          	mov    0x34(%esp),%ecx
     e14:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
     e17:	3b 42 14             	cmp    0x14(%edx),%eax
     e1a:	76 04                	jbe    e20 <ext3_try_to_allocate_with_rsv+0x1b3>
     e1c:	89 d6                	mov    %edx,%esi
     e1e:	eb d2                	jmp    df2 <ext3_try_to_allocate_with_rsv+0x185>
     e20:	39 fe                	cmp    %edi,%esi
     e22:	74 11                	je     e35 <ext3_try_to_allocate_with_rsv+0x1c8>
     e24:	83 7f 18 00          	cmpl   $0x0,0x18(%edi)
     e28:	74 0b                	je     e35 <ext3_try_to_allocate_with_rsv+0x1c8>
     e2a:	8b 44 24 20          	mov    0x20(%esp),%eax
     e2e:	89 fa                	mov    %edi,%edx
     e30:	e8 20 f5 ff ff       	call   355 <rsv_window_remove>
     e35:	89 5f 14             	mov    %ebx,0x14(%edi)
     e38:	8b 54 24 34          	mov    0x34(%esp),%edx
     e3c:	39 fe                	cmp    %edi,%esi
     e3e:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
     e45:	8d 44 1a ff          	lea    -0x1(%edx,%ebx,1),%eax
     e49:	89 47 18             	mov    %eax,0x18(%edi)
     e4c:	0f 84 c0 01 00 00    	je     1012 <ext3_try_to_allocate_with_rsv+0x3a5>
     e52:	8b 44 24 20          	mov    0x20(%esp),%eax
     e56:	89 fa                	mov    %edi,%edx
     e58:	e8 fc ff ff ff       	call   e59 <ext3_try_to_allocate_with_rsv+0x1ec>
     e5d:	e9 b0 01 00 00       	jmp    1012 <ext3_try_to_allocate_with_rsv+0x3a5>
     e62:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     e66:	e8 fc ff ff ff       	call   e67 <ext3_try_to_allocate_with_rsv+0x1fa>
     e6b:	83 7f 18 00          	cmpl   $0x0,0x18(%edi)
     e6f:	74 0b                	je     e7c <ext3_try_to_allocate_with_rsv+0x20f>
     e71:	8b 44 24 20          	mov    0x20(%esp),%eax
     e75:	89 fa                	mov    %edi,%edx
     e77:	e8 d9 f4 ff ff       	call   355 <rsv_window_remove>
     e7c:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     e80:	e8 fc ff ff ff       	call   e81 <ext3_try_to_allocate_with_rsv+0x214>
     e85:	eb 21                	jmp    ea8 <ext3_try_to_allocate_with_rsv+0x23b>
     e87:	8d 1c 28             	lea    (%eax,%ebp,1),%ebx
     e8a:	3b 5f 14             	cmp    0x14(%edi),%ebx
     e8d:	72 09                	jb     e98 <ext3_try_to_allocate_with_rsv+0x22b>
     e8f:	3b 5f 18             	cmp    0x18(%edi),%ebx
     e92:	0f 86 a2 01 00 00    	jbe    103a <ext3_try_to_allocate_with_rsv+0x3cd>
     e98:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     e9c:	89 fe                	mov    %edi,%esi
     e9e:	e8 fc ff ff ff       	call   e9f <ext3_try_to_allocate_with_rsv+0x232>
     ea3:	e9 3f ff ff ff       	jmp    de7 <ext3_try_to_allocate_with_rsv+0x17a>
     ea8:	83 cb ff             	or     $0xffffffff,%ebx
     eab:	e9 53 01 00 00       	jmp    1003 <ext3_try_to_allocate_with_rsv+0x396>
     eb0:	c7 44 24 54 ff ff ff 	movl   $0xffffffff,0x54(%esp)
     eb7:	ff 
     eb8:	eb 6a                	jmp    f24 <ext3_try_to_allocate_with_rsv+0x2b7>
     eba:	83 7c 24 54 00       	cmpl   $0x0,0x54(%esp)
     ebf:	78 63                	js     f24 <ext3_try_to_allocate_with_rsv+0x2b7>
     ec1:	8b 4c 24 5c          	mov    0x5c(%esp),%ecx
     ec5:	8d 5e 01             	lea    0x1(%esi),%ebx
     ec8:	2b 5c 24 24          	sub    0x24(%esp),%ebx
     ecc:	2b 5c 24 54          	sub    0x54(%esp),%ebx
     ed0:	8b 31                	mov    (%ecx),%esi
     ed2:	39 f3                	cmp    %esi,%ebx
     ed4:	73 4e                	jae    f24 <ext3_try_to_allocate_with_rsv+0x2b7>
     ed6:	8b 44 24 20          	mov    0x20(%esp),%eax
     eda:	8b a8 78 01 00 00    	mov    0x178(%eax),%ebp
     ee0:	81 c5 00 03 00 00    	add    $0x300,%ebp
     ee6:	89 e8                	mov    %ebp,%eax
     ee8:	e8 fc ff ff ff       	call   ee9 <ext3_try_to_allocate_with_rsv+0x27c>
     eed:	85 c0                	test   %eax,%eax
     eef:	74 33                	je     f24 <ext3_try_to_allocate_with_rsv+0x2b7>
     ef1:	89 f8                	mov    %edi,%eax
     ef3:	29 de                	sub    %ebx,%esi
     ef5:	e8 fc ff ff ff       	call   ef6 <ext3_try_to_allocate_with_rsv+0x289>
     efa:	85 c0                	test   %eax,%eax
     efc:	75 05                	jne    f03 <ext3_try_to_allocate_with_rsv+0x296>
     efe:	01 77 18             	add    %esi,0x18(%edi)
     f01:	eb 1a                	jmp    f1d <ext3_try_to_allocate_with_rsv+0x2b0>
     f03:	8b 48 14             	mov    0x14(%eax),%ecx
     f06:	8b 57 18             	mov    0x18(%edi),%edx
     f09:	89 c8                	mov    %ecx,%eax
     f0b:	29 d0                	sub    %edx,%eax
     f0d:	48                   	dec    %eax
     f0e:	39 f0                	cmp    %esi,%eax
     f10:	72 05                	jb     f17 <ext3_try_to_allocate_with_rsv+0x2aa>
     f12:	8d 04 16             	lea    (%esi,%edx,1),%eax
     f15:	eb 03                	jmp    f1a <ext3_try_to_allocate_with_rsv+0x2ad>
     f17:	8d 41 ff             	lea    -0x1(%ecx),%eax
     f1a:	89 47 18             	mov    %eax,0x18(%edi)
     f1d:	89 e8                	mov    %ebp,%eax
     f1f:	e8 fc ff ff ff       	call   f20 <ext3_try_to_allocate_with_rsv+0x2b3>
     f24:	8b 54 24 28          	mov    0x28(%esp),%edx
     f28:	39 57 14             	cmp    %edx,0x14(%edi)
     f2b:	77 09                	ja     f36 <ext3_try_to_allocate_with_rsv+0x2c9>
     f2d:	8b 4c 24 24          	mov    0x24(%esp),%ecx
     f31:	39 4f 18             	cmp    %ecx,0x18(%edi)
     f34:	73 22                	jae    f58 <ext3_try_to_allocate_with_rsv+0x2eb>
     f36:	8b 54 24 20          	mov    0x20(%esp),%edx
     f3a:	b9 10 00 00 00       	mov    $0x10,%ecx
     f3f:	8b 82 78 01 00 00    	mov    0x178(%edx),%eax
     f45:	ba 01 00 00 00       	mov    $0x1,%edx
     f4a:	05 08 03 00 00       	add    $0x308,%eax
     f4f:	e8 2b f4 ff ff       	call   37f <__rsv_window_dump>
     f54:	0f 0b                	ud2a   
     f56:	eb fe                	jmp    f56 <ext3_try_to_allocate_with_rsv+0x2e9>
     f58:	8b 4c 24 10          	mov    0x10(%esp),%ecx
     f5c:	8d 44 24 38          	lea    0x38(%esp),%eax
     f60:	8b 54 24 54          	mov    0x54(%esp),%edx
     f64:	89 44 24 08          	mov    %eax,0x8(%esp)
     f68:	8b 44 24 20          	mov    0x20(%esp),%eax
     f6c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     f70:	8b 4c 24 50          	mov    0x50(%esp),%ecx
     f74:	89 54 24 04          	mov    %edx,0x4(%esp)
     f78:	8b 54 24 1c          	mov    0x1c(%esp),%edx
     f7c:	89 0c 24             	mov    %ecx,(%esp)
     f7f:	8b 4c 24 18          	mov    0x18(%esp),%ecx
     f83:	e8 e8 f4 ff ff       	call   470 <ext3_try_to_allocate>
     f88:	85 c0                	test   %eax,%eax
     f8a:	89 c3                	mov    %eax,%ebx
     f8c:	78 0f                	js     f9d <ext3_try_to_allocate_with_rsv+0x330>
     f8e:	8b 44 24 38          	mov    0x38(%esp),%eax
     f92:	01 47 10             	add    %eax,0x10(%edi)
     f95:	8b 54 24 5c          	mov    0x5c(%esp),%edx
     f99:	89 02                	mov    %eax,(%edx)
     f9b:	eb 45                	jmp    fe2 <ext3_try_to_allocate_with_rsv+0x375>
     f9d:	8b 4c 24 5c          	mov    0x5c(%esp),%ecx
     fa1:	8b 01                	mov    (%ecx),%eax
     fa3:	89 44 24 38          	mov    %eax,0x38(%esp)
     fa7:	e9 45 fd ff ff       	jmp    cf1 <ext3_try_to_allocate_with_rsv+0x84>
     fac:	8b 44 24 5c          	mov    0x5c(%esp),%eax
     fb0:	8b 54 24 54          	mov    0x54(%esp),%edx
     fb4:	8b 4c 24 50          	mov    0x50(%esp),%ecx
     fb8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     fbf:	00 
     fc0:	89 44 24 08          	mov    %eax,0x8(%esp)
     fc4:	8b 44 24 20          	mov    0x20(%esp),%eax
     fc8:	89 54 24 04          	mov    %edx,0x4(%esp)
     fcc:	8b 54 24 1c          	mov    0x1c(%esp),%edx
     fd0:	89 0c 24             	mov    %ecx,(%esp)
     fd3:	8b 4c 24 18          	mov    0x18(%esp),%ecx
     fd7:	e8 94 f4 ff ff       	call   470 <ext3_try_to_allocate>
     fdc:	85 c0                	test   %eax,%eax
     fde:	89 c3                	mov    %eax,%ebx
     fe0:	78 21                	js     1003 <ext3_try_to_allocate_with_rsv+0x396>
     fe2:	8b 4c 24 50          	mov    0x50(%esp),%ecx
     fe6:	b8 10 00 00 00       	mov    $0x10,%eax
     feb:	8b 54 24 1c          	mov    0x1c(%esp),%edx
     fef:	e8 fc ff ff ff       	call   ff0 <ext3_try_to_allocate_with_rsv+0x383>
     ff4:	85 c0                	test   %eax,%eax
     ff6:	74 67                	je     105f <ext3_try_to_allocate_with_rsv+0x3f2>
     ff8:	8b 54 24 60          	mov    0x60(%esp),%edx
     ffc:	83 cb ff             	or     $0xffffffff,%ebx
     fff:	89 02                	mov    %eax,(%edx)
    1001:	eb 5c                	jmp    105f <ext3_try_to_allocate_with_rsv+0x3f2>
    1003:	8b 54 24 50          	mov    0x50(%esp),%edx
    1007:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    100b:	e8 fc ff ff ff       	call   100c <ext3_try_to_allocate_with_rsv+0x39f>
    1010:	eb 4d                	jmp    105f <ext3_try_to_allocate_with_rsv+0x3f2>
    1012:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    1016:	e8 fc ff ff ff       	call   1017 <ext3_try_to_allocate_with_rsv+0x3aa>
    101b:	8b 47 14             	mov    0x14(%edi),%eax
    101e:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    1022:	8b 54 24 50          	mov    0x50(%esp),%edx
    1026:	29 e8                	sub    %ebp,%eax
    1028:	e8 6e f2 ff ff       	call   29b <bitmap_search_next_usable_block>
    102d:	85 c0                	test   %eax,%eax
    102f:	0f 89 52 fe ff ff    	jns    e87 <ext3_try_to_allocate_with_rsv+0x21a>
    1035:	e9 28 fe ff ff       	jmp    e62 <ext3_try_to_allocate_with_rsv+0x1f5>
    103a:	8b 4c 24 20          	mov    0x20(%esp),%ecx
    103e:	8b 54 24 54          	mov    0x54(%esp),%edx
    1042:	8b 44 24 10          	mov    0x10(%esp),%eax
    1046:	89 0c 24             	mov    %ecx,(%esp)
    1049:	8b 4c 24 18          	mov    0x18(%esp),%ecx
    104d:	e8 ae ef ff ff       	call   0 <goal_in_my_reservation>
    1052:	85 c0                	test   %eax,%eax
    1054:	0f 84 56 fe ff ff    	je     eb0 <ext3_try_to_allocate_with_rsv+0x243>
    105a:	e9 c5 fe ff ff       	jmp    f24 <ext3_try_to_allocate_with_rsv+0x2b7>
    105f:	83 c4 3c             	add    $0x3c,%esp
    1062:	89 d8                	mov    %ebx,%eax
    1064:	5b                   	pop    %ebx
    1065:	5e                   	pop    %esi
    1066:	5f                   	pop    %edi
    1067:	5d                   	pop    %ebp
    1068:	c3                   	ret    

00001069 <ext3_new_blocks>:
ext3_new_blocks():
    1069:	55                   	push   %ebp
    106a:	57                   	push   %edi
    106b:	56                   	push   %esi
    106c:	53                   	push   %ebx
    106d:	83 ec 60             	sub    $0x60,%esp
    1070:	89 54 24 2c          	mov    %edx,0x2c(%esp)
    1074:	8b 54 24 74          	mov    0x74(%esp),%edx
    1078:	89 4c 24 28          	mov    %ecx,0x28(%esp)
    107c:	8b 4c 24 78          	mov    0x78(%esp),%ecx
    1080:	89 44 24 30          	mov    %eax,0x30(%esp)
    1084:	c7 44 24 58 00 00 00 	movl   $0x0,0x58(%esp)
    108b:	00 
    108c:	8b 02                	mov    (%edx),%eax
    108e:	89 44 24 54          	mov    %eax,0x54(%esp)
    1092:	c7 01 e4 ff ff ff    	movl   $0xffffffe4,(%ecx)
    1098:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
    109c:	8b bb a4 00 00 00    	mov    0xa4(%ebx),%edi
    10a2:	85 ff                	test   %edi,%edi
    10a4:	75 13                	jne    10b9 <ext3_new_blocks+0x50>
    10a6:	c7 04 24 3d 03 00 00 	movl   $0x33d,(%esp)
    10ad:	31 f6                	xor    %esi,%esi
    10af:	e8 fc ff ff ff       	call   10b0 <ext3_new_blocks+0x47>
    10b4:	e9 e4 04 00 00       	jmp    159d <ext3_new_blocks+0x534>
    10b9:	0f b6 47 10          	movzbl 0x10(%edi),%eax
    10bd:	31 f6                	xor    %esi,%esi
    10bf:	8b 5c 24 54          	mov    0x54(%esp),%ebx
    10c3:	88 c1                	mov    %al,%cl
    10c5:	31 c0                	xor    %eax,%eax
    10c7:	0f a5 de             	shld   %cl,%ebx,%esi
    10ca:	d3 e3                	shl    %cl,%ebx
    10cc:	f6 c1 20             	test   $0x20,%cl
    10cf:	0f 45 f3             	cmovne %ebx,%esi
    10d2:	0f 45 d8             	cmovne %eax,%ebx
    10d5:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    10d9:	89 da                	mov    %ebx,%edx
    10db:	89 f1                	mov    %esi,%ecx
    10dd:	e8 fc ff ff ff       	call   10de <ext3_new_blocks+0x75>
    10e2:	ba 07 00 00 00       	mov    $0x7,%edx
    10e7:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    10eb:	e8 fc ff ff ff       	call   10ec <ext3_new_blocks+0x83>
    10f0:	8b 9f 78 01 00 00    	mov    0x178(%edi),%ebx
    10f6:	8b 54 24 2c          	mov    0x2c(%esp),%edx
    10fa:	89 5c 24 40          	mov    %ebx,0x40(%esp)
    10fe:	8b 43 34             	mov    0x34(%ebx),%eax
    1101:	89 44 24 3c          	mov    %eax,0x3c(%esp)
    1105:	8b 42 b4             	mov    -0x4c(%edx),%eax
    1108:	85 c0                	test   %eax,%eax
    110a:	75 11                	jne    111d <ext3_new_blocks+0xb4>
    110c:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%esp)
    1113:	00 
    1114:	66 c7 44 24 4a 00 00 	movw   $0x0,0x4a(%esp)
    111b:	eb 1c                	jmp    1139 <ext3_new_blocks+0xd0>
    111d:	8b 48 0c             	mov    0xc(%eax),%ecx
    1120:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%esp)
    1127:	00 
    1128:	66 85 c9             	test   %cx,%cx
    112b:	0f 44 44 24 44       	cmove  0x44(%esp),%eax
    1130:	66 89 4c 24 4a       	mov    %cx,0x4a(%esp)
    1135:	89 44 24 44          	mov    %eax,0x44(%esp)
    1139:	8b 44 24 40          	mov    0x40(%esp),%eax
    113d:	e8 03 f0 ff ff       	call   145 <ext3_has_free_blocks>
    1142:	85 c0                	test   %eax,%eax
    1144:	75 17                	jne    115d <ext3_new_blocks+0xf4>
    1146:	8b 5c 24 78          	mov    0x78(%esp),%ebx
    114a:	c7 03 e4 ff ff ff    	movl   $0xffffffe4,(%ebx)
    1150:	c7 44 24 34 00 00 00 	movl   $0x0,0x34(%esp)
    1157:	00 
    1158:	e9 cf 03 00 00       	jmp    152c <ext3_new_blocks+0x4c3>
    115d:	8b 54 24 3c          	mov    0x3c(%esp),%edx
    1161:	8b 42 14             	mov    0x14(%edx),%eax
    1164:	39 44 24 28          	cmp    %eax,0x28(%esp)
    1168:	72 09                	jb     1173 <ext3_new_blocks+0x10a>
    116a:	8b 4c 24 28          	mov    0x28(%esp),%ecx
    116e:	3b 4a 04             	cmp    0x4(%edx),%ecx
    1171:	72 04                	jb     1177 <ext3_new_blocks+0x10e>
    1173:	89 44 24 28          	mov    %eax,0x28(%esp)
    1177:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    117b:	31 d2                	xor    %edx,%edx
    117d:	8b 8f 78 01 00 00    	mov    0x178(%edi),%ecx
    1183:	29 c3                	sub    %eax,%ebx
    1185:	89 d8                	mov    %ebx,%eax
    1187:	f7 71 10             	divl   0x10(%ecx)
    118a:	c7 44 24 34 00 00 00 	movl   $0x0,0x34(%esp)
    1191:	00 
    1192:	89 44 24 24          	mov    %eax,0x24(%esp)
    1196:	89 44 24 50          	mov    %eax,0x50(%esp)
    119a:	8b 54 24 24          	mov    0x24(%esp),%edx
    119e:	8d 4c 24 5c          	lea    0x5c(%esp),%ecx
    11a2:	89 f8                	mov    %edi,%eax
    11a4:	e8 fc ff ff ff       	call   11a5 <ext3_new_blocks+0x13c>
    11a9:	85 c0                	test   %eax,%eax
    11ab:	89 c5                	mov    %eax,%ebp
    11ad:	0f 84 6f 03 00 00    	je     1522 <ext3_new_blocks+0x4b9>
    11b3:	83 7c 24 44 00       	cmpl   $0x0,0x44(%esp)
    11b8:	8b 50 0c             	mov    0xc(%eax),%edx
    11bb:	74 1b                	je     11d8 <ext3_new_blocks+0x16f>
    11bd:	66 39 54 24 4a       	cmp    %dx,0x4a(%esp)
    11c2:	76 14                	jbe    11d8 <ext3_new_blocks+0x16f>
    11c4:	8b 4c 24 44          	mov    0x44(%esp),%ecx
    11c8:	b8 00 00 00 00       	mov    $0x0,%eax
    11cd:	83 79 18 00          	cmpl   $0x0,0x18(%ecx)
    11d1:	0f 45 c1             	cmovne %ecx,%eax
    11d4:	89 44 24 44          	mov    %eax,0x44(%esp)
    11d8:	66 85 d2             	test   %dx,%dx
    11db:	74 78                	je     1255 <ext3_new_blocks+0x1ec>
    11dd:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
    11e1:	8b 87 78 01 00 00    	mov    0x178(%edi),%eax
    11e7:	8b 54 24 24          	mov    0x24(%esp),%edx
    11eb:	8b 73 14             	mov    0x14(%ebx),%esi
    11ee:	8b 58 10             	mov    0x10(%eax),%ebx
    11f1:	89 f8                	mov    %edi,%eax
    11f3:	e8 b0 ef ff ff       	call   1a8 <read_block_bitmap>
    11f8:	85 c0                	test   %eax,%eax
    11fa:	89 44 24 34          	mov    %eax,0x34(%esp)
    11fe:	0f 84 1e 03 00 00    	je     1522 <ext3_new_blocks+0x4b9>
    1204:	8d 44 24 58          	lea    0x58(%esp),%eax
    1208:	8b 54 24 44          	mov    0x44(%esp),%edx
    120c:	89 44 24 10          	mov    %eax,0x10(%esp)
    1210:	8d 44 24 54          	lea    0x54(%esp),%eax
    1214:	8b 4c 24 34          	mov    0x34(%esp),%ecx
    1218:	89 44 24 0c          	mov    %eax,0xc(%esp)
    121c:	8b 44 24 28          	mov    0x28(%esp),%eax
    1220:	89 54 24 08          	mov    %edx,0x8(%esp)
    1224:	31 d2                	xor    %edx,%edx
    1226:	89 0c 24             	mov    %ecx,(%esp)
    1229:	8b 4c 24 24          	mov    0x24(%esp),%ecx
    122d:	29 f0                	sub    %esi,%eax
    122f:	f7 f3                	div    %ebx
    1231:	89 f8                	mov    %edi,%eax
    1233:	89 54 24 04          	mov    %edx,0x4(%esp)
    1237:	8b 54 24 30          	mov    0x30(%esp),%edx
    123b:	e8 2d fa ff ff       	call   c6d <ext3_try_to_allocate_with_rsv>
    1240:	83 7c 24 58 00       	cmpl   $0x0,0x58(%esp)
    1245:	89 c6                	mov    %eax,%esi
    1247:	0f 85 df 02 00 00    	jne    152c <ext3_new_blocks+0x4c3>
    124d:	85 c0                	test   %eax,%eax
    124f:	0f 89 09 01 00 00    	jns    135e <ext3_new_blocks+0x2f5>
    1255:	8b 87 78 01 00 00    	mov    0x178(%edi),%eax
    125b:	8b 40 24             	mov    0x24(%eax),%eax
    125e:	89 44 24 4c          	mov    %eax,0x4c(%esp)
    1262:	f0 83 04 24 00       	lock addl $0x0,(%esp)
    1267:	66 d1 6c 24 4a       	shrw   0x4a(%esp)
    126c:	0f b7 44 24 4a       	movzwl 0x4a(%esp),%eax
    1271:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    1275:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%esp)
    127c:	00 
    127d:	89 44 24 20          	mov    %eax,0x20(%esp)
    1281:	e9 9c 00 00 00       	jmp    1322 <ext3_new_blocks+0x2b9>
    1286:	43                   	inc    %ebx
    1287:	b8 00 00 00 00       	mov    $0x0,%eax
    128c:	3b 5c 24 4c          	cmp    0x4c(%esp),%ebx
    1290:	8d 4c 24 5c          	lea    0x5c(%esp),%ecx
    1294:	0f 43 d8             	cmovae %eax,%ebx
    1297:	89 f8                	mov    %edi,%eax
    1299:	89 da                	mov    %ebx,%edx
    129b:	e8 fc ff ff ff       	call   129c <ext3_new_blocks+0x233>
    12a0:	85 c0                	test   %eax,%eax
    12a2:	89 c5                	mov    %eax,%ebp
    12a4:	0f 84 78 02 00 00    	je     1522 <ext3_new_blocks+0x4b9>
    12aa:	0f b7 40 0c          	movzwl 0xc(%eax),%eax
    12ae:	3b 44 24 20          	cmp    0x20(%esp),%eax
    12b2:	7e 6a                	jle    131e <ext3_new_blocks+0x2b5>
    12b4:	83 7c 24 34 00       	cmpl   $0x0,0x34(%esp)
    12b9:	74 09                	je     12c4 <ext3_new_blocks+0x25b>
    12bb:	8b 44 24 34          	mov    0x34(%esp),%eax
    12bf:	e8 fc ff ff ff       	call   12c0 <ext3_new_blocks+0x257>
    12c4:	89 da                	mov    %ebx,%edx
    12c6:	89 f8                	mov    %edi,%eax
    12c8:	e8 db ee ff ff       	call   1a8 <read_block_bitmap>
    12cd:	85 c0                	test   %eax,%eax
    12cf:	89 44 24 34          	mov    %eax,0x34(%esp)
    12d3:	0f 84 49 02 00 00    	je     1522 <ext3_new_blocks+0x4b9>
    12d9:	8d 44 24 54          	lea    0x54(%esp),%eax
    12dd:	8b 4c 24 44          	mov    0x44(%esp),%ecx
    12e1:	8d 54 24 58          	lea    0x58(%esp),%edx
    12e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
    12e9:	8b 44 24 34          	mov    0x34(%esp),%eax
    12ed:	89 54 24 10          	mov    %edx,0x10(%esp)
    12f1:	8b 54 24 30          	mov    0x30(%esp),%edx
    12f5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    12f9:	89 d9                	mov    %ebx,%ecx
    12fb:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
    1302:	ff 
    1303:	89 04 24             	mov    %eax,(%esp)
    1306:	89 f8                	mov    %edi,%eax
    1308:	e8 60 f9 ff ff       	call   c6d <ext3_try_to_allocate_with_rsv>
    130d:	83 7c 24 58 00       	cmpl   $0x0,0x58(%esp)
    1312:	89 c6                	mov    %eax,%esi
    1314:	0f 85 12 02 00 00    	jne    152c <ext3_new_blocks+0x4c3>
    131a:	85 c0                	test   %eax,%eax
    131c:	79 3c                	jns    135a <ext3_new_blocks+0x2f1>
    131e:	ff 44 24 38          	incl   0x38(%esp)
    1322:	8b 54 24 4c          	mov    0x4c(%esp),%edx
    1326:	39 54 24 38          	cmp    %edx,0x38(%esp)
    132a:	0f 85 56 ff ff ff    	jne    1286 <ext3_new_blocks+0x21d>
    1330:	83 7c 24 44 00       	cmpl   $0x0,0x44(%esp)
    1335:	66 c7 44 24 4a 00 00 	movw   $0x0,0x4a(%esp)
    133c:	74 0d                	je     134b <ext3_new_blocks+0x2e2>
    133e:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%esp)
    1345:	00 
    1346:	e9 4f fe ff ff       	jmp    119a <ext3_new_blocks+0x131>
    134b:	8b 4c 24 78          	mov    0x78(%esp),%ecx
    134f:	c7 01 e4 ff ff ff    	movl   $0xffffffe4,(%ecx)
    1355:	e9 d2 01 00 00       	jmp    152c <ext3_new_blocks+0x4c3>
    135a:	89 5c 24 50          	mov    %ebx,0x50(%esp)
    135e:	8b 4c 24 5c          	mov    0x5c(%esp),%ecx
    1362:	b8 00 00 00 00       	mov    $0x0,%eax
    1367:	8b 54 24 30          	mov    0x30(%esp),%edx
    136b:	e8 fc ff ff ff       	call   136c <ext3_new_blocks+0x303>
    1370:	85 c0                	test   %eax,%eax
    1372:	89 44 24 58          	mov    %eax,0x58(%esp)
    1376:	0f 85 b0 01 00 00    	jne    152c <ext3_new_blocks+0x4c3>
    137c:	8b 9f 78 01 00 00    	mov    0x178(%edi),%ebx
    1382:	8b 55 00             	mov    0x0(%ebp),%edx
    1385:	8b 43 34             	mov    0x34(%ebx),%eax
    1388:	03 70 14             	add    0x14(%eax),%esi
    138b:	8b 44 24 50          	mov    0x50(%esp),%eax
    138f:	0f af 43 10          	imul   0x10(%ebx),%eax
    1393:	01 c6                	add    %eax,%esi
    1395:	39 f2                	cmp    %esi,%edx
    1397:	72 0b                	jb     13a4 <ext3_new_blocks+0x33b>
    1399:	8b 44 24 54          	mov    0x54(%esp),%eax
    139d:	48                   	dec    %eax
    139e:	01 f0                	add    %esi,%eax
    13a0:	39 c2                	cmp    %eax,%edx
    13a2:	76 39                	jbe    13dd <ext3_new_blocks+0x374>
    13a4:	8b 55 04             	mov    0x4(%ebp),%edx
    13a7:	39 f2                	cmp    %esi,%edx
    13a9:	72 0b                	jb     13b6 <ext3_new_blocks+0x34d>
    13ab:	8b 44 24 54          	mov    0x54(%esp),%eax
    13af:	48                   	dec    %eax
    13b0:	01 f0                	add    %esi,%eax
    13b2:	39 c2                	cmp    %eax,%edx
    13b4:	76 27                	jbe    13dd <ext3_new_blocks+0x374>
    13b6:	8b 55 08             	mov    0x8(%ebp),%edx
    13b9:	39 d6                	cmp    %edx,%esi
    13bb:	72 0a                	jb     13c7 <ext3_new_blocks+0x35e>
    13bd:	89 d0                	mov    %edx,%eax
    13bf:	03 43 18             	add    0x18(%ebx),%eax
    13c2:	48                   	dec    %eax
    13c3:	39 c6                	cmp    %eax,%esi
    13c5:	76 16                	jbe    13dd <ext3_new_blocks+0x374>
    13c7:	8b 44 24 54          	mov    0x54(%esp),%eax
    13cb:	48                   	dec    %eax
    13cc:	8d 0c 30             	lea    (%eax,%esi,1),%ecx
    13cf:	39 d1                	cmp    %edx,%ecx
    13d1:	72 2e                	jb     1401 <ext3_new_blocks+0x398>
    13d3:	03 53 18             	add    0x18(%ebx),%edx
    13d6:	8d 42 ff             	lea    -0x1(%edx),%eax
    13d9:	39 c1                	cmp    %eax,%ecx
    13db:	77 24                	ja     1401 <ext3_new_blocks+0x398>
    13dd:	8b 44 24 54          	mov    0x54(%esp),%eax
    13e1:	89 74 24 0c          	mov    %esi,0xc(%esp)
    13e5:	c7 44 24 08 60 03 00 	movl   $0x360,0x8(%esp)
    13ec:	00 
    13ed:	c7 44 24 04 9e 03 00 	movl   $0x39e,0x4(%esp)
    13f4:	00 
    13f5:	89 44 24 10          	mov    %eax,0x10(%esp)
    13f9:	89 3c 24             	mov    %edi,(%esp)
    13fc:	e8 fc ff ff ff       	call   13fd <ext3_new_blocks+0x394>
    1401:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
    1405:	8b 44 24 54          	mov    0x54(%esp),%eax
    1409:	8b 53 04             	mov    0x4(%ebx),%edx
    140c:	48                   	dec    %eax
    140d:	01 f0                	add    %esi,%eax
    140f:	39 d0                	cmp    %edx,%eax
    1411:	72 36                	jb     1449 <ext3_new_blocks+0x3e0>
    1413:	8b 44 24 50          	mov    0x50(%esp),%eax
    1417:	89 5c 24 18          	mov    %ebx,0x18(%esp)
    141b:	bb 01 00 00 00       	mov    $0x1,%ebx
    1420:	89 54 24 10          	mov    %edx,0x10(%esp)
    1424:	89 74 24 0c          	mov    %esi,0xc(%esp)
    1428:	89 44 24 14          	mov    %eax,0x14(%esp)
    142c:	c7 44 24 08 ad 03 00 	movl   $0x3ad,0x8(%esp)
    1433:	00 
    1434:	c7 44 24 04 9e 03 00 	movl   $0x39e,0x4(%esp)
    143b:	00 
    143c:	89 3c 24             	mov    %edi,(%esp)
    143f:	e8 fc ff ff ff       	call   1440 <ext3_new_blocks+0x3d7>
    1444:	e9 e5 00 00 00       	jmp    152e <ext3_new_blocks+0x4c5>
    1449:	83 64 24 50 07       	andl   $0x7,0x50(%esp)
    144e:	c1 64 24 50 06       	shll   $0x6,0x50(%esp)
    1453:	8b 4c 24 50          	mov    0x50(%esp),%ecx
    1457:	8b 54 24 40          	mov    0x40(%esp),%edx
    145b:	8d 9c 0a 00 01 00 00 	lea    0x100(%edx,%ecx,1),%ebx
    1462:	89 d8                	mov    %ebx,%eax
    1464:	e8 fc ff ff ff       	call   1465 <ext3_new_blocks+0x3fc>
    1469:	8b 44 24 54          	mov    0x54(%esp),%eax
    146d:	66 29 45 0c          	sub    %ax,0xc(%ebp)
    1471:	89 d8                	mov    %ebx,%eax
    1473:	bb 01 00 00 00       	mov    $0x1,%ebx
    1478:	e8 fc ff ff ff       	call   1479 <ext3_new_blocks+0x410>
    147d:	8b 54 24 54          	mov    0x54(%esp),%edx
    1481:	8b 44 24 40          	mov    0x40(%esp),%eax
    1485:	f7 da                	neg    %edx
    1487:	83 c0 7c             	add    $0x7c,%eax
    148a:	e8 fc ff ff ff       	call   148b <ext3_new_blocks+0x422>
    148f:	b8 00 00 00 00       	mov    $0x0,%eax
    1494:	8b 4c 24 5c          	mov    0x5c(%esp),%ecx
    1498:	8b 54 24 30          	mov    0x30(%esp),%edx
    149c:	e8 fc ff ff ff       	call   149d <ext3_new_blocks+0x434>
    14a1:	83 7c 24 58 00       	cmpl   $0x0,0x58(%esp)
    14a6:	0f 45 44 24 58       	cmovne 0x58(%esp),%eax
    14ab:	89 44 24 58          	mov    %eax,0x58(%esp)
    14af:	c6 47 11 01          	movb   $0x1,0x11(%edi)
    14b3:	83 7c 24 58 00       	cmpl   $0x0,0x58(%esp)
    14b8:	75 74                	jne    152e <ext3_new_blocks+0x4c5>
    14ba:	8b 5c 24 78          	mov    0x78(%esp),%ebx
    14be:	31 ed                	xor    %ebp,%ebp
    14c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    14c6:	8b 44 24 34          	mov    0x34(%esp),%eax
    14ca:	e8 fc ff ff ff       	call   14cb <ext3_new_blocks+0x462>
    14cf:	8b 44 24 74          	mov    0x74(%esp),%eax
    14d3:	8b 10                	mov    (%eax),%edx
    14d5:	2b 54 24 54          	sub    0x54(%esp),%edx
    14d9:	89 d7                	mov    %edx,%edi
    14db:	8b 54 24 2c          	mov    0x2c(%esp),%edx
    14df:	8b 82 a4 00 00 00    	mov    0xa4(%edx),%eax
    14e5:	0f b6 40 10          	movzbl 0x10(%eax),%eax
    14e9:	88 c1                	mov    %al,%cl
    14eb:	31 c0                	xor    %eax,%eax
    14ed:	0f a5 fd             	shld   %cl,%edi,%ebp
    14f0:	d3 e7                	shl    %cl,%edi
    14f2:	f6 c1 20             	test   $0x20,%cl
    14f5:	0f 45 ef             	cmovne %edi,%ebp
    14f8:	0f 45 f8             	cmovne %eax,%edi
    14fb:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    14ff:	89 fa                	mov    %edi,%edx
    1501:	89 e9                	mov    %ebp,%ecx
    1503:	e8 fc ff ff ff       	call   1504 <ext3_new_blocks+0x49b>
    1508:	ba 07 00 00 00       	mov    $0x7,%edx
    150d:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    1511:	e8 fc ff ff ff       	call   1512 <ext3_new_blocks+0x4a9>
    1516:	8b 44 24 54          	mov    0x54(%esp),%eax
    151a:	8b 5c 24 74          	mov    0x74(%esp),%ebx
    151e:	89 03                	mov    %eax,(%ebx)
    1520:	eb 7b                	jmp    159d <ext3_new_blocks+0x534>
    1522:	8b 44 24 78          	mov    0x78(%esp),%eax
    1526:	c7 00 fb ff ff ff    	movl   $0xfffffffb,(%eax)
    152c:	31 db                	xor    %ebx,%ebx
    152e:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    1532:	85 c9                	test   %ecx,%ecx
    1534:	74 12                	je     1548 <ext3_new_blocks+0x4df>
    1536:	8b 54 24 78          	mov    0x78(%esp),%edx
    153a:	89 f8                	mov    %edi,%eax
    153c:	89 0a                	mov    %ecx,(%edx)
    153e:	ba 00 00 00 00       	mov    $0x0,%edx
    1543:	e8 fc ff ff ff       	call   1544 <ext3_new_blocks+0x4db>
    1548:	85 db                	test   %ebx,%ebx
    154a:	75 3f                	jne    158b <ext3_new_blocks+0x522>
    154c:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
    1550:	31 ff                	xor    %edi,%edi
    1552:	8b 4c 24 74          	mov    0x74(%esp),%ecx
    1556:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
    155c:	8b 31                	mov    (%ecx),%esi
    155e:	0f b6 40 10          	movzbl 0x10(%eax),%eax
    1562:	88 c1                	mov    %al,%cl
    1564:	31 c0                	xor    %eax,%eax
    1566:	0f a5 f7             	shld   %cl,%esi,%edi
    1569:	d3 e6                	shl    %cl,%esi
    156b:	f6 c1 20             	test   $0x20,%cl
    156e:	0f 45 fe             	cmovne %esi,%edi
    1571:	0f 45 f0             	cmovne %eax,%esi
    1574:	89 f2                	mov    %esi,%edx
    1576:	89 d8                	mov    %ebx,%eax
    1578:	89 f9                	mov    %edi,%ecx
    157a:	e8 fc ff ff ff       	call   157b <ext3_new_blocks+0x512>
    157f:	ba 07 00 00 00       	mov    $0x7,%edx
    1584:	89 d8                	mov    %ebx,%eax
    1586:	e8 fc ff ff ff       	call   1587 <ext3_new_blocks+0x51e>
    158b:	31 f6                	xor    %esi,%esi
    158d:	83 7c 24 34 00       	cmpl   $0x0,0x34(%esp)
    1592:	74 09                	je     159d <ext3_new_blocks+0x534>
    1594:	8b 44 24 34          	mov    0x34(%esp),%eax
    1598:	e8 fc ff ff ff       	call   1599 <ext3_new_blocks+0x530>
    159d:	83 c4 60             	add    $0x60,%esp
    15a0:	89 f0                	mov    %esi,%eax
    15a2:	5b                   	pop    %ebx
    15a3:	5e                   	pop    %esi
    15a4:	5f                   	pop    %edi
    15a5:	5d                   	pop    %ebp
    15a6:	c3                   	ret    

000015a7 <ext3_new_block>:
ext3_new_block():
    15a7:	53                   	push   %ebx
    15a8:	83 ec 0c             	sub    $0xc,%esp
    15ab:	8b 5c 24 14          	mov    0x14(%esp),%ebx
    15af:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15b6:	00 
    15b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    15bb:	8d 5c 24 08          	lea    0x8(%esp),%ebx
    15bf:	89 1c 24             	mov    %ebx,(%esp)
    15c2:	e8 fc ff ff ff       	call   15c3 <ext3_new_block+0x1c>
    15c7:	83 c4 0c             	add    $0xc,%esp
    15ca:	5b                   	pop    %ebx
    15cb:	c3                   	ret    

000015cc <ext3_should_retry_alloc>:
ext3_should_retry_alloc():
    15cc:	56                   	push   %esi
    15cd:	89 c6                	mov    %eax,%esi
    15cf:	53                   	push   %ebx
    15d0:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
    15d6:	89 d3                	mov    %edx,%ebx
    15d8:	e8 68 eb ff ff       	call   145 <ext3_has_free_blocks>
    15dd:	85 c0                	test   %eax,%eax
    15df:	74 1f                	je     1600 <ext3_should_retry_alloc+0x34>
    15e1:	8b 13                	mov    (%ebx),%edx
    15e3:	8d 42 01             	lea    0x1(%edx),%eax
    15e6:	83 fa 03             	cmp    $0x3,%edx
    15e9:	89 03                	mov    %eax,(%ebx)
    15eb:	7f 13                	jg     1600 <ext3_should_retry_alloc+0x34>
    15ed:	8b 86 78 01 00 00    	mov    0x178(%esi),%eax
    15f3:	5b                   	pop    %ebx
    15f4:	5e                   	pop    %esi
    15f5:	8b 80 2c 03 00 00    	mov    0x32c(%eax),%eax
    15fb:	e9 fc ff ff ff       	jmp    15fc <ext3_should_retry_alloc+0x30>
    1600:	5b                   	pop    %ebx
    1601:	31 c0                	xor    %eax,%eax
    1603:	5e                   	pop    %esi
    1604:	c3                   	ret    

00001605 <ext3_count_free_blocks>:
ext3_count_free_blocks():
    1605:	55                   	push   %ebp
    1606:	57                   	push   %edi
    1607:	89 c7                	mov    %eax,%edi
    1609:	56                   	push   %esi
    160a:	53                   	push   %ebx
    160b:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
    1611:	8b 68 24             	mov    0x24(%eax),%ebp
    1614:	f0 83 04 24 00       	lock addl $0x0,(%esp)
    1619:	31 f6                	xor    %esi,%esi
    161b:	31 db                	xor    %ebx,%ebx
    161d:	eb 16                	jmp    1635 <ext3_count_free_blocks+0x30>
    161f:	31 c9                	xor    %ecx,%ecx
    1621:	89 da                	mov    %ebx,%edx
    1623:	89 f8                	mov    %edi,%eax
    1625:	e8 fc ff ff ff       	call   1626 <ext3_count_free_blocks+0x21>
    162a:	85 c0                	test   %eax,%eax
    162c:	74 06                	je     1634 <ext3_count_free_blocks+0x2f>
    162e:	0f b7 40 0c          	movzwl 0xc(%eax),%eax
    1632:	01 c6                	add    %eax,%esi
    1634:	43                   	inc    %ebx
    1635:	39 eb                	cmp    %ebp,%ebx
    1637:	75 e6                	jne    161f <ext3_count_free_blocks+0x1a>
    1639:	89 f0                	mov    %esi,%eax
    163b:	5b                   	pop    %ebx
    163c:	5e                   	pop    %esi
    163d:	5f                   	pop    %edi
    163e:	5d                   	pop    %ebp
    163f:	c3                   	ret    

00001640 <ext3_bg_has_super>:
ext3_bg_has_super():
    1640:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
    1646:	b9 01 00 00 00       	mov    $0x1,%ecx
    164b:	8b 40 34             	mov    0x34(%eax),%eax
    164e:	f6 40 64 01          	testb  $0x1,0x64(%eax)
    1652:	74 0e                	je     1662 <ext3_bg_has_super+0x22>
    1654:	89 d0                	mov    %edx,%eax
    1656:	e8 f2 e9 ff ff       	call   4d <ext3_group_sparse>
    165b:	31 c9                	xor    %ecx,%ecx
    165d:	85 c0                	test   %eax,%eax
    165f:	0f 95 c1             	setne  %cl
    1662:	89 c8                	mov    %ecx,%eax
    1664:	c3                   	ret    

00001665 <ext3_bg_num_gdb>:
ext3_bg_num_gdb():
    1665:	55                   	push   %ebp
    1666:	89 c5                	mov    %eax,%ebp
    1668:	57                   	push   %edi
    1669:	56                   	push   %esi
    166a:	89 d6                	mov    %edx,%esi
    166c:	53                   	push   %ebx
    166d:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
    1673:	8b 48 34             	mov    0x34(%eax),%ecx
    1676:	8b 58 20             	mov    0x20(%eax),%ebx
    1679:	f6 41 60 10          	testb  $0x10,0x60(%ecx)
    167d:	8b b9 04 01 00 00    	mov    0x104(%ecx),%edi
    1683:	74 0a                	je     168f <ext3_bg_num_gdb+0x2a>
    1685:	89 d0                	mov    %edx,%eax
    1687:	31 d2                	xor    %edx,%edx
    1689:	f7 f3                	div    %ebx
    168b:	39 f8                	cmp    %edi,%eax
    168d:	73 1e                	jae    16ad <ext3_bg_num_gdb+0x48>
    168f:	f6 41 64 01          	testb  $0x1,0x64(%ecx)
    1693:	74 0d                	je     16a2 <ext3_bg_num_gdb+0x3d>
    1695:	89 f0                	mov    %esi,%eax
    1697:	e8 b1 e9 ff ff       	call   4d <ext3_group_sparse>
    169c:	31 d2                	xor    %edx,%edx
    169e:	85 c0                	test   %eax,%eax
    16a0:	74 2f                	je     16d1 <ext3_bg_num_gdb+0x6c>
    16a2:	8b 85 78 01 00 00    	mov    0x178(%ebp),%eax
    16a8:	8b 50 1c             	mov    0x1c(%eax),%edx
    16ab:	eb 24                	jmp    16d1 <ext3_bg_num_gdb+0x6c>
    16ad:	89 c1                	mov    %eax,%ecx
    16af:	ba 01 00 00 00       	mov    $0x1,%edx
    16b4:	0f af cb             	imul   %ebx,%ecx
    16b7:	39 ce                	cmp    %ecx,%esi
    16b9:	74 16                	je     16d1 <ext3_bg_num_gdb+0x6c>
    16bb:	8d 41 01             	lea    0x1(%ecx),%eax
    16be:	39 c6                	cmp    %eax,%esi
    16c0:	8d 44 19 ff          	lea    -0x1(%ecx,%ebx,1),%eax
    16c4:	0f 94 c2             	sete   %dl
    16c7:	39 c6                	cmp    %eax,%esi
    16c9:	0f 94 c0             	sete   %al
    16cc:	09 c2                	or     %eax,%edx
    16ce:	0f b6 d2             	movzbl %dl,%edx
    16d1:	5b                   	pop    %ebx
    16d2:	89 d0                	mov    %edx,%eax
    16d4:	5e                   	pop    %esi
    16d5:	5f                   	pop    %edi
    16d6:	5d                   	pop    %ebp
    16d7:	c3                   	ret    

000016d8 <ext3_init_block_alloc_info>:
ext3_init_block_alloc_info():
    16d8:	56                   	push   %esi
    16d9:	89 c6                	mov    %eax,%esi
    16db:	53                   	push   %ebx
    16dc:	8b 98 a4 00 00 00    	mov    0xa4(%eax),%ebx
    16e2:	ba 50 00 00 00       	mov    $0x50,%edx
    16e7:	a1 10 00 00 00       	mov    0x10,%eax
    16ec:	e8 fc ff ff ff       	call   16ed <ext3_init_block_alloc_info+0x15>
    16f1:	85 c0                	test   %eax,%eax
    16f3:	89 c2                	mov    %eax,%edx
    16f5:	74 3e                	je     1735 <ext3_init_block_alloc_info+0x5d>
    16f7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    16fe:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    1705:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
    170b:	8b 40 3c             	mov    0x3c(%eax),%eax
    170e:	c7 42 10 00 00 00 00 	movl   $0x0,0x10(%edx)
    1715:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
    171c:	c7 42 20 00 00 00 00 	movl   $0x0,0x20(%edx)
    1723:	25 00 00 01 00       	and    $0x10000,%eax
    1728:	83 f8 01             	cmp    $0x1,%eax
    172b:	19 c0                	sbb    %eax,%eax
    172d:	f7 d0                	not    %eax
    172f:	83 e0 08             	and    $0x8,%eax
    1732:	89 42 0c             	mov    %eax,0xc(%edx)
    1735:	89 56 b4             	mov    %edx,-0x4c(%esi)
    1738:	5b                   	pop    %ebx
    1739:	5e                   	pop    %esi
    173a:	c3                   	ret    

0000173b <ext3_discard_reservation>:
ext3_discard_reservation():
    173b:	57                   	push   %edi
    173c:	56                   	push   %esi
    173d:	89 c6                	mov    %eax,%esi
    173f:	53                   	push   %ebx
    1740:	8b 58 b4             	mov    -0x4c(%eax),%ebx
    1743:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
    1749:	85 db                	test   %ebx,%ebx
    174b:	8b 80 78 01 00 00    	mov    0x178(%eax),%eax
    1751:	74 30                	je     1783 <ext3_discard_reservation+0x48>
    1753:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
    1757:	74 2a                	je     1783 <ext3_discard_reservation+0x48>
    1759:	8d b8 00 03 00 00    	lea    0x300(%eax),%edi
    175f:	89 f8                	mov    %edi,%eax
    1761:	e8 fc ff ff ff       	call   1762 <ext3_discard_reservation+0x27>
    1766:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
    176a:	74 0d                	je     1779 <ext3_discard_reservation+0x3e>
    176c:	8b 86 a4 00 00 00    	mov    0xa4(%esi),%eax
    1772:	89 da                	mov    %ebx,%edx
    1774:	e8 dc eb ff ff       	call   355 <rsv_window_remove>
    1779:	89 f8                	mov    %edi,%eax
    177b:	5b                   	pop    %ebx
    177c:	5e                   	pop    %esi
    177d:	5f                   	pop    %edi
    177e:	e9 fc ff ff ff       	jmp    177f <ext3_discard_reservation+0x44>
    1783:	5b                   	pop    %ebx
    1784:	5e                   	pop    %esi
    1785:	5f                   	pop    %edi
    1786:	c3                   	ret    
Disassembly of section .rodata.str1.1:

00000000 <.rodata.str1.1>:
   0:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
   4:	6b 5f 67 72          	imul   $0x72,0x67(%edi),%ebx
   8:	6f                   	outsl  %ds:(%esi),(%dx)
   9:	75 70                	jne    7b <.rodata.str1.1+0x7b>
   b:	20 3e                	and    %bh,(%esi)
   d:	3d 20 67 72 6f       	cmp    $0x6f726720,%eax
  12:	75 70                	jne    84 <.rodata.str1.1+0x84>
  14:	73 5f                	jae    75 <.rodata.str1.1+0x75>
  16:	63 6f 75             	arpl   %bp,0x75(%edi)
  19:	6e                   	outsb  %ds:(%esi),(%dx)
  1a:	74 20                	je     3c <.rodata.str1.1+0x3c>
  1c:	2d 20 62 6c 6f       	sub    $0x6f6c6220,%eax
  21:	63 6b 5f             	arpl   %bp,0x5f(%ebx)
  24:	67 72 6f             	addr16 jb 96 <.rodata.str1.1+0x96>
  27:	75 70                	jne    99 <.rodata.str1.1+0x99>
  29:	20 3d 20 25 64 2c    	and    %bh,0x2c642520
  2f:	20 67 72             	and    %ah,0x72(%edi)
  32:	6f                   	outsl  %ds:(%esi),(%dx)
  33:	75 70                	jne    a5 <.rodata.str1.1+0xa5>
  35:	73 5f                	jae    96 <.rodata.str1.1+0x96>
  37:	63 6f 75             	arpl   %bp,0x75(%edi)
  3a:	6e                   	outsb  %ds:(%esi),(%dx)
  3b:	74 20                	je     5d <.rodata.str1.1+0x5d>
  3d:	3d 20 25 6c 75       	cmp    $0x756c2520,%eax
  42:	00 65 78             	add    %ah,0x78(%ebp)
  45:	74 33                	je     7a <.rodata.str1.1+0x7a>
  47:	5f                   	pop    %edi
  48:	67                   	addr16
  49:	65                   	gs
  4a:	74 5f                	je     ab <.rodata.str1.1+0xab>
  4c:	67 72 6f             	addr16 jb be <.rodata.str1.1+0xbe>
  4f:	75 70                	jne    c1 <.rodata.str1.1+0xc1>
  51:	5f                   	pop    %edi
  52:	64                   	fs
  53:	65                   	gs
  54:	73 63                	jae    b9 <.rodata.str1.1+0xb9>
  56:	00 47 72             	add    %al,0x72(%edi)
  59:	6f                   	outsl  %ds:(%esi),(%dx)
  5a:	75 70                	jne    cc <.rodata.str1.1+0xcc>
  5c:	20 64 65 73          	and    %ah,0x73(%ebp)
  60:	63 72 69             	arpl   %si,0x69(%edx)
  63:	70 74                	jo     d9 <.rodata.str1.1+0xd9>
  65:	6f                   	outsl  %ds:(%esi),(%dx)
  66:	72 20                	jb     88 <.rodata.str1.1+0x88>
  68:	6e                   	outsb  %ds:(%esi),(%dx)
  69:	6f                   	outsl  %ds:(%esi),(%dx)
  6a:	74 20                	je     8c <.rodata.str1.1+0x8c>
  6c:	6c                   	insb   (%dx),%es:(%edi)
  6d:	6f                   	outsl  %ds:(%esi),(%dx)
  6e:	61                   	popa   
  6f:	64 65 64 20 2d 20 62 	and    %ch,%fs:%gs:0x6f6c6220
  76:	6c 6f 
  78:	63 6b 5f             	arpl   %bp,0x5f(%ebx)
  7b:	67 72 6f             	addr16 jb ed <.rodata.str1.1+0xed>
  7e:	75 70                	jne    f0 <.rodata.str1.1+0xf0>
  80:	20 3d 20 25 64 2c    	and    %bh,0x2c642520
  86:	20 67 72             	and    %ah,0x72(%edi)
  89:	6f                   	outsl  %ds:(%esi),(%dx)
  8a:	75 70                	jne    fc <.rodata.str1.1+0xfc>
  8c:	5f                   	pop    %edi
  8d:	64                   	fs
  8e:	65                   	gs
  8f:	73 63                	jae    f4 <.rodata.str1.1+0xf4>
  91:	20 3d 20 25 6c 75    	and    %bh,0x756c2520
  97:	2c 20                	sub    $0x20,%al
  99:	64                   	fs
  9a:	65                   	gs
  9b:	73 63                	jae    100 <.rodata.str1.1+0x100>
  9d:	20 3d 20 25 6c 75    	and    %bh,0x756c2520
  a3:	00 43 61             	add    %al,0x61(%ebx)
  a6:	6e                   	outsb  %ds:(%esi),(%dx)
  a7:	6e                   	outsb  %ds:(%esi),(%dx)
  a8:	6f                   	outsl  %ds:(%esi),(%dx)
  a9:	74 20                	je     cb <.rodata.str1.1+0xcb>
  ab:	72 65                	jb     112 <.rodata.str1.1+0x112>
  ad:	61                   	popa   
  ae:	64 20 62 6c          	and    %ah,%fs:0x6c(%edx)
  b2:	6f                   	outsl  %ds:(%esi),(%dx)
  b3:	63 6b 20             	arpl   %bp,0x20(%ebx)
  b6:	62 69 74             	bound  %ebp,0x74(%ecx)
  b9:	6d                   	insl   (%dx),%es:(%edi)
  ba:	61                   	popa   
  bb:	70 20                	jo     dd <.rodata.str1.1+0xdd>
  bd:	2d 20 62 6c 6f       	sub    $0x6f6c6220,%eax
  c2:	63 6b 5f             	arpl   %bp,0x5f(%ebx)
  c5:	67 72 6f             	addr16 jb 137 <.rodata.str1.1+0x137>
  c8:	75 70                	jne    13a <.rodata.str1.1+0x13a>
  ca:	20 3d 20 25 64 2c    	and    %bh,0x2c642520
  d0:	20 62 6c             	and    %ah,0x6c(%edx)
  d3:	6f                   	outsl  %ds:(%esi),(%dx)
  d4:	63 6b 5f             	arpl   %bp,0x5f(%ebx)
  d7:	62 69 74             	bound  %ebp,0x74(%ecx)
  da:	6d                   	insl   (%dx),%es:(%edi)
  db:	61                   	popa   
  dc:	70 20                	jo     fe <.rodata.str1.1+0xfe>
  de:	3d 20 25 75 00       	cmp    $0x752520,%eax
  e3:	72 65                	jb     14a <.rodata.str1.1+0x14a>
  e5:	61                   	popa   
  e6:	64                   	fs
  e7:	5f                   	pop    %edi
  e8:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
  ec:	6b 5f 62 69          	imul   $0x69,0x62(%edi),%ebx
  f0:	74 6d                	je     15f <.rodata.str1.1+0x15f>
  f2:	61                   	popa   
  f3:	70 00                	jo     f5 <.rodata.str1.1+0xf5>
  f5:	69 6e 63 6c 75 64 65 	imul   $0x6564756c,0x63(%esi),%ebp
  fc:	2f                   	das    
  fd:	6c                   	insb   (%dx),%es:(%edi)
  fe:	69 6e 75 78 2f 62 69 	imul   $0x69622f78,0x75(%esi),%ebp
 105:	74 5f                	je     166 <.rodata.str1.1+0x166>
 107:	73 70                	jae    179 <.rodata.str1.1+0x179>
 109:	69 6e 6c 6f 63 6b 2e 	imul   $0x2e6b636f,0x6c(%esi),%ebp
 110:	68 00 42 6c 6f       	push   $0x6f6c4200
 115:	63 6b 20             	arpl   %bp,0x20(%ebx)
 118:	41                   	inc    %ecx
 119:	6c                   	insb   (%dx),%es:(%edi)
 11a:	6c                   	insb   (%dx),%es:(%edi)
 11b:	6f                   	outsl  %ds:(%esi),(%dx)
 11c:	63 61 74             	arpl   %sp,0x74(%ecx)
 11f:	69 6f 6e 20 52 65 73 	imul   $0x73655220,0x6e(%edi),%ebp
 126:	65                   	gs
 127:	72 76                	jb     19f <.rodata.str1.1+0x19f>
 129:	61                   	popa   
 12a:	74 69                	je     195 <.rodata.str1.1+0x195>
 12c:	6f                   	outsl  %ds:(%esi),(%dx)
 12d:	6e                   	outsb  %ds:(%esi),(%dx)
 12e:	20 57 69             	and    %dl,0x69(%edi)
 131:	6e                   	outsb  %ds:(%esi),(%dx)
 132:	64 6f                	outsl  %fs:(%esi),(%dx)
 134:	77 73                	ja     1a9 <.rodata.str1.1+0x1a9>
 136:	20 4d 61             	and    %cl,0x61(%ebp)
 139:	70 20                	jo     15b <.rodata.str1.1+0x15b>
 13b:	28 25 73 29 3a 0a    	sub    %ah,0xa3a2973
 141:	00 72 65             	add    %dh,0x65(%edx)
 144:	73 65                	jae    1ab <.rodata.str1.1+0x1ab>
 146:	72 76                	jb     1be <.rodata.str1.1+0x1be>
 148:	61                   	popa   
 149:	74 69                	je     1b4 <.rodata.str1.1+0x1b4>
 14b:	6f                   	outsl  %ds:(%esi),(%dx)
 14c:	6e                   	outsb  %ds:(%esi),(%dx)
 14d:	20 77 69             	and    %dh,0x69(%edi)
 150:	6e                   	outsb  %ds:(%esi),(%dx)
 151:	64 6f                	outsl  %fs:(%esi),(%dx)
 153:	77 20                	ja     175 <.rodata.str1.1+0x175>
 155:	30 78 25             	xor    %bh,0x25(%eax)
 158:	70 20                	jo     17a <.rodata.str1.1+0x17a>
 15a:	73 74                	jae    1d0 <.rodata.str1.1+0x1d0>
 15c:	61                   	popa   
 15d:	72 74                	jb     1d3 <.rodata.str1.1+0x1d3>
 15f:	3a 20                	cmp    (%eax),%ah
 161:	20 25 6c 75 2c 20    	and    %ah,0x202c756c
 167:	65 6e                	outsb  %gs:(%esi),(%dx)
 169:	64 3a 20             	cmp    %fs:(%eax),%ah
 16c:	20 25 6c 75 0a 00    	and    %ah,0xa756c
 172:	42                   	inc    %edx
 173:	61                   	popa   
 174:	64 20 72 65          	and    %dh,%fs:0x65(%edx)
 178:	73 65                	jae    1df <.rodata.str1.1+0x1df>
 17a:	72 76                	jb     1f2 <.rodata.str1.1+0x1f2>
 17c:	61                   	popa   
 17d:	74 69                	je     1e8 <.rodata.str1.1+0x1e8>
 17f:	6f                   	outsl  %ds:(%esi),(%dx)
 180:	6e                   	outsb  %ds:(%esi),(%dx)
 181:	20 25 70 20 28 73    	and    %ah,0x73282070
 187:	74 61                	je     1ea <.rodata.str1.1+0x1ea>
 189:	72 74                	jb     1ff <.rodata.str1.1+0x1ff>
 18b:	20 3e                	and    %bh,(%esi)
 18d:	3d 20 65 6e 64       	cmp    $0x646e6520,%eax
 192:	29 0a                	sub    %ecx,(%edx)
 194:	00 42 61             	add    %al,0x61(%edx)
 197:	64 20 72 65          	and    %dh,%fs:0x65(%edx)
 19b:	73 65                	jae    202 <.rodata.str1.1+0x202>
 19d:	72 76                	jb     215 <.rodata.str1.1+0x215>
 19f:	61                   	popa   
 1a0:	74 69                	je     20b <.rodata.str1.1+0x20b>
 1a2:	6f                   	outsl  %ds:(%esi),(%dx)
 1a3:	6e                   	outsb  %ds:(%esi),(%dx)
 1a4:	20 25 70 20 28 70    	and    %ah,0x70282070
 1aa:	72 65                	jb     211 <.rodata.str1.1+0x211>
 1ac:	76 2d                	jbe    1db <.rodata.str1.1+0x1db>
 1ae:	3e 65 6e             	outsb  %ds:%gs:(%esi),(%dx)
 1b1:	64 20 3e             	and    %bh,%fs:(%esi)
 1b4:	3d 20 73 74 61       	cmp    $0x61747320,%eax
 1b9:	72 74                	jb     22f <.rodata.str1.1+0x22f>
 1bb:	29 0a                	sub    %ecx,(%edx)
 1bd:	00 52 65             	add    %dl,0x65(%edx)
 1c0:	73 74                	jae    236 <.rodata.str1.1+0x236>
 1c2:	61                   	popa   
 1c3:	72 74                	jb     239 <.rodata.str1.1+0x239>
 1c5:	69 6e 67 20 72 65 73 	imul   $0x73657220,0x67(%esi),%ebp
 1cc:	65                   	gs
 1cd:	72 76                	jb     245 <.rodata.str1.1+0x245>
 1cf:	61                   	popa   
 1d0:	74 69                	je     23b <.rodata.str1.1+0x23b>
 1d2:	6f                   	outsl  %ds:(%esi),(%dx)
 1d3:	6e                   	outsb  %ds:(%esi),(%dx)
 1d4:	20 77 61             	and    %dh,0x61(%edi)
 1d7:	6c                   	insb   (%dx),%es:(%edi)
 1d8:	6b 20 69             	imul   $0x69,(%eax),%esp
 1db:	6e                   	outsb  %ds:(%esi),(%dx)
 1dc:	20 76 65             	and    %dh,0x65(%esi)
 1df:	72 62                	jb     243 <.rodata.str1.1+0x243>
 1e1:	6f                   	outsl  %ds:(%esi),(%dx)
 1e2:	73 65                	jae    249 <.rodata.str1.1+0x249>
 1e4:	20 6d 6f             	and    %ch,0x6f(%ebp)
 1e7:	64 65 0a 00          	or     %fs:%gs:(%eax),%al
 1eb:	57                   	push   %edi
 1ec:	69 6e 64 6f 77 20 6d 	imul   $0x6d20776f,0x64(%esi),%ebp
 1f3:	61                   	popa   
 1f4:	70 20                	jo     216 <.rodata.str1.1+0x216>
 1f6:	63 6f 6d             	arpl   %bp,0x6d(%edi)
 1f9:	70 6c                	jo     267 <.rodata.str1.1+0x267>
 1fb:	65                   	gs
 1fc:	74 65                	je     263 <.rodata.str1.1+0x263>
 1fe:	2e 0a 00             	or     %cs:(%eax),%al
 201:	66                   	data16
 202:	73 2f                	jae    233 <.rodata.str1.1+0x233>
 204:	65                   	gs
 205:	78 74                	js     27b <.rodata.str1.1+0x27b>
 207:	33 2f                	xor    (%edi),%ebp
 209:	62 61 6c             	bound  %esp,0x6c(%ecx)
 20c:	6c                   	insb   (%dx),%es:(%edi)
 20d:	6f                   	outsl  %ds:(%esi),(%dx)
 20e:	63 2e                	arpl   %bp,(%esi)
 210:	63 00                	arpl   %ax,(%eax)
 212:	46                   	inc    %esi
 213:	72 65                	jb     27a <.rodata.str1.1+0x27a>
 215:	65 69 6e 67 20 62 6c 	imul   $0x6f6c6220,%gs:0x67(%esi),%ebp
 21c:	6f 
 21d:	63 6b 73             	arpl   %bp,0x73(%ebx)
 220:	20 6e 6f             	and    %ch,0x6f(%esi)
 223:	74 20                	je     245 <.rodata.str1.1+0x245>
 225:	69 6e 20 64 61 74 61 	imul   $0x61746164,0x20(%esi),%ebp
 22c:	7a 6f                	jp     29d <.rodata.str1.1+0x29d>
 22e:	6e                   	outsb  %ds:(%esi),(%dx)
 22f:	65 20 2d 20 62 6c 6f 	and    %ch,%gs:0x6f6c6220
 236:	63 6b 20             	arpl   %bp,0x20(%ebx)
 239:	3d 20 25 6c 75       	cmp    $0x756c2520,%eax
 23e:	2c 20                	sub    $0x20,%al
 240:	63 6f 75             	arpl   %bp,0x75(%edi)
 243:	6e                   	outsb  %ds:(%esi),(%dx)
 244:	74 20                	je     266 <.rodata.str1.1+0x266>
 246:	3d 20 25 6c 75       	cmp    $0x756c2520,%eax
 24b:	00 65 78             	add    %ah,0x78(%ebp)
 24e:	74 33                	je     283 <.rodata.str1.1+0x283>
 250:	5f                   	pop    %edi
 251:	66                   	data16
 252:	72 65                	jb     2b9 <.rodata.str1.1+0x2b9>
 254:	65                   	gs
 255:	5f                   	pop    %edi
 256:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
 25a:	6b 73 00 46          	imul   $0x46,0x0(%ebx),%esi
 25e:	72 65                	jb     2c5 <.rodata.str1.1+0x2c5>
 260:	65 69 6e 67 20 62 6c 	imul   $0x6f6c6220,%gs:0x67(%esi),%ebp
 267:	6f 
 268:	63 6b 73             	arpl   %bp,0x73(%ebx)
 26b:	20 69 6e             	and    %ch,0x6e(%ecx)
 26e:	20 73 79             	and    %dh,0x79(%ebx)
 271:	73 74                	jae    2e7 <.rodata.str1.1+0x2e7>
 273:	65                   	gs
 274:	6d                   	insl   (%dx),%es:(%edi)
 275:	20 7a 6f             	and    %bh,0x6f(%edx)
 278:	6e                   	outsb  %ds:(%esi),(%dx)
 279:	65                   	gs
 27a:	73 20                	jae    29c <.rodata.str1.1+0x29c>
 27c:	2d 20 42 6c 6f       	sub    $0x6f6c4220,%eax
 281:	63 6b 20             	arpl   %bp,0x20(%ebx)
 284:	3d 20 25 6c 75       	cmp    $0x756c2520,%eax
 289:	2c 20                	sub    $0x20,%al
 28b:	63 6f 75             	arpl   %bp,0x75(%edi)
 28e:	6e                   	outsb  %ds:(%esi),(%dx)
 28f:	74 20                	je     2b1 <.rodata.str1.1+0x2b1>
 291:	3d 20 25 6c 75       	cmp    $0x756c2520,%eax
 296:	00 62 68             	add    %ah,0x68(%edx)
 299:	32 6a 68             	xor    0x68(%edx),%ch
 29c:	28 62 69             	sub    %ah,0x69(%edx)
 29f:	74 6d                	je     30e <.rodata.str1.1+0x30e>
 2a1:	61                   	popa   
 2a2:	70 5f                	jo     303 <.rodata.str1.1+0x303>
 2a4:	62 68 29             	bound  %ebp,0x29(%eax)
 2a7:	2d 3e 62 5f 63       	sub    $0x635f623e,%eax
 2ac:	6f                   	outsl  %ds:(%esi),(%dx)
 2ad:	6d                   	insl   (%dx),%es:(%edi)
 2ae:	6d                   	insl   (%dx),%es:(%edi)
 2af:	69 74 74 65 64 5f 64 	imul   $0x61645f64,0x65(%esp,%esi,2),%esi
 2b6:	61 
 2b7:	74 61                	je     31a <.rodata.str1.1+0x31a>
 2b9:	20 21                	and    %ah,(%ecx)
 2bb:	3d 20 28 28 76       	cmp    $0x76282820,%eax
 2c0:	6f                   	outsl  %ds:(%esi),(%dx)
 2c1:	69 64 20 2a 29 30 29 	imul   $0x293029,0x2a(%eax),%esp
 2c8:	00 
 2c9:	3c 30                	cmp    $0x30,%al
 2cb:	3e                   	ds
 2cc:	41                   	inc    %ecx
 2cd:	73 73                	jae    342 <.rodata.str1.1+0x342>
 2cf:	65                   	gs
 2d0:	72 74                	jb     346 <.rodata.str1.1+0x346>
 2d2:	69 6f 6e 20 66 61 69 	imul   $0x69616620,0x6e(%edi),%ebp
 2d9:	6c                   	insb   (%dx),%es:(%edi)
 2da:	75 72                	jne    34e <.rodata.str1.1+0x34e>
 2dc:	65 20 69 6e          	and    %ch,%gs:0x6e(%ecx)
 2e0:	20 25 73 28 29 20    	and    %ah,0x20292873
 2e6:	61                   	popa   
 2e7:	74 20                	je     309 <.rodata.str1.1+0x309>
 2e9:	25 73 3a 25 64       	and    $0x64253a73,%eax
 2ee:	3a 20                	cmp    (%eax),%ah
 2f0:	22 25 73 22 0a 00    	and    0xa2273,%ah
 2f6:	62 69 74             	bound  %ebp,0x74(%ecx)
 2f9:	20 61 6c             	and    %ah,0x6c(%ecx)
 2fc:	72 65                	jb     363 <.rodata.str1.1+0x363>
 2fe:	61                   	popa   
 2ff:	64                   	fs
 300:	79 20                	jns    322 <.rodata.str1.1+0x322>
 302:	63 6c 65 61          	arpl   %bp,0x61(%ebp)
 306:	72 65                	jb     36d <.rodata.str1.1+0x36d>
 308:	64 20 66 6f          	and    %ah,%fs:0x6f(%esi)
 30c:	72 20                	jb     32e <.rodata.str1.1+0x32e>
 30e:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
 312:	6b 20 25             	imul   $0x25,(%eax),%esp
 315:	6c                   	insb   (%dx),%es:(%edi)
 316:	75 00                	jne    318 <.rodata.str1.1+0x318>
 318:	65                   	gs
 319:	78 74                	js     38f <.rodata.str1.1+0x38f>
 31b:	33 5f 66             	xor    0x66(%edi),%ebx
 31e:	72 65                	jb     385 <.rodata.str1.1+0x385>
 320:	65                   	gs
 321:	5f                   	pop    %edi
 322:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
 326:	6b 73 3a 20          	imul   $0x20,0x3a(%ebx),%esi
 32a:	6e                   	outsb  %ds:(%esi),(%dx)
 32b:	6f                   	outsl  %ds:(%esi),(%dx)
 32c:	6e                   	outsb  %ds:(%esi),(%dx)
 32d:	65                   	gs
 32e:	78 69                	js     399 <.rodata.str1.1+0x399>
 330:	73 74                	jae    3a6 <.rodata.str1.1+0x3a6>
 332:	65 6e                	outsb  %gs:(%esi),(%dx)
 334:	74 20                	je     356 <.rodata.str1.1+0x356>
 336:	64                   	fs
 337:	65                   	gs
 338:	76 69                	jbe    3a3 <.rodata.str1.1+0x3a3>
 33a:	63 65 00             	arpl   %sp,0x0(%ebp)
 33d:	65                   	gs
 33e:	78 74                	js     3b4 <.rodata.str1.1+0x3b4>
 340:	33 5f 6e             	xor    0x6e(%edi),%ebx
 343:	65                   	gs
 344:	77 5f                	ja     3a5 <.rodata.str1.1+0x3a5>
 346:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
 34a:	6b 3a 20             	imul   $0x20,(%edx),%edi
 34d:	6e                   	outsb  %ds:(%esi),(%dx)
 34e:	6f                   	outsl  %ds:(%esi),(%dx)
 34f:	6e                   	outsb  %ds:(%esi),(%dx)
 350:	65                   	gs
 351:	78 69                	js     3bc <.rodata.str1.1+0x3bc>
 353:	73 74                	jae    3c9 <.rodata.str1.1+0x3c9>
 355:	65 6e                	outsb  %gs:(%esi),(%dx)
 357:	74 20                	je     379 <.rodata.str1.1+0x379>
 359:	64                   	fs
 35a:	65                   	gs
 35b:	76 69                	jbe    3c6 <.rodata.str1.1+0x3c6>
 35d:	63 65 00             	arpl   %sp,0x0(%ebp)
 360:	41                   	inc    %ecx
 361:	6c                   	insb   (%dx),%es:(%edi)
 362:	6c                   	insb   (%dx),%es:(%edi)
 363:	6f                   	outsl  %ds:(%esi),(%dx)
 364:	63 61 74             	arpl   %sp,0x74(%ecx)
 367:	69 6e 67 20 62 6c 6f 	imul   $0x6f6c6220,0x67(%esi),%ebp
 36e:	63 6b 20             	arpl   %bp,0x20(%ebx)
 371:	69 6e 20 73 79 73 74 	imul   $0x74737973,0x20(%esi),%ebp
 378:	65                   	gs
 379:	6d                   	insl   (%dx),%es:(%edi)
 37a:	20 7a 6f             	and    %bh,0x6f(%edx)
 37d:	6e                   	outsb  %ds:(%esi),(%dx)
 37e:	65 20 2d 20 62 6c 6f 	and    %ch,%gs:0x6f6c6220
 385:	63 6b 73             	arpl   %bp,0x73(%ebx)
 388:	20 66 72             	and    %ah,0x72(%esi)
 38b:	6f                   	outsl  %ds:(%esi),(%dx)
 38c:	6d                   	insl   (%dx),%es:(%edi)
 38d:	20 25 6c 75 2c 20    	and    %ah,0x202c756c
 393:	6c                   	insb   (%dx),%es:(%edi)
 394:	65 6e                	outsb  %gs:(%esi),(%dx)
 396:	67 74 68             	addr16 je 401 <__rsv_window_dump+0x82>
 399:	20 25 6c 75 00 65    	and    %ah,0x6500756c
 39f:	78 74                	js     415 <__rsv_window_dump+0x96>
 3a1:	33 5f 6e             	xor    0x6e(%edi),%ebx
 3a4:	65                   	gs
 3a5:	77 5f                	ja     406 <__rsv_window_dump+0x87>
 3a7:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
 3ab:	6b 00 62             	imul   $0x62,(%eax),%eax
 3ae:	6c                   	insb   (%dx),%es:(%edi)
 3af:	6f                   	outsl  %ds:(%esi),(%dx)
 3b0:	63 6b 28             	arpl   %bp,0x28(%ebx)
 3b3:	25 6c 75 29 20       	and    $0x2029756c,%eax
 3b8:	3e                   	ds
 3b9:	3d 20 62 6c 6f       	cmp    $0x6f6c6220,%eax
 3be:	63 6b 73             	arpl   %bp,0x73(%ebx)
 3c1:	20 63 6f             	and    %ah,0x6f(%ebx)
 3c4:	75 6e                	jne    434 <__rsv_window_dump+0xb5>
 3c6:	74 28                	je     3f0 <__rsv_window_dump+0x71>
 3c8:	25 64 29 20 2d       	and    $0x2d202964,%eax
 3cd:	20 62 6c             	and    %ah,0x6c(%edx)
 3d0:	6f                   	outsl  %ds:(%esi),(%dx)
 3d1:	63 6b 5f             	arpl   %bp,0x5f(%ebx)
 3d4:	67 72 6f             	addr16 jb 446 <__rsv_window_dump+0xc7>
 3d7:	75 70                	jne    449 <__rsv_window_dump+0xca>
 3d9:	20 3d 20 25 64 2c    	and    %bh,0x2c642520
 3df:	20 65 73             	and    %ah,0x73(%ebp)
 3e2:	20 3d 3d 20 25 70    	and    %bh,0x7025203d
 3e8:	20 00                	and    %al,(%eax)
Disassembly of section .altinstructions:

00000000 <.altinstructions>:
   0:	de 00                	fiadd  (%eax)
   2:	00 00                	add    %al,(%eax)
   4:	00 00                	add    %al,(%eax)
   6:	00 00                	add    %al,(%eax)
   8:	1a 05 03 00 62 12    	sbb    0x12620003,%al
   e:	00 00                	add    %al,(%eax)
  10:	03 00                	add    (%eax),%eax
  12:	00 00                	add    %al,(%eax)
  14:	1a 05 03 00 14 16    	sbb    0x16140003,%al
  1a:	00 00                	add    %al,(%eax)
  1c:	06                   	push   %es
  1d:	00 00                	add    %al,(%eax)
  1f:	00 1a                	add    %bl,(%edx)
  21:	05                   	.byte 0x5
  22:	03                   	.byte 0x3
Disassembly of section .altinstr_replacement:

00000000 <.altinstr_replacement>:
   0:	0f ae e8             	lfence 
   3:	0f ae e8             	lfence 
   6:	0f ae e8             	lfence 
Disassembly of section .smp_locks:

00000000 <.smp_locks>:
   0:	48                   	dec    %eax
   1:	02 00                	add    (%eax),%al
   3:	00 79 02             	add    %bh,0x2(%ecx)
   6:	00 00                	add    %al,(%eax)
   8:	fd                   	std    
   9:	02 00                	add    (%eax),%al
   b:	00 2c 03             	add    %ch,(%ebx,%eax,1)
   e:	00 00                	add    %al,(%eax)
  10:	d5 05                	aad    $0x5
  12:	00 00                	add    %al,(%eax)
  14:	0f 06                	clts   
  16:	00 00                	add    %al,(%eax)
  18:	2e                   	cs
  19:	06                   	push   %es
  1a:	00 00                	add    %al,(%eax)
  1c:	4b                   	dec    %ebx
  1d:	06                   	push   %es
  1e:	00 00                	add    %al,(%eax)
  20:	c6 06 00             	movb   $0x0,(%esi)
  23:	00 f7                	add    %dh,%bh
  25:	06                   	push   %es
  26:	00 00                	add    %al,(%eax)
  28:	1a 07                	sbb    (%edi),%al
  2a:	00 00                	add    %al,(%eax)
  2c:	40                   	inc    %eax
  2d:	07                   	pop    %es
  2e:	00 00                	add    %al,(%eax)
  30:	63 09                	arpl   %cx,(%ecx)
  32:	00 00                	add    %al,(%eax)
  34:	91                   	xchg   %eax,%ecx
  35:	09 00                	or     %eax,(%eax)
  37:	00 cc                	add    %cl,%ah
  39:	09 00                	or     %eax,(%eax)
  3b:	00 18                	add    %bl,(%eax)
  3d:	0a 00                	or     (%eax),%al
  3f:	00 21                	add    %ah,(%ecx)
  41:	0a 00                	or     (%eax),%al
  43:	00 38                	add    %bh,(%eax)
  45:	0a 00                	or     (%eax),%al
  47:	00 91 0a 00 00 ba    	add    %dl,-0x45fffff6(%ecx)
  4d:	0a 00                	or     (%eax),%al
	...
Disassembly of section __bug_table:

00000000 <__bug_table>:
   0:	75 02                	jne    4 <__bug_table+0x4>
   2:	00 00                	add    %al,(%eax)
   4:	f5                   	cmc    
   5:	00 00                	add    %al,(%eax)
   7:	00 36                	add    %dh,(%esi)
   9:	00 00                	add    %al,(%eax)
   b:	00 28                	add    %ch,(%eax)
   d:	03 00                	add    (%eax),%eax
   f:	00 f5                	add    %dh,%ch
  11:	00 00                	add    %al,(%eax)
  13:	00 36                	add    %dh,(%esi)
  15:	00 00                	add    %al,(%eax)
  17:	00 64 04 00          	add    %ah,0x0(%esp,%eax,1)
  1b:	00 01                	add    %al,(%ecx)
  1d:	02 00                	add    (%eax),%al
  1f:	00 ae 00 00 00 f2    	add    %ch,-0xe000000(%esi)
  25:	04 00                	add    $0x0,%al
  27:	00 01                	add    %al,(%ecx)
  29:	02 00                	add    (%eax),%al
  2b:	00 43 03             	add    %al,0x3(%ebx)
  2e:	00 00                	add    %al,(%eax)
  30:	47                   	inc    %edi
  31:	06                   	push   %es
  32:	00 00                	add    %al,(%eax)
  34:	f5                   	cmc    
  35:	00 00                	add    %al,(%eax)
  37:	00 36                	add    %dh,(%esi)
  39:	00 00                	add    %al,(%eax)
  3b:	00 3c 07             	add    %bh,(%edi,%eax,1)
  3e:	00 00                	add    %al,(%eax)
  40:	f5                   	cmc    
  41:	00 00                	add    %al,(%eax)
  43:	00 36                	add    %dh,(%esi)
  45:	00 00                	add    %al,(%eax)
  47:	00 8d 09 00 00 f5    	add    %cl,-0xafffff7(%ebp)
  4d:	00 00                	add    %al,(%eax)
  4f:	00 36                	add    %dh,(%esi)
  51:	00 00                	add    %al,(%eax)
  53:	00 0d 0a 00 00 01    	add    %cl,0x100000a
  59:	02 00                	add    (%eax),%al
  5b:	00 20                	add    %ah,(%eax)
  5d:	02 00                	add    (%eax),%al
  5f:	00 34 0a             	add    %dh,(%edx,%ecx,1)
  62:	00 00                	add    %al,(%eax)
  64:	f5                   	cmc    
  65:	00 00                	add    %al,(%eax)
  67:	00 36                	add    %dh,(%esi)
  69:	00 00                	add    %al,(%eax)
  6b:	00 b6 0a 00 00 f5    	add    %dh,-0xafffff6(%esi)
  71:	00 00                	add    %al,(%eax)
  73:	00 36                	add    %dh,(%esi)
  75:	00 00                	add    %al,(%eax)
  77:	00 43 0c             	add    %al,0xc(%ebx)
  7a:	00 00                	add    %al,(%eax)
  7c:	01 02                	add    %eax,(%edx)
  7e:	00 00                	add    %al,(%eax)
  80:	1e                   	push   %ds
  81:	01 00                	add    %eax,(%eax)
  83:	00 54 0f 00          	add    %dl,0x0(%edi,%ecx,1)
  87:	00 01                	add    %al,(%ecx)
  89:	02 00                	add    (%eax),%al
  8b:	00 2a                	add    %ch,(%edx)
  8d:	05                   	.byte 0x5
	...
Disassembly of section .rodata:

00000000 <__func__.18579>:
   0:	65                   	gs
   1:	78 74                	js     77 <ext3_group_sparse+0x2a>
   3:	33 5f 6e             	xor    0x6e(%edi),%ebx
   6:	65                   	gs
   7:	77 5f                	ja     68 <ext3_group_sparse+0x1b>
   9:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
   d:	6b 73 00 65          	imul   $0x65,0x0(%ebx),%esi

00000010 <__func__.18468>:
  10:	65                   	gs
  11:	78 74                	js     87 <ext3_group_sparse+0x3a>
  13:	33 5f 74             	xor    0x74(%edi),%ebx
  16:	72 79                	jb     91 <ext3_group_sparse+0x44>
  18:	5f                   	pop    %edi
  19:	74 6f                	je     8a <ext3_group_sparse+0x3d>
  1b:	5f                   	pop    %edi
  1c:	61                   	popa   
  1d:	6c                   	insb   (%dx),%es:(%edi)
  1e:	6c                   	insb   (%dx),%es:(%edi)
  1f:	6f                   	outsl  %ds:(%esi),(%dx)
  20:	63 61 74             	arpl   %sp,0x74(%ecx)
  23:	65                   	gs
  24:	5f                   	pop    %edi
  25:	77 69                	ja     90 <ext3_group_sparse+0x43>
  27:	74 68                	je     91 <ext3_group_sparse+0x44>
  29:	5f                   	pop    %edi
  2a:	72 73                	jb     9f <ext3_group_sparse+0x52>
  2c:	76 00                	jbe    2e <__func__.18468+0x1e>
	...

00000030 <__func__.18121>:
  30:	65                   	gs
  31:	78 74                	js     a7 <ext3_get_group_desc+0x7>
  33:	33 5f 66             	xor    0x66(%edi),%ebx
  36:	72 65                	jb     9d <ext3_group_sparse+0x50>
  38:	65                   	gs
  39:	5f                   	pop    %edi
  3a:	62 6c 6f 63          	bound  %ebp,0x63(%edi,%ebp,2)
  3e:	6b 73 5f 73          	imul   $0x73,0x5f(%ebx),%esi
  42:	62 00                	bound  %eax,(%eax)

00000044 <__func__.18054>:
  44:	65                   	gs
  45:	78 74                	js     bb <ext3_get_group_desc+0x1b>
  47:	33 5f 72             	xor    0x72(%edi),%ebx
  4a:	73 76                	jae    c2 <ext3_get_group_desc+0x22>
  4c:	5f                   	pop    %edi
  4d:	77 69                	ja     b8 <ext3_get_group_desc+0x18>
  4f:	6e                   	outsb  %ds:(%esi),(%dx)
  50:	64 6f                	outsl  %fs:(%esi),(%dx)
  52:	77 5f                	ja     b3 <ext3_get_group_desc+0x13>
  54:	61                   	popa   
  55:	64                   	fs
  56:	64                   	fs
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43             	add    %al,0x43(%edi)
   3:	43                   	inc    %ebx
   4:	3a 20                	cmp    (%eax),%ah
   6:	28 47 4e             	sub    %al,0x4e(%edi)
   9:	55                   	push   %ebp
   a:	29 20                	sub    %esp,(%eax)
   c:	34 2e                	xor    $0x2e,%al
   e:	32 2e                	xor    (%esi),%ch
  10:	31 20                	xor    %esp,(%eax)
  12:	28 44 65 62          	sub    %al,0x62(%ebp)
  16:	69 61 6e 20 34 2e 32 	imul   $0x322e3420,0x6e(%ecx),%esp
  1d:	2e                   	cs
  1e:	31                   	.byte 0x31
  1f:	2d                   	.byte 0x2d
  20:	35                   	.byte 0x35
  21:	29 00                	sub    %eax,(%eax)

--T4sUOijqQbZv57TR--
