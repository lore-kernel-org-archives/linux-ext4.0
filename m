From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 0/8] Add tests for zero range into xfstests
Date: Wed,  5 Mar 2014 16:51:31 +0100
Message-ID: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, lczerner@redhat.com, xfs@oss.sgi.com
To: linux-ext4@vger.kernel.org
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

Hi,

this patch set adds two new test for zero range into xfstests - generic/008
and ext4/001. It also adds zero range support for fsstress and fsx.

Thanks!
-Lukas

Changes in v2:
- fsstress print left over flag values
- rework test_fallocate() to work properly

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
