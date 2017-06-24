From: "Vladimir 'phcoder' Serbinenko" <phcoder@gmail.com>
Subject: Re: Possible regression in e2fsprogs-1.43.4
Date: Sat, 24 Jun 2017 21:31:38 +0000
Message-ID: <CAEaD8JONcxwx8fCwjs5PswxkbF4xAQ9aR8NZ1JVad8NYRo=J+g@mail.gmail.com>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
	<20170623195318.cfs4ftpmy5nhcccy@thunk.org>
	<20170623232935.13fa4688@leda>
	<048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2762779052862317798=="
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: The development of GNU GRUB <grub-devel@gnu.org>,
	Christian Hesse <list@eworm.de>
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
In-Reply-To: <048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/archive/html/grub-devel/>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Sender: "Grub-devel" <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
List-Id: linux-ext4.vger.kernel.org

--===============2762779052862317798==
Content-Type: multipart/alternative; boundary="94eb2c0ef5980f27df0552bb724c"

--94eb2c0ef5980f27df0552bb724c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D1=81=D0=B1, 24 =D0=B8=D1=8E=D0=BD. 2017 =D0=B3., 23:22 Felipe A Rodriguez=
 <far@illumenos.com>:

> On Jun 23, 2017, at 11:29 PM, Christian Hesse <list@eworm.de> wrote:
>
> > Theodore Ts'o <tytso@mit.edu> on Fri, 2017/06/23 15:53:
> >> +grub-devel
> >>
> >> On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote:
> >>> Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the boot
> >>> loader to fail (unknown filesystem error) on the x86_64 VM I use for
> >>> initial testing.  I traced the problem to changes in the e2fsprogs
> >>> configuration file which now sets 64 bit flags.  I tried upgrading
> >>> to GRUB 2.02 but that did not resolve the problem.  Reverting the
> >>> changes per the patch below fixes the problem.
> >>
> >> Hmm, my laptop has been using a file system with the 64-bit feature
> >> enabled for quite some time, and my Debian Stretch system has been
> >> using Grub 2.02 to boot my system without any difficulties.
> >>
> >> I've done a quick check of the Debian patches and none of them seem to
> >> modify Grub's ext2/ext4 file system implementation.  So I don't know
> >> what to tell you.  Are you sure you properly reinstalled grub on the
> >> boot device after you upgraded to grub 2.02?
> >
>
> Yes.  I did not upgrade the test VM directly.  I replaced GRUB 2.00 with
> 2.02 in my build automation which creates an installer ISO.  Installation
> onto the VM is also largely automated.  GRUB 2.02 (and 2.00) work fine if=
 I
> revert the config file to that in 1.42.13.
>
Do you mean grub is unable to read some files ? Can you try, recreating it
with grub-fstest? Can you upload failing image somewhere?

>
> To be clear:  I don=E2=80=99t believe any of the code changes between 1.4=
2.13 and
> 1.43.4 cause this issue.  The problem arises from just the changes in the
> built-in default configuration file that gets installed.  A distro that
> uses its own custom configuration file may not encounter this issue.
>
>
> > Grub should be fine, however syslinux still suffers issues with 64-bit
> > feature. Possibly you use a chain to load syslinux first, grub second?
>
> Yes, my test VM is configured to chain load GRUB from Syslinux
> (ISOLINUX).  I don=E2=80=99t recall whether I tried booting directly into=
 GRUB so I
> will test that tomorrow.
>
>
>
>
>
> Regards,
>
> Felipe
>
> _______________________________________________
> Grub-devel mailing list
> Grub-devel@gnu.org
> https://lists.gnu.org/mailman/listinfo/grub-devel
>

--94eb2c0ef5980f27df0552bb724c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote"><div dir=3D"ltr">=D1=81=D0=B1, 24 =D0=B8=
=D1=8E=D0=BD. 2017 =D0=B3., 23:22 Felipe A Rodriguez &lt;<a href=3D"mailto:=
far@illumenos.com">far@illumenos.com</a>&gt;:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">On Jun 23, 2017, at 11:29 PM, Christian Hesse &lt;<a href=3D"mai=
lto:list@eworm.de" target=3D"_blank">list@eworm.de</a>&gt; wrote:<br>
<br>
&gt; Theodore Ts&#39;o &lt;<a href=3D"mailto:tytso@mit.edu" target=3D"_blan=
k">tytso@mit.edu</a>&gt; on Fri, 2017/06/23 15:53:<br>
&gt;&gt; +grub-devel<br>
&gt;&gt;<br>
&gt;&gt; On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote=
:<br>
&gt;&gt;&gt; Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes th=
e boot<br>
&gt;&gt;&gt; loader to fail (unknown filesystem error) on the x86_64 VM I u=
se for<br>
&gt;&gt;&gt; initial testing.=C2=A0 I traced the problem to changes in the =
e2fsprogs<br>
&gt;&gt;&gt; configuration file which now sets 64 bit flags.=C2=A0 I tried =
upgrading<br>
&gt;&gt;&gt; to GRUB 2.02 but that did not resolve the problem.=C2=A0 Rever=
ting the<br>
&gt;&gt;&gt; changes per the patch below fixes the problem.<br>
&gt;&gt;<br>
&gt;&gt; Hmm, my laptop has been using a file system with the 64-bit featur=
e<br>
&gt;&gt; enabled for quite some time, and my Debian Stretch system has been=
<br>
&gt;&gt; using Grub 2.02 to boot my system without any difficulties.<br>
&gt;&gt;<br>
&gt;&gt; I&#39;ve done a quick check of the Debian patches and none of them=
 seem to<br>
&gt;&gt; modify Grub&#39;s ext2/ext4 file system implementation.=C2=A0 So I=
 don&#39;t know<br>
&gt;&gt; what to tell you.=C2=A0 Are you sure you properly reinstalled grub=
 on the<br>
&gt;&gt; boot device after you upgraded to grub 2.02?<br>
&gt;<br>
<br>
Yes.=C2=A0 I did not upgrade the test VM directly.=C2=A0 I replaced GRUB 2.=
00 with 2.02 in my build automation which creates an installer ISO.=C2=A0 I=
nstallation onto the VM is also largely automated.=C2=A0 GRUB 2.02 (and 2.0=
0) work fine if I revert the config file to that in 1.42.13.<br></blockquot=
e></div><div>Do you mean grub is unable to read some files ? Can you try, r=
ecreating it with grub-fstest? Can you upload failing image somewhere?</div=
><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
To be clear:=C2=A0 I don=E2=80=99t believe any of the code changes between =
1.42.13 and 1.43.4 cause this issue.=C2=A0 The problem arises from just the=
 changes in the built-in default configuration file that gets installed.=C2=
=A0 A distro that uses its own custom configuration file may not encounter =
this issue.<br>
<br>
<br>
&gt; Grub should be fine, however syslinux still suffers issues with 64-bit=
<br>
&gt; feature. Possibly you use a chain to load syslinux first, grub second?=
<br>
<br>
Yes, my test VM is configured to chain load GRUB from Syslinux (ISOLINUX).=
=C2=A0 I don=E2=80=99t recall whether I tried booting directly into GRUB so=
 I will test that tomorrow.<br>
<br>
<br>
<br>
<br>
<br>
Regards,<br>
<br>
Felipe<br>
<br>
_______________________________________________<br>
Grub-devel mailing list<br>
<a href=3D"mailto:Grub-devel@gnu.org" target=3D"_blank">Grub-devel@gnu.org<=
/a><br>
<a href=3D"https://lists.gnu.org/mailman/listinfo/grub-devel" rel=3D"norefe=
rrer" target=3D"_blank">https://lists.gnu.org/mailman/listinfo/grub-devel</=
a><br>
</blockquote></div>

--94eb2c0ef5980f27df0552bb724c--


--===============2762779052862317798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Grub-devel mailing list
Grub-devel@gnu.org
https://lists.gnu.org/mailman/listinfo/grub-devel

--===============2762779052862317798==--
