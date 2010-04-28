From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Tue, 27 Apr 2010 21:25:00 -0400
Message-ID: <4BD78E6C.6000709@teksavvy.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <4BD2F69D.7070508@redhat.com>	 <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>	 <4BD30393.4050800@redhat.com>	 <h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>	 <4BD324B5.4030808@redhat.com>	 <p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>	 <4BD33B61.2080807@redhat.com> <4BD59C84.4040200@teksavvy.com>	 <yq18w8ae0mq.fsf@sermon.lab.mkp.net> <x2s87f94c371004260827gf5f978f4l48548add85094e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:36053 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755013Ab0D1BZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Apr 2010 21:25:04 -0400
In-Reply-To: <x2s87f94c371004260827gf5f978f4l48548add85094e22@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 26/04/10 11:27 AM, Greg Freemyer wrote:
..
> Mark, or anyone, do you think it would be a bad idea for me to push
> for Opensuse 11.3 (2.6.34 based) to use wiper.sh as a standard ext4
> discard tool?  hdparm and wiper.sh are already in the distro, it just
> needs a cron entry and maybe some basic management infrastructure.
> They're at feature freeze for 11.3, so I don't know if I can get it in
> or not.
..

I'd hold off for now.  Rumour has it that Intel SSDs are not 100% compliant
with TRIM -- they fail with large amounts of range data.

I don't have an Intel SSD to verify that or fix it with.

Cheers
