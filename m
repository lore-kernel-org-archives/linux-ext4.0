From: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Date: Thu, 13 Dec 2018 13:38:36 +0300
Message-ID: <aep9ef-6rt.ln1@banana.localnet>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net> <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet> <2547416.7Vy7A2kRpU@siriux> <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com> <cbdb2e6b-31a2-1e19-f51f-067dcbdcf183@mailbox.org> <CA+PODjpLRuc1u4SNSRqfWtx+Z+C8NGi6fs7yFuyKK0DwHggEdg@mail.gmail.com> <de67b507-ca54-e827-867e-76d57e531cb9@mailbox.org> <CA+PODjrT=pXg-jbhk=q=M6j6-v0x+c05s4Lmi3+MLm0P4iirqg@mail.gmail.com> <20181211001158.GA20388@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In gmane.comp.file-systems.ext4 Pavel Machek <pavel@ucw.cz> wrote:
> [-- text/plain, кодировка quoted-printable, кодировка: us-ascii, 32 строк --]

> Hi!

> > > >> OK, - and now we are looking forward to *your* ideas how to solve this.
> > > >
> > > > After four days playing games around git bisect - real winner is
> > > > debian gcc-8.2.0-9. Upgrade it to 8.2.0-10 or use 7.3.0-30 version for
> > > > same kernel + config - does not exhibit ext4 corruption.
> > > >
> > > > I think I hit this https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87859
> > > > with 8.2.0-9 version.
> > > >
> > > Good that it works for you. But others used gcc 5.4.0 or 6.3.0 and were
> > > hit anyway: https://bugzilla.kernel.org/show_bug.cgi?id=201685#c165
> > 
> > Depends on workload pattern. 4.19.5 built with 8.2.0-10 and 7.3.0-30 -
> > crashed after 4 hours of usage (previous build crash in 5 min).
> > So my assumption about broken gcc is wrong.

> Would it be possible to try vanilla 4.19? (Not stable?)

> I test vanilla and -next kernels every week or two, and did not have
> ext4 problems recently. I guess many kernel developers test mainline
> but not stable...

Fix already commited to stable/vanilla brances:
https://bugzilla.kernel.org/show_bug.cgi?id=201685#c314
