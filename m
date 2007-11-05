From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Mon, 05 Nov 2007 11:37:50 -0600
Message-ID: <472F54EE.9030904@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com> <472A2384.2010001@redhat.com> <472AE644.1040102@gmail.com> <472B453F.8010608@redhat.com> <472E1114.7060206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz.tomas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXKERh4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 12:37:56 -0500
In-Reply-To: <472E1114.7060206@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> thanks for the data. the attached patch should fix couple issues:
> broken history output and policy in that smaller usable chunk to
> be used. can you give it a spin, please?

Hi Alex -

This looks *much* better:

First block: 100355
Last block: 2342657
Discontinuity: Block 30208 is at 133120 (was 130562)
Discontinuity: Block 60928 is at 165891 (was 163839)
Discontinuity: Block 90368 is at 197634 (was 195330)
Discontinuity: Block 121856 is at 232448 (was 229121)
Discontinuity: Block 150528 is at 263170 (was 261119)
Discontinuity: Block 181504 is at 296963 (was 294145)
Discontinuity: Block 210944 is at 328706 (was 326402)
Discontinuity: Block 241664 is at 361474 (was 359425)
Discontinuity: Block 272896 is at 395264 (was 392705)
Discontinuity: Block 303360 is at 427010 (was 425727)
Discontinuity: Block 334080 is at 459778 (was 457729)
Discontinuity: Block 365568 is at 493568 (was 491265)
Discontinuity: Block 395264 is at 525314 (was 523263)
Discontinuity: Block 426240 is at 558082 (was 556289)
....

for an 8192x1M (8G) buffered dd, I now get 88 extents, in order.

Do you want the mballoc history?

Now I can try some multithreaded tests :)

Thanks,
-Eric

> thanks, Alex
