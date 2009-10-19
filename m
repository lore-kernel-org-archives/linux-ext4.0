From: "Stephen Samuel (gmail)" <darkonc@gmail.com>
Subject: Re: optimising filesystem for many small files
Date: Mon, 19 Oct 2009 00:23:30 -0700
Message-ID: <6cd50f9f0910190023i5d719543n21862725c294aef3@mail.gmail.com>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	<4AD9D599.3000306@redhat.com>
	<84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	<20091017222619.GA10074@mit.edu>
	<84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
	<20091018114100.GA26721@eagle102.home.lan>
	<84c89ac10910180608v76caf7f5y4837ccaf6a66a594@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0409428359=="
Cc: Matija Nalis <mnalis-ml@voyager.hr>, linux-ext4@vger.kernel.org,
	ext3-users@redhat.com
To: Viji V Nair <viji@fedoraproject.org>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <84c89ac10910180608v76caf7f5y4837ccaf6a66a594@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

--===============0409428359==
Content-Type: multipart/alternative; boundary=000e0cd117c865bfcd0476449f96

--000e0cd117c865bfcd0476449f96
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Oct 18, 2009 at 6:08 AM, Viji V Nair <viji@fedoraproject.org> wrote:

> From: Matija Nalis <mnalis-ml@voyager.hr>
>
> On Sun, Oct 18, 2009 at 03:01:46PM +0530, Viji V Nair wrote:
> > The application which we are using are modified versions of mapnik and
> > tilecache, these are single threaded so we are running 4 process at a
>
> How does it scale if you reduce the number or processes - especially if you
> run just one of those ? As this is just a single disk, 4 simultaneous
> readers/writers would probably *totally* kill it with seeks.
>
> I suspect it might even run faster with just 1 process then with 4 of
> them...
>
> with one process it is giving me 6 seconds
>

If it takes 6 seconds with one process and 20 seconds with 4 processes, then
this
pretty clearly points to problems with thrashing the heads.
(this presumes that the timing you're mentioning is time between  request
and
service with the same request patterns).

Others have suggested flash drives... This sounds like an idea.  On the
cheaper end, I'd suggest  lots of mirroring.. The more drives the merrier. a
4-way mirrir will probably give you a good deal of speedup.   If you can
find an old RAID box, try throwing in a dozen or so smaller drives (even 72
or 36GB SCSI drives)..

It sounds like the problem is clearly head seek, not transfer speeds, so
lots of old SCSI drives with a single (slower) connection will probably do
you more good than 4 demon-fast SATA drives.
If you have smaller drives, go to raid10. If you have larger drives, then go
to raid 1 and mirror them up the wazoo.  (I'm presuming that this is a
read-mostly application.  If you're doing lots of parallel writes, then raid
10 might still be a good idea, even with big drives).

If you already have a deep mirror and you later get  Flash drives, then I'd
say add the flash drives into the mix, rather than just replacing the RAID
with flash, again -- unless this isn't a read-mostly situation -- the more
drives the merrier.

Stephen Samuel http://www.bcgreen.com  Software, like love,
778-861-7641                              grows when you give it away

--000e0cd117c865bfcd0476449f96
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Sun, Oct 18, 2009 at 6:08 AM, Viji V =
Nair <span dir=3D"ltr">&lt;<a href=3D"mailto:viji@fedoraproject.org">viji@f=
edoraproject.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.=
8ex; padding-left: 1ex;">
<div class=3D"im">
From: Matija Nalis &lt;<a href=3D"mailto:mnalis-ml@voyager.hr">mnalis-ml@vo=
yager.hr</a>&gt;<br>
<br>
</div><div class=3D"im">On Sun, Oct 18, 2009 at 03:01:46PM +0530, Viji V Na=
ir wrote:<br>
&gt; The application which we are using are modified versions of mapnik and=
<br>
&gt; tilecache, these are single threaded so we are running 4 process at a<=
br>
<br>
How does it scale if you reduce the number or processes - especially if you=
<br>
run just one of those ? As this is just a single disk, 4 simultaneous<br>
readers/writers would probably *totally* kill it with seeks.<br>
<br>
I suspect it might even run faster with just 1 process then with 4 of<br>
them...<br>
<br>
</div>with one process it is giving me 6 seconds<br></blockquote><div><br>I=
f it takes 6 seconds with one process and 20 seconds with 4 processes, then=
 this <br>pretty clearly points to problems with thrashing the heads. <br>
(this presumes that the timing you&#39;re mentioning is time between=A0 req=
uest and <br>service with the same request patterns).<br><br>Others have su=
ggested flash drives... This sounds like an idea.=A0 On the cheaper end, I&=
#39;d suggest=A0 lots of mirroring.. The more drives the merrier. a 4-way m=
irrir will probably give you a good deal of speedup.=A0=A0 If you can find =
an old RAID box, try throwing in a dozen or so smaller drives (even 72 or 3=
6GB SCSI drives).. <br>
<br>It sounds like the problem is clearly head seek, not transfer speeds, s=
o lots of old SCSI drives with a single (slower) connection will probably d=
o you more good than 4 demon-fast SATA drives.=A0 <br>If you have smaller d=
rives, go to raid10. If you have larger drives, then go to raid 1 and mirro=
r them up the wazoo.=A0 (I&#39;m presuming that this is a read-mostly appli=
cation.=A0 If you&#39;re doing lots of parallel writes, then raid 10 might =
still be a good idea, even with big drives).<br>
<br>If you already have a deep mirror and you later get=A0 Flash drives, th=
en I&#39;d say add the flash drives into the mix, rather than just replacin=
g the RAID with flash, again -- unless this isn&#39;t a read-mostly situati=
on -- the more drives the merrier.<br>
</div></div> <br>Stephen Samuel <a href=3D"http://www.bcgreen.com">http://w=
ww.bcgreen.com</a> =A0Software, like love, <br>778-861-7641 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0grows when you give it away<br>

--000e0cd117c865bfcd0476449f96--


--===============0409428359==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ext3-users mailing list
Ext3-users@redhat.com
https://www.redhat.com/mailman/listinfo/ext3-users
--===============0409428359==--
