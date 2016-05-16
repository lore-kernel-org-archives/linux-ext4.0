From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Mon, 16 May 2016 17:59:50 +0200
Message-ID: <20160516155950.GF21714@quack2.suse.cz>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
 <20160513052419.GD5862@thunk.org>
 <20160513135600.GA2996@thunk.org>
 <20160516093525.GD12026@quack2.suse.cz>
 <20160516142616.GB21714@quack2.suse.cz>
 <20160516150820.GJ7799@thunk.org>
 <CAPcyv4iVQadEC-23B36QX-2=vioVniRB+_tSh6ro+dCHKkQzuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZfOjI3PrQbgiZnxM"
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4iVQadEC-23B36QX-2=vioVniRB+_tSh6ro+dCHKkQzuA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 16-05-16 08:13:50, Dan Williams wrote:
> On Mon, May 16, 2016 at 8:08 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Mon, May 16, 2016 at 04:26:16PM +0200, Jan Kara wrote:
> >> 1) Just push patches as is and have ext4 dax broken between ext4 merge and
> >> nvdimm merge.
> >>
> >> 2) Split out the one-line change from "dax: Remove dead zeroing code from
> >> fault handlers" in __dax_fault() which fixes the behavior for ext4 and
> >> merge it through ext4 tree. Merge the rest through nvdimm tree.
> >
> > I'm good either way, although I have a slight preference for (2).
> > It's really tiny preference, though, so if you or Dan want to run the
> > fix through the dax branch, that's fine too.
> 
> Would you fold the change and trigger a rebase or just apply it on
> top?  If just applying on top then it seems the same exposure as
> merging it intact through nvdimm.git.

The patch which fixes ext4 behavior is attached. Just that we know what we
are speaking about... Rebasing all the patches on top of this is trivial
(git rebase just handles the conflict automatically).

I've scheduled full ext4 & XFS xfstest run with just this patch and ext4
fixes to make sure it doesn't introduce some intermediate regresion
somewhere.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--ZfOjI3PrQbgiZnxM
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Call-get_blocks-with-create-1-for-write-faults-t.patch"

>From c8963499eeba112430fc4499c675cca243b8b4a6 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 16 May 2016 17:42:11 +0200
Subject: [PATCH] dax: Call get_blocks() with create == 1 for write faults to
 unwritten extents

Currently, __dax_fault() does not call get_blocks() callback with create
argument set, when we got back unwritten extent from the initial
get_blocks() call during a write fault. This is because originally
filesystems were supposed to convert unwritten extents to written ones
using complete_unwritten() callback. Later this was abandoned in favor of
using pre-zeroed blocks however the condition whether get_blocks() needs
to be called with create == 1 remained.

Fix the condition so that filesystems are not forced to zero-out and
convert unwritten extents when get_blocks() is called with create == 0
(which introduces unnecessary overhead for read faults and can be
problematic as the filesystem may possibly be read-only).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 75ba46d82a76..2494255c5785 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -667,7 +667,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (error)
 		goto unlock_page;
 
-	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
+	if (!buffer_mapped(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			error = get_block(inode, block, &bh, 1);
 			count_vm_event(PGMAJFAULT);
-- 
2.6.6


--ZfOjI3PrQbgiZnxM--
