From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v2 08/20] ext4 crypto: add encryption key management
 facilities
Date: Fri, 29 May 2015 16:03:50 -0400
Message-ID: <20150529200350.GG18540@thunk.org>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu>
 <1428894996-7852-9-git-send-email-tytso@mit.edu>
 <87382im95e.fsf@openvz.org>
 <20150527170606.GA31840@thunk.org>
 <20150527183724.GA18540@thunk.org>
 <87wpzrmfp6.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com, Ildar Muslukhov <muslukhovi@gmail.com>
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37463 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbbE2UDw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 May 2015 16:03:52 -0400
Content-Disposition: inline
In-Reply-To: <87wpzrmfp6.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 29, 2015 at 08:55:17PM +0300, Dmitry Monakhov wrote:

> This gives me as an attacker very good guess that
> l51q60ZbBvtGnUl8a3y3yA == grep and so on, So I have can try brute force
> attack on first block (But AFAIU it is not practical for AES-256)
> May be we can prevent this my tweak inode size if key is not
> available. For example allign i_size to fsblock which makes distro-based
> attack impractical. See patch attached.

It's not practical for AES-128, let alone AES-256:

     If you assume:
        * Every person on the planet owns 10 computers.
        * There are 7 billion people on the planet.
        * Each of these computers can test 1 billion key combinations per second.
        * On average, you can crack the key after testing 50% of the possibilities.

     Then the earth's population can crack one AES-128 encryption key in
     77,000,000,000,000,000,000,000,000 years![1]

AES-256 is 10^19 times harder.  So take the
77,000,000,000,000,000,000,000,000 years and add another 19 zero's.
:-)

The bottom line is trying to deny the attacker plaintext/ciphertext
pairs really isn't worth the effort.  It's assumed the attacker can do
this, and it really doesn't bother me.  After all, the the per-inode
key is a completely random 256 bit key.

The much more concerning attack is one where the attacker tries to
attack the user's passphrase by trying brute force the user's
password.  We're using a pbkdf2_sha512 with an iteration count of
65535, to try and slow down the brute force attack, but if the user is
using the typically horrendous user-chosen password, it's still going
to be the weakest link.

So the attacker will simply use a password link, try all lower-case
passwords, all lower case passwords with a single digit, etc., etc.,
turn that into a master key, try to use the master key and the nonce
to create the per-inode key, and then see if the resulting file or
filename looks plausible.  The fact that it will take 65535 iterations
of SHA-512 per passphrase tried will slow the attacker down somewhat,
but if the user uses a birthday, or their girlfriend's name, etc.,
it's not going to help enough.

> At least it would be reasonable to provide this as an mkfs/tune2fs
> option.

I'd really rather not support adding extra complexity unless it's very
clear what is the specific threat that we are protecting about, and
we're clear that it is a valid threat in the context of the overall
system.  Otherwise we may be strengthening the titanium/steel door
while ignoring the paper maiche walls that it is set in.

(Or see the image on slide #4 of:
http://kernsec.org/files/lss2014/Halcrow_EXT4_Encryption.pdf  :-)

						- Ted

[1] http://www.eetimes.com/document.asp?doc_id=1279619
