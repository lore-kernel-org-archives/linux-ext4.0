From: Andrew Morton <akpm@google.com>
Subject: i_version_3_ext4_user_interface.patch
Date: Thu, 15 Feb 2007 04:00:21 -0800
Message-ID: <20070215040021.63bde922.akpm@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jean Noel Cordenner <jean-noel.cordenner@bull.net>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:14311 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965702AbXBOMAi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Feb 2007 07:00:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


ia64 allmodconfig gives:

fs/stat.c: In function `cp_new_stat':
fs/stat.c:234: error: structure has no member named `st_i_version'

I'll drop the ext4 tree.
