From: "rishi agrawal" <postrishi@gmail.com>
Subject: Re: Copying Data Blocks
Date: Tue, 6 Jan 2009 19:42:34 +0530
Message-ID: <5feb302e0901060612p4e114953pb6e297778aa7c0a4@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
	 <ea11fea30901060524n559a48f1h85bbf27be5b30b50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_186753_25025349.1231251154659"
Cc: "Rohit Sharma" <imreckless@gmail.com>, ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Manish Katiyar" <mkatiyar@gmail.com>
Return-path: <kernelnewbies-bounce@nl.linux.org>
In-Reply-To: <ea11fea30901060524n559a48f1h85bbf27be5b30b50@mail.gmail.com>
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

------=_Part_186753_25025349.1231251154659
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

yes i suppose the donor inode is known
moreover the receiver inode's number is also known

On Tue, Jan 6, 2009 at 6:54 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:

> On Tue, Jan 6, 2009 at 4:06 PM, Rohit Sharma <imreckless@gmail.com> wrote:
> > I want to read data blocks from one inode
> > and copy it to other inode.
> >
> > I mean to copy data from data blocks associated with one inode
> > to the data blocks associated with other inode.
>
> Copying 4K chunk of data itself is a costly operation. and depending
> on the size of your donor inode this can be huge . Why do you want to
> do that ? Do you know the inode of the donor inode ?
>
> thanks -
> Manish
> >
> > Is that possible in kernel space.?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
Rishi B. Agrawal

------=_Part_186753_25025349.1231251154659
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

yes i suppose the donor inode is known<div><br></div><div>moreover the receiver inode&#39;s number is also known<br><br><div class="gmail_quote">On Tue, Jan 6, 2009 at 6:54 PM, Manish Katiyar <span dir="ltr">&lt;<a href="mailto:mkatiyar@gmail.com">mkatiyar@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;"><div class="Ih2E3d">On Tue, Jan 6, 2009 at 4:06 PM, Rohit Sharma &lt;<a href="mailto:imreckless@gmail.com">imreckless@gmail.com</a>&gt; wrote:<br>

&gt; I want to read data blocks from one inode<br>
&gt; and copy it to other inode.<br>
&gt;<br>
&gt; I mean to copy data from data blocks associated with one inode<br>
&gt; to the data blocks associated with other inode.<br>
<br>
</div>Copying 4K chunk of data itself is a costly operation. and depending<br>
on the size of your donor inode this can be huge . Why do you want to<br>
do that ? Do you know the inode of the donor inode ?<br>
<br>
thanks -<br>
<font color="#888888">Manish<br>
</font><div><div></div><div class="Wj3C7c">&gt;<br>
&gt; Is that possible in kernel space.?<br>
&gt; --<br>
&gt; To unsubscribe from this list: send the line &quot;unsubscribe linux-ext4&quot; in<br>
&gt; the body of a message to <a href="mailto:majordomo@vger.kernel.org">majordomo@vger.kernel.org</a><br>
&gt; More majordomo info at &nbsp;<a href="http://vger.kernel.org/majordomo-info.html" target="_blank">http://vger.kernel.org/majordomo-info.html</a><br>
&gt;<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-ext4&quot; in<br>
the body of a message to <a href="mailto:majordomo@vger.kernel.org">majordomo@vger.kernel.org</a><br>
More majordomo info at &nbsp;<a href="http://vger.kernel.org/majordomo-info.html" target="_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</div></div></blockquote></div><br><br clear="all"><br>-- <br>Regards,<br>Rishi B. Agrawal<br><br>
</div>

------=_Part_186753_25025349.1231251154659--

--
To unsubscribe from this list: send an email with
"unsubscribe kernelnewbies" to ecartis@nl.linux.org
Please read the FAQ at http://kernelnewbies.org/FAQ
