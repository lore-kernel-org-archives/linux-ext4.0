From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Add a norecovery option to ext3/4?
Date: Mon, 9 Apr 2007 02:05:56 +0200
Message-ID: <20070409000556.GA13980@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from iona.labri.fr ([147.210.8.143]:40585 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXDIAF6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Apr 2007 20:05:58 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Distribution installers usually try to probe OSes for building a suited
grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
mode, does perform some operations on the filesystem (log recovery).
This is not a good idea since it may silently garbage data.  XFS has a
norecovery option that allows to disable that, I'd say ext3/4 should
have it too.

Samuel
