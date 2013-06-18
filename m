From: Tomas Racek <tracek@redhat.com>
Subject: Re: [PATCH v4 20/20] ext4: Allow punch hole with bigalloc enabled
Date: Tue, 18 Jun 2013 08:34:32 -0400 (EDT)
Message-ID: <673012831.10321487.1371558872146.JavaMail.root@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com> <1368549454-8930-21-git-send-email-lczerner@redhat.com> <20130531151454.GB19561@thunk.org> <alpine.LFD.2.00.1306111436290.14711@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1306111436290.14711@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

----- Original Message -----
> On Fri, 31 May 2013, Theodore Ts'o wrote:
> 
> > Date: Fri, 31 May 2013 11:14:54 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
> >     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
> >     akpm@linux-foundation.org, hughd@google.com
> > Subject: Re: [PATCH v4 20/20] ext4: Allow punch hole with bigalloc enabled
> > 
> > On Tue, May 14, 2013 at 06:37:34PM +0200, Lukas Czerner wrote:
> > > In commits 5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85 and
> > > 30bc2ec9598a1b156ad75217f2e7d4560efdeeab we've reworked punch_hole
> > > implementation and there is noting holding us back from using punch hole
> > > on file system with bigalloc feature enabled.
> > > 
> > > This has been tested with fsx and xfstests.
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > This patch is causing a test failure with bigalloc enabled with the
> > xfstests shared/298.
> > 
> > Since it's at the end of the invalidate page range tests, I'm going to
> > drop this patch for now.  Could you take a look at this?
> > 
> > Thanks!!
> > 
> > 					- Ted
> 
> Hi Ted,
> 
> I should have really noticed this earlier. This test (shared/298)
> have nothing to do with bigalloc, nor punch hole. It tests file
> system discard implementation.
> 
> The most likely reason it failed for you is that the tests does not
> count with bigalloc feature. However it seems to be working for me
> without any problems. Can you provide more information about the
> problem you've seen, or at least your xfstest configuration so we
> can see what went wrong and possibly fix the test ?

You are right, the test doesn't count with bigalloc. I was able to trigger the test failure by using MKFS_OPTIONS="-O bigalloc -C 8192"

If I understood it correctly, the dumpe2fs outputs free blocks even if bigalloc is used, that is only the first block of the cluster. I changed the test to count with whole cluster. Please try the following patch to the xfstests if it helps you. I tried different cluster sizes from 8192 to 65536 and it works for me.

Thank you!
Tom

http://www.fi.muni.cz/~xracek/0001-xfstests-298-fix-failure-on-ext4-with-bigalloc.patch



>From ccf4cb26505c3e64ef1bfb1264a17ed840a03a81 Mon Sep 17 00:00:00 2001
From: Tomas Racek <tracek@redhat.com>
Date: Tue, 18 Jun 2013 13:45:50 +0200
Subject: [PATCH] xfstests: 298: fix failure on ext4 with bigalloc

Count with cluster size instead of block size if bigalloc is used.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 tests/shared/298 | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tests/shared/298 b/tests/shared/298
index 4541798..78a229d 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -56,14 +56,21 @@ get_free_sectors()
 {
 	case $FSTYP in
 	ext4)
+	cluster_size=$($DUMPE2FS_PROG $img_file 2>&1 | sed -n 's/Cluster size: *\(.*\)/\1/p')
+	if [ -n "$cluster_size" ]; then
+		blocks_per_cluster=`expr $cluster_size / $block_size`
+	else
+		blocks_per_cluster=1
+	fi
+
 	$DUMPE2FS_PROG $img_file  2>&1 | grep " Free blocks" | cut -d ":" -f2- | \
 		tr ',' '\n' | $SED_PROG 's/^ //' | \
-		$AWK_PROG -v spb=$sectors_per_block 'BEGIN{FS="-"};
+		$AWK_PROG -v spb=$sectors_per_block -v bpc=$blocks_per_cluster 'BEGIN{FS="-"};
 		     NF {
 			if($2 != "") # range of blocks
-				print spb * $1, spb * ($2 + 1) - 1;
+				print spb * $1, spb * ($2 + bpc) - 1;
 			else		# just single block
-				print spb * $1, spb * ($1 + 1) - 1;
+				print spb * $1, spb * ($1 + bpc) - 1;
 		     }'
 	;;
 	xfs)
-- 
1.7.11.7


> 
> Tom can you take a look at this ? (Adding Tomas Racek to the CC)
> 
> So, since this failure is not really related to the patch itself,
> can we re-include the patch (it might be already too late I guess).
> 
> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
