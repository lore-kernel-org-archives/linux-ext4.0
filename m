From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Fri, 15 Jun 2012 09:19:23 +0000
Message-ID: <201206150919.23484.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <20120614170533.GA15093@thunk.org> <alpine.LFD.2.02.1206141505300.23555@xanadu.home>
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
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2FOJTp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2012 05:19:45 -0400
In-Reply-To: <alpine.LFD.2.02.1206141505300.23555@xanadu.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 14 June 2012, Nicolas Pitre wrote:
> On Thu, 14 Jun 2012, Ted Ts'o wrote:
>
> > The reason why I talk about making it work automatically at mke2fs
> > time is that the vast majority of created file systems (where a
> > specially created fs by a handset vendor counts as "one", even if it
> > then gets stamped on millions of devices), the end user is someone
> > naive/oblivious, so the right thing has to happen by default in the
> > common case of running mke2fs on the storage device where the file
> > system gets used.
> 
> Absolutely.  However it is fair to say that less than 0.01% of total end 
> users will even think of running mke2fs on their device.  So another 
> strategy that can be executed at run time when the fs is live would be 
> required too.

The trouble is that detecting the erase block size requires us to
write specific patterns to the device, which is generally a bad
idea after the file system has been created.

I think the best we can do is

* default to "unspecified" as before
* if "unspecified", make the file system ask the block device. in
  case of eMMC, that will usually be reliable
* Add an option to mkfs and tunefs to hardcode a specific size for
  users that know the size and can't rely on the blockdev reporting
  it correctly to the file system.
* Add an option to mkfs to autodetect the size for the drive it's
  run on.

	Arnd
