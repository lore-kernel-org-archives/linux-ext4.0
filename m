From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/8] ext4 crypto: encrypt tmpfile located in encryption
 protected directory
Date: Fri, 29 May 2015 12:33:25 -0400
Message-ID: <20150529163325.GE18540@thunk.org>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
 <1432856867-5710-4-git-send-email-tytso@mit.edu>
 <CAHAf8Wm6n+32+HDjqnnNiV5vDWxsMBEzLS-qcdvnoODquWQ_ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com
To: Albino Biasutti Neto <bino@riseup.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36985 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161130AbbE2Qde (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 May 2015 12:33:34 -0400
Content-Disposition: inline
In-Reply-To: <CAHAf8Wm6n+32+HDjqnnNiV5vDWxsMBEzLS-qcdvnoODquWQ_ew@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 29, 2015 at 08:09:01AM -0300, Albino Biasutti Neto wrote:
> 2015-05-28 20:47 GMT-03:00 Theodore Ts'o <tytso@mit.edu>:
> > +static inline struct ext4_crypt_info *ext4_encryption_info(struct =
inode *inode)
> > +{
> > +       return NULL;
> > +}
> >  #endif
>=20
> Ts=B4o, this code can not return anything be empty or not ?

I'm not sure what you ar asking, since I can't quite parse your
question as a valid english sentence, sorry.

I think what you are asking is why is this function always returning
NULL?

That's because it's in the #else clause of an #ifdef
CONFIG_EXT4_FS_ENCRYPTION.  In the case where
CONFIG_EXT4_FS_ENCRYPTION is defined, it returns:

static inline struct ext4_crypt_info *ext4_encryption_info(struct inode=
 *inode)
{
	return EXT4_I(inode)->i_crypt_info;
}

The idea is to minimize the need for #ifdef's in the .c files.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
