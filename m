From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v2 08/20] ext4 crypto: add encryption key management
 facilities
Date: Wed, 27 May 2015 14:37:24 -0400
Message-ID: <20150527183724.GA18540@thunk.org>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu>
 <1428894996-7852-9-git-send-email-tytso@mit.edu>
 <87382im95e.fsf@openvz.org>
 <20150527170606.GA31840@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com, Ildar Muslukhov <muslukhovi@gmail.com>
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60928 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbbE0Sh1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 14:37:27 -0400
Content-Disposition: inline
In-Reply-To: <20150527170606.GA31840@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2015 at 01:06:06PM -0400, Theodore Ts'o wrote:
> 
> That's not true.  If the attacker finds the encryption key for an
> inode, and they have the nonce which is stored in file's extended
> attribute, what the attacker has is a single plaintext/ciphertext
> pair.  That doesn't imply that they can get the master key; they would
> still need to do a brute force search on the keyspace try to find the
> master key.

So an update, after conferring with Michael Halcrow, who set me
straight.  I was wrong, because I mixed up which was the deriving key
and which was the source key.  You're correct; if an attacker could
get ahold of the per-file key, they could use the nonce to decrypt it
and obtain the master key.

However, there are only two ways to determine the per-file key.  The
first is a ring 0 compromise, in which case it's likely they could get
access to the master key, and the second is if there is a practical
known-plaintext attack on AES, and the attacker has access to the
block device --- and possibly a chosen-plaintext attack if the
attacker can control what data is written to the file.  But either
way, if there is such a crypto-analytic attack on AES, then this is
going to be least of the whole world's problems.  :-)

There are alternatives, such as either using the master to encrypt the
nonce and none+1: (AES-256-ENCRYPT(nonce) || AES-256-ENCRYPT
(nonce+1)).  But this will be 40% slower than what we are currently
doing, which is to use AES-256 to encrypt the master key.

Or we could use an HMAC, which would be even slower yet, especially
since many chips have AES acceleration, but few have SHA hardware
acceleration.

So ultimately, the question is whether we want to make a change (with
all of the versioning work we would need for backwards compatibility)
that decreases performance, which will be especially noticeable for
small files, to protect against a partial Ring 0 compromise when other
Ring 0 compromise would make us be toast anyway.

						- Ted
