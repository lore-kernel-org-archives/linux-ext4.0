From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: remove unused variable in add_dirent_to_buf()
Date: Mon, 28 Jan 2013 21:28:03 -0500
Message-ID: <20130129022803.GG7003@thunk.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-2-git-send-email-yan@linux.vnet.ibm.com>
 <20130129011218.GA4754@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45966 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3A2C2G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:28:06 -0500
Content-Disposition: inline
In-Reply-To: <20130129011218.GA4754@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2013 at 05:12:18PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 18, 2013 at 04:01:12PM +0800, Guo Chao wrote:
> > After commit 978fef9 (create __ext4_insert_dentry for dir entry
> > insertion), 'reclen' is not used anymore.
> > 
> > Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> This one looks ok too.
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
