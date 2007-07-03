From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 3 Jul 2007 18:15:22 -0400
Message-ID: <20070703221522.GE14074@fieldses.org>
References: <1183275424.4010.126.camel@localhost.localdomain> <1183388313.3864.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1183388313.3864.35.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 02, 2007 at 10:58:33AM -0400, Mingming Cao wrote:
> Trond or Bruce, can you please review these patch series and ack if you
> agrees?

Thanks, looks like what we need!

How will nfsd tell whether it can really on a given filesystem's
i_version, or whether it should fall back on ctime?

> As to performance concerns that raise before the inode version counter
> (at least for ext4) is done inside ext4_mark_inode_dirty), so there is
> no extra IO work to store this counter to disk.

So what's the motivation for the "noversion" mount option?

--b.
