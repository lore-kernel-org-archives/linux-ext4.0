From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 31 Mar 2014 23:53:31 +0900
Message-ID: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: viro@zeniv.linux.org.uk, david@fromorbit.com, hch@infradead.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, lczerner@redhat.com
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

FALLOC_FL_INSERT_RANGE was mentioned as the opposite command of collapse
range from discussion between Hugh Dickins and Dave Chinner.

In continuation of the work of making the process of non linear editing of
media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
for fallocate.

This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
in between the file within the range specified by offset and len. User can
write new data in this space. e.g. ads.
Like collapse range, currently we have the limitation that offset and len
should be block size aligned for both XFS and Ext4.

The semantics of the flag are :
1) It allocates new zeroed out on disk space of len bytes starting
   at offset byte without overwriting any existing data. All the data blocks
   from offset to EOF are shifted towards right to make space for inserting
   new blocks
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Insert range does not work for the case when offset is overlapping/beyond
   i_size. If the user wants to allocate space at the end of file they are
   advised to use either ftruncate(2) or fallocate(2) with mode 0.
5) It increses the size of file by len bytes.

Namjae Jeon (3):
 fs: Add FALLOC_FL_INSERT_RANGE flags for fallocate
 xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
 TODO : xfsprog: xfsio: Add support FALLOC_FL_INSERT_RANGE for fallocate
 TODO : xfstests: Add insert range testcase

-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
