From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH ext3/ext4] orphan list corruption due bad inode
Date: Tue, 5 Jun 2007 07:13:15 +0100
Message-ID: <20070605061315.GA25760@infradead.org>
References: <4663A0CE.102@sw.ru> <20070604190340.dba85bb0.akpm@linux-foundation.org> <4664FE80.4080801@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org, linux-ext4@vger.kernel.org,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35339 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbXFEGNW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 02:13:22 -0400
Content-Disposition: inline
In-Reply-To: <4664FE80.4080801@sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 05, 2007 at 10:11:12AM +0400, Vasily Averin wrote:
> >>  	return d_splice_alias(inode, dentry);
> >>  }
> > Seems reasonable.  So this prevents the bad inodes from getting onto the
> > orphan list in the first place?
> 
> make_bad_inode() is called from ext3_read_inode() that is called from iget() only.

Which is artefact of using the read_inode interface.  Please switch from
iget to iget_locked and you can handle this case without ever inserting the
"bad" inode into the inode hash.
