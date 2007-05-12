From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Sat, 12 May 2007 13:38:01 +0400
Message-ID: <46458AF9.404@clusterfs.com>
References: <20070512020248.GQ6375@schatzie.adilger.int>	 <1178957506.20145.41.camel@eric-laptop>  <46457BD5.8040301@clusterfs.com> <1178962364.20145.99.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:58900 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbXELJiT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 May 2007 05:38:19 -0400
In-Reply-To: <1178962364.20145.99.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I don't quite follow? how would you "probe" ? for example,
there is DDN array which write well with 1MB aligned/sized
requests only. thus, mballoc tries to align allocation
requests WRT to this constrain. do you mean incorporation
storage benchmark in the mount procedure?

thanks, Alex

Eric wrote:
> That hadn't occurred to me. Perhaps the filesystem driver or mkfs could
> probe for the stride in those cases? If the code asks for, say, 10MiB of
> data from the block device and it gets back sectors that are spaced
> 128KiB apart before it gets the rest of the data, it can make an
> intelligent guess about the stride.
> 
> I wonder what penalties would come from a bad guess due to a cache in
> between the block device driver and the disk platters, or other load on
> a SAN...
> 
> 
> Eric
> 
