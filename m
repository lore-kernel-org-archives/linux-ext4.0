From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [RFC][PATCH 0/6] Enhanced file stat system call
Date: Fri, 13 May 2016 07:28:29 -0700
Message-ID: <CACyXjPw-dY4o4O_ZXzeb9R-akmE-r1uAQ7Sd-dGYegkG932yqw@mail.gmail.com>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
	<CAH2r5mvWHwmqkzyfjHro__dWf-9ZAskPHgHDGS22jNzXZVQ4iA@mail.gmail.com>
	<CAH2r5muL336k178DJHxKByfbGMMc=_m5jsCctgRQCc1H+SRSQg@mail.gmail.com>
	<4211584.odaTcq8sN6@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench@gmail.com>,
	David Howells <dhowells@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-afs@vger.kernel.org,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Deepa Dinamani <deepa.kernel@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4211584.odaTcq8sN6@wuerfel>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 9, 2016 at 6:09 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 05 May 2016 21:00:18 Steve French wrote:
>> On Thu, May 5, 2016 at 5:54 PM, Steve French <smfrench@gmail.com> wr=
ote:
>> > On Wed, May 4, 2016 at 8:46 AM, Arnd Bergmann <arnd@arndb.de> wrot=
e:
>> >> On Friday 29 April 2016 13:57:36 David Howells wrote:
>> >>> struct statx *buffer);
>> >>>
>> >>> This is an enhanced file stat function that provides a number of=
 useful
>> >>> features, in summary:
>> >>>
>> >>> (1) More information: creation time, data version number, inode
>> >>> generation
>> >>> number and flags. A subset of these is available through a numbe=
r of
>> >>> filesystems (such as CIFS, NFS, AFS, Ext4 and BTRFS).
>> >>>
>> >>
>> >> I have a question about birthtime/creationtime: As we are gaining=
 a way
>> >> to read this, should we also provide a way to update it using a n=
ew
>> >> variant
>> >> of the utimensat syscall in order to have 'cp -a' create an ident=
ical
>> >> copy,
>> >> or is the idea that this is defined as the time that is particula=
r copy
>> >> of the inode was created?
>> >>
>> >> I've discussed this with Deepa in the past, as she is driving the
>> >> convertion of the inode timestamps to timespec64 now, and we will
>> >> need a new version of utimensat for her work as well. I can see g=
ood
>> >> reasons either way (allowing updates of btime or disallowing them=
).
>> >
>> It would help interop with Windows (and presumably Mac) if birth tim=
e can be
>> updated
>
> Ok, thanks. That is certainly a good reason in favor.
>
> If nothing else comes up, I guess we can prepare a patch for a new
> utimensat variant to do this and wait for more comments on that.
>
>         Arnd

Isn't there also a strong case for a setattr call that allows us to
atomically set a collection of attributes from userspace?

It would seem that network file systems (the clients) could use such fe=
atures.

--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
