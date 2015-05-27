From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Incompat change: giving inline data four more bytes?
Date: Tue, 26 May 2015 17:25:43 -0700
Message-ID: <20150527002543.GC830@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4 <linux-ext4@vger.kernel.org>, tm@tao.ma,
	gnehzuil.liu@gmail.com, wenqing.lz@taobao.com,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21845 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbbE0AZ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 May 2015 20:25:57 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

[echoing a conversation on today's concall]

I'm just curious -- is there a reason why the inline data feature stores the
data with an xattr of [EXT4_XATTR_INDEX_SYSTEM, "data"] instead of creating a
new index value to cover "system.data"?  That would allow us to set the namelen
to zero, which fetches us an extra 4 bytes for inline data storage:

struct ext4_xattr_info i = {
	.name_index = EXT4_XATTR_INDEX_SYSTEM,
	.name = EXT4_XATTR_SYSTEM_DATA,
};

becomes

struct ext4_xattr_info i = {
	.name_index = EXT4_XATTR_INDEX_SYSTEM_DATA,
	.name = "",
};

The hard part, of course, is that inline.c is hardcoded to the xattr key that
it uses (instead of using "system.data" and letting the key resolver figure it
out), which makes it harder to switch to the optimized encoding.

On the other hand, since inline data isn't in a released e2fsprogs yet, there
still aren't very many users of it, so if we're going to make the change we
ought to do so now while it's still fairly inexpensive to do so.

The biggest problem of course is retrofitting anyone who's been using this
feature, since old kernels require the larger encoding.  So, who are those
users, and are you willing to trade some breakage for four more bytes?

It shouldn't be that hard to teach the kernel to look for either encoding of
the xattr name.  e2fsprogs uses the full string and lets the xattr code
figure out the encoding.

--D
