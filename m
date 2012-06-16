From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Sat, 16 Jun 2012 07:14:01 +0000
Message-ID: <201206160714.01830.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <20120615220453.GC7363@thunk.org> <83D78CE9-16BA-45DE-ADED-88E03DC2E073@dilger.ca>
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
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2FPHOS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jun 2012 03:14:18 -0400
In-Reply-To: <83D78CE9-16BA-45DE-ADED-88E03DC2E073@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 15 June 2012, Andreas Dilger wrote:
> > Oh, that's cool.  And I don't think that's hard to do.  We could just
> > keep a flag in the in-core inode indicating whether it is in "large
> > unit" mode.  If it is in large unit mode, we can make the fs writeback
> > function make sure that we adhere to the restrictions of the large
> > unit mode, and if at any point we need to do something that might
> > violate the constraints, the file system would simply close the
> > context.
> 
> This is very similar to what was implemented in mballoc preallocation.
> Large files will get their own preallocation context, while small files
> would share a context (i.e. an 8MB extent) and be packed densely into
> this extent to avoid seeking.  It wouldn't be unreasonable to just give
> each mballoc context a different eMMC context.

My understanding is that once we do that, we have already won much more
than we can by using contexts, because we get perfect write patterns.
The only thing that contexts would still buy us is that the device has
more freedom to cache things separately in each context if we write
with less than superpage alignment.

Is the mballoc algorithm you describe something that is already implemented
with the semantics you describe, or is there something we need to change
still, e.g. making sure that all allocations are aligned to the stripe-width?

	Arnd
