From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: don't flush the FS unless it's actually dirty
Date: Tue, 12 Aug 2014 12:16:49 -0400
Message-ID: <20140812161649.GE12871@thunk.org>
References: <20140811175045.GD2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dan Jacobson <jidanni@jidanni.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56522 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbaHLQQx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2014 12:16:53 -0400
Content-Disposition: inline
In-Reply-To: <20140811175045.GD2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick, thanks for the patch.

Could you change the test to use $CRCSUM instead of md5sum.  I'd
prefer not to introduce an additional dependency to e2fsprogs, and
using a crc checksum should be sufficient for our purposes here.

Thanks!!

						- Ted

