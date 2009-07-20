From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3 default journal mode
Date: Mon, 20 Jul 2009 17:29:04 -0400
Message-ID: <20090720212904.GI2416@mit.edu>
References: <4A63DB89.2060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Valerie Aurora <vaurora@redhat.com>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60221 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZGTV3T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 17:29:19 -0400
Content-Disposition: inline
In-Reply-To: <4A63DB89.2060306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's a revised proposal for the KCONFIG text.  

Hopefully this is balanced about the two sides of the issue, without
explicitly advocating for one choice versus another.

What do people think?

						- Ted

P.S.  Note that date=writeback does not make the filesystem more
"prone to corruption after crashes".


config EXT3_DEFAULTS_TO_ORDERED
	bool "Default to 'data=ordered' in ext3"
	depends on EXT3_FS
	help
	  If a filesystem does not explicitly specify a data ordering
	  mode, and the journal capability allowed it, ext3 used to
	  historically default to 'data=ordered'.

          Data=ordered mode is the mode used by most distributions, but can
          introduce latency problems in some workloads, especially if there 
	  is a combination of high bandwidth background writes and foreground
	  processes calling fsync() and waiting for the result.   In worst
	  case scenarios, the fsync() call can 500ms to multiple seconds 
	  to return.

	  The problem with using a default of data=writeback, however,
	  is that is that after a system crash or a power failure,
	  files that were written right before the system went down
	  could contain previously written data or other garbage.
	  With data=ordered mode, any blocks in the file will have
	  been data written by the application, avoiding a possibility
	  of a security breach, which is especially problematic on a
	  multi-user system.  Note, however, that data=ordered does
	  not guarantee that the file will be consistent at an
	  application level; the application must use fsync() at
	  appropriate commit points in order to guarantee
	  application-level consistency.

          If you have been historically happy with ext3's performance,
  	  data=ordered mode will be a safe choice and you should
  	  answer "y" here.  If you understand the reliability and data
  	  privacy issues of data=writeback and are willing to make
  	  that trade off, answer "n".

