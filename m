From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: fix 'zero_hugefiles = false' regression
Date: Tue, 9 May 2017 12:36:12 -0400
Message-ID: <20170509163612.32fdm2z5g3jqwkd2@thunk.org>
References: <20170508224757.94528-1-ebiggers3@gmail.com>
 <20170509015636.GC5963@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33476 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753589AbdEIQgQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 May 2017 12:36:16 -0400
Content-Disposition: inline
In-Reply-To: <20170509015636.GC5963@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 08, 2017 at 06:56:36PM -0700, Darrick J. Wong wrote:
> 
> Soooo... I don't know that I like the potential for stale data exposure,
> which predisposes me not to like this patch.

We like causing mke2fs to take 24+ hours per high capacity HDD even less.  :-)

Especially when the only user of the huge file is a trusted storage
server where all data is stored encrypted at rest with multiple layers
of encryption[1], so forcing a zero write pass is really pointless.

[1] https://cloud.google.com/security/encryption-at-rest/default-encryption/

Cheers,

						- Ted
