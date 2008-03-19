From: Eric Sandeen <sandeen@redhat.com>
Subject: e2fsprogs/pu has a conflict checked in
Date: Wed, 19 Mar 2008 10:23:28 -0500
Message-ID: <47E12FF0.80906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121AbYCSTnb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob;f=lib/ext2fs/Makefile.in;h=1f5effa42d0f9c69458941bd75cde82940197a2f;hb=pu#l659

doesn't really build well that way ;)

-Eric
