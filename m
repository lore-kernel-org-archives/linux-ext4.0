From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG: using smp_processor_id() in preemptible
Date: Wed, 20 Aug 2008 23:17:57 -0500
Message-ID: <48ACEC75.2030709@redhat.com>
References: <20080820053438.GA6381@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYHUEVE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Aug 2008 00:21:04 -0400
In-Reply-To: <20080820053438.GA6381@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> BUG: using smp_processor_id() in preemptible [00000000] code:
> fsstress/20995
> caller is ext4_mb_initialize_context+0x20c/0x22c
> Pid: 20995, comm: fsstress Not tainted 2.6.27-rc3-autokern1 #1
> [<c0294a2f>] debug_smp_processor_id+0x9f/0xb8
> [<c01e523d>] ext4_mb_initialize_context+0x20c/0x22c
> [<c01ea017>] ext4_mb_new_blocks+0x17c/0x715
> [<c0136b43>] ? trace_hardirqs_on+0xb/0xd
> [<c01e23f2>] ext4_ext_get_blocks+0xbaf/0xde1
> [<c0137d20>] ? __lock_acquire+0x61e/0x674
> [<c0137d20>] ? __lock_acquire+0x61e/0x674
> [<c01d464a>] ext4_get_blocks_wrap+0xce/0x1eb
> [<c01dfaba>] ext4_fallocate+0x135/0x27d
> [<c016472d>] ? fget+0x1d/0xd3
> [<c01647aa>] ? fget+0x9a/0xd3
> [<c01623a4>] sys_fallocate+0xce/0xf3
> [<c0102bb9>] sysenter_do_call+0x12/0x35
> =======================

whoops, ok, I should probably convert it to use raw_smp_processor_id; I
don't think we care if we get pre-empted and the cpu changes; we use the
cpu id exactly once to grab it from the array, I think we don't need any
atomicity.  I'll convert to raw_smp_processor_id() to avoid the debug
check, unless anyone sees a problem with that ...

-Eric
