From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest generic/018 and ext4 defrag
Date: Thu, 13 Nov 2014 17:02:28 -0500
Message-ID: <20141113220228.GC28780@thunk.org>
References: <CAH2r5mvAGe-N0e2rOsEe4DBT1tRM0Uv8rNQChmQY+d7dkLxR2w@mail.gmail.com>
 <5465244D.2090708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57437 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbaKMWCb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 17:02:31 -0500
Content-Disposition: inline
In-Reply-To: <5465244D.2090708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2014 at 03:36:13PM -0600, Eric Sandeen wrote:
> 
> I don't honestly know if ext4 has an upper limit on acls.

The limit is based on the blocksize; but this test seems to assume an
absolute count of the number of acl entries, and looking at the xfs
max code, it looks like if we just wired it up to some arbitrary
number, such as "32", it would probably allow ext4 to run the test and
pass it correctly.  I'm not sure it's would test something useful
that's not tested by the other xfstests, though.

						- Ted
