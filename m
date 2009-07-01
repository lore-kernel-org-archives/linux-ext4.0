From: Andreas Dilger <adilger@sun.com>
Subject: Re: Plans to evaluate the reliability and integrity of ext4	against
 power failures.
Date: Thu, 02 Jul 2009 01:37:55 +0200
Message-ID: <20090701233721.GL3248@webber.adilger.int>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	fs-team@google.com
To: Shaozhi Ye <yeshao@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 30, 2009  16:27 -0700, Shaozhi Ye wrote:
> We are planing to evaluate the reliability and integrity of ext4
> against power failures and will post the results when its done.
> Please find attached design document and let me know if you have any
> suggestions for features to test or existing benchmark tools which
> serve our purpose.

What might be interesting is to enhance fsx to work on multiple nodes.
It would need an additional "sync" operation that would flush the
cache to disk, so that there is a limited amount of rollback after a
server reset.

The client would log locally the file operations that are being done
on the server and after the server is restarted the client would verify
that the data in the file is consistent at least up to the most recent
sync.


Another very interesting filesystem test is "racer.sh" (a cleaned up
version is in the Lustre test set), which does random filesystem
operations (create, write, rename, link, unlink, symlink, mkdir, rmdir).
Currently the operations are completely random, but if there was a client
logging the operations it should be possible to track the state on the
client.  What would be necessary is for the server to export the current
transaction id (tid) and then the client records this with every operation.
At server recovery time the last committed tid is in the journal superblock
and the client can then verify that its record of the filesystem state
matches the actual state (after journal rollback).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

