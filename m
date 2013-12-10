From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/9] Use %pd in Ext4
Date: Tue, 10 Dec 2013 10:58:18 -0500
Message-ID: <20131210155818.GA1700@thunk.org>
References: <20131210152612.4916.80435.stgit@warthog.procyon.org.uk>
 <20131210152655.4916.77232.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-fsdevel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131210152655.4916.77232.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 10, 2013 at 03:26:55PM +0000, David Howells wrote:
> Use the new %pd printk() specifier in Ext4 to replace passing of dentry name or
> dentry name and name length * 2 with just passing the dentry.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: "Theodore Ts'o" <tytso@mit.edu>
> cc: Andreas Dilger <adilger.kernel@dilger.ca>
> cc: linux-ext4@vger.kernel.org

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Do you want to have Al take this, or I'm happy to carry this in the
ext4 tree.

						- Ted
