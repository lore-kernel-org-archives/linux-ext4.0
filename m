From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: e4crypt - Possible to Change Passphrase?
Date: Thu, 26 Oct 2017 19:51:49 -0700
Message-ID: <20171027025149.GA1803@zzz.localdomain>
References: <4F5135A853DDCC4BAAF325E04E1419C807A384A4@ALPMBAPA10.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Joe Richey <joerichey@google.com>
To: "Grochowalski, Matthew (GE Aviation, US)"
        <MatthewS.Grochowalski@ge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:52483 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932334AbdJ0Cvx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Oct 2017 22:51:53 -0400
Received: by mail-pf0-f180.google.com with SMTP id e64so3906168pfk.9
        for <linux-ext4@vger.kernel.org>; Thu, 26 Oct 2017 19:51:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4F5135A853DDCC4BAAF325E04E1419C807A384A4@ALPMBAPA10.e2k.ad.ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

+Cc Joe Richey <joerichey@google.com>

Hi Matt,

On Thu, Oct 26, 2017 at 11:20:16PM +0000, Grochowalski, Matthew (GE Aviation, US) wrote:
> Is it possible to change the passphrase of a folder encrypted using e4crypt set_policy?

e4crypt doesn't support changing the passphrase because it derives the master
encryption key directly from the passphrase, rather than using the
passphrase-derived key to unwrap another key.

> I'm assuming I'd need to copy everything from one directory to another with a
> different policy then delete the originals,

That's fine as a workaround, although keep in mind you probably should delete
the originals with 'shred' so that the old ciphertext (which is protected only
by the old passphrase) is less likely to still exist on disk.

> use as a passphrase then encrypt that with the actual user passphrase?

Loosely speaking, that approach will work and is actually the proper way to
support passphrase changes.  However, implementing key derivation and key
wrapping yourself is error-prone; it's the type of thing that is very easy to
implement insecurely without knowing it.  I suggest using the "fscrypt" program
(https://github.com/google/fscrypt) which has implemented this already, with the
wrapped keys stored in a ".fscrypt" directory in the root directory of the
filesystem.  It also has many other advantages, such as PAM support, and also
working for f2fs and ubifs.  In the future I expect we'll be more aggressively
advertising fscrypt and documenting e4crypt (and f2fscrypt, which is e4crypt
copy+pasted into f2fs-tools) as deprecated.  You can ask Joe Richey, who is the
primary author of the fscrypt program, for more details.

Eric
