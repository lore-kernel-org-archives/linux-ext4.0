From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 00/17] fs: introduce new writeback error reporting
 and convert ext2 and ext4 to use it
Date: Wed, 31 May 2017 13:27:28 -0700
Message-ID: <20170531132728.2e60bd607bd4174739b6b661@linux-foundation.org>
References: <20170531124540.8782-1-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 31 May 2017 08:45:23 -0400 Jeff Layton <jlayton@redhat.com> wrote:

> This is v5 of the patchset to improve how we're tracking and reporting
> errors that occur during pagecache writeback.

I'm curious to know how you've been testing this?  Is that testing
strong enough for us to be confident that all nature of I/O errors
will be reported to userspace?

