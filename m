From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: SEEK_DATA/HOLE on ocfs2 - v2
Date: Wed, 18 May 2011 19:44:42 -0700
Message-ID: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk,
        o
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org


Two patches follow this message. One fixes the default implementation
of SEEK_HOLE/DATA. This patch applies atop Josef's last posted patch.
The second patch implements the same on ocfs2.

The test tool for the same is available here.
http://oss.oracle.com/~smushran/seek_data/seek_test.c

It is improved since the last post. It runs cleanly on zfs, ocfs2 and ext3
(default behavior). Users testing on zfs will need to flip the values of
SEEK_HOLE/DATA.

The results on ext4 and btrfs are also available here.
http://oss.oracle.com/~smushran/seek_data/

Thanks
Sunil
