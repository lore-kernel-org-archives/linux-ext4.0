From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in start_this_handle()
 to control allocation flags.
Date: Sun, 5 Jun 2011 17:12:24 -0700
Message-ID: <BANLkTinW+uttKb+NJeZduCtRzSmfd4chpA@mail.gmail.com>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com> <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org> <20110602095424.GA5718@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50147 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1FFAMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jun 2011 20:12:45 -0400
Received: by qwk3 with SMTP id 3so1444089qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 05 Jun 2011 17:12:44 -0700 (PDT)
In-Reply-To: <20110602095424.GA5718@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 2, 2011 at 2:54 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 31-05-11 18:27:20, Ted Tso wrote:
>> On Tue, May 31, 2011 at 01:22:53PM +0200, Jan Kara wrote:
>> >
>> > The problem is that with ext4, we need i_mutex in io completion pa=
th to
>> > end page writeback. So we cannot do GFP_KERNEL allocation whenever=
 we hold
>> > i_mutex because mm might wait in direct reclaim for IO to complete=
 and that
>> > cannot happen until we release i_mutex.
>>
>> OK, maybe I'm being dense, but I'm not seeing it. =A0I see where we =
need
>> i_mutex on the ext4_da_writepages() codepath, but that's never used
>> for direct reclaim. =A0Direct reclaim only calls ext4_writepage(), a=
nd
>> that doesn't seem to try to grab i_mutex as near as I can tell. =A0A=
m I
>> missing something?
> =A0What happens is that direct reclaim sometimes does
> wait_on_page_writeback() (e.g. shrink_page_list()) or it explicitely =
waits
> for NR_WRITEBACK statistics to go below some threshold
> (throttle_vm_writeout()). And that is deadlockable if we hold i_mutex=
 while
> doing this because we may need i_mutex to actually move the page from
> PageWriteback state...
>
> As I'm saying this, I've realized ext4 has this problem also with
> stable-pages patches because there we can wait for PageWriteback in
> grab_cache_page_write_begin() when we also hold i_mutex. So I think w=
e'll
> have to come up with a way to convert unwritten extents without havin=
g to
> hold i_mutex. That's going to be interesting.

Hi Jan/Ted,

Does that mean I should remove the whole JBD2_TOPLEVEL thing from my
revised patch ? Or should I fix it as per your feedback in
the other patch ?

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
