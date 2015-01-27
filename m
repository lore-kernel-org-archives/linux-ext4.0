From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mke2fs: Fix German translation of mke2fs
Date: Tue, 27 Jan 2015 17:26:19 +0100
Message-ID: <20150127162619.GB29567@quack.suse.cz>
References: <1422350355-21997-1-git-send-email-jack@suse.cz>
 <54C78526.9070502@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbbA0Q0V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:26:21 -0500
Content-Disposition: inline
In-Reply-To: <54C78526.9070502@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue 27-01-15 13:31:34, Bernd Schubert wrote:
> On 01/27/2015 10:19 AM, Jan Kara wrote:
> > When a device mke2fs should work on already contains an ext? filesystem,
> > mke2fs prints a warning. In German translation the warning doesn't end
> > with a date string (which is terminated by a newline) and thus the
> > output comes out mangled like:
> > 
> > mke2fs 1.42.12 (29-Aug-2014)
> > /dev/disk/by-label/WD20_SL12 hat ein ext3-Dateisystem mit Namen
> > „WD20_SL12“
> >         zuletzt auf /WD20_SL12 auf Tue Jan 27 09:01:44 2015
> >  eingehängtTrotzdem fortfahren? (j,n)
> > ^^^^^^^^^^^^^ here
> > 
> > Fix the translation to end the printed string with a newline and avoid
> > superfluous space at the beginning of the line.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  po/de.po | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/po/de.po b/po/de.po
> > index fd96bb17f712..cf34daf428f2 100644
> > --- a/po/de.po
> > +++ b/po/de.po
> > @@ -5778,9 +5778,11 @@ msgid "Proceed anyway? (y,n) "
> >  msgstr "Trotzdem fortfahren? (j,n) "
> >  
> >  #: misc/util.c:132
> > +# The second %s refers to a date string ending with a newline. Make the
> > +# translated string end with a newline as well to maintain output compatibility.
> >  #, c-format
> >  msgid "\tlast mounted on %s on %s"
> > -msgstr "\tzuletzt auf %s auf %s eingehängt"
> > +msgstr "\tzuletzt auf %s auf %seingehängt.\n"
> 
> I never checked translation before, but if you already change that,
> could you please change it to "am %s eingehängt"? So
> 
> -msgstr "\tzuletzt auf %s auf %s eingehängt"
> +msgstr "\tzuletzt auf %s am %seingehängt.\n"
  OK, no problem.

> Now does the date string always end with a white space, or should that
> better be
  ctime() always ends the date string with '\n'. That's why I removed ' '
from the German format string.

> +msgstr "\tzuletzt auf %s am %s eingehängt.\n"
> 
> Also, the date string is in English, shouldn't that be localized either?
  I'd expect that output of ctime() is localized (LC_TIME?). If it's not,
I don't think it's a job of e2fsprogs to fix that...

  New patch attached.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--ReaqsoxgOBHFXBhH
Content-Type: text/x-patch; charset=utf-8
Content-Disposition: attachment; filename="0001-mke2fs-Fix-German-translation-of-mke2fs.patch"
Content-Transfer-Encoding: 8bit

>From a322e0862cbbaf37e134b46e9aa0e9b9a0c01c81 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 27 Jan 2015 10:04:52 +0100
Subject: [PATCH] mke2fs: Fix German translation of mke2fs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a device mke2fs should work on already contains an ext? filesystem,
mke2fs prints a warning. In German translation the warning doesn't end
with a date string (which is terminated by a newline) and thus the
output comes out mangled like:

mke2fs 1.42.12 (29-Aug-2014)
/dev/disk/by-label/WD20_SL12 hat ein ext3-Dateisystem mit Namen
„WD20_SL12“
        zuletzt auf /WD20_SL12 auf Tue Jan 27 09:01:44 2015
 eingehängtTrotzdem fortfahren? (j,n)
^^^^^^^^^^^^^ here

Fix the translation to end the printed string with a newline and avoid
superfluous space at the beginning of the line.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 po/de.po | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/po/de.po b/po/de.po
index fd96bb17f712..40f3fb439564 100644
--- a/po/de.po
+++ b/po/de.po
@@ -5778,9 +5778,11 @@ msgid "Proceed anyway? (y,n) "
 msgstr "Trotzdem fortfahren? (j,n) "
 
 #: misc/util.c:132
+# The second %s refers to a date string ending with a newline. Make the
+# translated string end with a newline as well to maintain output compatibility.
 #, c-format
 msgid "\tlast mounted on %s on %s"
-msgstr "\tzuletzt auf %s auf %s eingehängt"
+msgstr "\tzuletzt auf %s am %seingehängt.\n"
 
 #: misc/util.c:135
 #, c-format
-- 
2.1.2


--ReaqsoxgOBHFXBhH--
