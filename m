From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext2: Report metadata errors during fsync
Date: Wed, 25 Nov 2009 13:48:58 -0800
Message-ID: <20091125134858.97ca863d.akpm@linux-foundation.org>
References: <1259144693-6732-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932970AbZKYVtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2009 16:49:04 -0500
In-Reply-To: <1259144693-6732-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Nov 2009 11:24:53 +0100
Jan Kara <jack@suse.cz> wrote:

> When an IO error happens while writing metadata buffers, we should better
> report it and call ext2_error since the filesystem is probably no longer
> consistent. Sometimes such IO errors happen while flushing thread does
> background writeback, the buffer gets later evicted from memory, and thus
> the only trace of the error remains as AS_EIO bit set in blockdevice's
> mapping. So we check this bit in ext2_fsync and report the error although
> we cannot be really sure which buffer we failed to write.

So this doesn't cause significant changes in runtime behaviour unless
the operator specified errors=remount-ro or errors=panic?
