From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: ext2/3 using ext4 module mkdir IO error on pmem DAX mount
Date: Wed, 2 Mar 2016 17:28:24 -0700
Message-ID: <20160303002824.GA31238@linux.intel.com>
References: <20160302064304.GA15559@dhcp12-144.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nvdimm@ml01.01.org, linux-ext4@vger.kernel.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>,
	Lokesh Jaliminche <lokesh.jaliminche@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160302064304.GA15559@dhcp12-144.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 02, 2016 at 02:43:04PM +0800, Xiong Zhou wrote:
> Hi,
> 
> mkdir failed IO error on pmem DAX ext2/3 fs mount using ext4 module.
> 
> This happends only on -next tree, not on Linus' tree,
> at least from 4.5.0-rc5-next-20160224.

I was able to reproduce this and bisect it to the following commit:

commit 1f2d779fed21 ("ext4: optimize group search for inode allocation")

The fact that DAX was enabled in this failure was a red herring - it fails
without DAX as well.  The key is just that we're mounting an ext2 formatted
filesystem using the ext4 module, I think.

- Ross
