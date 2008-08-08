From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 on s390?
Date: Fri, 08 Aug 2008 16:31:13 -0500
Message-ID: <489CBB21.5030801@redhat.com>
References: <489CA7B8.7090202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbYHHVbg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Aug 2008 17:31:36 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m78LVFFD016903
	for <linux-ext4@vger.kernel.org>; Fri, 8 Aug 2008 17:31:15 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78LVFRj022729
	for <linux-ext4@vger.kernel.org>; Fri, 8 Aug 2008 17:31:15 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m78LVDbi019759
	for <linux-ext4@vger.kernel.org>; Fri, 8 Aug 2008 17:31:14 -0400
In-Reply-To: <489CA7B8.7090202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Just wondering if anyone has tested ext4 on s390.  I see that some
> assembly bitops got fixed upstream, but even with those in place I'm
> hanging when ext4 tries to init bg's:
> 
> Call Trace:
> ([<0000000000016472>] show_trace+0xb2/0x130)
>  [<00000000001793f4>] showacpu+0x48/0x68
>  [<0000000000024816>] do_ext_call_interrupt+0x8a/0xc4
>  [<000000000001c2b6>] do_extint+0xe2/0xfc
>  [<0000000000020ea8>] ext_no_vtime+0x16/0x1a
>  [<0000000020cd99f2>] ext4_mb_init_cache+0x9fe/0x1020 [ext4dev]
> ([<0000000020cd91a4>] ext4_mb_init_cache+0x1b0/0x1020 [ext4dev])
>  [<0000000020cdba9c>] ext4_mb_load_buddy+0x264/0x36c [ext4dev]
>  [<0000000020cdc446>] ext4_mb_regular_allocator+0x53e/0x1218 [ext4dev]
>  [<0000000020ce0d06>] ext4_mb_new_blocks+0x1a2/0x7e8 [ext4dev]
>  [<0000000020cd6538>] ext4_ext_get_blocks+0xe3c/0x1074 [ext4dev]
>  [<0000000020cc32be>] ext4_get_blocks_wrap+0x132/0x190 [ext4dev]
>  [<0000000020cc40aa>] ext4_getblk+0x8a/0x26c [ext4dev]
>  [<0000000020cc4b12>] ext4_bread+0x26/0xd8 [ext4dev]
>  [<0000000020cc89fa>] ext4_mkdir+0x18e/0x3c8 [ext4dev]
>  [<00000000000be54c>] vfs_mkdir+0x10c/0x1a8
>  [<00000000000c204e>] sys_mkdirat+0xca/0x114
>  [<00000000000208c0>] sysc_tracego+0xe/0x14
>  [<00000200001345e6>] 0x200001345e6
> 
> I'm now struggling to get an s390 booted on an upstream kernel to test
> that, but I know about -><- about s390s.

I managed to boot 2.6.26.2 (stock) on an s390; same problem.  :(

IBM, help? :)

-Eric
