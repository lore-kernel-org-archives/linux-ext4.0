From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 03/22] libext2fs: add functions to operate on extended
 attribute
Date: Sun, 13 Oct 2013 21:55:26 -0400
Message-ID: <20131014015526.GA25013@thunk.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-4-git-send-email-wenqing.lz@taobao.com>
 <20130805173452.GA9203@blackbox.djwong.org>
 <20130805231434.GA3784@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45639 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab3JNBzd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Oct 2013 21:55:33 -0400
Content-Disposition: inline
In-Reply-To: <20130805231434.GA3784@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 06, 2013 at 07:14:34AM +0800, Zheng Liu wrote:
> > > +ec	EXT2_ET_EXT_ATTR_CURRUPTED,
> > > +	"Extended attribute currupted"
> > 
> > "corrupted".
> 
> Thanks for pointing it out.  Fix it in next spin.
> 
> > (Or maybe shorten that to "corrupt"?)
> 
> I find the 'CORRUPT' in lib/ext2fs/ext2_err.et.in, and the result are as
> below.
> 
> It seems that there is no any rule about this.  I am wondering if we
> need to rename _DIR_CORRUPTED to _DIR_CORRUPT.  I am ok for using
> _CORRUPT or _CORRUPTED.

We shouldn't change existing error codes since that will break
backwards compatibility.  My preference for the new error code is:

ec	  EXT2_ET_EXT_ATTR_CORRUPT,
	  "Corrupt Extended attribute"

							- Ted
