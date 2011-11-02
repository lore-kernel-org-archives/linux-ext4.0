From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Latency writing to an mlocked ext4 mapping
Date: Tue, 1 Nov 2011 18:51:04 -0700
Message-ID: <CALCETrWNCy0VN-rQM-xPksiJ50DW-KM+w2NBprNOPhvnizZW=Q@mail.gmail.com>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
 <ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca> <CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
 <CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
 <CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
 <20111025122618.GA8072@quack.suse.cz> <CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
 <20111031231031.GD10107@quack.suse.cz> <CALCETrViG6t1forOFtO-R=bGABvtLcECxJ8m8Tenv6rwxLg_ew@mail.gmail.com>
 <20111101230320.GH18701@quack.suse.cz> <CALCETrVKHyRtizmTs=4hZzOs+7JLnvv0WtkSLYLDmM0fs2ce-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37337 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1KBBvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 21:51:25 -0400
In-Reply-To: <CALCETrVKHyRtizmTs=4hZzOs+7JLnvv0WtkSLYLDmM0fs2ce-w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 1, 2011 at 4:10 PM, Andy Lutomirski <luto@amacapital.net> w=
rote:
> On Tue, Nov 1, 2011 at 4:03 PM, Jan Kara <jack@suse.cz> wrote:

>>
>> Avoiding IO during a minor fault would be a decent thing which might=
 be
>> worth pursuing. As you properly noted "stable pages during writeback=
"
>> requirement is one obstacle which won't be that trivial to avoid tho=
ugh...
>
> There's an easy solution that would be good enough for me: add a moun=
t
> option to turn off stable pages.
>
> Is the other problem just a race, perhaps? =A0__block_page_mkwrite ca=
lls
> __block_write_begin (which calls get_block, which I think is where th=
e
> latency comes from) *before* wait_on_page_writeback, which means that
> there might not be any space allocated yet.

I think I'm right (other than calling it a race).  If I change my code =
to do:

- map the file (with MCL_FUTURE set)
- fallocate
- dirty all pages
- fsync
- dirty all pages again

in the non-real-time thread, then a short test that was a mediocre
reproducer seems to work.

This is annoying, though -- I'm not generating twice as much write I/O
as I used to.  Is there any way to force the delalloc code to do its
thing without triggering writeback?  I don't think fallocate has this
effect.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
