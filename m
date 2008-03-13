From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsck not fixing all corruptions on the first run?
Date: Thu, 13 Mar 2008 22:22:25 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803132219590.7433@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de> <20080313205426.GD28728@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:37199 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbYCMVWb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 17:22:31 -0400
In-Reply-To: <20080313205426.GD28728@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Mar 2008, Theodore Tso wrote:
>> http://nerdbynature.de/bits/e2fsprogs.pu/md4.log
>> http://nerdbynature.de/bits/e2fsprogs.pu/
>
> Hmm.  What I really need is *first* e2fsck run, to see what it did.

The md4.log is the first e2fsck run:

1) mounted fs, noticed error message in dmesg
2) umounted fs
3) ran e2fsck, right on top of this md4.log file...

The 2nd run is the one after the "/dev/md4: clean" message in md4.log

Thanks,
Christian.
-- 
BOFH excuse #265:

The mouse escaped.
