From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/25] freefrag: fix up getopt case statement
Date: Fri, 16 Sep 2011 15:49:25 -0500
Message-ID: <1316206180-6375-11-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46743 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no need to print out a "bad option" message; getopt
does that for us, and in fact will change "c" to "?" so
it's not even useful.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/e2freefrag.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index e6fd67e..419c6fc 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -282,10 +282,8 @@ int main(int argc, char *argv[])
 			}
 			chunk_info.chunkbytes *= 1024;
 			break;
-		default:
-			fprintf(stderr, "%s: bad option '%c'\n",
-				progname, c);
 		case 'h':
+		default:
 			usage(progname);
 			break;
 		}
-- 
1.7.4.1

