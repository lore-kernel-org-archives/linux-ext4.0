From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: - jbd-strictly-check-for-write-errors-on-data-buffers.patch removed from -mm tree
Date: Mon, 14 Jul 2008 10:10:44 -0400
Message-ID: <170fa0d20807140710o29af31b5q7a0b268e3c6494b1@mail.gmail.com>
References: <200806092212.m59MC553010889@imap1.linux-foundation.org>
	 <484E4097.2010204@hitachi.com>
	 <20080610021746.51e5cfa8.akpm@linux-foundation.org>
	 <170fa0d20807140708k46f86ac1tfee50d3fa14e3e41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Satoshi OSHIMA" <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>,
	"Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:20923 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYGNOKs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 10:10:48 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2395810ywe.1
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 07:10:45 -0700 (PDT)
In-Reply-To: <170fa0d20807140708k46f86ac1tfee50d3fa14e3e41@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

gah, I had html enabled... resend.

On Mon, Jul 14, 2008 at 10:08 AM, Mike Snitzer <snitzer@gmail.com> wrote:
>
>
> On Tue, Jun 10, 2008 at 5:17 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Tue, 10 Jun 2008 17:51:35 +0900 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
>>
>> > Hello Andrew,
>> >
>> > akpm@linux-foundation.org wrote:
>> >
>> > > The patch titled
>> > >      jbd: strictly check for write errors on data buffers
>> > > has been removed from the -mm tree.  Its filename was
>> > >      jbd-strictly-check-for-write-errors-on-data-buffers.patch
>> > >
>> > > This patch was dropped because I don't think we want to go read-only on file data write errors
>> > >
>> > > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>> > >
>> > > ------------------------------------------------------
>> > > Subject: jbd: strictly check for write errors on data buffers
>> > > From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>> >
>> > This patch series doesn't change the behavior on file data write
>> > errors as I stated before, but we found that the current behavior has
>> > been made accidentally.  So yesterday I sent an additional patch(*)
>> > which removes the invocation of journal_abort() and thus stop making
>> > the fs read-only on file data write errors, but it seems to be late
>> > for the -mm release preparation.
>> >
>> >   Patch(*) can be found at:
>> >   http://marc.info/?l=linux-kernel&m=121300618614453&w=2
>> >
>> > Anyway, as this patch series was dropped from -mm, I'm going to
>> > send a revised version.
>> >
>> > I plan to separate these pathces into three patche set.
>> > The first patch (set) corrects the current behavior in ordered
>> > writes, it means it removes the invocation of journal_abort() on file
>> > data write errors.  It is the almost same as the patch(*).
>> > The second patch set fixes error handlings for metadata writes and
>> > checkpointing.  It should be applied independently of the first
>> > patch set, and it is the same as PATCH 3/5 to 5/5.
>> > The third patch set makes "abort the journal on file data write errors"
>> > tunable for mission critical users.  Of course, this feature depends
>> > on the first patch set.
>> >
>>
>> That sounds like a good plan, thanks.
>
> Hidehiro and Andrew,
>
> The first patch(set) has been in -mm with the following patches:
> jbd-dont-abort-if-flushing-file-data-failed.patch
> jbd-dont-abort-if-flushing-file-data-failed-fix.patch
>
> "PATCH 3/5 to 5/5" haven't made their way into -mm; nor has the tunable "abort the journal on file data write errors".  Where do things stand on this work?
>
> Given the potential for corruption and the fact that -mm's series file justifiably has a place-holder comment of "jbd write-error stuff: scary" I'm wondering: how soon will all associated fixes be included in -mm?
>
> regards,
> Mike
