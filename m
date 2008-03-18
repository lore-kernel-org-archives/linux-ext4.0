From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10276] New: directory ctime not updated by
 rename
Date: Tue, 18 Mar 2008 10:54:03 -0700
Message-ID: <20080318105403.8b2d8d8c.akpm@linux-foundation.org>
References: <bug-10276-10286@http.bugzilla.kernel.org/>
	<20080318100023.1e047627.akpm@linux-foundation.org>
	<20080318174608.GH10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	bugme-daemon@bugzilla.kernel.org,
	lasse-kernelbug-2008@mail.plastictree.net
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080318174608.GH10722@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 18 Mar 2008 17:46:09 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Mar 18, 2008 at 10:00:23AM -0700, Andrew Morton wrote:
> 
> > Do we agree that this is a bug?  If so, is it a VFS thing or a per-fs
> > thing?
> 
> The latter; all control over timestamps on directory operations is in
> filesystems.

OK

>  Which filesystem it is, BTW?

ext3.

>  E.g. ext2 has
>         dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
> in ext2_set_link() (and the same in ext2_add_entry()/ext2_delete_entry()),
> so on all paths in ext2_rename() both parents will get ctime and mtime
> updated; so will the object being moved and the object being unlinked
> (explicitly in ext2_rename()).
