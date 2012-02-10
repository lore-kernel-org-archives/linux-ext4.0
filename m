From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Generic O_SYNC AIO DIO handling
Date: Fri, 10 Feb 2012 17:03:58 +0100
Message-ID: <1328889842-23231-1-git-send-email-jack@suse.cz>
Cc: cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org


  Hi Jeff,

  these patches implement generic way of handling O_SYNC AIO DIO. They work
for all filesystems except for ext4 and xfs. Thus together with your patches,
all filesystems should handle O_SYNC AIO DIO correctly. I've tested ext3,
btrfs, and xfs (to check that I didn't break anything when the generic code
is unused) and things seem to work fine. Will you add these patches to your
series please? Thanks.

								Honza
