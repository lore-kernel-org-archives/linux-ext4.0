From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] libext2fs: fix ext2fs_llseek on i386
Date: Thu, 24 Jan 2013 23:34:43 -0500
Message-ID: <51020B63.5000404@ubuntu.com>
References: <20130125041313.GF28908@thunk.org> <1359087258-13276-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:46322 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3AYEeo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 23:34:44 -0500
In-Reply-To: <1359087258-13276-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/24/2013 11:14 PM, Theodore Ts'o wrote:
> +	fallback: +		if (offset < ((ext2_loff_t) 1 << ((sizeof(off_t)*8)
> -1))) +			return lseek(fd, (off_t) offset, origin); errno =
> EINVAL;

Shouldn't that be EOVERFLOW?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJRAgtjAAoJEJrBOlT6nu75II4H/07hJXsFEGxetEpJGdshSxBc
YTixcONEBDlzppAtLr/aLmHDGr+0269Wjrdj0EhrEqIqlkMG3sRcEkkBoGE7bXbm
3oYLru+YtdVFuDfvZ6PDuConYD/Ud711uLP1Bu2gJN0fGO0l+cg0v1VIirKgaDMO
pB468llpVxMY3Tj9SN5JB7Np0ZS3qxhMpYc3RGsObRamU/BHcIRYw65K8Vsgi4xa
jtf6O8/bQm2AUB+d4IRBuR+KV0/HWFCYtcfSBh/iv/e3aWr2CXA59J5WuGpCfWAM
a72+S9Ek7IOiTi2H59swh2bCSajf01da1JvA26f6yBH7KrY2mvWys1/C/3liUzs=
=/V1N
-----END PGP SIGNATURE-----
