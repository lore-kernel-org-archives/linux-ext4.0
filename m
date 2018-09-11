From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH 0/2] fix sync to flush processor cache for ext4 DAX files
Date: Tue, 11 Sep 2018 09:42:44 -0600
Message-ID: <20180911154246.6844-1-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: jack-AlSwsSmVLrQ@public.gmane.org,
	dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

This patchset fixes an issue that sync syscall to an existing DAX file
does not flush processor cache.

Patch 1/2 adds a check to skip the journal inode. It's a bit awkward,
but I could not find a beter way to get the journal inode.

Patch 2/2 fixes the issue by moving up ext4_set_inode_flags() before
ext4_set_aops() in ext4_iget(). This assumes updated i_flags is harmless
in the error cases after the moved-up ext4_set_inode_flags(). Please
review.

---
Toshi Kani (2):
 1/2 ext4, dax: update dax check to skip journal inode
 2/2 ext4, dax: set ext4_dax_aops for dax files

---
 fs/ext4/ext4_jbd2.h | 8 ++++++++
 fs/ext4/inode.c     | 5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)
