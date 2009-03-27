From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: add checks of block references for non-extent
	inodes
Date: Fri, 27 Mar 2009 17:05:01 -0400
Message-ID: <20090327210501.GG6239@mit.edu>
References: <49B94396.2020800@ph.tum.de> <49C3A51C.1030201@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39051 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbZC0VFE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 17:05:04 -0400
Content-Disposition: inline
In-Reply-To: <49C3A51C.1030201@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, I've combined these your two patches ("add checks of block
references for non-extent inodes" and "check block references only
when read from disk") into a single patch and added it to the ext4
patch queue.

						- Ted
