From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Wed, 20 Jun 2012 15:46:27 +0000
Message-ID: <201206201546.27362.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206191517.26687.arnd.bergmann@linaro.org> <26E7A31274623843B0E8CF86148BFE32779D94DD@NTXAVZMBX04.azit.micron.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"venkat@linaro.org" <venkat@linaro.org>
To: "Luca Porzio (lporzio)" <lporzio@micron.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2FTPqd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2012 11:46:33 -0400
In-Reply-To: <26E7A31274623843B0E8CF86148BFE32779D94DD@NTXAVZMBX04.azit.micron.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 20 June 2012, Luca Porzio (lporzio) wrote:
> > > > * We can only start the large unit at the start of an erase block. If
> > > >   we unmount the drive and later continue writing, it has to continue
> > > >   without the large-unit flag at first until we hit an erase block
> > > >   boundary.
> > >
> > > My assumption was that when you umount the drive, the file system
> > > would close all of the contexts.
> > 
> > Yes, makes sense. This is probably required to ensure that the data
> > has made to the drive, at least for the large contexts, but it is
> > definitely required for housekeeping of contexts if we manage them
> > from the block layer.
> > 
> 
> One comment here, large unit contexts (according to spec) are not bounded
> to erase blocks. They can span one or more blocks, actually they are not
> related to block size at all (just virtual page size of the device which
> can be read from the EXT_CSD configuration registers for eMMC).

Well, when I say erase block, I really mean the "large unit", which is some
multiple of entire megabytes, because the only reasonable way to use this
is to define this to the size of the erase block or a very small multiple
of that. When detecting the "erase block size" of an eMMC, we should report
the smallest multiple of the ERASE_GPR_SIZE, HC_ERASE_GRP_SIZE and 
LARGE_UNIT_SIZE_M1.

	Arnd
