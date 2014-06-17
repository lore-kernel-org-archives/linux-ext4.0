From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Tue, 17 Jun 2014 10:35:50 -0700
Message-ID: <CAKP4w2RHt+pBX0-ng+pwy4eBRBzV2iPau3oHUVHr=T6nbccLDg@mail.gmail.com>
References: <20140613031538.GR4453@dastard> <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard>
 <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
 <20140617124629.GA13868@thunk.org> <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
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
In-Reply-To: <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 17, 2014 at 6:00 AM, Luk=C3=A1=C5=A1 Czerner <lczerner@redh=
at.com> wrote:
>
> What is the difference between -o discard mount option ?
Android will not mount -o discard because of the overall penalty.

> I guess
> that this way you can do it selectively on certain files, but I
> wonder how useful it is going to be anyway ?
=46or certain files only. Useful enough.


> If they are ok with only best effort, then we can have FISTRIM ioctl
> which would use the same internal file system functionality as
> FITRIM but we would add a flag to be able to call sb_issue_discard()
> with BLKDEV_DISCARD_SECURE flag,
I think this was the idea of the original patch.

> disable the optimization to skip
> already discarded groups and call sync on the file system before we
> start doing any actuall work.
That would need adding to the original patch.

> If we do this though we should not add word "security" anywhere for
> the use to see :)
We can live with that.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
