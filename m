From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v5 27/28] ext4: xattr inode deduplication
Date: Wed, 21 Jun 2017 15:42:09 -0600
Message-ID: <E4913B36-9018-4915-9E3F-4CBD73DEF7BE@dilger.ca>
References: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
 <20170620090721.12480-1-tahsin@google.com>
 <C5BD0B33-E343-405A-B74F-1F1717B618F9@dilger.ca>
 <CAAeU0aN8_WUTkBM8XgiNXtGFxCRqjeftnG_v3V_8dCaiWmYwog@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AA83EEB5-B2F0-4820-A493-245434EB750B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeU0aN8_WUTkBM8XgiNXtGFxCRqjeftnG_v3V_8dCaiWmYwog@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_AA83EEB5-B2F0-4820-A493-245434EB750B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Jun 21, 2017, at 3:34 PM, Tahsin Erdogan <tahsin@google.com> wrote:
> 
>> Tashin, we are already using the "no_mbcache" option name, so would prefer
>> to keep that working.  It would be OK to accept both option names to mean
>> the same thing, and only document the "nombcache" option.
> 
> Updated patch to accept both nombcache and no_mbcache.
> 
>>>      struct mb_cache *s_mb_cache;
>>> +     struct mb_cache *s_ea_inode_cache;
>> 
>> These names should be consistent, like "s_ea_block_cache".
> 
> Yes, I will rename this to s_ea_block_cache.
> 
>>> #define EXT4_GET_MB_CACHE(inode)      (((struct ext4_sb_info *) \
>>>                              inode->i_sb->s_fs_info)->s_mb_cache)
>>> 
>>> +#define EA_INODE_CACHE(inode)        (((struct ext4_sb_info *) \
>>> +                             inode->i_sb->s_fs_info)->s_ea_inode_cache)
>> 
>> These names should be consistent, like EXT4_GET_EA_CACHE() or maybe
>> EXT4_GET_EA_BLOCK_CACHE() and EXT4_GET_EA_INODE_CACHE().
> 
> How about EA_BLOCK_CACHE() and EA_INODE_CACHE() to keep them short?

Sure, that is fine since these macros are local to xattr.c.

Cheers, Andreas






--Apple-Mail=_AA83EEB5-B2F0-4820-A493-245434EB750B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZSugypIg59Q01vtYRAn66AJ9kzORNGFoU0YMHBKkjqWSoagEASwCgpM8N
wc0dUkj7V/4rQBcRXWi8cwo=
=w3sc
-----END PGP SIGNATURE-----

--Apple-Mail=_AA83EEB5-B2F0-4820-A493-245434EB750B--
