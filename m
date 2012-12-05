From: Theodore Ts'o <tytso@mit.edu>
Subject: RFC: remove CONFIG_EXT4_FS_XATTR
Date: Wed, 05 Dec 2012 17:35:05 -0500
Message-ID: <nsxsj7kw2jq.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37007 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab2LEWfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 17:35:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The number of build warnings that were generated with the inline data
patch makes me think that perhaps we should just remove
CONFIG_EXT4_FS_XATTR.  Turning off CONFIG_EXT4_FS_XATTR causes a net
decrease in the ext4 file system by 27k (about 7.3% if ext4 is built as
a module; the entire compiled kernel's text+data size for my
all-in-one-no-modules-for-kvm-testing is 19 megabytes).

Another advantage of making this change is with the inline data option,
if you turn off CONFIG_EXT4_FS_XATTR, it will still allow a file system
with inline_data to be mounted, but then attempts to read small files or
small directories will end up returning EOPNOTSUPP, which will be
surprising to end users in a very serious way.  (Assuming it works at
all; I haven't tested to make sure it fails cleanly, and I'm not sure
Tao has tested that case either; so easing our test matrix is another
reason why removing this config option would be helpful.)

Does anyone have any objections or other reasons why this would be a bad
idea?

                                                - Ted




