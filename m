From: coly <colyli@gmail.com>
Subject: it seems Evolution remove the Tabs
Date: Fri, 25 May 2007 14:04:21 +0800
Message-ID: <1180073061.4136.3.camel@coly-t43.site>
References: <1179943606.4179.53.camel@coly-t43.site>
	 <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
	 <1180018046.4078.2.camel@coly-t43.site>
	 <Pine.LNX.4.61.0705241826070.31549@yvahk01.tjqt.qr>
	 <20070525013003.GA2429@localhost.localdomain>
	 <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759933AbXEYGDs@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I tested again, it seems Evolution removes the Tabs with blanks.
How to resolve this issue on Evolution ?  I am trying :-)

Coly

=E5=9C=A8 2007-05-25=E4=BA=94=E7=9A=84 07:52 +0200=EF=BC=8CJan Engelhar=
dt=E5=86=99=E9=81=93=EF=BC=9A
> On May 25 2007 09:30, WANG Cong wrote:
> >>>
> >>>Yes, I found all TABs gone when I received the mail. When I post n=
ext
> >>>version of the patch, I will test to send to me first :-)
> >>>
> >>>Thanks for your information.
> >>
> >>Blame Gmail.
> >
> >I am using gmail too. That's not gmail's fault,
>=20
> Then it is one of these:
> - gmail's default settings for web input sucks or
>=20
> - the web browser reformats it
>   (not so much - pastebin.ca suffers from something similar, but *not=
 the
>   same*; in that it translates all tabs into spaces, but at least it =
keeps
>   the width.) or
>=20
> - you are using your own client, and directly SMTPing gmail servers,
>   in which case unwanted reformatting by broken MTAs can be bypassed.
>=20
> >I think your email client sucks.
> >So which email client are you using, coly? I recommend mutt to you. =
;)
>=20
> X-Mailer:	 Evolution 2.6.0
>=20
> Hm, this looks like another of these "Thunderbird" cases. (Means,
> Thunderbird users also get their patches wrapped and twangled unless
> they set some option that is not on by default.)
>=20
>=20
> 	Jan
