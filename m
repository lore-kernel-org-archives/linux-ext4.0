From: luigi burdo <intermediadc@hotmail.com>
Subject: Re: ext4 filesystem corruption with 4.10-rc2 on ppc64le
Date: Wed, 4 Jan 2017 07:34:00 +0000
Message-ID: <HE1PR01MB1548C63C28DE2F5F06A0EBECC8610@HE1PR01MB1548.eurprd01.prod.exchangelabs.com>
References: <20170104161808.5ad7b4fd@kryten>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="_000_HE1PR01MB1548C63C28DE2F5F06A0EBECC8610HE1PR01MB1548eurp_"
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Anton Blanchard <anton@samba.org>, "jack@suse.cz" <jack@suse.cz>, "Michael
 Ellerman" <mpe@ellerman.id.au>, Benjamin Herrenschmidt
 <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "Stephen
 Rothwell" <sfr@canb.auug.org.au>, "axboe@fb.com" <axboe@fb.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20170104161808.5ad7b4fd@kryten>
Content-Language: it-IT
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-ext4.vger.kernel.org

--_000_HE1PR01MB1548C63C28DE2F5F06A0EBECC8610HE1PR01MB1548eurp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

it is present on ppc not le too.

found it on Ubuntu Mate 16.10 PPC with kernel 4.9 rc6 PPC64 on P5020/P5040


Thanks

Luigi


________________________________
Da: Linuxppc-dev <linuxppc-dev-bounces+intermediadc=3Dhotmail.com@lists.ozl=
abs.org> per conto di Anton Blanchard <anton@samba.org>
Inviato: mercoled=EC 4 gennaio 2017 06.18
A: jack@suse.cz; Michael Ellerman; Benjamin Herrenschmidt; Paul Mackerras; =
Stephen Rothwell; axboe@fb.com
Cc: linux-fsdevel@vger.kernel.org; linux-ext4@vger.kernel.org; linuxppc-dev=
@lists.ozlabs.org; linux-kernel@vger.kernel.org
Oggetto: ext4 filesystem corruption with 4.10-rc2 on ppc64le

Hi,

I'm consistently seeing ext4 filesystem corruption using a mainline
kernel. It doesn't take much to trigger it - download a ppc64le Ubuntu
cloud image, boot it in KVM and run:

sudo apt-get update
sudo apt-get dist-upgrade
sudo reboot

And it never makes it back up, dying with rather severe filesystem
corruption.

I've narrowed it down to:

64e1c57fa474 ("ext4: Use clean_bdev_aliases() instead of iteration")
e64855c6cfaa ("fs: Add helper to clean bdev aliases under a bh and use it")
ce98321bf7d2 ("fs: Remove unmap_underlying_metadata")

Backing these patches out fixes the issue.

Anton

--_000_HE1PR01MB1548C63C28DE2F5F06A0EBECC8610HE1PR01MB1548eurp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Arial,Helvetica,sans-serif;" dir=3D"ltr">
<p>Hi,</p>
<p>it is present on ppc not le too.&nbsp;</p>
<p>found it on Ubuntu Mate 16.10 PPC with kernel 4.9 rc6 PPC64&nbsp;on P502=
0/P5040&nbsp;</p>
<p><br>
</p>
<p>Thanks</p>
<p>Luigi&nbsp;</p>
<br>
<br>
<div style=3D"color: rgb(0, 0, 0);">
<div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>Da:</b> Linuxppc-dev &lt;linu=
xppc-dev-bounces&#43;intermediadc=3Dhotmail.com@lists.ozlabs.org&gt; per co=
nto di Anton Blanchard &lt;anton@samba.org&gt;<br>
<b>Inviato:</b> mercoled=EC 4 gennaio 2017 06.18<br>
<b>A:</b> jack@suse.cz; Michael Ellerman; Benjamin Herrenschmidt; Paul Mack=
erras; Stephen Rothwell; axboe@fb.com<br>
<b>Cc:</b> linux-fsdevel@vger.kernel.org; linux-ext4@vger.kernel.org; linux=
ppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org<br>
<b>Oggetto:</b> ext4 filesystem corruption with 4.10-rc2 on ppc64le</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">Hi,<br>
<br>
I'm consistently seeing ext4 filesystem corruption using a mainline<br>
kernel. It doesn't take much to trigger it - download a ppc64le Ubuntu<br>
cloud image, boot it in KVM and run:<br>
<br>
sudo apt-get update<br>
sudo apt-get dist-upgrade<br>
sudo reboot<br>
<br>
And it never makes it back up, dying with rather severe filesystem<br>
corruption.<br>
<br>
I've narrowed it down to:<br>
<br>
64e1c57fa474 (&quot;ext4: Use clean_bdev_aliases() instead of iteration&quo=
t;)<br>
e64855c6cfaa (&quot;fs: Add helper to clean bdev aliases under a bh and use=
 it&quot;)<br>
ce98321bf7d2 (&quot;fs: Remove unmap_underlying_metadata&quot;)<br>
<br>
Backing these patches out fixes the issue.<br>
<br>
Anton<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_HE1PR01MB1548C63C28DE2F5F06A0EBECC8610HE1PR01MB1548eurp_--
