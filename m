Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379EA3F1079;
	Fri,  9 Oct 2026 21:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582736; cv=none; b=Vc/yfOceoDGtcCy3j+xdXAx+EmYn1JREB5/jYhCEuky1swwW+Qd0ygsHhgfI0+EK7O06qO3vOSzS9k/jEksXAkm1KGYLxwC01otWnX6NwM6BfgG8lsOYR3fH1GHKfNeZbntphc2lbYLdgFu5WR1hHiF5h8TyXm+FUqiNaT5jS8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582736; c=relaxed/simple;
	bh=LXsL1y/j+e7UUH5xH4UKs5usCG1uCNqZTFzWMmxwdro=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T1ygxKDVFsb8+Cmy/ggGpWi28niZjPgutDFr4rSR38HOcAiqCGITwRQeSAtbnKe0FB4AsXi33A5PXFQw/RRWL+5haLh4WfmzRmNUMsiKYyFX5Frv27G5p8XaId6V7ieBg2732dDNCcGhskFLjRhmo9YBfE8XuB47LIFu1HhQEIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAHaLuVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAHaLuVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A9A1F000FF;
	Fri,  9 Oct 2026 21:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582734;
	bh=BunSUlMmKQVuWdN5L9PoEJ5F0NzruEHwxHZ6NbALJpc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bAHaLuVFp4JmN9S7f9njuTYmSS6aYjqMUXbYKRyQNJ1NEDTfGrsxD7KlHevn+jH1E
	 cgaKLdZofUb/LyohOV6YIMiSjvpIbl4g9NpgsOUsTw4JainD121I2pbyiKXeaxEyuv
	 j4BRw95R/GSp5phafjtZ174GCBprix+O/MuUe32nrRMq3DwvbUVWKxVTnwgCv+pfEW
	 x6rVAiOqM8HA3eOl62/DX7AErGex0yZaIhtDql96RPQXZ6jgW4wOzQWuhTcw9DKlgJ
	 rWpwt0I1Xbmoq9dXaiFKMj+xowhUMnK7Tbb7nFRz/7UIfjuMYJKrkywcl0cX9ReR1R
	 cvehzqrkMiRzg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:55 +0200
Subject: [PATCH 5/8] ipc: drop the mqueue mount with kern_unmount() on
 setup failure
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-5-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3268; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LXsL1y/j+e7UUH5xH4UKs5usCG1uCNqZTFzWMmxwdro=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPwTWGqwgj1m0XrXfZvNT5mu+CI+9eOJzdsjObi+H
 1i1wN5veUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEtjxl+B+fsN6jpHHN3Nf7
 HatvruIP3T5NmCVSZd2vlT3Hu4WfnbjMyPD4+Mm5KX1n/2XWuOv/m3BkZo3b6Wono61ed1QTZcX
 OzuADAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

mq_init_ns() creates the mqueue mount with fc_mount_longterm(), so its
->mnt_ns is MNT_NS_INTERNAL. When setting up the mqueue or ipc sysctls
or msg_init_ns() fails afterwards, create_ipc_ns() drops it with a plain
mntput(). With ->mnt_ns set that takes the fast path of
mntput_no_expire(). The count drops to zero and nothing ever kills the
mount, so the mount and the mqueue superblock are leaked.

Commit dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
added the first failure path after mq_init_ns() and never dropped the
mount. Commit 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on
sysctl setup failure") tried to fix that with a mntput() but that
doesn't help for a long-term mount.

Use kern_unmount(). free_ipc() open-codes the same thing for a namespace
that made it.

Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Fixes: 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Reproducer: repro.c fails each slab allocation of unshare(CLONE_NEWIPC)
in turn with fail-nth, a hundred rounds. It needs CONFIG_FAILSLAB and
CONFIG_FAULT_INJECTION_DEBUG_FS and runs as root.

    echo N > /sys/kernel/debug/failslab/ignore-gfp-wait
    echo 0 > /sys/kernel/debug/failslab/verbose
    echo 2 > /proc/sys/vm/drop_caches; cat /proc/sys/fs/inode-nr
    ./repro 100
    sleep 2
    echo 2 > /proc/sys/vm/drop_caches; cat /proc/sys/fs/inode-nr

Every failure in setup_mq_sysctls() and setup_ipc_sysctls() leaves an
mqueue superblock behind with its root inode, about seven per round.
Without this patch inode-nr goes from 967 to 1678, with it it stays at
967.

repro.c:

    #define _GNU_SOURCE
    #include <fcntl.h>
    #include <sched.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/wait.h>
    #include <unistd.h>

    /*
     * Fail the nth slab allocation of unshare(CLONE_NEWIPC). Returns 1 once
     * nth is past the last one: nothing was injected and unshare() worked.
     */
    static int last(int nth)
    {
    	int status;

    	if (!fork()) {
    		char buf[16] = "";
    		int fd, ret;

    		fd = open("/proc/thread-self/fail-nth", O_RDWR);
    		snprintf(buf, sizeof(buf), "%d", nth);
    		write(fd, buf, strlen(buf));
    		ret = unshare(CLONE_NEWIPC);
    		pread(fd, buf, sizeof(buf) - 1, 0);
    		_exit(!ret && atoi(buf));
    	}
    	wait(&status);
    	return WEXITSTATUS(status);
    }

    int main(int argc, char *argv[])
    {
    	for (int i = 0; i < atoi(argv[1]); i++)
    		for (int nth = 1; !last(nth); nth++)
    			;
    	return 0;
    }
---
 ipc/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 1e71353bdb4a..75aa7b469348 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -96,7 +96,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 fail_mq_sysctls:
 	retire_mq_sysctls(ns);
 fail_mq_mount:
-	mntput(ns->mq_mnt);
+	kern_unmount(ns->mq_mnt);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_common_free(ns);

-- 
2.53.0

