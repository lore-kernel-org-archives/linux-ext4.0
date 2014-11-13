From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Thu, 13 Nov 2014 10:44:59 +0200
Message-ID: <54646F8B.8040000@plexistor.com>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu> <20141113064150.GI28565@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61832 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaKMIpB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2014 03:45:01 -0500
Received: by mail-wi0-f174.google.com with SMTP id d1so7498848wiv.1
        for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2014 00:45:00 -0800 (PST)
In-Reply-To: <20141113064150.GI28565@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/13/2014 08:41 AM, Dave Chinner wrote:
<>
> 
> I think this needs to a VFS level inode timestamp update option.
> The games ext4 is playing with reference counts inside .drop_inode are
> pretty nasty and could be avoided if this is implemented at the VFs
> level..
> 
> I think that the "lazy time update" status should really be tracked
> in the inode->i_state field. Something like lazytime updates do not
> call ->update_inode, nor do they mark the inode dirty, but they do
> update the inode->i_[acm]time fields and set a TIMEDIRTY state flag.
> 
> Then when the filesystem next logs or writes the inode it can
> log those fields and clear the TIMEDIRTY flag, or if iput_final()
> sees that flag it can call ->update_time directly to get the
> filesystem to run a transaction to update the timestamps before the
> inode is evicted from cache.
> 
> That way the same update semantics can be easily implemented on all
> filesystems, and filesystems that already implement update_time
> should work without any modification at all...
> 

+1 Like from Boaz. I think Dave is very much right!

> Cheers,

Indeed
Boaz

> Dave.
<>

