Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46803 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbeLRFoK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Dec 2018 00:44:10 -0500
Received: by mail-pg1-f194.google.com with SMTP id w7so7255747pgp.13
        for <linux-ext4@vger.kernel.org>; Mon, 17 Dec 2018 21:44:09 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <F169A778-5219-4FDD-8899-3074DFFDD8A4@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FACC4751-14DF-4C15-9C3F-3BF9121CFC0B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: avoid declaring fs inconsistent due to invalid file
 handles
Date: Mon, 17 Dec 2018 22:43:40 -0700
In-Reply-To: <20181218044541.GB25775@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20181213175107.29464-1-tytso@mit.edu>
 <A3D72248-487E-412E-B341-7450C773E81F@dilger.ca>
 <20181218044541.GB25775@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FACC4751-14DF-4C15-9C3F-3BF9121CFC0B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Dec 17, 2018, at 9:45 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> 
> On Mon, Dec 17, 2018 at 03:53:46PM -0700, Andreas Dilger wrote:
>>> +#define EXT4_IGET_NORMAL	1
>>> +#define EXT4_IGET_HANDLE	2
>> 
>> It would be better to make this:
>> 
>> enum ext4_iget_flags {
>>        EXT4_IGET_RESERVED = 0x00,	/* just guessing, see further below */
>> 	EXT4_IGET_NORMAL   = 0x01,
>> 	EXT4_IGET_HANDLE   = 0x02,
>> };
>> 
>>> -	inode = ext4_iget(sb, ino);
>>> +	inode = ext4_iget(sb, ino, 0);
>> 
>> What does "0" mean?  It isn't in the list of EXT4_IGET_* flags.
>> I'm guessing it means that access to reserved or otherwise invalid
>> inodes is allowed?
> 
> The flags are boolean OR'ed together, much like O_TRUNC | O_CREAT,
> etc.  So an enum isn't really appropriate.

I don't think that it is verboten to use binary flag values in an enum,
if you explicitly specify the values, which is why I used "0x01", "0x02"
to make it more clear these are binary values.  IMHO, using a named enum
is a good way to annotate the function parameters rather than a generic
"int flag" parameter that is ambiguous unless you look at the function
code to see what the values of "flag" might be.

> So 0 means we're not enforcing "must be a normal inode" rules, and
> we're also not going to avoid throwing an EXT4_ERROR if the inode
> number is invalid.

So that matches what I reverse engineered, which was EXT4_IGET_RESERVED
but might have a better name if you can think of it.  I originally had
EXT4_IGET_NONE = 0, but I don't think that is quite correct.

> I had thought it was obvious that flags can be or'ed together, and
> that "modes" are what might use an enum.

Their definition as "1" and "2" didn't make it clear that the next
possible value was "4" and not "3".

> I personally like flags because the can be more expressive, although
> I can see that "modes" are simpler since there is a much smaller set
> of valid modes, and you don't have to worry about define what happens
> when flags interact in unusual/unexpected ways.

I'm not against flags, and I figured out that they were orthogonal
flags after reading the whole patch.

> It sounds like should add more explicit documentation at the very
> least so it's more clear what's going on.
> 
>      	      	   	 	      - Ted


Cheers, Andreas






--Apple-Mail=_FACC4751-14DF-4C15-9C3F-3BF9121CFC0B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwYiQwACgkQcqXauRfM
H+CTsA/8C6vn/BM/Dah7Onxq1T8bYzS4ftODKZ+cqpQTBvyoVTSr+xSNtX2g6Ktp
rggc3q+8RlXQnTwW0MtmX99/jQnmC4agGtzQyfaj/rJ9n/BQhHRs+OPiEWNncx7J
kN2gXndi9zupZHDyjyg1wn+ySGj4Kp7O+OsgGI4dRcisreuHMN4/+pe0Cnyc2X5D
UeT6JB5wKFYHqQbZjDEBVTcFu1cGnl49FmnNiO38+fnX+vOrWiuVpTv47z2mTF3O
8xhphqN1TbAmPrwZY3I1pW4xW6ZezyoBzafY5jhYl9Sb5+Tp8F1Hu0WHxrX4Apem
mCClhwMbQvTtFTAROebAm/veUKVPNr/ZfDoEnxc7kR86Tkzma2K7h8QMM9I+YnLt
7YaYMENMOSDpGY6sa3RroINN11Qs3MhXTsVfESnrwLAnG2ry3+7op9zbOH2xESQs
x1lZIMCeeCCZF/IkywA4fGh9b0EsSij9jBjGzWvPAhEK8K6waerxdK4JGPWifJ7E
F34oLihD/5QM0wcSpdEVKp+iB8+aB26AsuUwBtscWDUf753mv276c4gUhxOEC7Do
mYG4S1dxHhTQ7AjajBm5qL3qJmqITRuxGMMIO9yI3x4zQg5wjVIUJ3zHNWsL/8tE
CNidzrTpC3JgwpPaUKtBFPcQJ20Aybr1FPQJF1AsgjFO2wFb6CY=
=JwT6
-----END PGP SIGNATURE-----

--Apple-Mail=_FACC4751-14DF-4C15-9C3F-3BF9121CFC0B--
