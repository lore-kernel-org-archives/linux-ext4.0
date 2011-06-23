From: Sean Ryle <seanbo@gmail.com>
Subject: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Thu, 23 Jun 2011 16:55:50 -0400
Message-ID: <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
 <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com> <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
 <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com> <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com> <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
Reply-To: Sean Ryle <seanbo@gmail.com>, 615998@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=0016364c7b8725dcd304a66751b0
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>, "Ted Ts'o" <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.615998.B615998.13088625877913@bugs.debian.org>
In-Reply-To: <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
List-URL: <http://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

--0016364c7b8725dcd304a66751b0
Content-Type: text/plain; charset=ISO-8859-1

Maybe I am wrong here, but shouldn't the cast be to (unsigned long) or to
(sector_t)?

Line 534 of commit.c:
                        jbd_debug(4, "JBD: got buffer %llu (%p)\n",
                                (unsigned long long)bh->b_blocknr,
bh->b_data);

Line 64 of buffer_head.h:
         sector_t b_blocknr;             /* start block number */

Lines 137-143 of include/linux/types/h:
#ifdef CONFIG_LBDAF
typedef u64 sector_t;
typedef u64 blkcnt_t;
#else
typedef unsigned long sector_t;
typedef unsigned long blkcnt_t;
#endif

Is it possible he is experiencing the panic due to a bad cast in the call to
jbd_debug() in fs/jbd2/commit.c?  It would seem to me this should be cast to
(sector_t).  Any thoughts?



On Thu, Jun 23, 2011 at 2:32 PM, Moffett, Kyle D
<Kyle.D.Moffett@boeing.com>wrote:

> Hello again everyone,
>
> I'm in the middle of doing some software testing on a pre-production
> clone of this system using some modified software configurations and a
> testing-only data volume, and I've managed to trigger this panic again.
>
> The trigger was exactly the same; I had a bunch of queued emails from
> logcheck because my TLS configuration was wrong, then I fixed the TLS
> configuration and typed "postqueue -f" to send the queued mail.
>
> Ted, since this new iteration has no customer data, passwords, keys, or
> any other private data, I'm going to try to get approval to release an
> exact EC2 image of this system for you to test with, including the fake
> data volume that I triggered the problem on.
>
> If not I can certainly reproduce it now by stopping email delivery and
> generating a lot of fake syslog spam; I can try applying kernel patches
> and report what happens.
>
> Hopefully you're still willing to help out tracking down the problem?
>
> Thanks again!
>
> Cheers,
> Kyle Moffett
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--0016364c7b8725dcd304a66751b0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Maybe I am wrong here, but shouldn&#39;t the cast be to (unsigned long) or =
to (sector_t)?<br><br>Line 534 of commit.c:<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 jbd_debug(4, &quot;JBD: got buff=
er %llu (%p)\n&quot;,<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (unsigned long long)bh-&gt;b_=
blocknr, bh-&gt;b_data);<br>

<br>Line 64 of buffer_head.h:<br>=A0=A0=A0=A0=A0=A0=A0=A0 sector_t b_blockn=
r;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* start block number */<br><br>Line=
s 137-143 of include/linux/types/h:<br>#ifdef CONFIG_LBDAF<br>typedef u64 s=
ector_t;<br>typedef u64 blkcnt_t;<br>

#else<br>typedef unsigned long sector_t;<br>typedef unsigned long blkcnt_t;=
<br>#endif<br><br>Is it possible he is experiencing the panic due to a bad =
cast in the call to jbd_debug() in fs/jbd2/commit.c?=A0 It would seem to me=
 this should be cast to (sector_t).=A0 Any thoughts?<br>

<br><br><br><div class=3D"gmail_quote">On Thu, Jun 23, 2011 at 2:32 PM, Mof=
fett, Kyle D <span dir=3D"ltr">&lt;<a href=3D"mailto:Kyle.D.Moffett@boeing.=
com">Kyle.D.Moffett@boeing.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex;">

Hello again everyone,<br>
<br>
I&#39;m in the middle of doing some software testing on a pre-production<br=
>
clone of this system using some modified software configurations and a<br>
testing-only data volume, and I&#39;ve managed to trigger this panic again.=
<br>
<br>
The trigger was exactly the same; I had a bunch of queued emails from<br>
logcheck because my TLS configuration was wrong, then I fixed the TLS<br>
configuration and typed &quot;postqueue -f&quot; to send the queued mail.<b=
r>
<br>
Ted, since this new iteration has no customer data, passwords, keys, or<br>
any other private data, I&#39;m going to try to get approval to release an<=
br>
exact EC2 image of this system for you to test with, including the fake<br>
data volume that I triggered the problem on.<br>
<br>
If not I can certainly reproduce it now by stopping email delivery and<br>
generating a lot of fake syslog spam; I can try applying kernel patches<br>
and report what happens.<br>
<br>
Hopefully you&#39;re still willing to help out tracking down the problem?<b=
r>
<br>
Thanks again!<br>
<br>
Cheers,<br>
Kyle Moffett<br>
<font color=3D"#888888">--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-ext4&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</font></blockquote></div><br>

--0016364c7b8725dcd304a66751b0--
