From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v2 08/20] ext4 crypto: add encryption key management
 facilities
Date: Wed, 27 May 2015 13:06:06 -0400
Message-ID: <20150527170606.GA31840@thunk.org>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu>
 <1428894996-7852-9-git-send-email-tytso@mit.edu>
 <87382im95e.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com, Ildar Muslukhov <muslukhovi@gmail.com>
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60723 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbbE0RGI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 13:06:08 -0400
Content-Disposition: inline
In-Reply-To: <87382im95e.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2015 at 04:39:57PM +0300, Dmitry Monakhov wrote:
>  I'm wondering whenever derivation key algo (AEC-CBC) is too weak because allow
>  attacker get master key once attacker find key for any inode in a filesystem.
>  IMHO sane key derivation should be done via HMAC (HMACSHA256) or any
>  other one direction procedure.

That's not true.  If the attacker finds the encryption key for an
inode, and they have the nonce which is stored in file's extended
attribute, what the attacker has is a single plaintext/ciphertext
pair.  That doesn't imply that they can get the master key; they would
still need to do a brute force search on the keyspace try to find the
master key.

There are certainly key derivations that do not use HMAC; for example,
see RFC-4615, which we used as a model for what we are using.

> Read file connect w/o key. 
>    Currently this is prohibited which breaks a lot of applications. For
>    example my backup scenario looks like rsync like script which copy
>    content of home directory to some archive. Script has no
>    access to my keys, so encrypted files will be backed-up. This is bad.
>    IMHO it is reasonable to allow to read content of the file even w/o key but
>    return encrypted content (as it is stored on disk). This is very
>    similar to what we do with filenames. AFAIU this will no break our
>    security assumptions 'steal once' because even if attacker has access
>    to several versions of the encrypted file this simply equals to
>    several files with same ctx.nonce (effectively equals encrypted file
>    with size = sum of all files)

If we let applications get the encrypted version of the files if the
key is not available, I suspect _more_ applications would break, or at
least behave in very surprising ways.  The current behavior breaks
exactly one class of applications --- backup applications.

The problem is that merely backing up the encrypted data isn't enough.
It's also important to back up the encryption context, and there also
has to be a way of restoring (or interpreting) the encryption context.
So it's a lot more complicated, and in the future, the rules when an
encryption context is allowed to be different from the parent
directory's encryption context (if the parent directory is protected
using encryption).

The other thing that is going to get complicated is that if one userid
has access to the key, and the other userid does not, we will need to
keep track of both the encrypted and unencrypted pages in the page
cache.  Currently we don't keep the encrypted version of the pages at
all.  Adding support for this is going to get messy (unless you want
to only allow backup programs to use O_DIRECT).

So I can imagine a new open flag that says, "I'm a backup program, so
I want to read the encrypted blocks if that is all I can get", and
then also a way of exporting and importing encryption contexts, and
deal with the encrypted vs. unencrypted page cache issue, I could
imagine adding the ability to back up encrypted files w/o having
access to the key.  But it's a lot more complicated than it first
appears.

						- Ted
