From: Theodore Ts'o <tytso@mit.edu>
Subject: [E2FSPROGS PATCH 4/4] e2image: Use open64() so that "e2image -I" works on image files > 2GB
Date: Thu, 13 Mar 2008 01:12:27 -0400
Message-ID: <1205385147-12855-4-git-send-email-tytso@mit.edu>
References: <1205385147-12855-1-git-send-email-tytso@mit.edu>
 <1205385147-12855-2-git-send-email-tytso@mit.edu>
 <1205385147-12855-3-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: bas@dev.tetra.nl
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38331 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751369AbYCMFMi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 01:12:38 -0400
In-Reply-To: <1205385147-12855-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 4313cc0..e10554e 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -579,8 +579,11 @@ static void install_image(char *device, char *image_fn, int raw_flag)
 		exit(1);
 	}
 
