From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: Make -U option consistent between tune2fs and
 mke2fs
Date: Thu, 13 Apr 2017 16:24:07 -0600
Message-ID: <3501FCFF-B686-47DF-B530-802CB3A79FAB@dilger.ca>
References: <20170413194702.GA41849@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_597D2B67-9235-460C-996F-3A18DDD581E0";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Drew Davenport <ddavenport@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36804 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdDMWYN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Apr 2017 18:24:13 -0400
Received: by mail-io0-f196.google.com with SMTP id x86so15842898ioe.3
        for <linux-ext4@vger.kernel.org>; Thu, 13 Apr 2017 15:24:13 -0700 (PDT)
In-Reply-To: <20170413194702.GA41849@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_597D2B67-9235-460C-996F-3A18DDD581E0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Apr 13, 2017, at 1:47 PM, Drew Davenport <ddavenport@google.com> wrote:
> 
> Allow "null", "clear", "random", or "time" for the -U option for
> mke2fs, which are already allowed options for tune2fs.
> 
> Signed-off-by: Drew Davenport <ddavenport@google.com>

Looks OK, but please also add this to the mke2fs man page, then you can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> misc/mke2fs.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 49c6e94d..b8d078a0 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2914,7 +2914,14 @@ int main (int argc, char *argv[])
> 	 * Parse or generate a UUID for the filesystem
> 	 */
> 	if (fs_uuid) {
> -		if (uuid_parse(fs_uuid, fs->super->s_uuid) !=0) {
> +		if ((strcasecmp(fs_uuid, "null") == 0) ||
> +		    (strcasecmp(fs_uuid, "clear") == 0)) {
> +			uuid_clear(fs->super->s_uuid);
> +		} else if (strcasecmp(fs_uuid, "time") == 0) {
> +			uuid_generate_time(fs->super->s_uuid);
> +		} else if (strcasecmp(fs_uuid, "random") == 0) {
> +			uuid_generate(fs->super->s_uuid);
> +		} else if (uuid_parse(fs_uuid, fs->super->s_uuid) != 0) {
> 			com_err(device_name, 0, "could not parse UUID: %s\n",
> 				fs_uuid);
> 			exit(1);
> --
> 2.12.2.762.g0e3151a226-goog
> 


Cheers, Andreas






--Apple-Mail=_597D2B67-9235-460C-996F-3A18DDD581E0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY7/qIpIg59Q01vtYRAiMVAJ4jNcRV4n3esdhIaeSBdfiF9TnM9gCgw89j
fKiM9H238oifT0X3Xv6eKD4=
=dqUM
-----END PGP SIGNATURE-----

--Apple-Mail=_597D2B67-9235-460C-996F-3A18DDD581E0--
