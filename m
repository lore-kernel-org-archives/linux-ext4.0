From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH v2 3/6] ext4: Use ext4_get_block_write() for DAX
Date: Sun, 05 Jul 2015 16:29:28 +0300
Message-ID: <55993138.3040307@plexistor.com>
References: <1435934443-17090-1-git-send-email-matthew.r.wilcox@intel.com> <1435934443-17090-4-git-send-email-matthew.r.wilcox@intel.com> <20150703183027.GH9456@thunk.org> <20150703184824.GA13681@linux.intel.com> <20150703190703.GK9456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <willy@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150703190703.GK9456@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/03/2015 10:07 PM, Theodore Ts'o wrote:
> On Fri, Jul 03, 2015 at 02:48:24PM -0400, Matthew Wilcox wrote:
>>
>> At boot, I "modprobe pmem".
> 
> Is there a reason why it's important to build and load pmem as a
> module?  If I use CONFIG_BLK_DEV_PMEM=y (which is more convenient
> given how I launch my KVM test appliance), should I expect any
> problems?
> 

This (=y) should work fine. We use it a lot. (with KVM even boot an
image with -dax, with a trick)

Note that DAX need not be tested with pmem only, you can always use brd
at any given point without any reboot.

One more trick for xfstest I use:
	memmap=2G!4G,2G!6G

And have two pmem0/1 and don't need to bother with any fdisk. Do need
to mkfs every boot though.

BTW: with kvm a reboot with above memmap will give you back the exact
same memory. halt and "virsh start" is a different story.

> I assume that this won't detect any bugs caused by missing CLFLUSH
> instructions, but I assume that when using NVM as a block device, this
> isn't much of an issue, as long as we don't care about torn writes?
> (How using NVM with metdata checksums, or any checksums for that
> matter, seems to be an interesting question --- how do we recover from
> a checksum failure after a power failure?)
> 

Currently pmem maps a very-(very) slow ioremap_nocache. So any Kernel
memory access should be pmem persistent. For a real world faster ioremap,
there are few major pieces still missing in the stack to make it
persistent. Note the even today with  ioremap_nocache, any application
mmap (like git) is not persistent.

> 					- Ted

Cheers
Boaz

