From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Fri, 15 Jun 2012 17:30:46 -0400
Message-ID: <20120615213046.GB7363@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <20120614170533.GA15093@thunk.org>
 <alpine.LFD.2.02.1206141505300.23555@xanadu.home>
 <201206150919.23484.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50713 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2FOVay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jun 2012 17:30:54 -0400
Content-Disposition: inline
In-Reply-To: <201206150919.23484.arnd.bergmann@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 15, 2012 at 09:19:23AM +0000, Arnd Bergmann wrote:
> 
> The trouble is that detecting the erase block size requires us to
> write specific patterns to the device, which is generally a bad
> idea after the file system has been created.

How much space do you need?  It's not hard to allocate a bunch of
space, in a file, use FIEMAP ioctl to verify that you have a
contiguous range of blocks, and then do direct I/O into that region.

> I think the best we can do is
> 
> * default to "unspecified" as before
> * if "unspecified", make the file system ask the block device. in
>   case of eMMC, that will usually be reliable
> * Add an option to mkfs and tunefs to hardcode a specific size for
>   users that know the size and can't rely on the blockdev reporting
>   it correctly to the file system.
> * Add an option to mkfs to autodetect the size for the drive it's
>   run on.

Well, I think we can do better; the question is whether or not it's
worth the effort.  It may not be....

				- Ted
