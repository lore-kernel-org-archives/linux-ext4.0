From: Andrew Morton <akpm@linux-foundation.org>
Subject: i_version_2_ext4_specific_code
Date: Thu, 15 Feb 2007 00:22:18 -0800
Message-ID: <20070215002218.56944d89.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39068 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965241AbXBOIWX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 03:22:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


This:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.20-ext4-1/broken-out/i_version_2_ext4_specific_code

has 100% broken whitespace: it uses spaces where there should be hard tabs.

Please let's not merge anything which does that.
