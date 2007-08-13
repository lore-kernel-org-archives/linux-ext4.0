From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
Date: Mon, 13 Aug 2007 09:14:01 -0700
Message-ID: <1187021641.10249.90.camel@localhost>
References: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com>
	 <20070813090128.GJ6689@schatzie.adilger.int>
	 <20070813151917.GA28130@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, Eric Sandeen <esandeen@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3099 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938075AbXHMQOi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2007 12:14:38 -0400
In-Reply-To: <20070813151917.GA28130@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-08-13 at 11:19 -0400, Theodore Tso wrote:
> Yep, agreed.

OK. saved in my tree as

EXT4 FILE SYSTEM
P:      Ted Ts'o
M:	tytso@mit.edu
P:	Eric Sandeen
M:	sandeen@sgi.com
P:	Mingming Cao
M:	cmm@us.ibm.com
L:	linux-ext4@vger.kernel.org
S:	Maintained
F:	fs/ext4/
F:	include/linux/ext4*

Separate question.  Is it right that the L: entries
for ext2/3/4 are all linux-ext4@vger.kernel.org?
