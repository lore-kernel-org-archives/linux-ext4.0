From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 13:27:34 -0500
Message-ID: <20080715132734.68c64000@ichigo>
References: <87bq10w8gv.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60290 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbYGOS1j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 14:27:39 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FIRaBN006565
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 14:27:36 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FIRa53173352
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 14:27:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FIRaoN011799
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 14:27:36 -0400
In-Reply-To: <87bq10w8gv.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 14 Jul 2008 21:50:56 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> Hi,
> 
> we are using lustre on a cluster of servers and raid boxes. Currently
> lustre is based on the ext3 code and has a limit of 8TiB for each
> filesystem. For us that results on having to split a servers storage
> into up to 4 chunks and run one fs on each which I would rather avoid.
> The solution for this would be to rebase the lustre patches to use
> ext4 instead, which should also reduce the patch set considerably.
> Lustre already patches a lot of ext4 features into the ext3 base.
> 
> 
> But before I start rebasing lustre I though I would first test out
> plain ext4 so I know any bugs I find will be from my rebasing and not
> already existing in ext4 itself. And there I run into a big problem:
> Current e2fsprogs (1.41) seem to be totaly unable to handle the ext4 64BIT
> feature, i.e. filesystems larger than 16TiB. The mkfs.ext4 always
> stops saying the disk exceeds the 32bit block count. And looking at
> the code I see a lot of blk_t (instead of blk64_t) and unsigned long
> (instead of unsigned long long [or even better blk64_t]) usage.
> 
> I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
> mkfs. Does anyone know if there is an updated patch set for 1.41
> anywhere? And when will that be added to e2fsprogs upstream?

Hi Goswin,

I've recently submitted a set of patches that covers most of the API
changes needed to support >16TB file systems (missing Ted bitmap
support of course).  Once the bitmap support is included, it _SHOULD_
be relatively painless to add mke2fs support with this series of patches.

Stay tune.
 
> MfG
>         Goswin

-JRS
