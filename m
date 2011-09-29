From: Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 1/2] ext4: MMP: kmmpd should use nodename from init_uts_ns.name, not sysname
Date: Fri, 30 Sep 2011 00:38:19 +0100
Message-ID: <1317339500-4341-2-git-send-email-nikitas_angelinas@xyratex.com>
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com>
 <1317339500-4341-1-git-send-email-nikitas_angelinas@xyratex.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	nikitas_angelinas@xyratex.com, andrew_perepechko@xyratex.com,
	nikitasangelinas@gmail.com
To: tytso@mit.edu, adilger.kernel@dilger.ca, adilger@whamcloud.com,
	johann@whamcloud.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317339500-4341-1-git-send-email-nikitas_angelinas@xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sysname holds "Linux" by default, i.e. what appears when doing a "uname
-s"; nodename should be used to print the machine's hostname, i.e. what
is returned when doing a "uname -n" or "hostname", and what
gethostname(2)/sethostname(2) manipulate, in order to notify the
administrator of the node which is contending to mount the filesystem.

Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
Acked-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/mmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 9bdef3f..2fca64e 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -109,7 +109,7 @@ static int kmmpd(void *data)
 	mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
 	bdevname(bh->b_bdev, mmp->mmp_bdevname);
 
-	memcpy(mmp->mmp_nodename, init_utsname()->sysname,
+	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
 	       sizeof(mmp->mmp_nodename));
 
 	while (!kthread_should_stop()) {
-- 
1.7.4.4
