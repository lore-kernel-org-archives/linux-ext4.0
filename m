From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Is it possible for the ext4/btrfs file system to pass some	context related info to low level block driver?
Date: Thu, 5 May 2011 14:11:51 -0600
Message-ID: <7DF5B5A9-7AD7-4EAC-9A42-DA22A814056F@dilger.ca>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com> <yq1mxj32932.fsf@sermon.lab.mkp.net> <CE761E84DADF2947A4AF22FB8D97A47358EE526A@shsmsx501.ccr.corp.intel.com> <60C31100-5694-4CA9-A778-91CB15915052@dilger.ca> <20110505181032.GA21360@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Gao, Yunpeng" <yunpeng.gao@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20110505181032.GA21360@parisc-linux.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 5, 2011, at 12:10, Matthew Wilcox wrote:
> On Wed, May 04, 2011 at 08:51:39AM -0600, Andreas Dilger wrote:
>> I was aware of REQ_META, but I didn't know there was any benefit to
>> using it. I think it would be easy to set REQ_META on all ext4 metadata
>> if there was a reason to do so.
> 
> The CFQ ioscheduler pays attention to it (prioritising metadata accesses
> over data accesses), and blocktrace will print an 'M' for metadata
> requests if it's set, so I think that's two excellent reasons to set
> REQ_META today.
> 
> However, ext3, ext4, and XFS already use it:
> 
> fs/ext4/inode.c:1500:   ll_rw_block(READ_META, 1, &bh);
  - ext4_bread()

> fs/ext4/inode.c:4775:           submit_bh(READ_META, bh);
  - __ext4_get_inode_loc()
> fs/ext4/namei.c:924:                    ll_rw_block(READ_META, 1, &bh);
  - ext4_find_entry()

Looking more closely at the code it seems that this is handling only a subset of the code.  There are many places in ext4 that are using sb_bread() instead of ext4_bread(), in particular in the extents and migration code that was developed more recently, but also in the xattr code which has been around a long time.

Cheers, Andreas





