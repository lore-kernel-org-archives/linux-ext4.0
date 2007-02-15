From: Andrew Morton <akpm@linux-foundation.org>
Subject: i_version_1_vfs_layer
Date: Thu, 15 Feb 2007 00:26:56 -0800
Message-ID: <20070215002656.a163dee9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jean Noel Cordenner <jean-noel.cordenner@bull.net>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39177 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965234AbXBOI1C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 03:27:02 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.20-ext4-1/broken-out/i_version_1_vfs_layer

significantly deoptimises file_update_time() for major filesystems (eg, ext3).

The changelog offers no reason for this alteration.  In fact the changelog
basically says nothing at all and needs a lot of work.

What is this patch doing and why does it need to make that change?
