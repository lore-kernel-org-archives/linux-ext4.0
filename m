From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest generic/018 and ext4 defrag
Date: Thu, 13 Nov 2014 16:58:12 -0500
Message-ID: <20141113215811.GB28780@thunk.org>
References: <CAH2r5mvAGe-N0e2rOsEe4DBT1tRM0Uv8rNQChmQY+d7dkLxR2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57418 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934261AbaKMV6O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 16:58:14 -0500
Content-Disposition: inline
In-Reply-To: <CAH2r5mvAGe-N0e2rOsEe4DBT1tRM0Uv8rNQChmQY+d7dkLxR2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2014 at 03:16:30PM -0600, Steve French wrote:
> 
> Is generic xfstest 18 still broken on ext4?

Yes; the e4defrag program has different criteria for decided when to
defrag a file.  I believe this should be fixed by commit c7c539e8fd86d
in e2fsprogs, but that's not yet in a released version yet.

> Also am curious about test generic/026
> 
> generic/026  [not run] ext4 does not define maximum ACL count
> 
> Is that expected?

Yes; the test currently is only wired up for jfs and xfs.  (See
xfstests/common/attr:_acl_get_max).

						- Ted
