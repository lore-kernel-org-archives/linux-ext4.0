From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Wed, 3 Apr 2013 18:22:04 +0800
Message-ID: <20130403102204.GA15383@gmail.com>
References: <1211053180.322948.1364797847717.JavaMail.root@redhat.com>
 <87fvzaspr8.fsf@openvz.org>
 <874841142.414482.1364875584266.JavaMail.root@redhat.com>
 <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
 <877gkls1q7.fsf@openvz.org>
 <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org>
 <87r4isd1vn.fsf@openvz.org>
 <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org>
 <87li90q9mx.fsf@openvz.org>
 <87hajoq6s2.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>,
	CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87hajoq6s2.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 03, 2013 at 01:53:49PM +0400, Dmitry Monakhov wrote:
> On Wed, 03 Apr 2013 12:52:06 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Non-text part: multipart/mixed
> > On Tue, 2 Apr 2013 16:22:41 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> > > On Wed, 3 Apr 2013 at 02:05, Dmitry Monakhov wrote:
> > > > Please drop that patch and collect logs with a kernel which 
> > > > has only 0001-enable-ES_AGGRESSIVE_TEST-V2.patch patch applied
> > Ok I have found at least one issue.
> Yeah.. My college advise me to use sparse in order to spot all
> cpu_to_ondisk format conversion
> make C=2 CF="-D__CHECK_ENDIAN__" fs/ext4/ 
> And it spotted a huge amount of issues. Which tell us that we are deeply
> in shit.

Yes, My college also suggest me that we should use sparse to check this
problem.  I think the following patch could fix this bug.

Regards,
                                                - Zheng

Subject: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out

From: Zheng Liu <wenqing.lz@taobao.com>

When an extent was zeroed out, we forgot to do convert from cpu to le16.
It could make us hit a BUG_ON when we try to write dirty pages out.  So
fix it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e4a6844..2352467 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2999,20 +2999,23 @@ static int ext4_split_extent_at(handle_t *handle,
 			if (split_flag & EXT4_EXT_DATA_VALID1) {
 				err = ext4_ext_zeroout(inode, ex2);
 				zero_ex.ee_block = ex2->ee_block;
-				zero_ex.ee_len = ext4_ext_get_actual_len(ex2);
+				zero_ex.ee_len = cpu_to_le16(
+						ext4_ext_get_actual_len(ex2));
 				ext4_ext_store_pblock(&zero_ex,
 						      ext4_ext_pblock(ex2));
 			} else {
 				err = ext4_ext_zeroout(inode, ex);
 				zero_ex.ee_block = ex->ee_block;
-				zero_ex.ee_len = ext4_ext_get_actual_len(ex);
+				zero_ex.ee_len = cpu_to_le16(
+						ext4_ext_get_actual_len(ex));
 				ext4_ext_store_pblock(&zero_ex,
 						      ext4_ext_pblock(ex));
 			}
 		} else {
 			err = ext4_ext_zeroout(inode, &orig_ex);
 			zero_ex.ee_block = orig_ex.ee_block;
-			zero_ex.ee_len = ext4_ext_get_actual_len(&orig_ex);
+			zero_ex.ee_len = cpu_to_le16(
+						ext4_ext_get_actual_len(&orig_ex));
 			ext4_ext_store_pblock(&zero_ex,
 					      ext4_ext_pblock(&orig_ex));
 		}
@@ -3272,7 +3275,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		if (err)
 			goto out;
 		zero_ex.ee_block = ex->ee_block;
-		zero_ex.ee_len = ext4_ext_get_actual_len(ex);
+		zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex));
 		ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex));
 
 		err = ext4_ext_get_access(handle, inode, path + depth);
-- 
1.7.12.rc2.18.g61b472e
