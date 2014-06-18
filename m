From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Wed, 18 Jun 2014 14:51:42 -0700
Message-ID: <CAKP4w2RoHxhTRmSbSYH8FAgvEMXifZBcOR87Pww9skTRAo8fmw@mail.gmail.com>
References: <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard>
 <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
 <20140617124629.GA13868@thunk.org> <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
 <20140617135405.GA5054@thunk.org> <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com>
 <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 18, 2014 at 2:33 AM, Luk=C3=A1=C5=A1 Czerner <lczerner@redh=
at.com> wrote:
> Except when it does not. Looking at the mmc driver I can see that we
> have already some devices where secure trim is broken.


And that is why we don't just blindly use random eMMC devices.

> Let's call is deep discard, or whatever but avoid the security word
> at least when file system comes into play.

Best effort discard :)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
