From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9 v4] ext4: Punch hole and DAX fixes
Date: Thu, 10 Dec 2015 10:10:56 -0700
Message-ID: <20151210171056.GB13603@linux.intel.com>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
 <20151208010841.GF3094@thunk.org>
 <20151209235518.GA31235@linux.intel.com>
 <20151210162642.GB8898@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbbLJRLq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2015 12:11:46 -0500
Content-Disposition: inline
In-Reply-To: <20151210162642.GB8898@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 10, 2015 at 11:26:42AM -0500, Theodore Ts'o wrote:
> On Wed, Dec 09, 2015 at 04:55:18PM -0700, Ross Zwisler wrote:
> > Hey Ted,
> > 
> > I'm working on some fsync/msync patches that I'm hoping to merge for v4.5 and
> > my patches build upon the work done in this series by Jan.
> > 
> > I see Jan's patches in your dev branch - do you expect that branch to be part
> > of a pull request (are the commit IDs stable)?  Or will patches from the dev
> > branch get moved into another branch before you send the pull request to
> > Linus?
> 
> Thanks for asking.  I assume your work is not just ext4 specific (in
> which I could just manage it using patches in the ext4 patch queue).,
> but where you want to start a git tree and then push to Linus
> independently, yes?

Correct.  Here's the series I'm talking about (sorry for not including a link
in the original mail):

https://lists.01.org/pipermail/linux-nvdimm/2015-December/003259.html

The only patch that touches ext4 is patch 6/7, which is a 4 line change to
hook into the ext4_dax_pfn_mkwrite() function and have it call
dax_pfn_mkwrite().  Jan's series added ext4_dax_pfn_mkwrite(), which is my
dependency.

> > I'm just trying to figure out what I should use as a baseline for my changes
> > since I need to build on Jan's patches but obviously don't want to include new
> > ext4 code with my pull request (which I will send after you send yours). :)
> 
> Please use the "master" branch from the ext4 tree as your baseline.
> Normally dev is a rewinding branch, but for these sorts of situations
> I'll guarantee that everything between origin..master will be stable,
> while commits between master..dev may be rewound or dropped to fix
> bugs/regressions:
> 
> * dde86e3 - (HEAD -> guilt/origin, dev) ext4 crypto: add missing locking for keyring_key access (10 hours ago)
> * 0969c39 - ext4 crypto: add ioctls to allow backup of encryption metadata (10 hours ago)
> * 843848f - ext4 crypto: add ciphertext_access mount option (10 hours ago)
> * ba5843f - (master) ext4: use pre-zeroed blocks for DAX page faults (3 days ago)
> * c86d8db - ext4: implement allocation of pre-zeroed blocks (3 days ago)
> * 53085fa - ext4: provide ext4_issue_zeroout() (3 days ago)
> * 2dcba47 - ext4: get rid of EXT4_GET_BLOCKS_NO_LOCK flag (3 days ago)
> * e74031f - ext4: document lock ordering (3 days ago)
> * 0112784 - ext4: fix races of writeback with punch hole and zero range (3 days ago)
> * 32ebffd - ext4: fix races between buffered IO and collapse / insert range (3 days ago)
> * 17048e8 - ext4: move unlocked dio protection from ext4_alloc_file_blocks() (3 days ago)
> * ea3d720 - ext4: fix races between page faults and hole punching (3 days ago)
> 
> Jan's patches have gone through multiple rounds of testing and I'm
> quite confident there are no bugs or regressions that can't be dealt
> with using follow up patches.

Perfect, thank you. :)
