From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Sun, 26 Oct 2008 04:49:58 -0400
Message-ID: <20081026084958.GB9270@infradead.org>
References: <49019EF6.4000706@rs.jp.nec.com> <20081026084048.GF3184@webber.adilger.int> <20081026084848.GA9270@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYJZIt7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Oct 2008 04:49:59 -0400
Content-Disposition: inline
In-Reply-To: <20081026084848.GA9270@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 26, 2008 at 04:48:48AM -0400, Christoph Hellwig wrote:
> Btw, any reason the XFS approach of passing in filehandles for both
> the inode to be defragmented and the "donor" inode doesn't work for you?

Sorry should be file descriptor and not filehandle above.

