From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] E2fsprogs: use the generic inode flags
Date: Mon, 18 Apr 2011 06:51:46 -0400
Message-ID: <20110418105146.GA15557@infradead.org>
References: <4DA2A0CC.9000301@cn.fujitsu.com>
 <4DABEA36.5060007@cn.fujitsu.com>
 <4DABF93E.1030504@coly.li>
 <4DABFDF0.9060608@cn.fujitsu.com>
 <4DAC1D5D.3020506@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: liubo <liubo2009@cn.fujitsu.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	tytso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>
To: Coly Li <i@coly.li>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DAC1D5D.3020506@coly.li>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 18, 2011 at 07:15:41PM +0800, Coly Li wrote:
> It seems chattr and lsattr is not an ext[234] only utilities any more...

They haven't been for a long time.

