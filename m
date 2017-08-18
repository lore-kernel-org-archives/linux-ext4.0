From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Y2038 bug in ext4 recently_deleted() function
Date: Fri, 18 Aug 2017 09:41:29 -0400
Message-ID: <20170818134129.ubollrjtjenlfrqd@thunk.org>
References: <20170808050517.7160-1-wshilong@ddn.com>
 <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz>
 <20170817092153.GA14074@quack2.suse.cz>
 <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca>
 <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Arnd Bergmann <arnd@arndb.de>,
        Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58370 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752545AbdHRNlf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 18 Aug 2017 09:41:35 -0400
Content-Disposition: inline
In-Reply-To: <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 17, 2017 at 06:23:26PM -0700, Deepa Dinamani wrote:
> 
> I don't think dtime has widened on the disk layout for ext4 according
> to https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout. So I am
> not sure how fixing the internal implementation would be useful until
> we do that. Is there a plan for that?

The dtime field is not visible to user; it's mostly for debugging
purposes.  For debugfs we just are just using i_ctime_extra to compose
the time.  (Perhaps we should be using i_mtime_extra, or the max of
the ctime, mtime, and atime extra fields; but it's not really that
important.)

The issue which Andreas pointed out is the only place where we
actually use the dtime field, and that's so we can avoid re-using a
freshly deleted inode until at least N seconds have gone by in
no-journal node.  That's because if we don't, there are some
unfortunate effects that can take place if we crash and not all of the
metadata gets updated.  Even after running e2fsck -fy, we can end up
having a directory or an immutable file show up where ntp or timed
expects to find a time adjustment file, or some such, that can cause
various system daemons to crash and burn because they aren't expecting
find a file at a particular pathname they own which they can't delete.

There are a number ways we could solve it; one is to just use a new
in-memory variable which can be 64-bits wide.  This burns an extra 8
bytes for each inode in the inode cache, which is why we didn't do
that.

It doesn't really have to be super exact; if we actually have an inode
that avoids getting reused for 136 years (2**32 seconds), it will have
disappeared from the in-memory inode cache.  We just need something
which is valid for N seconds after the deletion time.  (I think we may
have upped N to a larger value on our data center kernels --- 300
seconds if I recall correctly --- because there were some edge cases
where 35 seconds wasn't enough.)

						- Ted
