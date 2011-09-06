From: MaoXiaoyun <tinnycloud@hotmail.com>
Subject: RE: ext4 BUG in dom0 Kernel 2.6.32.36
Date: Tue, 6 Sep 2011 23:11:56 +0800
Message-ID: <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>,
	<20110906145347.GA4133@dumpdata.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1819275364=="
Cc: jeremy@goop.org, linux-ext4@vger.kernel.org,
	xen devel <xen-devel@lists.xensource.com>
To: <konrad.wilk@oracle.com>
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20110906145347.GA4133@dumpdata.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
List-Id: linux-ext4.vger.kernel.org

--===============1819275364==
Content-Type: multipart/alternative;
	boundary="_88720937-3531-4584-a055-432612a6bc85_"

--_88720937-3531-4584-a055-432612a6bc85_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit


 

> Date: Tue, 6 Sep 2011 10:53:47 -0400
> From: konrad.wilk@oracle.com
> To: tinnycloud@hotmail.com
> CC: linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com; jeremy@goop.org
> Subject: Re: ext4 BUG in dom0 Kernel 2.6.32.36
> 
> On Tue, Sep 06, 2011 at 03:24:14PM +0800, MaoXiaoyun wrote:
> > 
> > 
> > Hi:
> > 
> > I've met an ext4 Bug in dom0 kernel 2.6.32.36. (See kernel stack below)
> 
> Did you try the 3.0 kernel?
No,  I am afried the change would be to much for our current env.
May result in other stable issue.
So, I want to dig out what really happen. Hopes.
 
Thanks. 		 	   		  
--_88720937-3531-4584-a055-432612a6bc85_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: 8bit

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Î¢ÈíÑÅºÚ
}
--></style>
</head>
<body class='hmmessage'><div dir='ltr'>
&nbsp;<BR>
<DIV>
&gt; Date: Tue, 6 Sep 2011 10:53:47 -0400<BR>&gt; From: konrad.wilk@oracle.com<BR>&gt; To: tinnycloud@hotmail.com<BR>&gt; CC: linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com; jeremy@goop.org<BR>&gt; Subject: Re: ext4 BUG in dom0 Kernel 2.6.32.36<BR>&gt; <BR>&gt; On Tue, Sep 06, 2011 at 03:24:14PM +0800, MaoXiaoyun wrote:<BR>&gt; &gt; <BR>&gt; &gt; <BR>&gt; &gt; Hi:<BR>&gt; &gt; <BR>&gt; &gt; I've met an ext4 Bug in dom0 kernel 2.6.32.36. (See kernel stack below)<BR>&gt; <BR>&gt; Did you try the 3.0 kernel?<BR>No,&nbsp; I am afried the change would be to much for our current env.</DIV>
<DIV>May result in other stable issue.</DIV>
<DIV>So, I want to dig out what really happen. Hopes.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks.</DIV> 		 	   		  </div></body>
</html>
--_88720937-3531-4584-a055-432612a6bc85_--


--===============1819275364==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Xen-devel mailing list
Xen-devel@lists.xensource.com
http://lists.xensource.com/xen-devel

--===============1819275364==--
