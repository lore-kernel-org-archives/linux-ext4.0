From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: Re: [bug] ext{3,4}: __find_get_block_slow() failed on 3.0.3
Date: Tue, 20 Sep 2011 20:08:29 +0200
Message-ID: <CANvSZQ8g5Wb7HwbCb7M9G+WQT0PK9nFSMWhybCza4xy+kOxAQA@mail.gmail.com>
References: <CANvSZQ804KZWhPG4JvzOPtkC02ibD6YmRnUvHCEhLB8DKEo7LQ@mail.gmail.com>
 <20110905125939.GF5466@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44900 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1ITSOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 14:14:44 -0400
In-Reply-To: <20110905125939.GF5466@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 5, 2011 at 14:59, Jan Kara <jack@suse.cz> wrote:
> =C2=A0Something has corrupted your buffer head structure in memory (a=
nd we then
> infinitely looped in __getblk_slow()). bh->b_blocknr has been 0xC1390=
00B9
> which it should have been 0x139000B9 (5th byte has been changed from =
0x00
> to 0x0C). It might be a hw fault, buggy driver, or some other bug - h=
ard to
> say. You might want to run memtest for some time, or enable some kern=
el debug
> options (DEBUG_PAGEALLOC, DEBUG_SLAB) which might catch the code caus=
ing
> corruption (this assumes it's at least occasionally reproducible and =
your
> are willing to take the performance hit)...

Thanks for your reply and sorry for the slow response. As my system
also experienced lockups from time to time I performed an extensive
memtest run, which actually brought up sporadic memory corruption
(some bits flipping to zero) after 20 hours or so. I swapped CPU,
mainboard and RAM and have not experienced any problems since then, so
I guess this was the cause of the issue.

Thanks,
Thilo
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
