From: Dave Jones <davej@redhat.com>
Subject: Re: EXT4 corruption on Linus latest tree.
Date: Wed, 27 Feb 2013 11:56:21 -0500
Message-ID: <20130227165621.GA8834@redhat.com>
References: <20130227154311.GA12450@redhat.com>
 <20130227155539.GA2638@pd.tnic>
 <20130227160446.GA4792@redhat.com>
 <20130227164417.GF5609@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760416Ab3B0Q4l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 11:56:41 -0500
Content-Disposition: inline
In-Reply-To: <20130227164417.GF5609@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 27, 2013 at 11:44:17AM -0500, Theodore Ts'o wrote:
 > On Wed, Feb 27, 2013 at 11:04:46AM -0500, Dave Jones wrote:
 > >  > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
 > > 
 > > Yeah, looks similar.  The missing files/dirs reappeared when I
 > > booted an older kernel, so it looks like the corruption doesn't
 > > hit the disk.  Fsck (1.42.5) didn't find anything either.
 > 
 > I suspect I see the problem...   can you send me the results of 
 > 
 >   debugfs -R "stat <172235804>" /dev/sdb1
 > 
 > to confirm?

debugfs 1.42.5 (29-Jul-2012)
Inode: 172235804   Type: directory    Mode:  0775   Flags: 0x80000
Generation: 1174354732    Version: 0x00000000:00000055
User:  1000   Group:  1000   Size: 4096
File ACL: 0    Directory ACL: 0
Links: 24   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x512d0fdc:71fe3000 -- Tue Feb 26 14:41:16 2013
 atime: 0x512d106e:5a143300 -- Tue Feb 26 14:43:42 2013
 mtime: 0x512d0fdc:71fe3000 -- Tue Feb 26 14:41:16 2013
crtime: 0x50e76c35:1d69aad8 -- Fri Jan  4 18:56:37 2013
Size of extra inode fields: 28
Extended attributes stored in inode body: 
  selinux = "unconfined_u:object_r:file_t:s0\000" (32)
EXTENTS:
(0):688923213


That took about 2 minutes to run btw, expected ?

	Dave


 
