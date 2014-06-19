From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Thu, 19 Jun 2014 10:10:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406191010020.2182@localhost.localdomain>
References: <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com> <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org> <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard> <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain> <20140617124629.GA13868@thunk.org> <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain> <20140617135405.GA5054@thunk.org>
 <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com> <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain> <CAKP4w2RoHxhTRmSbSYH8FAgvEMXifZBcOR87Pww9skTRAo8fmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1424403955-1403165460=:2182"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: JP Abgrall <jpa@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKP4w2RoHxhTRmSbSYH8FAgvEMXifZBcOR87Pww9skTRAo8fmw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1424403955-1403165460=:2182
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 18 Jun 2014, JP Abgrall wrote:

> Date: Wed, 18 Jun 2014 14:51:42 -0700
> From: JP Abgrall <jpa@google.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
>     Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
>     Geremy Condra <gcondra@google.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Subject: Re: [PATCH] ext4: Add support for SFITRIM,
>     an ioctl for secure FITRIM.
> 
> On Wed, Jun 18, 2014 at 2:33 AM, Lukáš Czerner <lczerner@redhat.com> wrote:
> > Except when it does not. Looking at the mmc driver I can see that we
> > have already some devices where secure trim is broken.
> 
> And that is why we don't just blindly use random eMMC devices.

'we' as in ... ? Remember, you're not the only one using this code.

> 
> > Let's call is deep discard, or whatever but avoid the security word
> > at least when file system comes into play.
> 
> Best effort discard :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1424403955-1403165460=:2182--
