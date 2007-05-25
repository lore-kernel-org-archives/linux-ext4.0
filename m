From: coly <colyli@gmail.com>
Subject: Re: it seems Evolution remove the Tabs
Date: Fri, 25 May 2007 14:42:21 +0800
Message-ID: <1180075342.4136.4.camel@coly-t43.site>
References: <1179943606.4179.53.camel@coly-t43.site>
	 <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
	 <1180018046.4078.2.camel@coly-t43.site>
	 <Pine.LNX.4.61.0705241826070.31549@yvahk01.tjqt.qr>
	 <20070525013003.GA2429@localhost.localdomain>
	 <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
	 <1180073061.4136.3.camel@coly-t43.site>
	 <d45a3acc0705242333v1f4c65d4x92b0167d51e3b1a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	WANG Cong <xiyou.wangcong@gmail.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: andrew hendry <andrew.hendry@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:20619 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbXEYGmZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 May 2007 02:42:25 -0400
Received: by ug-out-1314.google.com with SMTP id j3so1048685ugf
        for <linux-ext4@vger.kernel.org>; Thu, 24 May 2007 23:42:00 -0700 (PDT)
In-Reply-To: <d45a3acc0705242333v1f4c65d4x92b0167d51e3b1a6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew,

Thanks for your information :-)

Coly


=E5=9C=A8 2007-05-25=E4=BA=94=E7=9A=84 16:33 +1000=EF=BC=8Candrew hendr=
y=E5=86=99=E9=81=93=EF=BC=9A
> select your whole mail and use pre-format in evolution.
> or change it to pre-format and do insert->text file.
> this should send it with tabs intact, the confusing bit i think is if
> your testing it by sending it to yourself, then you cant see the tabs
> again.
>=20
> Read it in another mailer, something like sylpheed or mutt to see if
> the tabs are really there.
>=20
> On 5/25/07, coly <colyli@gmail.com> wrote:
> > Hi,
> >
> > I tested again, it seems Evolution removes the Tabs with blanks.
> > How to resolve this issue on Evolution ?  I am trying :-)
> >
> > Coly
> >
> > =E5=9C=A8 2007-05-25=E4=BA=94=E7=9A=84 07:52 +0200=EF=BC=8CJan Enge=
lhardt=E5=86=99=E9=81=93=EF=BC=9A
> > > On May 25 2007 09:30, WANG Cong wrote:
> > > >>>
> > > >>>Yes, I found all TABs gone when I received the mail. When I po=
st next
> > > >>>version of the patch, I will test to send to me first :-)
> > > >>>
> > > >>>Thanks for your information.
> > > >>
> > > >>Blame Gmail.
> > > >
> > > >I am using gmail too. That's not gmail's fault,
> > >
> > > Then it is one of these:
> > > - gmail's default settings for web input sucks or
> > >
> > > - the web browser reformats it
> > >   (not so much - pastebin.ca suffers from something similar, but =
*not the
> > >   same*; in that it translates all tabs into spaces, but at least=
 it keeps
> > >   the width.) or
> > >
> > > - you are using your own client, and directly SMTPing gmail serve=
rs,
> > >   in which case unwanted reformatting by broken MTAs can be bypas=
sed.
> > >
> > > >I think your email client sucks.
> > > >So which email client are you using, coly? I recommend mutt to y=
ou. ;)
> > >
> > > X-Mailer:      Evolution 2.6.0
> > >
> > > Hm, this looks like another of these "Thunderbird" cases. (Means,
> > > Thunderbird users also get their patches wrapped and twangled unl=
ess
> > > they set some option that is not on by default.)
> > >
> > >
> > >       Jan
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ker=
nel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
