From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: address a benign compiler warning
Date: Mon, 17 Feb 2014 20:43:54 -0500
Message-ID: <20140218014354.GE26580@thunk.org>
References: <CA+C-WL9ARNvOqeA4n5Abnja+99O4F1VdMDUPjuRCcXiVsMTc7A@mail.gmail.com>
 <1392264724-10542-1-git-send-email-patrick@parcs.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, joe@perches.com
To: Patrick Palka <patrick@parcs.ath.cx>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1392264724-10542-1-git-send-email-patrick@parcs.ath.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 12, 2014 at 11:12:04PM -0500, Patrick Palka wrote:
> When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as a
> no_printk() statement instead of an empty statement in order to suppr=
ess
> the following compiler warning:
>=20
> fs/ext4/mballoc.c: In function =E2=80=98ext4_mb_cleanup_pa=E2=80=99:
> fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body =
in an =E2=80=98if=E2=80=99 statement [-Wempty-body]
>    mb_debug(1, "mballoc: %u PAs left\n", count);
>=20
> Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>

Thanks, applied.

					- Ted
