From: Theodore Tso <tytso@mit.edu>
Subject: What's in e2fsprogs.git (stable)
Date: Thu, 13 Mar 2008 14:05:03 -0400
Message-ID: <20080313180503.GC31653@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46373 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754281AbYCMSFR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 14:05:17 -0400
Content-Disposition: inline
In-Reply-To: <20080229142830.GB8968@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' (and 'master') branch has these fixes since the last
  announcement

Benno Schulenberg (1):
  po: update nl.po (from translationproject.org)

Clytie Siddall (1):
  po: update vi.po (from translationproject.org)

G=F6ran Uddeborg (1):
  po: update sv.po (from translationproject.org)

Jakub Bogusz (1):
  po: update pl.po (from translationproject.org)

Petr Pisar (1):
  po: update cs.po (from translationproject.org)

Theodore Ts'o (9):
  Fix mke2fs man page regarding 128-byte default inode size
  blkid: Fix portability problem caused by using uint instead of
      unsigned int
  resize2fs: Fix resizing filesystems with large inodes
  e2fsck: Fix obvious typo in an "internal error" message
  e2fsck: Handle a pass 2 "should never happen" error gracefully
  libext2fs: Add ext2fs_dblist_get_last() and
      ext2fs_dblist_drop_last()
  e2fsck: Fix directory i_size handling
  e2image: Use open64() so that "e2image -I" works on image files >
      2GB
  e2fsck: Use "Clear Htree" instead of "Clear" when the Htree is
      corrupt

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
