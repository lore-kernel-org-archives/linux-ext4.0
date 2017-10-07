From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] ext4: Fix bool initialization/comparison
Date: Sat, 07 Oct 2017 16:02:21 +0200
Message-ID: <1507383097084-1659541848-8-diffsplit-thomas@m3y3r.de>
References: <1507383097081-778026979-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507383097081-778026979-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bool initializations should use true and false. Bool tests don't need
comparisons.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/ext4/extents.c b/fs/ext4/extents.c
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5242,7 +5242,7 @@ ext4_ext_shift_path_extents(struct ext4_
 {
 	int depth, err = 0;
 	struct ext4_extent *ex_start, *ex_last;
-	bool update = 0;
+	bool update = false;
 	depth = path->p_depth;
 
 	while (depth >= 0) {
@@ -5258,7 +5258,7 @@ ext4_ext_shift_path_extents(struct ext4_
 				goto out;
 
 			if (ex_start == EXT_FIRST_EXTENT(path[depth].p_hdr))
-				update = 1;
+				update = true;
 
 			while (ex_start <= ex_last) {
 				if (SHIFT == SHIFT_LEFT) {
