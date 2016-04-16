From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/4] e2fsck: don't try to set a UUID on metadata_csum file systems
Date: Fri, 15 Apr 2016 21:06:04 -0600
Message-ID: <062EB0E7-1B5E-4DF0-B4B2-F87A7566A81F@dilger.ca>
References: <1460769225-31398-1-git-send-email-tytso@mit.edu> <1460769225-31398-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_28A28D7B-BC6D-420A-AF30-69E0FF379FBF"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35318 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbcDPDGJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2016 23:06:09 -0400
Received: by mail-io0-f178.google.com with SMTP id g185so151880621ioa.2
        for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2016 20:06:08 -0700 (PDT)
In-Reply-To: <1460769225-31398-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_28A28D7B-BC6D-420A-AF30-69E0FF379FBF
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Apr 15, 2016, at 7:13 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> If the UUID field is NULL, e2fsck will try to generate and set a new
> UUID.  This will cause massive problems if the metadata_csum feature
> is set, so avoid doing so in that case.

Should enabling the metadata csum feature complain/fail if the checksum
is unset?  It doesn't make sense to use a NULL UUID as the checksum salt.

Cheers, Andreas

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> e2fsck/super.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index e09c14c..dec70bd 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -756,6 +756,7 @@ void check_super_block(e2fsck_t ctx)
> 	 * if the id changes under the kernel remounting rw may fail.
> 	 */
> 	if (!(ctx->options & E2F_OPT_READONLY) && uuid_is_null(sb->s_uuid) &&
> +	    !ext2fs_has_feature_metadata_csum(ctx->fs->super) &&
> 	    (!csum_flag || !(ctx->mount_flags & EXT2_MF_MOUNTED))) {
> 		if (fix_problem(ctx, PR_0_ADD_UUID, &pctx)) {
> 			uuid_generate(sb->s_uuid);
> --
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_28A28D7B-BC6D-420A-AF30-69E0FF379FBF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVxGsHXKl2rkXzB/gAQiE/hAAmwhGz1WtR9sLWsS9tDk49zoPRMlY+vK5
4T7+J8E6qayeUmEjixxUXqnCuQ5x/gTO6H2GIgCns4q9m8+E9LSUDkVV4AChV4W9
gfYYg7f4M1tge6pAmHZOg1l2mXYWj9rqe6HWPpjb4vUupYpklW0ROm4p9hdhZ9wM
UuB+vxg3yb1X/cta4vq5pdDqoKXjrOg7J5byYBJRt+NyFyR+1jeEBgotLlfQyl4F
hI4r25Bf3DFpkvUwfOxoU1pc2RfYUkKOJ+gLcF2W0DDGg5M//YTFfraKvtgE9lRi
bzRBbL9hE7jpZsc4aDFJsBmt4gicHEL3RPvYHE0BT7RUZ5vpNOZHs7CCini4Gg6C
PtgjGVjQ2WS5E1wDYPs16tgXu/PpH9JHcG4wkiZrL6xRcX7TAuyqMb/2J340cUAx
b8lAxUM0epjn5QI1mQvxPXYi5gvbnQfjQLKzi9/frvcmKHXXKWqr8fUwAejH955G
Ye02QI1VewEd1V1k1Os4VxvTmrjv1o4ttL4f4HRhnQ+IBRtEW7iA4x9B4/ofF/r4
HUf8MrSmE4gBhEsHs9HQJ9Zrr8zAimbwvfylX579jO6jFQpYPoAjGcm+yj9UYh20
G4NqIrpUMx+5takvs4E3bNmdnaY4zq0FURvShlsRNIm6sIfEFgNrj1shu8KbT/WY
HMMxP64LF7o=
=VFG9
-----END PGP SIGNATURE-----

--Apple-Mail=_28A28D7B-BC6D-420A-AF30-69E0FF379FBF--
