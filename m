From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: New compiler warning in 2.6.34-rc1: 'start_ext.ee_block' may be used
 uninitialized
Date: Mon, 15 Mar 2010 15:42:39 +0100
Message-ID: <4B9E475F.1010302@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36028 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028Ab0COOms (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Mar 2010 10:42:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I saw the following scroll by during kernel compilation:

fs/ext4/move_extent.c: In function 'mext_leaf_block':

fs/ext4/move_extent.c:478: warning: 'start_ext.ee_block' may be used
uninitialized in this function


Is it real?  It seems that the initial start_ext.ee_len = 0 guards
against accidental use of an uninitialized start_ext.ee_block, but maybe
I missed something.

The message is from gcc (Gentoo 4.3.4 p1.0, pie-10.1.5) 4.3.4 here.
-- 
Stefan Richter
-=====-==-=- --== -====
http://arcgraph.de/sr/
