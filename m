From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Wed, 18 Jun 2014 18:06:01 -0400
Message-ID: <20140618220601.GA5114@thunk.org>
References: <20140613143157.GB23180@thunk.org>
 <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org>
 <20140617024953.GG9508@dastard>
 <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
 <20140617124629.GA13868@thunk.org>
 <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
 <20140617135405.GA5054@thunk.org>
 <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com>
 <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: JP Abgrall <jpa@google.com>, Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46460 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbaFRWGH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2014 18:06:07 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 18, 2014 at 11:33:47AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Except when it does not. Looking at the mmc driver I can see that we
> have already some devices where secure trim is broken.
>=20
> /*
>  * On these Samsung MoviNAND parts, performing secure erase or
>  * secure trim can result in unrecoverable corruption due to a
>  * firmware bug.
>  */

The bug IMHO is that the eMMC driver is falling back to discard,
instead of returning EOPNOTSUPP.  The question of whether we should
fall back to discard or not should be made at a level much higher up
than the MMC device driver....

> And I have no illusion that those are the only ones that does not
> work. This hardware can not be trusted and this must not be
> advertised as a security feature.

There's always crappy hardware out there.  If that's true, should then
not call ATA Secure Erase by that term because somewhere out there,
there will be an incompetently implemented SSD that doesn't do the
right thing with ATA Secure Erase?  I just don't think that's
particularly useful.  If the command is called "secure erase" or
"secure discard" in the specification, then that's what we should use,
just to avoid confusion if nothing else.

Now, if the spec explicitly disclaims correct behavior, in the case of
discard and discard zeros data, that's a different matter.  But I
don't think that is what's going on here.  The MMC specification makes
certain guarantees; there is no "the drive is allowed to disregard the
discard command if it's too busy to attend to it mealy-mouthed
language", as there is in the ATA discard specification.

The fact that there happens to be buggy hardware out there, is just
the natural state of affairs.  But that's what black lists are for.

    	    	     	       	   - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
