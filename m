From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Mon, 3 Oct 2016 11:03:40 -0700
Message-ID: <20161003180340.GA54410@google.com>
References: <1475258329-146528-1-git-send-email-ebiggers@google.com>
 <CAFLxGvyCHwWms8wJf1gU0hRj__Q0Z2F2wKuZ3sYNfp8wQ9S4PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvyCHwWms8wJf1gU0hRj__Q0Z2F2wKuZ3sYNfp8wQ9S4PQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 01, 2016 at 06:03:31PM +0200, Richard Weinberger wrote:
> Eric,
> 
> On Fri, Sep 30, 2016 at 7:58 PM, Eric Biggers <ebiggers@google.com> wrote:
> > The XTS tweak (or IV) was initialized differently on little endian and
> > big endian systems.  Because the ciphertext depends on the XTS tweak, it
> > was not possible to use an encrypted filesystem created by a little
> > endian system on a big endian system and vice versa, even if they shared
> > the same PAGE_SIZE.  Fix this by always using little endian.
> >
> > This will break hypothetical big endian users of ext4 or f2fs
> > encryption.  However, all users we are aware of are little endian, and
> > it's believed that "real" big endian users are unlikely to exist yet.
> > So this might as well be fixed now before it's too late.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  fs/crypto/crypto.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > index 61057b7d..98f87fe 100644
> > --- a/fs/crypto/crypto.c
> > +++ b/fs/crypto/crypto.c
> > @@ -151,7 +151,10 @@ static int do_page_crypto(struct inode *inode,
> >                         struct page *src_page, struct page *dest_page,
> >                         gfp_t gfp_flags)
> >  {
> > -       u8 xts_tweak[FS_XTS_TWEAK_SIZE];
> > +       struct {
> > +               __le64 index;
> > +               u8 padding[FS_XTS_TWEAK_SIZE - sizeof(__le64)];
> > +       } xts_tweak;
> 
> While we are here, wouldn't it make sense to rename the variable to "iv"?
> In aes-xts mode the IV is used as tweak. But it is still an IV and passed
> as IV parameter to the crypto API.
> 
> Especially when other cipher modes are used this is confusing.
> 

Good idea --- I agree that "iv" is a better name, so as to not tie the code to
XTS specifically.  But I think the renaming should be a separate patch.

Also, currently this code *is* only supposed to be used for XTS.  There's a bug
where a specially crafted filesystem can cause this code path to be entered with
CTS, but I have a patch pending in the ext4 tree to fix that.

Eric
