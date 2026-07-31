Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A6F3090C2
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 03:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.149.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785469041; cv=none; b=pNR8CFIcj0UaaRTwayemAp/ymr9/1NnthDVM0B9gz6n4+OXiNd0xT0ujrNSyGJXPB+3G9xOCbXCR/xS7bLUdhpEQYelerVPY9uLt0N/ZjnJQkDZ3STl/9qvKF8zYkO4+TEN2wVKyl+cu96Jq7bg4PneQ9h8+CGJKqc0xsX20kME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785469041; c=relaxed/simple;
	bh=KmPVb1VAmHGyWrZOFKZhD88dTwEZpjs10Qk1ANX46/Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Cge5n7h2NrKVrskS80c3+bgzUvuto8ILB4cr+c31HspdaAvmu/ZbLdVi+TN7ztiKhVJ0tjjcrLGxESGWo1VQ/txOkuCqQBUs0aFj9BMEB+LxWYHcgLJT933FlX1WPAUmFGGvr9Km446RONaHe6HDWGdcPlWvZQFAytfPvLhd04Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=UVk/qSze; arc=none smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="UVk/qSze"
Received: from pps.filterd (m0409409.ppops.net [127.0.0.1])
	by m0409409.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 66V3akNZ2400415;
	Fri, 31 Jul 2026 04:37:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=apr2026.eng; bh=6j97b6FjXOU+HvQJHIw4
	xbte4qGgUPTWjax15cnpXJ4=; b=UVk/qSzel1UA/auYONbxI6P5e20ofVHwl/zb
	k945IpQC8dFh0rm8dNG4J8IBDo01HL/HVibPQ7UsIZ7fo/Ff/xxKLOnett/xk3Er
	leFd3fS3onXP8EjtNX1iuXJo/gr2taOP3i5yyAIJCRndGIErJrkTvpQmaBe3gXcT
	w4MsDpb0KLpcZxJ++sLluyzsQr5rjrPZ/leBegQj7Rm8qZzlp5SfotvLP/VPw/+5
	dtSjWm9Dm92RxPXka+bB1wciOy1ARM1P1A+u/jipthjSjxfiV9ocxH/9IUlh3ZL7
	dOY4QoJvZGndGPtoW25kJq7lD5jA3lJGfXqsgj9oZdB6dSkb7w==
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
	by m0409409.ppops.net-00190b01. (PPS) with ESMTPS id 4fn6fn4hhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 04:37:11 +0100 (BST)
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
	by prod-mail-ppoint4.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 66V3YH8V029003;
	Thu, 30 Jul 2026 23:37:10 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.220])
	by prod-mail-ppoint4.akamai.com (PPS) with ESMTPS id 4fr5ng6dx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:37:10 -0400 (EDT)
Received: from ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 30 Jul 2026 20:37:10 -0700
Received: from sjc-lp2nq5qm.santaclara.corp.akamai.com (172.27.164.43) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server id 15.2.2562.43 via Frontend Transport; Thu, 30 Jul 2026 20:37:10
 -0700
Received: by sjc-lp2nq5qm.santaclara.corp.akamai.com (Postfix, from userid 30754)
	id 816C8AC0E6D; Thu, 30 Jul 2026 20:37:09 -0700 (PDT)
From: Josh Hunt <johunt@akamai.com>
To: <linux-ext4@vger.kernel.org>
CC: <kknox@akamai.com>, <tytos@mit.edu>, Josh Hunt <johunt@akamai.com>
Subject: [PATCH 0/3] e2fsprogs vulnerabilities with untrusted fs images
Date: Thu, 30 Jul 2026 20:36:58 -0700
Message-ID: <20260731033701.2657758-1-johunt@akamai.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607310020
X-Proofpoint-GUID: snZpLPajlZilEvc83bNwmL1MAbZCAbn7
X-Proofpoint-ORIG-GUID: snZpLPajlZilEvc83bNwmL1MAbZCAbn7
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfXzzkMQyebN5ng
 xjWnSVUfwSnJxbRS13bpCmGLLPnH30sE+AnrVpejcdhIvL614XZreFEIrV/bkQhSG0YFbiCR3PN
 DjrDJIRT+FgEAUR0/LalG9M/C8AFTuo=
X-Authority-Analysis: v=2.4 cv=RZ+gzVtv c=1 sm=1 tr=0 ts=6a6c1867 cx=c_pps
 a=NaJOksh5yBwW9//Q5C/Ubg==:117 a=NaJOksh5yBwW9//Q5C/Ubg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=TTBIr9FR-UdC54aaq7Eb:22 a=NEAV23lmAAAA:8 a=NLVCJWREP4Cemwqsw04A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAyMCBTYWx0ZWRfX7mmkj+HKJ0Wy
 C59M1kTgXNp897lKxAmnTdCA3vqq0QQKQZmb1fmtALQ1zfzRe7VXBlLQ4IHODhYF7LvW9vsUJZB
 wD5Hik5+R/ixGTDIhCLNVMjfAu+gmUfuG3QLp9O0dlAy5MsJZFMF87F1Qscupv4q00YA/cpAgEa
 kYKj0SP8qYq+Pz5wdzRwx0D0TGI73rLbovF4DkXWckiyRXaJRzOTEY9HgZ4L18fYMqA7d6uW0hV
 StJ7T63B9Ft30dyJyLXHbFEY3dIFjrnZpPzheeDnuInws8FAPJ3OZx9Cg8NlPaETDwmdJSpiifq
 tcD/0+4lFPItzkO1MauKtqX9QMMl6uu2P4lUesjx3lJ5OuAGUhdHlTJwXauBxqszjpEGqtvTl6x
 ey2yNjV7R8+dm9BI/nH7h/pt0aAgssYrcEWvCy/bjJ59LLLF0Y16nBSLmYlR7m6tqhh2bglt6Y2
 UWeVFCQ6GJ4wktro0pQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
 spamscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606160001 definitions=main-2607310020

This patchset addresses several security vulnerabilities discovered during a
security audit of e2fsprogs when processing untrusted filesystem images. These
tools (resize2fs, e2fsck, dumpe2fs, tune2fs) are often run as root, making
memory corruption vulnerabilities potentially exploitable for privilege
escalation.

Issue #1: Out-of-bounds read/write in xattr entry scanning
Issue #2: Heap overflow from bitmap byte size miscalculation
Issue #3: Out of bounds memory access during UUID or checksum updates

Further details for all 3 of these items can be found at the end of this
mail.

The problems found during this audit were verified with real filesystem images
and we are happy to provide you with those or steps to recreate these issues
upon request. The patches in this series were created on top of the master
branch of e2fsprogs found here: https://github.com/tytso/e2fsprogs.

Please let us know if you have any questions about the above or comments on the
attached patches. We have not requested to have CVEs created for these
issues yet, but do plan to request them.

---

Issue #1: Out-of-bounds read/write in xattr entry scanning

Location: resize/resize2fs.c - fix_ea_entries(), fix_ea_ibody_entries()

The fix_ea_entries() function iterates over extended attribute entries using the
loop condition "while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry))". This
check is insufficient because:
 1. It does not verify the full 16-byte ext2_ext_attr_entry structure fits
    within the buffer before accessing its fields. With fewer than 16 bytes
    remaining, evaluating EXT2_EXT_IS_LAST_ENTRY() reads past the buffer.

 2. A crafted e_name_len value can cause EXT2_EXT_ATTR_NEXT() to advance past
    the buffer boundary, and subsequent iterations read/write beyond allocated
    memory.

 3. When entry->e_value_inum > last_ino, resize2fs writes to
    entry->e_value_inum, potentially corrupting heap memory.

Additionally, fix_ea_ibody_entries() does not validate i_extra_isize before
using it to compute xattr offsets. A malformed inode with an invalid
i_extra_isize value (unaligned or too large) causes out-of-bounds reads when
accessing the ea_magic field.

This vulnerability is triggered when resize2fs processes an untrusted filesystem
image with the ea_inode feature enabled.

Proposed Fix in patch 1 of this series:

 * Add proper bounds checking in fix_ea_entries()
 * Verify (entry + sizeof(struct ext2_ext_attr_entry) <= end)
 * Verify (EXT2_EXT_ATTR_NEXT(entry) <= end) before accessing fields
 * Add i_extra_isize validation in fix_ea_ibody_entries() matching the checks
 * Verify 4-byte alignment
 * Verify i_extra_isize <= (inode_size - EXT2_GOOD_OLD_INODE_SIZE)

Exploit attempt prior to patch:
$ ./resize/resize2fs -f kknox_xattr.img 32768
resize2fs 1.47.3 (8-Jul-2025)
Resizing the filesystem on kknox_xattr.img to 32768 (1k) blocks.
=================================================================
==213930==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x511000000b40 at pc 0x58db125e1dae bp 0x7ffc76293fd0 sp 0x7ffc76293fc0
READ of size 4 at 0x511000000b40 thread T0
    #0 0x58db125e1dad in fix_ea_entries /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2049
    #1 0x58db125e1dad in fix_ea_ibody_entries /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2078
    #2 0x58db125e1dad in fix_ea_inode_refs /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2140
    #3 0x58db125edd0f in inode_scan_and_fix /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2341
    #4 0x58db125edd0f in resize_fs /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:193
    #5 0x58db125db7aa in main /root/upstream/e2fsprogs/resize/main.c:671
    #6 0x77030ba2a1c9 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #7 0x77030ba2a28a in __libc_start_main_impl ../csu/libc-start.c:360
    #8 0x58db125dcbb4 in _start (/home/kknox/upstream/e2fsprogs/resize/resize2fs+0x13bb4) (BuildId: 423df96af73be32a10f5b4eb2975409aa79272cb)

0x511000000b40 is located 0 bytes after 256-byte region [0x511000000a40,0x511000000b40)
allocated by thread T0 here:
    #0 0x77030befd9c7 in malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
    #1 0x58db125e9249 in inode_scan_and_fix /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2224
    #2 0x58db125e9249 in resize_fs /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:193

SUMMARY: AddressSanitizer: heap-buffer-overflow /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2049 in fix_ea_entries
Shadow bytes around the buggy address:
  0x511000000880: fd fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x511000000900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x511000000980: 00 00 00 00 00 00 00 00 00 fa fa fa fa fa fa fa
  0x511000000a00: fa fa fa fa fa fa fa fa 00 00 00 00 00 00 00 00
  0x511000000a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x511000000b00: 00 00 00 00 00 00 00 00[fa]fa fa fa fa fa fa fa
  0x511000000b80: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x511000000c00: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x511000000c80: fa fa fa fa fa fa fa fa fd fd fd fd fd fd fd fd
  0x511000000d00: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x511000000d80: fd fd fd fd fd fd fd fd fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==213930==ABORTING

Exploit attempt after applying patch 1:
$ ./resize/resize2fs -f kknox_xattr.img 32768
resize2fs 1.47.3 (8-Jul-2025)
Resizing the filesystem on kknox_xattr.img to 32768 (1k) blocks.
The filesystem on kknox_xattr.img is now 32768 (1k) blocks long.


Issue #2: Heap overflow from bitmap byte size miscalculation

Location:
resize/resize2fs.c - resize2fs_calculate_summary_stats()
lib/ext2fs/rw_bitmaps.c - write_bitmaps(), read_bitmaps_range_*()
e2fsck/pass5.c - check_block_bitmaps()
misc/dumpe2fs.c - list_desc()

The bitmap byte size calculations use integer division (count / 8) without
rounding up. When clusters_per_group or inodes_per_group is not a multiple of 8,
this allocates too few bytes. The bitmap backends copy (num + 7) / 8 bytes via
ext2fs_get_block_bitmap_range2(), causing a buffer overrun of 1-7 bytes.

Example: With s_clusters_per_group = blocksize*8 + 1, the buffer is undersized
by 1 byte, causing heap corruption when the bitmap is copied.

Proposed Fix: Use ceiling division (count + 7) / 8 for all bitmap byte size
calculations to ensure buffers are always large enough.

Exploit attempt prior to patch:
$ ./resize/resize2fs kknox_bitmap.img 50000
resize2fs 1.47.3 (8-Jul-2025)
Resizing the filesystem on kknox_bitmap.img to 50000 (4k) blocks.
=================================================================
==215069==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x521000013d00 at pc 0x78c4150fa97d bp 0x7ffe520722f0 sp 0x7ffe52071a98
WRITE of size 4097 at 0x521000013d00 thread T0
    #0 0x78c4150fa97c in memset ../../../../src/libsanitizer/sanitizer_common/sanitizer_common_interceptors_memintrinsics.inc:87
    #1 0x63377ddb97f2 in memset /usr/include/x86_64-linux-gnu/bits/string_fortified.h:59
    #2 0x63377ddb97f2 in rb_get_bmap_range /root/upstream/e2fsprogs/lib/ext2fs/blkmap64_rb.c:776
    #3 0x63377dd414e7 in resize2fs_calculate_summary_stats /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2938
    #4 0x63377dd4b5da in resize_fs /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:215
    #5 0x63377dd3c7aa in main /root/upstream/e2fsprogs/resize/main.c:671
    #6 0x78c414c2a1c9 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #7 0x78c414c2a28a in __libc_start_main_impl ../csu/libc-start.c:360
    #8 0x63377dd3dbb4 in _start (/home/kknox/upstream/e2fsprogs/resize/resize2fs+0x13bb4) (BuildId: c37380732d846ff0296308be12ccba8c3f12aeb2)

0x521000013d00 is located 0 bytes after 4096-byte region [0x521000012d00,0x521000013d00)
allocated by thread T0 here:
    #0 0x78c4150fd9c7 in malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
    #1 0x63377dd41352 in resize2fs_calculate_summary_stats /home/kknox/upstream/e2fsprogs/resize/resize2fs.c:2934

SUMMARY: AddressSanitizer: heap-buffer-overflow ../../../../src/libsanitizer/sanitizer_common/sanitizer_common_interceptors_memintrinsics.inc:87 in memset
Shadow bytes around the buggy address:
  0x521000013a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x521000013b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x521000013b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x521000013c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x521000013c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x521000013d00:[fa]fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x521000013d80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x521000013e00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x521000013e80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x521000013f00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x521000013f80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==215069==ABORTING


Exploit attempt after patch 2 applied:
$ ./resize/resize2fs kknox_bitmap.img 50000
resize2fs 1.47.3 (8-Jul-2025)
Resizing the filesystem on kknox_bitmap.img to 50000 (4k) blocks.
./resize/resize2fs: The ext2 superblock is corrupt while trying to resize kknox_bitmap.img
Please run 'e2fsck -fy kknox_bitmap.img' to fix the filesystem
after the aborted resize operation.


Issue #3: Out of bounds memory access during UUID or checksum updates

Location misc/tune2fs.c

When tune2fs processes EA inodes and xattr entries during inode rewriting
operations (such as when changing UUID or disabling checksums) the code does not
validate that the i_size field of an EA inode fit within the allocated 64KB
buffer before reading, nor did it perform bounds checking when iterating through
extended attribute entries. A maliciously crafted filesystem with an oversized
EA inode size or corrupted xattr entry lengths could cause tune2fs to read or
write beyond the allocated heap buffer, potentially leading to memory
corruption. The fix adds explicit size validation against the buffer size before
reading EA inode contents, and adds bounds checks to ensure that each xattr
entry's header and name length don't extend past the end of the valid buffer
region.

Exploit attempt prior to patch:

./misc/tune2fs -O ^metadata_csum ./kknox_ea_overflow.img 
tune2fs 1.47.3 (8-Jul-2025)
Disabling checksums could take some time.
Proceed anyway (or wait 5 seconds to proceed) ? (y,N) <proceeding>
=================================================================
==215266==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x531000010800 at pc 0x744856efb303 bp 0x7ffc87dbd580 sp 0x7ffc87dbcd28
WRITE of size 4096 at 0x531000010800 thread T0
    #0 0x744856efb302 in memcpy ../../../../src/libsanitizer/sanitizer_common/sanitizer_common_interceptors_memintrinsics.inc:115
    #1 0x5e1a36189ffc in memcpy /usr/include/x86_64-linux-gnu/bits/string_fortified.h:29
    #2 0x5e1a36189ffc in ext2fs_file_read /root/upstream/e2fsprogs/lib/ext2fs/fileio.c:333
    #3 0x5e1a36150113 in update_ea_inode_hash /root/upstream/e2fsprogs/misc/tune2fs.c:757
    #4 0x5e1a36150113 in rewrite_one_inode /root/upstream/e2fsprogs/misc/tune2fs.c:844
    #5 0x5e1a36150113 in rewrite_inodes_pass /root/upstream/e2fsprogs/misc/tune2fs.c:922
    #6 0x5e1a3614584a in rewrite_inodes /root/upstream/e2fsprogs/misc/tune2fs.c:961
    #7 0x5e1a3614584a in rewrite_metadata_checksums /root/upstream/e2fsprogs/misc/tune2fs.c:981
    #8 0x5e1a3614584a in main /root/upstream/e2fsprogs/misc/tune2fs.c:3735
    #9 0x744856a2a1c9 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #10 0x744856a2a28a in __libc_start_main_impl ../csu/libc-start.c:360
    #11 0x5e1a36146f34 in _start (/home/kknox/upstream/e2fsprogs/misc/tune2fs+0x2bf34) (BuildId: 27ed73d3d9008c2cd2a9cbe06b9749948975c3f3)

0x531000010800 is located 0 bytes after 65536-byte region [0x531000000800,0x531000010800)
allocated by thread T0 here:
    #0 0x744856efd9c7 in malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:69
    #1 0x5e1a3619887c in ext2fs_get_mem /root/upstream/e2fsprogs/lib/ext2fs/ext2fs.h:2022

SUMMARY: AddressSanitizer: heap-buffer-overflow ../../../../src/libsanitizer/sanitizer_common/sanitizer_common_interceptors_memintrinsics.inc:115 in memcpy
Shadow bytes around the buggy address:
  0x531000010580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x531000010600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x531000010680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x531000010700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x531000010780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x531000010800:[fa]fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x531000010880: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x531000010900: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x531000010980: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x531000010a00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x531000010a80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==215266==ABORTING

Exploit attempt after patch 3 applied:

$ ./misc/tune2fs -O ^metadata_csum ./kknox_ea_overflow.img 
tune2fs 1.47.3 (8-Jul-2025)
Disabling checksums could take some time.
Proceed anyway (or wait 5 seconds to proceed) ? (y,N) <proceeding>
update_ea_inode_hash: Extended attribute has an invalid value length ea_inode 12 has invalid size 131072

Kit Knox (3):
  resize2fs: out-of-bounds read/write in xattr entry scanning
  fix bitmap byte size calculations
  tune2fs: Add bounds checking for extended attribute processing

 e2fsck/pass5.c          | 10 ++++++----
 lib/ext2fs/rw_bitmaps.c | 13 ++++++-------
 misc/dumpe2fs.c         |  4 ++--
 misc/tune2fs.c          | 19 ++++++++++++++++---
 resize/resize2fs.c      | 24 ++++++++++++++++++++++--
 5 files changed, 52 insertions(+), 18 deletions(-)

-- 
2.34.1

