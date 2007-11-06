From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Tue, 06 Nov 2007 13:54:08 -0600
Message-ID: <4730C660.5020800@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com> <472A2384.2010001@redhat.com> <472AE644.1040102@gmail.com> <472B453F.8010608@redhat.com> <472E1114.7060206@gmail.com> <472F54EE.9030904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <bzzz.tomas@gmail.com>,
	Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608AbXKFTy3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 14:54:29 -0500
In-Reply-To: <472F54EE.9030904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Alex Tomas wrote:
>> thanks for the data. the attached patch should fix couple issues:
>> broken history output and policy in that smaller usable chunk to
>> be used. can you give it a spin, please?
> 
> Hi Alex -
> 
> This looks *much* better:

Hmm bad news is when I add uninit_groups into the mix, it goes a little
south again, with some out-of-order extents.  Not the end of the world,
but a little unexpected?

....
Discontinuity: Block 1430784 is at 24183810 (was 24181761)
Discontinuity: Block 1461760 is at 24216578 (was 24214785)
Discontinuity: Block 1492480 is at 37888 (was 24247297)
Discontinuity: Block 1519616 is at 850944 (was 65023)
Discontinuity: Block 1520640 is at 883712 (was 851967)
Discontinuity: Block 1521664 is at 1670144 (was 884735)
Discontinuity: Block 1522688 is at 2685952 (was 1671167)
Discontinuity: Block 1523712 is at 4226048 (was 2686975)
Discontinuity: Block 1524736 is at 11271168 (was 4227071)
Discontinuity: Block 1525760 is at 23952384 (was 11272191)
...

-Eric
