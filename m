From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] fscrypt: use 32 bytes of encrypted filename
Date: Wed, 19 Apr 2017 10:09:40 -0700
Message-ID: <20170419170940.GA89688@gmail.com>
References: <20170418210642.6039-1-gwendal@chromium.org>
 <CAFLxGvz+kODD+8s9aPw_DeYtf3Gjv0aQBC=UfoBFx3Wn2b=wxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gwendal Grignou <gwendal@chromium.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kinaba@chromium.org,
        hashimoto@chromium.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:36251 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967798AbdDSRJ7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Apr 2017 13:09:59 -0400
Content-Disposition: inline
In-Reply-To: <CAFLxGvz+kODD+8s9aPw_DeYtf3Gjv0aQBC=UfoBFx3Wn2b=wxQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Richard,

On Wed, Apr 19, 2017 at 03:37:42PM +0200, Richard Weinberger wrote:
> >
> > Tested only on ext4.
> 
> I hope you classify this patch as RFC then.
> We'll have problems when you just develop and test for ext4. :-)
> 

It's a little difficult for people to test stuff on UBIFS without a turn-key
solution like kvm-xfstests where they can just run something like
'kvm-xfstests -c ext4,f2fs,ubifs -g encrypt'.

I did post patches to add UBIFS support to xfstests and kvm-xfstests a few
months ago; maybe you're interested in taking them over and working to get them
merged?

> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index c4a389a6027b..14b2a2335a32 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -1257,8 +1257,8 @@ static inline int ext4_match(struct ext4_filename *fname,
> >                         int ret;
> >                         if (de->name_len < 16)
> >                                 return 0;
> > -                       ret = memcmp(de->name + de->name_len - 16,
> > -                                    fname->crypto_buf.name + 8, 16);
> > +                       ret = memcmp(de->name + de->name_len - 32,
> > +                                    fname->crypto_buf.name + 8, 32);
> >                         return (ret == 0) ? 1 : 0;
> >                 }
> >                 name = fname->crypto_buf.name;
> 
> Can the code still be able to read filenames which have been encrypted
> using the "old" scheme?
> 

The patch only changes the presentation of long encrypted filenames when
accessed without the key.  It doesn't change how filenames are encrypted.

- Eric
