From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] ext4: support freezing ext2 (nojournal) file systems
Date: Thu, 18 Sep 2014 14:46:34 -0600
Message-ID: <DF6FF9BB-702A-423B-B64E-2731A0347AE8@dilger.ca>
References: <1411071989-4974-1-git-send-email-tytso@mit.edu> <1411071989-4974-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_00ECB620-5C85-427A-817B-E55301C72AD5"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dexuan Cui <decui@microsoft.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37527 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaIRUqQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2014 16:46:16 -0400
Received: by mail-pd0-f176.google.com with SMTP id g10so2136351pdj.21
        for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2014 13:46:16 -0700 (PDT)
In-Reply-To: <1411071989-4974-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_00ECB620-5C85-427A-817B-E55301C72AD5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Sep 18, 2014, at 2:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Through an oversight, when we added nojournal support to ext4, we
> didn't add support to allow file system freezing.  This is relatively
> easy to add, so let's do it.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> ---
> fs/ext4/super.c | 27 ++++++++++++++++-----------
> 1 file changed, 16 insertions(+), 11 deletions(-)
> 
> @@ -4758,23 +4760,26 @@ static int ext4_freeze(struct super_block *sb)
> 
> 	journal = EXT4_SB(sb)->s_journal;
[snip]
> 	/* Journal blocked and flushed, clear needs_recovery flag. */
> 	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> 	error = ext4_commit_super(sb, 1);
> out:
> -	/* we rely on upper layer to stop further updates */
> -	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> +	if (journal)
> +		/* we rely on upper layer to stop further updates */
> +		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);

This could use "journal" directly instead of "EXT4_SB(sb)->s_journal"

Cheers, Andreas






--Apple-Mail=_00ECB620-5C85-427A-817B-E55301C72AD5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVBtEqnKl2rkXzB/gAQI66A/+J8Hl3N/XYgIDGcEwaSP/X2bUDTZYTSdQ
HOqJhwMgvHRoTy4HkPMHLNrUUYaDXBIeEIgFe5eUGrsBy9GB/pWJkxs5ymPuA8fT
/9ytmBfQyCFKXDkQaBaLyRUJchbtWjyiGrvnRNVBZEsGWluY0cAZKnTkyYRNFhMp
BiFcfyWh3cHENgVPTWhp2tIdWZ/xpLNLqV6IGO3fcozsAthHpNYT796AI0fhoR6m
f6unD9NJ3NU7YFe6eKnAd0nfJnojQhryx0sIb9E5v4qbAKqmM5l5O8UhLzarPxIO
QW4FtY3uoJSgLyxv67C4xU4jKsYUKC/01HOr8LGgCZykGZ6i0BRTSoFyrp21224X
bQc1QNKvVHHLsOnOJT6jNWOGrNADAmnkAQBdGE7/7MIxxxAhW+eAlOeAQmmXiF4B
tCnMmeoK8591ax6mfWqXEUg75YpIEGAR2Yir6PzzXNl10eD+QtvmMtELw5jXKsgu
rw6NxPhfRDCBkUaCvk7bqbk9mN7nFEqWcjMiiuR2al2ucxmkzKtAEfi4lkuWwwC1
6eoX9Yn5oah+C03m7MVEi9x0Rb4ibqCXwUoGfFotlfvK4A/+9oqxfOcwA1Xi8QO0
ez0HfeBlkTqGEbJ0mGM+siBGZslg30w5pUp31p9OEXoxn37zU1lstZuyj/FLhqDJ
PvQY/7GUt78=
=GRaI
-----END PGP SIGNATURE-----

--Apple-Mail=_00ECB620-5C85-427A-817B-E55301C72AD5--
