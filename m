From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: Add statx support
Date: Mon, 20 Mar 2017 10:52:29 -0700
Message-ID: <20170320175229.GA26784@infradead.org>
References: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 16, 2017 at 11:35:33AM +0000, David Howells wrote:
> Return enhanced file attributes from the Ext4 filesystem.  This includes
> the following:

Just as the comment to a similar patch from Darrick for XFS:  Please add
test cases that verify this information.

Especially in the light of the races mentioned in the discussion later.

If we can't get tests for statx before 4.11 is getting close to release
I fear we'll have to revert it - untested syscalls have a tendency to
be broken and create problems for the future.
