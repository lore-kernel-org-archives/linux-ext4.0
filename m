From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Wed, 18 Jun 2014 11:33:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain>
References: <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com> <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org> <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard> <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain> <20140617124629.GA13868@thunk.org> <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain> <20140617135405.GA5054@thunk.org>
 <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1719799381-1403084031=:3406"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: JP Abgrall <jpa@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1719799381-1403084031=:3406
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 17 Jun 2014, JP Abgrall wrote:

> Date: Tue, 17 Jun 2014 10:53:21 -0700
> From: JP Abgrall <jpa@google.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Lukáš Czerner <lczerner@redhat.com>, Dave Chinner <david@fromorbit.com>,
>     Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
>     Geremy Condra <gcondra@google.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Subject: Re: [PATCH] ext4: Add support for SFITRIM,
>     an ioctl for secure FITRIM.
> 
> On Tue, Jun 17, 2014 at 6:54 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > There's an assumption here that the eMMC SECDISCARD functionality is
> > more competently spec'ed out compared to the ATA/SCSI interface.  I'm
> > not sure whether or not that's true, but perhaps JP and Geremy can
> > confirm that.
> We only care about the eMMC spec. In the eMMC spec there is no room
> for ignoring the commands. If the card declares it can do a secure
> erase/trim it must do it as per the spec.

Except when it does not. Looking at the mmc driver I can see that we
have already some devices where secure trim is broken.

/*
 * On these Samsung MoviNAND parts, performing secure erase or
 * secure trim can result in unrecoverable corruption due to a
 * firmware bug.
 */

And I have no illusion that those are the only ones that does not
work. This hardware can not be trusted and this must not be
advertised as a security feature.

Btw, AFACIT with this backlisted hardware the user will not even
notice that secure discard did not went through and the driver will
simply use normal discard, which is a bug if you ask me.

Let's call is deep discard, or whatever but avoid the security word
at least when file system comes into play.

-Lukas

>   JEDEC Standard No. 84-A441
>   7.6.9 Secure Erase
>   7.6.10 Secure Trim

--8323328-1719799381-1403084031=:3406--
