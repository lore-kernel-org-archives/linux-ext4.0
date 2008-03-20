From: hooanon05@yahoo.co.jp
Subject: Re: [Bugme-new] [Bug 10276] New: directory ctime not updated by rename
Date: Thu, 20 Mar 2008 12:36:41 +0900
Message-ID: <7732.1205984201@jrobl>
References: <bug-10276-10286@http.bugzilla.kernel.org/> <20080318100023.1e047627.akpm@linux-foundation.org> <20080318174608.GH10722@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	bugme-daemon@bugzilla.kernel.org,
	lasse-kernelbug-2008@mail.plastictree.net
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:57230 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYCTDrW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 23:47:22 -0400
In-Reply-To: <20080318174608.GH10722@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Al Viro:
> The latter; all control over timestamps on directory operations is in
> filesystems.  Which filesystem it is, BTW?  E.g. ext2 has
>         dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
> in ext2_set_link() (and the same in ext2_add_entry()/ext2_delete_entry()),
> so on all paths in ext2_rename() both parents will get ctime and mtime
> updated; so will the object being moved and the object being unlinked
> (explicitly in ext2_rename()).

Is it correct to update the mtime of renaming inode?
When it is a regular file the mtime is not updated, but a directory. I
have been wondering it for a long time.

$ stat -f .
  File: "."
    ID: c39e8aabce296ceb Namelen: 255     Type: ext2/ext3
Block size: 1024       Fundamental block size: 1024
Blocks: Total: 124442     Free: 122443     Available: 116018
Inodes: Total: 32256      Free: 32144
(actually it is ext2)

$ mkdir d1
$ stat d1
  File: `d1'
  Size: 1024      	Blocks: 2          IO Block: 1024   directory
Device: 30ah/778d	Inode: 2017        Links: 2
Access: (0755/drwxr-xr-x)  Uid: ( 1000/     jro)   Gid: ( 1000/     jro)
Access: 2008-03-20 12:33:57.000000000 +0900
Modify: 2008-03-20 12:33:57.000000000 +0900
Change: 2008-03-20 12:33:57.000000000 +0900

$ /tmp/rename d1 d2
(simply issues rename systemcall.)

$ stat d2
  File: `d2'
  Size: 1024      	Blocks: 2          IO Block: 1024   directory
Device: 30ah/778d	Inode: 2017        Links: 2
Access: (0755/drwxr-xr-x)  Uid: ( 1000/     jro)   Gid: ( 1000/     jro)
Access: 2008-03-20 12:33:57.000000000 +0900
Modify: 2008-03-20 12:34:11.000000000 +0900
Change: 2008-03-20 12:34:11.000000000 +0900
$ 


Junjiro Okajima
