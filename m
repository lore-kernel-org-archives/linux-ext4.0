From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in start_this_handle()
 to control allocation flags.
Date: Mon, 20 Jun 2011 11:08:30 -0700
Message-ID: <BANLkTi=AQA5h3J6+pPA_L=_1OEUm61900A@mail.gmail.com>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com> <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org> <20110602095424.GA5718@quack.suse.cz>
 <20110606032113.GC7180@thunk.org> <20110608141006.GG30037@thunk.org>
 <BANLkTikVuPx8F8DSdjFxZyR8ZA0ts3hQ_w@mail.gmail.com> <20110620143201.GD4810@quack.suse.cz>
 <BANLkTi=nZrq9ZfU3G=YS6ZmZMhhD5g+tCg@mail.gmail.com> <20110620175720.GD32133@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61026 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1FTSIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 14:08:51 -0400
Received: by qwk3 with SMTP id 3so915153qwk.19
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 11:08:50 -0700 (PDT)
In-Reply-To: <20110620175720.GD32133@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 10:57 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 20, 2011 at 07:40:53AM -0700, Manish Katiyar wrote:
>> > =A0OK, after my discussion with Ted today, i_mutex really shouldn'=
t be an
>> > issue so your patch should be fine. I just suggest you resend it t=
o Ted to
>> > remind yourself :).
>>
>> Thanks a lot Jan, Will resend the series to Ted.
>
> Thanks, but don't bother resending it unless you have any changes to
> update.

Thanks Ted, ... I don't have any other changes.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
