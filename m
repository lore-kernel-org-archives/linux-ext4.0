From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/25] uuidd: Add missing break to option case statement
Date: Fri, 16 Sep 2011 15:49:24 -0500
Message-ID: <1316206180-6375-10-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46742 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Specifying the "-n" option to uuidd would incorrectly
fall through to the "-p" case, and assign that number to
the pidfile_path.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/uuidd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/misc/uuidd.c b/misc/uuidd.c
index 89bff72..912773a 100644
--- a/misc/uuidd.c
+++ b/misc/uuidd.c
@@ -472,6 +472,7 @@ int main(int argc, char **argv)
 				fprintf(stderr, _("Bad number: %s\n"), optarg);
 				exit(1);
 			}
+			break;
 		case 'p':
 			pidfile_path = optarg;
 			drop_privs = 1;
-- 
1.7.4.1

