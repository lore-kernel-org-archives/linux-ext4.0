From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 fallocate related crash on 2.6.26
Date: Fri, 18 Jul 2008 17:30:24 +0530
Message-ID: <20080718120024.GA23898@skywalker>
References: <487C223D.6060704@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <487C223D.6060704@cse.unsw.edu.au>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 15, 2008 at 02:06:21PM +1000, Shehjar Tikoo wrote:
> Hi all
>
> I've observed the following kernel crash during tests against ext4  
> fallocate'ion support on 2.6.26.
>
> Stack trace is at:
> http://www.gelato.unsw.edu.au/~shehjart/docs/ext4_fallocate_test_trace_2.6.26.txt
>
> The test involved running the following program which fallocates a given 
> length in bytes then writes to it. The above crash was seen when writing 
> to an ext4 disk, 2G file, in blocks of 64k with fallocate requests of 
> 1mb. After each 1mb of data is written to the fallocated space, another 
> 1mb is requested. This write-fallocate cycle continues till the requested 
> file size is reached. The trace is from one of the crashes from the 
> various runs(all crashed). I must emphasise that after one of the runs, 
> the test disk could not be mounted as the filesystem was unrecognized. 
> ext4dev was mounted in data=ordered mode.
>
> See the test code at:
> http://www.gelato.unsw.edu.au/~shehjart/docs/writefallocate.c
>
> The command line arguments are self-explanatory. Run without any  
> arguments to see the usage message. Do change the _NR_fallocate define  
> at the beginning of the file to your architecture's syscall number for  
> sys_fallocate.
>
> I can run a few more tests if more info is needed.


Can you try this patch ?

commit 1ebfca565bb06763e14dd468ce84aa55eecb1122
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Jul 18 17:25:18 2008 +0530

    falloc fix
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7bdaeec..9c8541e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2462,7 +2462,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		unsigned int newdepth;
 		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
 		if (allocated <= EXT4_EXT_ZERO_LEN) {
-			/* Mark first half uninitialized.
+			/*
+			 * iblock == ee_block is handled by the zerouout
+			 * at the beginning.
+			 * Mark first half uninitialized.
 			 * Mark second half initialized and zero out the
 			 * initialized extent
 			 */
@@ -2485,7 +2488,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				ex->ee_len   = orig_ex.ee_len;
 				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 				ext4_ext_dirty(handle, inode, path + depth);
-				/* zeroed the full extent */
+				/* blocks available from iblock */
 				return allocated;
 
 			} else if (err)
@@ -2513,6 +2516,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 					err = PTR_ERR(path);
 					return err;
 				}
+				/* get the second half extent details */
 				ex = path[depth].p_ext;
 				err = ext4_ext_get_access(handle, inode,
 								path + depth);
@@ -2542,6 +2546,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zeroed the full extent */
+			/* blocks available from iblock */
 			return allocated;
 
 		} else if (err)
@@ -2557,23 +2562,22 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		 */
 		orig_ex.ee_len = cpu_to_le16(ee_len -
 						ext4_ext_get_actual_len(ex3));
-		if (newdepth != depth) {
-			depth = newdepth;
-			ext4_ext_drop_refs(path);
-			path = ext4_ext_find_extent(inode, iblock, path);
-			if (IS_ERR(path)) {
-				err = PTR_ERR(path);
-				goto out;
-			}
-			eh = path[depth].p_hdr;
-			ex = path[depth].p_ext;
-			if (ex2 != &newex)
-				ex2 = ex;
-
-			err = ext4_ext_get_access(handle, inode, path + depth);
-			if (err)
-				goto out;
+		depth = newdepth;
+		ext4_ext_drop_refs(path);
+		path = ext4_ext_find_extent(inode, iblock, path);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out;
 		}
+		eh = path[depth].p_hdr;
+		ex = path[depth].p_ext;
+		if (ex2 != &newex)
+			ex2 = ex;
+
+		err = ext4_ext_get_access(handle, inode, path + depth);
+		if (err)
+			goto out;
+
 		allocated = max_blocks;
 
 		/* If extent has less than EXT4_EXT_ZERO_LEN and we are trying
@@ -2591,6 +2595,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zero out the first half */
+			/* blocks available from iblock */
 			return allocated;
 		}
 	}

-aneesh
