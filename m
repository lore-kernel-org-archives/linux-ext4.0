From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: How to add new fields into inode?
Date: Wed, 25 Feb 2015 14:02:13 +0300
Message-ID: <54EDABB5.5020806@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:43288 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbbBYLCQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2015 06:02:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently I'm working on (yet another attempt of) project id and quota
for ext4. Obviously I want to add new u32 field into inode for holding
it's project id.

As I see policy for that isn't well defined:

Kernel tries to allocate extra space according to sizeof(struct
ext4_inode). If EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE is set then it takes
maximum of sizeof, s_want_extra_isize and s_min_extra_isize.

Libext2fs always allocates space for it's own structure and in some
cases checks s_want_extra_isize but without checking related feature.

Thus in some cases default extra size of inodes doesn't depend on
present features and changes if we add new fields into structure.
For example expected output of some unit tests depends on that value.

Question is: it's ok to waste some bytes for unused fields at the of
inode or default extra size should depend on actually enabled features?

-- 
Konstantin
