From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Corrupt ext4 fs after creation
Date: Wed, 15 Mar 2017 01:11:30 -0400
Message-ID: <20170315051130.fy7j3o24z5pmbyll@thunk.org>
References: <153de314-38ff-ad68-65d9-a292213b47f6@phytec.de>
 <532e8151-ecc8-6411-9471-b7a74b4e0ab9@phytec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Teresa Remmet <t.remmet@phytec.de>
To: Daniel Schultz <d.schultz@phytec.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60886 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750965AbdCOFLe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Mar 2017 01:11:34 -0400
Content-Disposition: inline
In-Reply-To: <532e8151-ecc8-6411-9471-b7a74b4e0ab9@phytec.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 14, 2017 at 11:34:32AM +0100, Daniel Schultz wrote:
> 
> I figured out that when I run fsck.ext4 it will perform a directory
> optimizing which leads to a non-zero error code of 1 (File system errors
> corrected). Also, I figured out that this optimizing only occurres on the
> first boot and not after creating a lot of new files and dirs. After
> checking the fs it contains more blocks than before.

So the error code was one because the file system was modified.  It's
true that the formal definition of error code of one is "file system
errors corrected", and so this will be changed in the next release of
e2fsprogs:

commit bf9f3b6d5b10d19218b4ed904c12b22e36ec57dd
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Feb 16 22:02:35 2017 -0500

    e2fsck: exit with exit status 0 if no errors were fixed

    Previously, e2fsck would exit with a status code of 1 even though the
    only changes that it made to the file system were various
    optimziations and not fixing file system corruption.  Since the man
    page states that an exit status of 1 means "file system errors
    corrupted", fix e2fsck to return an exit status of 0.

    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Cheers,

					- Ted
