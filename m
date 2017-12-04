From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] mke2fs: Fix German translation of mke2fs
Date: Sun, 3 Dec 2017 19:49:16 -0500
Message-ID: <20171204004916.dv322wwvomyvnies@thunk.org>
References: <20171127095119.6213-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, pth@suse.de,
        translation-team-de@lists.sourceforge.net
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56604 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752648AbdLDAtV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 3 Dec 2017 19:49:21 -0500
Content-Disposition: inline
In-Reply-To: <20171127095119.6213-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 27, 2017 at 10:51:19AM +0100, Jan Kara wrote:
> When a device mke2fs should work on already contains an ext? filesystem,
> mke2fs prints a warning. In German translation the warning doesn't end
> with a date string (which is terminated by a newline) and thus the
> output comes out mangled like:
> 
> mke2fs 1.42.12 (29-Aug-2014)
> /dev/disk/by-label/WD20_SL12 hat ein ext3-Dateisystem mit Namen
> „WD20_SL12“
>         zuletzt auf /WD20_SL12 auf Tue Jan 27 09:01:44 2015
>  eingehängtTrotzdem fortfahren? (j,n)
> ^^^^^^^^^^^^^ here
> 
> Fix the translation to end the printed string with a newline and avoid
> superfluous space at the beginning of the line.
> 
> Reviewed-by: Bernd Schubert <bernd.schubert@fastmail.fm>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  po/de.po | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Ted, can you please merge this fix? Somehow it keeps getting ignored.

Hi Jan,

The reason why I don't merge translation fixes, but rather forward it
to the maintainers at the Translation Project, is because I've
delegated maintenance of the translation files to them.  If I make a
local change to the *.po files, then they will get overwritten the
next time I run my git-tp-sync script (which is a variant of Karel
Zak's script[1] from util-linux) those changes will get overwritten.

[1] https://github.com/karelzak/util-linux/blob/master/tools/git-tp-sync

It looks like last time this patch was back in March, and it appears I
failed to forward it to Philipp Thomas, who is the person on the
German translation team who takes care of e2fsprogs's de.po file.  My
apologies.  He's cc'ed on this message.

Cheers,

						- Ted

> diff --git a/po/de.po b/po/de.po
> index 4bbaaf9b611d..8a1ee2d716c2 100644
> --- a/po/de.po
> +++ b/po/de.po
> @@ -8610,9 +8610,11 @@ msgid "Bad magic value in profile_file_data_t"
>  msgstr "Ungültige magische Zahl im profile_file_data_t"
>  
>  #: lib/support/plausible.c:118
> +# The second %s refers to a date string ending with a newline. Make the
> +# translated string end with a newline as well to maintain output compatibility.
>  #, c-format
>  msgid "\tlast mounted on %s on %s"
> -msgstr "\tzuletzt auf %s auf %s eingehängt"
> +msgstr "\tzuletzt auf %s auf %seingehängt.\n"
>  
>  #: lib/support/plausible.c:121
>  #, c-format
> -- 
> 2.12.3
> 
