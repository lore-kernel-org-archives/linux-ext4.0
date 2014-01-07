From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Date: Tue, 7 Jan 2014 07:49:35 -0800
Message-ID: <20140107154935.GA17609@infradead.org>
References: <20140107025855.GA9229@birch.djwong.org>
 <20140107124831.GD16640@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rob Browning <rlb@defaultvalue.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaAGPuA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jan 2014 10:50:00 -0500
Content-Disposition: inline
In-Reply-To: <20140107124831.GD16640@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 07, 2014 at 01:48:31PM +0100, Jan Kara wrote:
>   I have to say I'm not thrilled by the idea of juggling strings in
> userspace and in kernel to set a flag for an inode...

Nevermind the massive amounts of code that sit in the filesystem.

Although my recent ACL patches are the first step towards handling the
existing semantically overloaded xattrs in common code.  Unless Al has
a valid reason to disagree I'd like to put a big NAK on adding any new
xattrs that aren't stored on disk as-is but provide magic functionality,
as they are pain to implement, maintain, and audit.
