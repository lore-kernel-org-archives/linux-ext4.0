From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Sat, 24 May 2008 19:49:04 -0400
Message-ID: <20080524234904.GC5970@mit.edu>
References: <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57672 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbYEXXtM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2008 19:49:12 -0400
Content-Disposition: inline
In-Reply-To: <20080428025302.GC30840@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The maint branch has been updated for 1.40.10 e2fsprogs release.

The master branch is proceeding towards a 1.41 release; there are only
a few more topics which are cooking (see the topic's message) before
we should be ready for 1.41.

    	  	     	  	      	      		- Ted

* The 'maint' branch has these fixes since the last announcement.

Benno Schulenberg (1):
  po: update nl.po (from translationproject.org)

Clytie Siddall (1):
  po: update vi.po (from translationproject.org)

G=F6ran Uddeborg (1):
  po: update sv.po (from translationproject.org)

Maciej W. Rozycki (1):
  Remove default sizeof sizes in configure script when
      cross-compiling

Matthias Koenig (1):
  libuuid: don't use unitialized variable

Philipp Thomas (1):
  po: update de.po (from translationproject.org)

Theodore Ts'o (4):
  Fix German translation bug (y,n) -> (j,n)
  e2fsck: Fix potential data corruptor bug in journal recovery
  blkid: If the device mtime is newer that the cache time, force a
      revalidation
  Update release notes and debian changelog for 1.40.10 release


* The 'master' branch has these since the last announcement
  in addition to the above.

Eric Sandeen (2):
  - fix swap sanity tests in blkid, and blkid tests
  fix extent_goto for non-0 leaf levels

Theodore Ts'o (8):
  Fix parallel build problem
  mke2fs: Add the ability to configure default extended options in
      mke2fs.conf
  Add ext4dev stanza to mke2fs.conf
  Install {mkfs,fsck}.{ext4,ext4dev} binary and man pages
  ext2fs.h: Add l_i_file_acl_high and l_version_hi to on-disk inode
      structure
  debugfs: Print the nanosecond field and i_version field of an inode
  Fix m_large_file and r_inline_xattr tests to match with recent
      changes
  Add 64-bit support to the test_io manager

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
