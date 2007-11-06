From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Tue, 6 Nov 2007 09:40:56 -0800
Message-ID: <20071106094056.3352a574@laptopd505.fenrus.org>
References: <20071106171537.GD23689@duck.suse.cz>
	<20071106171945.GG23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53482 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXKFRl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Nov 2007 12:41:59 -0500
In-Reply-To: <20071106171945.GG23689@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 6 Nov 2007 18:19:45 +0100
Jan Kara <jack@suse.cz> wrote:

> Implement recursive mtime (rtime) feature for ext3. The feature works
> as follows: In each directory we keep a flag EXT3_RTIME_FL
> (modifiable by a user) whether rtime should be updated. In case a
> directory or a file in it is modified and when the flag is set,
> directory's rtime is updated, the flag is cleared, and we move to the
> parent. If the flag is set there, we clear it, update rtime and
> continue upwards upto the root of the filesystem. In case a regular
> file or symlink is modified, we pick arbitrary of its parents
> (actually the one that happens to be at the head of i_dentry list)
> and start the rtime update algorith there.

Ok since mtime (and rtime) are part of the inode and not the dentry...
how do you deal with hardlinks? And with cases of files that have been
unlinked? (ok the later is a wash obviously other than not crashing)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
