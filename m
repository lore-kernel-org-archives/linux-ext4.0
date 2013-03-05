From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: don't assume that falloc_punch implies falloc
	in test 255
Date: Tue, 5 Mar 2013 13:07:56 -0600
Message-ID: <5136428C.3020604@sgi.com>
References: <1362506382-26974-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1362506382-26974-1-git-send-email-tytso@mit.edu>
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

This patch has been committed.

Thanks
--Rich

commit 864688d368d6781c3f6d60bc55b5e3591953e462
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Mar 5 17:59:42 2013 +0000

     xfstests: don't assume that falloc_punch implies falloc in test 255

     As of Linux 3.9-rc1, ext4 will support the punch operation on file
     systems using indirect blocks, but it can not support the fallocate
     operation (since there is no way to mark a block as uninitialized
     using indirect block scheme).  This caused test 255 to fail, since it
     only used _require_xfS_io_falloc_punch assuming that all file systems
     which supported punch can also support fallocate.  Fix this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
