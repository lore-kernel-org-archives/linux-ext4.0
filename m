From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 0/6][v2] ext{2,3,4}: tighten inheritance and setting of inode flags
Date: Wed, 11 Jun 2008 01:04:03 +0100
Message-ID: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758834AbYFKAEn@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch series prevents inheritance and setting of various flags,
as appropriate for specific inode types. Flags which should be inherited
are listed explicitly so as to prevent future flags being overlooked and
inherited by accident. It introduces a function to mask flags based on
the inode type and uses it in inode creation and the SETFLAGS ioctl to
facilitate future consistency.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

This version introduces the restrictions on setting flags for
inappropriate inodes and lists inheritable flags explicitly.

Cheers,
Duane.
