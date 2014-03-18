From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: don't interact with a non tty
Date: Tue, 18 Mar 2014 12:31:35 -0600
Message-ID: <A5AC507A-847C-496C-99FF-DE48BE224D80@dilger.ca>
References: <1395162718-22586-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_ADFD0BFC-D702-4361-9CC3-F9D2607C943A"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58484 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbaCRScm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Mar 2014 14:32:42 -0400
Received: by mail-pb0-f53.google.com with SMTP id rp16so7651452pbb.40
        for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 11:32:42 -0700 (PDT)
In-Reply-To: <1395162718-22586-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_ADFD0BFC-D702-4361-9CC3-F9D2607C943A
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Mar 18, 2014, at 11:11 AM, Phillip Susi <psusi@ubuntu.com> wrote:
> mke2fs displays an interactive y/n prompt for certain situations.
> This is not appropriate to do when stdin is not a tty.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> ---
> misc/util.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/misc/util.c b/misc/util.c
> index 92ab79f..c469744 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -71,6 +71,8 @@ void proceed_question(void)
> 	char buf[256];
> 	const char *short_yes = _("yY");
> 
> +	if (!isatty(0))
> +		return;

This means that mke2fs will silently continue to format whatever accidental
device was specified on the command line, instead of stopping and asking the
user for confirmation.  Instead, it should exit with an error in this case.

There is already the "-f" (force) option to override the cases where this
prompt is used, so if the user wants to do something unusual they should
use that as part of the script driving mke2fs.

The only time when I think "force" is required when it shouldn't be is in
case of full-device formatting.  I don't think this should be considered a
problem unless there is already a partition table on the device.  Formatting
the whole device is desirable to avoid alignment issues on RAID devices, so
I would be happy if that restriction was lifted.

Cheers, Andreas






--Apple-Mail=_ADFD0BFC-D702-4361-9CC3-F9D2607C943A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUyiRB3Kl2rkXzB/gAQKPAg//f1RVUKZUg9EZ3aD/nc+epvMpiYbjvxBJ
Ss9qQL0QbVuW/j3M1S3TF9kF7BFQ4ydfEei6VSqmUxKIMj5tJ26BUMtbQkZyg4FO
QGoOwtC72vA9xi80Jo0ZVdhOS2OfqWxPMjyKjmI/kw5CDecgzYLEBEEcxwi4BsL8
8hSTuSvlWB3KfAZHvr5Y4A9ujA1cqr83WjcTA5xUIkq2+yTlEBLrCzktqkF0Ok4J
w2onv6d9yF8K8rg+r/vgJWc/fceysIc+XAbLNHQEwMuZlyvyiSLeUlX7wzohRfoh
PLmhhosHLaWw7UyA7CNHAaZQdseocrMpYeQ1PwR+ITp0BQaJQe+rsFj8Spi+oSt2
/e6LG3P95y2LWZXQTZkT4FJwSMr1cyUo6ml+JMDyOqnruvukoTkeFoMNnu1chiwW
k8fBLUYDDc2XY7+KKjdt+/S2EXJnlysxxkqsrBjN4cVtB397xPIUZVw/fcqI5Th7
Gr4ksYOP/N/QsUDBCqAlRySCNS9y+yilRNYsSyhgzZe3pJSbFcFnw+x3yCTnhSZE
+ks5wvQUHEIrqywJ4GMPXiil2UCuOwcIBPDHWJm8bTWzegRy67uA/swQ6un4WuuB
/rB8uLo+/U37f3xqP2QHWxvRtgPTJ9sNMAkWSMBsLcTfUsq9VFRy08dVFxc9VYZ5
jbjWeWgmOwA=
=9SHo
-----END PGP SIGNATURE-----

--Apple-Mail=_ADFD0BFC-D702-4361-9CC3-F9D2607C943A--
