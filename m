From: Peter Teoh <htmldeveloper@gmail.com>
Subject: Re: Copying Data Blocks
Date: Sun, 11 Jan 2009 23:11:39 +0800
Message-ID: <804dabb00901110711w5061ccedha982792e73d7de1b@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=000e0cd1d53a2fefd3046036685a
Cc: ext4 <linux-ext4@vger.kernel.org>, Kernelnewbies <kernelnewbies@nl.linux.org>
To: Rohit Sharma <imreckless@gmail.com>
Return-path: <kernelnewbies-bounce@nl.linux.org>
In-Reply-To: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
List-Id: linux-ext4.vger.kernel.org

--000e0cd1d53a2fefd3046036685a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here are some tips on the blockdevice API:

http://lkml.org/lkml/2006/1/24/287
http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-01/msg09388.html

as indicated, documentation is rather sparse in this area.

not sure if anyone else have a summary list of blockdevice API and its
explanation?

thanks.


On Tue, Jan 6, 2009 at 6:36 PM, Rohit Sharma <imreckless@gmail.com> wrote:

> I want to read data blocks from one inode
> and copy it to other inode.
>
> I mean to copy data from data blocks associated with one inode
> to the data blocks associated with other inode.
>
> Is that possible in kernel space.?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
Peter Teoh

--000e0cd1d53a2fefd3046036685a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Here are some tips on the blockdevice API:<br><br><a href=3D"http://lkml.or=
g/lkml/2006/1/24/287" target=3D"_blank">http://lkml.org/lkml/2006/1/24/287<=
/a><br><a href=3D"http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-01/m=
sg09388.html">http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-01/msg09=
388.html</a><br>
<br>as indicated, documentation is rather sparse in this area.<br><br>not s=
ure if anyone else have a summary list of blockdevice API and its explanati=
on?<br><br>thanks.<br><br><br><div class=3D"gmail_quote">
On Tue, Jan 6, 2009 at 6:36 PM, Rohit Sharma <span dir=3D"ltr">&lt;<a href=
=3D"mailto:imreckless@gmail.com" target=3D"_blank">imreckless@gmail.com</a>=
&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"border-lef=
t: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1=
ex;">

I want to read data blocks from one inode<br>
and copy it to other inode.<br>
<br>
I mean to copy data from data blocks associated with one inode<br>
to the data blocks associated with other inode.<br>
<br>
Is that possible in kernel space.?<br>
<font color=3D"#888888">--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-ext4&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org" targe=
t=3D"_blank">majordomo@vger.kernel.org</a><br>
More majordomo info at &nbsp;<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Regards,<br>Pete=
r Teoh<br>

--000e0cd1d53a2fefd3046036685a--

--
To unsubscribe from this list: send an email with
"unsubscribe kernelnewbies" to ecartis@nl.linux.org
Please read the FAQ at http://kernelnewbies.org/FAQ
