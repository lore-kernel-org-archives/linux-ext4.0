From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Documenting the ext3 -> ext4 transition
Date: Thu, 3 Sep 2015 15:12:00 -0600
Message-ID: <FDEAB7F2-10F9-451F-ABBE-BBAA37FC4193@dilger.ca>
References: <20150903191644.GC10390@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35783 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbbICVMF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2015 17:12:05 -0400
Received: by pacfv12 with SMTP id fv12so1778765pac.2
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2015 14:12:04 -0700 (PDT)
In-Reply-To: <20150903191644.GC10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 3, 2015, at 1:16 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> Hi all,
> 
> Now that ext3.ko is going away, Ted and I talked about having a wiki
> page to talk about the transition (to using ext4.ko for ext3 FS) and
> potential upgrade paths.  There already was a section in the HOWTO,
> but I promoted it to its own page and a link from the front page:
> 
> Please take a look and suggest/make changes:
> 
> https://ext4.wiki.kernel.org/index.php/UpgradeToExt4

I thought is that ext3 had dir_index enabled by default, so it isn't
totally correct that this feature needs to be enabled when upgrading
from ext3 to ext4.

Cheers, Andreas





