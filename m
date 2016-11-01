From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 05/11] ext4: Use iomap for zeroing blocks in DAX mode
Date: Tue,  1 Nov 2016 22:06:15 +0100
Message-ID: <1478034381-19037-6-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1478034381-19037-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
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

Use iomap infrastructure for zeroing blocks when in DAX mode.
ext4_iomap_begin() handles read requests just fine and that's all that
is needed for iomap_zero_range().

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cc10145ea98b..ac26a390f14c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3844,8 +3844,10 @@ static int ext4_block_zero_page_range(handle_t *handle,
 	if (length > max || length < 0)
 		length = max;
 
-	if (IS_DAX(inode))
-		return dax_zero_page_range(inode, from, length, ext4_get_block);
+	if (IS_DAX(inode)) {
+		return iomap_zero_range(inode, from, length, NULL,
+					&ext4_iomap_ops);
+	}
 	return __ext4_block_zero_page_range(handle, mapping, from, length);
 }
 
-- 
2.6.6
