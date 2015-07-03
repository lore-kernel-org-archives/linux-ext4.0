From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 3/6] ext4: Use ext4_get_block_write() for DAX
Date: Fri, 3 Jul 2015 14:48:24 -0400
Message-ID: <20150703184824.GA13681@linux.intel.com>
References: <1435934443-17090-1-git-send-email-matthew.r.wilcox@intel.com>
 <1435934443-17090-4-git-send-email-matthew.r.wilcox@intel.com>
 <20150703183027.GH9456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150703183027.GH9456@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 03, 2015 at 02:30:27PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 03, 2015 at 10:40:40AM -0400, Matthew Wilcox wrote:
> > From: Matthew Wilcox <willy@linux.intel.com>
> > 
> > DAX relies on the get_block function either zeroing newly allocated blocks
> > before they're findable by subsequent calls to get_block, or marking newly
> > allocated blocks as unwritten.  ext4_get_block() cannot create unwritten
> > extents, but ext4_get_block_write() can.
> 
> To be clear, this patch has no prerequistes or dependencies, right?
> That is, it would be fine if I take this through the ext4 git tree?
> Or is there a reason or a preference for carrying this patch
> somewhere else?

Right, no dependencies or prerequisites, completely independent of all
the other patches.

> Also, is there a way I can test the DAX functionality in ext4 using
> KVM?  If so, can you give me a cheat sheet about how I can do that?

I don't use KVM, but I can tell you what I do ... (additional explanation
added, not for Ted's benefit, but because people less familiar with
Linux than Ted is may happen upon this email for their own purposes).

In /etc/default/grub, I have this line:

GRUB_CMDLINE_LINUX="memmap=4G!4G"

        memmap=nn[KMG]!ss[KMG]
                        [KNL,X86] Mark specific memory as protected.
                        Region of memory to be used, from ss to ss+nn.
                        The memory region may be marked as e820 type 12 (0xc)
                        and is NVDIMM or ADR memory.


In my kernel config, I have:

CONFIG_X86_PMEM_LEGACY=y
CONFIG_LIBNVDIMM=y
CONFIG_BLK_DEV_PMEM=m

At boot, I "modprobe pmem".  On the desktop-class system I'm using as
my development machine, the BIOS doesn't clear RAM between boots (only
power cycles), so the partition table and ext4 filesystem stays good,
and all I have to do is:

mount -odax /dev/pmem0p1 /mnt/ram0/

Also my xfstests local.config:

TEST_DEV=/dev/pmem0p1
TEST_DIR=/mnt/ram0
SCRATCH_DEV=/dev/pmem0p2
SCRATCH_MNT=/mnt/ram1
TEST_FS_MOUNT_OPTS="-o dax"
EXT_MOUNT_OPTIONS="-o dax"
MKFS_OPTIONS="-b4096"

Hope I didn't forget anything.
