From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 66/73] ext2: Split ext2_add_entry() from ext2_add_link() [ver #2]
Date: Sun, 26 Feb 2012 20:30:34 -0700
Message-ID: <B5DCCBD9-F032-44E1-8368-146137487B83@dilger.ca>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk> <20120221180546.25235.50961.stgit@warthog.procyon.org.uk> <20120227000428.GA8044@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"valerie.aurora@gmail.com" <valerie.aurora@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	"linux-ext4@kernel.org" <linux-ext4@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120227000428.GA8044@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2012-02-26, at 17:04, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 21, 2012 at 06:05:46PM +0000, David Howells wrote:
>> From: Valerie Aurora <vaurora@redhat.com>
>> 
>> Allow future code to use the guts of ext2_add_link().
>> 
>> Original-author: Valerie Aurora <vaurora@redhat.com>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: linux-ext4@kernel.org
> 
> I'd suggest folding this in with the following patch (67/73).  It's
> not clear from this patch why renaming ext2_add_link to
> ext2_add_entry() makes sense and then adding a new ext2_add_link()
> which calls ext_add_entry().   It doesn't seem to clarify much....

Also, why is this being done in ext2, when it should only be done in ext4?

Fedora is already using ext4 for ext2- and ext3-formatted filesystems, to allow us to finally deprecate and then delete both of those trees and their ongoing duplicate maintenance.  Adding new features to ext2 doesn't help that goal at all.

Cheers, Andreas