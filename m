From: David Newall <davidn@davidnewall.com>
Subject: Re: Zero length files - an alternative approach?
Date: Mon, 30 Mar 2009 06:46:42 +1030
Message-ID: <49CFD72A.5010107@davidnewall.com>
References: <87bprka9sg.fsf@newton.gmurray.org.uk> <yw1xab744lqi.fsf@thrashbarg.mansr.com> <49CF636A.3030400@ursus.ath.cx> <yw1x1vsg4jio.fsf@thrashbarg.mansr.com> <20090329134901.GB13737@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755997AbZC2URD@vger.kernel.org>
In-Reply-To: <20090329134901.GB13737@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Pavel Machek wrote:
> fsync() is easy. But some people _want_ to have either newdata _or_
> olddata, but don't care which one, and would prefer to avoid
> fsync. That's where replace() should help...

Most people, I wager, care more about their code being portable than
they do about leaping through a Linux-specific hoop.  They're not going
to use replace; not ever; that's what link/unlink is for.

If you think it's reasonable to modify every instance in applications
where a sudden crash would cause data loss, why not make a mount-time
flag that does all of that in FS; and for the other 99% of users, it
doesn't, but runs faster?
