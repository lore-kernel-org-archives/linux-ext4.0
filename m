From: maximilian attems <max@stro.at>
Subject: Re: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Wed, 6 Feb 2008 17:26:53 +0100
Message-ID: <20080206162653.GG3959@baikonur.stro.at>
References: <20080206113426.7833.59505.stgit@sor.suse.de> <20080206125651.GD558@petra.dvoda.cz> <20080206140559.GJ27119@mit.edu> <20080206152310.GF558@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, Matthias Koenig <mkoenig@suse.de>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:58437 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYBFQ2a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 11:28:30 -0500
Content-Disposition: inline
In-Reply-To: <20080206152310.GF558@petra.dvoda.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 06, 2008 at 04:23:10PM +0100, Karel Zak wrote:
>  I'm already working on vol_id + blkid merge
> 
>     http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=shortlog;h=topic/fsprobe
> 
>  My plan is follow ideas and code from blkid and add a new low-level API
>  for udev. That's all.

could you also integrate the requirements for fstype klibc,
so that we can kill the third place of needed fs recognition patches.
 
hpa formulated them a while ago, searching,
http://www.zytor.com/pipermail/klibc/2006-February/001345.html

concerning initramfs volume_id added --probe-all, before it
used to guess wrongly, so currently we prefer klibc fstype.
 
