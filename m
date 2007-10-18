From: Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: Re: ext3 warnings from LTP rename14
Date: Thu, 18 Oct 2007 01:09:02 +0100
Message-ID: <20071018000901.GA5657@palantir8>
References: <20071017002009.GA2966@palantir8> <4715637B.1090503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from venus.karoo.kcom.com ([212.50.160.60]:15551 "EHLO
	venus.eclipse.kcom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761944AbXJRAJG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2007 20:09:06 -0400
Content-Disposition: inline
In-Reply-To: <4715637B.1090503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Tue, Oct 16, 2007 at 08:20:59PM -0500, Eric Sandeen wrote:
> Martin Habets wrote:
> > Hello,
> > 
> > I ran the ltp-full-20070930 tests on 2.6.23-rc9-mph4 (sparc32 SMP), and am
> > seeing the following warnings:
> 
> This makes me a little nervous about my change
> ef2b02d3e617cb0400eedf2668f86215e1b0e6af
> (ext34: ensure do_split leaves enough free space in both blocks)
> 
> Do you know when this first showed up?  Could you test -rc6?

Thanks for the input.
Tried this on -rc6, it behaves worse. Besides the earlier warnings
  EXT3-fs warning (device sdb4): ext3_rename: Deleting old file (268753), 2, error=-2
I also get a lot of these
  EXT3-fs error (device sdb4): ext3_add_entry: bad entry in directory #268753: rec_len is smaller than minimal - offset=56, inode=8026488, rec_len=0, name_len=0
and these at the end of the test:
  EXT3-fs warning (device sdb4): ext3_unlink: Deleting nonexistent file (268761), 0
  EXT3-fs error (device sdb4): ext3_readdir: bad entry in directory #268753: rec_len is smaller than minimal - offset=56, inode=8026488, rec_len=0, name_len=0
  EXT3-fs error (device sdb4): empty_dir: bad entry in directory #268753: rec_len is smaller than minimal - offset=56, inode=8026488, rec_len=0, name_len=0

The FS is still mounted rw.

> You say you can reproduce it; have you checked (fsck'd) the filesystem
> in between, and is it in good shape?

Like you, I rerun rename14 stand-alone at the moment.
I didnt do an explicit fschk between all runs, but I also did 2 reboots
which did check the FS.

I'll try to bisect the original ext3_rename warning further.
-- 
Martin
