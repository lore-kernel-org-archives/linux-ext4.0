From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] jbd2: reduce the number of writes when commiting a
 transacation
Date: Tue, 24 Apr 2012 15:41:08 -0400
Message-ID: <20120424194108.GI18865@thunk.org>
References: <20120420110627.GA30373@gmail.com>
 <E5D2F131-A01C-4CB2-8A7C-88CACBBC450B@dilger.ca>
 <20120423022505.GA7855@gmail.com>
 <67060CC0-9F64-40ED-9467-572996ECF21F@whamcloud.com>
 <20120423221948.GA6938@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: djwong <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34416 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012Ab2DXTlQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 15:41:16 -0400
Content-Disposition: inline
In-Reply-To: <20120423221948.GA6938@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 23, 2012 at 10:19:48PM +0000, djwong wrote:
> 
> My huge checksum patchset _does_ include checksums for data blocks; see the
> t_checksum field in struct journal_block_tag_s.  iirc the corresponding journal
> replay modifications will skip over corrupt data blocks and keep going.

I need to check for this in the patches (and you may be doing this
already), but in the kernel failed checksums should result in an
ext4_error() call which will set the file system as corrupt and
needing to be checked.  And in e2fsck it should force a full check of
the file system.

					- Ted
