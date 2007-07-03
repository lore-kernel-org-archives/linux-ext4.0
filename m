From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 03 Jul 2007 10:24:42 -0400
Message-ID: <1183472682.6494.38.camel@heimdal.trondhjem.org>
References: <1183275424.4010.126.camel@localhost.localdomain>
	 <1183388313.3864.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pat.uio.no ([129.240.10.15]:60637 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbXGCO3H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2007 10:29:07 -0400
In-Reply-To: <1183388313.3864.35.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-02 at 10:58 -0400, Mingming Cao wrote:
> Trond or Bruce, can you please review these patch series and ack if you
> agrees? Thanks.
> 
> As to performance concerns that raise before the inode version counter
> (at least for ext4) is done inside ext4_mark_inode_dirty), so there is
> no extra IO work to store this counter to disk.

Hi Mingming,

It looks OK to me, but you might want to strip out the now redundant
i_version updates in add_dirent_to_buf(), ext4_rmdir(), ext4_rename().

I also have some questions about how this will affect the readdir code:
unless I missed something, the filp->f_version is still unsigned long,
so the comparisons and assignments in ext4_readdir()/ext4_dx_readdir()
no longer make sense.

Cheers
  Trond
