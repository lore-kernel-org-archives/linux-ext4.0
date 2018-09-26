Return-Path: <SRS0=wjg6=MI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbeI0BUF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Sep 2018 21:20:05 -0400
Subject: [PATCH 1/3] docs: generate a separate ext4 pdf file from the
 documentation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org
Date: Wed, 26 Sep 2018 12:05:37 -0700
Message-ID: <153798873785.29896.10931653144919511571.stgit@magnolia>
In-Reply-To: <153798873160.29896.3647029167086263735.stgit@magnolia>
References: <153798873160.29896.3647029167086263735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

The documentation build scripts won't build a pdf for the ext4
documentation unless explicitly called for, so ask for a separate
ext4.pdf to be generated with all the documentation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/conf.py |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/Documentation/conf.py b/Documentation/conf.py
index b691af4831fa..05dad6bda787 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -383,6 +383,8 @@ latex_documents = [
      'The kernel development community', 'manual'),
     ('filesystems/index', 'filesystems.tex', 'Linux Filesystems API',
      'The kernel development community', 'manual'),
+    ('filesystems/ext4/index', 'ext4.tex', 'ext4 Filesystem',
+     'ext4 Filesystem Developers', 'manual'),
     ('gpu/index', 'gpu.tex', 'Linux GPU Driver Developer\'s Guide',
      'The kernel development community', 'manual'),
     ('input/index', 'linux-input.tex', 'The Linux input driver subsystem',
