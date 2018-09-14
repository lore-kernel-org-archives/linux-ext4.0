From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH v2 0/3] fix sync to flush processor cache for ext2/4 DAX files
Date: Fri, 14 Sep 2018 08:51:11 -0600
Message-ID: <20180914145114.11122-1-toshi.kani@hpe.com>
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

This patchset fixes issues that sync syscall to existing DAX ex2/4
files does not flush processor cache.

Patch 1/3 adds .bmap to ext4_dax_aops so that mount -o dax works for
the journal inode.

Patch 2/3 fixes the ext4 issue by setting i_flags before ext4_set_aops()
in ext4_iget().

Patch 3/3 fixes the ext2 issue by setting i_flags before ext2_set_aops()
in ext2_iget(), i.e. same as ext4.

v2:
 - Add .bmap to ext4_dax_aops, instead of disabling dax for the journal
   inode. (Jan Kara)
 - Initialize i_flags early in ext4_iget(). (Jan Kara)
 - Update Fixes tag and add Cc to Stable. (Dan Williams)
 - Add fix to ext2.

---
Toshi Kani (3):
 1/3 ext4, dax: add ext4_bmap to ext4_dax_aops
 2/3 ext4, dax: set ext4_dax_aops for dax files
 3/3 ext2, dax: set ext2_dax_aops for dax files

---
 fs/ext2/inode.c | 2 +-
 fs/ext4/inode.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)
