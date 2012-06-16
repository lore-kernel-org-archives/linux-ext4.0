From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Sat, 16 Jun 2012 06:49:57 +0000
Message-ID: <201206160649.57838.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206150919.23484.arnd.bergmann@linaro.org> <20120615213046.GB7363@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59203 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2FPGuH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jun 2012 02:50:07 -0400
In-Reply-To: <20120615213046.GB7363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 15 June 2012, Ted Ts'o wrote:
> On Fri, Jun 15, 2012 at 09:19:23AM +0000, Arnd Bergmann wrote:
> > 
> > The trouble is that detecting the erase block size requires us to
> > write specific patterns to the device, which is generally a bad
> > idea after the file system has been created.
> 
> How much space do you need?  It's not hard to allocate a bunch of
> space, in a file, use FIEMAP ioctl to verify that you have a
> contiguous range of blocks, and then do direct I/O into that region.

We need a few erase blocks, spaced apart by a few erase blocks each.
Since we don't have to detect the number of erase blocks that the
device can handle, a small number would be ok I guess, so in order
to detect an 8 MB erase block correctly, we might use 3 erase blocks
that are spaced apart by 5 erase blocks, for a total of 104MB.

Once we figure out the erase block size, it would also help to
verify that we can write to at least e.g. 5 blocks concurrently
without triggering garbage collection, so we can print a warning
if it doesn't.

	Arnd
