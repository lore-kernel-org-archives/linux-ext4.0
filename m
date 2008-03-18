From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [Bugme-new] [Bug 10276] New: directory ctime not updated by rename
Date: Tue, 18 Mar 2008 17:46:09 +0000
Message-ID: <20080318174608.GH10722@ZenIV.linux.org.uk>
References: <bug-10276-10286@http.bugzilla.kernel.org/> <20080318100023.1e047627.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	bugme-daemon@bugzilla.kernel.org,
	lasse-kernelbug-2008@mail.plastictree.net
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762045AbYCSUAT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 16:00:19 -0400
Content-Disposition: inline
In-Reply-To: <20080318100023.1e047627.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 18, 2008 at 10:00:23AM -0700, Andrew Morton wrote:

> Do we agree that this is a bug?  If so, is it a VFS thing or a per-fs
> thing?

The latter; all control over timestamps on directory operations is in
filesystems.  Which filesystem it is, BTW?  E.g. ext2 has
        dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
in ext2_set_link() (and the same in ext2_add_entry()/ext2_delete_entry()),
so on all paths in ext2_rename() both parents will get ctime and mtime
updated; so will the object being moved and the object being unlinked
(explicitly in ext2_rename()).
