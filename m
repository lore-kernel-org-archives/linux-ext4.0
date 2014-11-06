From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] Some thoughts about providing data block checksumming
 for ext4
Date: Thu, 6 Nov 2014 07:55:17 -0500
Message-ID: <20141106125517.GA3719@thunk.org>
References: <20141103233308.GA27842@thunk.org>
 <alpine.LRH.2.02.1411041622490.30941@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1411041703590.7145@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1411041915430.32105@file01.intranet.prod.int.rdu2.redhat.com>
 <545A9885.8070901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-ext4@vger.kernel.org,
	dm-devel@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42253 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaKFMzW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Nov 2014 07:55:22 -0500
Content-Disposition: inline
In-Reply-To: <545A9885.8070901@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2014 at 10:37:09PM +0100, Milan Broz wrote:
> 
> Also, for encrypted devices (either on file level or block level) I think 
> there are still requests for implementing real crypto authenticated modes (like GCM)
> which obviously need similar space for auth tag. (I think ZFS uses it this way.) 

Yes, although it depends on your threat model.  If you need to worry
about known or chosen plaintext attack modes --- for example, if you
were implementing the chrome browser where the attacker might be able
to play MITM and replace web pages which would then get encrypted in
the browser cache, and where the attacker can continuously read and/or
replace blocks (say, because of some really stupid design where you
are using an unprotected iSCSI connection).  Or if you assume the
attacker can remove the hard drive, twiddle some blocks, and then
surreptitiously replace the hard drive many times, then yes, you need
to worry about data integrity because a system that doesn't include a
MAC --- such as what dm-crypt provides, is simply not enough.

Basically, a dm-crypt style block device encryption is only good if
your threat model is "the attacker steals the laptop and I want to
keep the contents of the storage device safe".

Michael Halcrow discussed this in this years Linux Security Symposium:

	http://kernsec.org/files/lss2014/Halcrow_EXT4_Encryption.pdf

Cheers,

						- Ted
