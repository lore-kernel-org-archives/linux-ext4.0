From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 15 Feb 2008 20:51:15 +0900
Message-ID: <79B050214DA541F9A8B193C7AACC3C7B@nsl.ad.nec.co.jp>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp> <20080208132657.GE3120@webber.adilger.int> <20080208145911.GA4257@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@MIT.EDU>, <linux-ext4@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>,
	"Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46566 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYBOLv7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2008 06:51:59 -0500
In-Reply-To: <20080208145911.GA4257@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Christoph Hellwig wrote:
> On Fri, Feb 08, 2008 at 08:26:57AM -0500, Andreas Dilger wrote:
>> You may as well make the common ioctl the same as the XFS version,
>> both by number and parameters, so that applications which already
>> understand the XFS ioctl will work on other filesystems.
>
> Yes.  In facy you should be able to lift the implementations of
> XFS_IOC_FREEZE and XFS_IOC_THAW to generic code, there's nothing
> XFS-specific in there.

According to Documentation/ioctl-number.txt,
XFS_IOC_XXXs (_IOWR('X', aa, bb)) are defined for XFS like below.
>From Documentation/ioctl-number.txt:
----------------------------------------------------------------------------
Code    Seq#    Include File            Comments
========================================================
:                 :
'X'     all     linux/xfs_fs.h
----------------------------------------------------------------------------
So XFS_IOC_FREEZE and XFS_IOC_THAW cannot be lifted to generic code simply.
I think we should create new generic numbers for freeze and thaw
like FIBMAP as followings.
linux/fs.h:
#define FIFREEZE _IO(0x00,3)
#define FITHAW   _IO(0x00,4)

And xfs_freeze calls XFS_IOC_FREEZE with a magic number 1, but what is 1?
Instead, I'd like the sec to timeout on freeze API in order to thaw
the filesystem automatically.  It can prevent a filesystem from staying
frozen forever.
(Because a freezer may cause a deadlock by accessing the frozen filesystem.)

Any comments are very welcome.

Cheers, Takashi 
