From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Zero length files - an alternative approach?
Date: Sun, 29 Mar 2009 15:49:01 +0200
Message-ID: <20090329134901.GB13737@elf.ucw.cz>
References: <87bprka9sg.fsf@newton.gmurray.org.uk> <yw1xab744lqi.fsf@thrashbarg.mansr.com> <49CF636A.3030400@ursus.ath.cx> <yw1x1vsg4jio.fsf@thrashbarg.mansr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: M?ns Rullg?rd <mans@mansr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35835 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZC2NtJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Mar 2009 09:49:09 -0400
Content-Disposition: inline
In-Reply-To: <yw1x1vsg4jio.fsf@thrashbarg.mansr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 2009-03-29 13:10:23, M?ns Rullg?rd wrote:
> "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx> writes:
> 
> > On 29.03.2009 13:22 M?ns Rullg?rd wrote:
> >> Consider this scenario:
> >>
> >> 1. Create/write/close newfile
> >> 2. Rename newfile to oldfile
> >> 3. Open/read oldfile.  This must return the new contents.
> >> 4. System crash and reboot before delayed allocation/flush complete
> >> 5. Open/read oldfile.  Old contents now returned.
> >>
> >> This rollback isn't obviously, to me at least, without problems of its
> >> own.
> >>   
> > Having the old data in 5) is far better than having no data in 5).
> 
> Of course having old data is better than no data.  However, fsync()
> and similar approaches make a rollback to old data after new data has
> been visible impossible or far less likely than the suggested one.

Untrue. Unless you fsync after rename, you can get olddata.

fsync() is easy. But some people _want_ to have either newdata _or_
olddata, but don't care which one, and would prefer to avoid
fsync. That's where replace() should help...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
