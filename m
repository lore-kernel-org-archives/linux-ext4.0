From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [Bugme-new] [Bug 10276] New: directory ctime not updated by rename
Date: Tue, 18 Mar 2008 17:53:30 +0000
Message-ID: <20080318175330.GA13555@ZenIV.linux.org.uk>
References: <bug-10276-10286@http.bugzilla.kernel.org/> <20080318100023.1e047627.akpm@linux-foundation.org> <20080318174608.GH10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	bugme-daemon@bugzilla.kernel.org,
	lasse-kernelbug-2008@mail.plastictree.net
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080318174608.GH10722@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 18, 2008 at 05:46:09PM +0000, Al Viro wrote:
> On Tue, Mar 18, 2008 at 10:00:23AM -0700, Andrew Morton wrote:
> 
> > Do we agree that this is a bug?  If so, is it a VFS thing or a per-fs
> > thing?
> 
> The latter; all control over timestamps on directory operations is in
> filesystems.  Which filesystem it is, BTW?  E.g. ext2 has

Doh.  ext3...  OK, that's a bug; direct update of directory entry by
                new_de->inode = cpu_to_le32(old_inode->i_ino);
needs an update of timestamps of new_dir.
