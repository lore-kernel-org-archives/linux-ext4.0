From: Cholerae Hu <choleraehyq@gmail.com>
Subject: Re: A blocksize problem about dax and ext4
Date: Thu, 24 Dec 2015 12:13:26 +0800
Message-ID: <CAM=YXF90VQgPabpYAZZzYdenO6xqRzd3QqcGtAcB+8aM6eNKRA@mail.gmail.com>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
	<CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
	<CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
	<CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0646539351401245494=="
Cc: Ted Tso <tytso@mit.edu>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

--===============0646539351401245494==
Content-Type: multipart/alternative; boundary=001a114fa8ac77890605279d0f66

--001a114fa8ac77890605279d0f66
Content-Type: text/plain; charset=UTF-8

I used ext4 and set the blocksize to 4096, the mount command was silent.
Does it indicate that dax has already been enabled?

2015-12-24 10:47 GMT+08:00 Elliott, Robert (Persistent Memory) <
elliott@hpe.com>:

> > -----Original Message-----
> > From: Cholerae Hu [mailto:choleraehyq@gmail.com]
> > Sent: Wednesday, December 23, 2015 8:36 PM
> > Subject: Re: A blocksize problem about dax and ext4
> ...
> > xfs will silently disable dax when the fs block size is too small,
> > i.e. your mmap() operations are backed by page cache in this case.
> > Currently the only indication of whether a mapping is DAX backed or
> > not is the presence of the VM_MIXEDMAP flag ("mm" in the VmFlags field
> > of /proc/<pid>/smaps)
> >
> > Did you mean that I should make the blocksize bigger until the mount
> > command tell me that dax is enabled?
>
> To really use DAX, the filesystem block size must match the
> system CPU's page size, which is probably 4096 bytes.
>
> ---
> Robert Elliott, HPE Persistent Memory
>
>

--001a114fa8ac77890605279d0f66
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I used ext4 and set the blocksize to 4096, the mount comma=
nd was silent. Does it indicate that dax has already been enabled?</div><di=
v class=3D"gmail_extra"><br><div class=3D"gmail_quote">2015-12-24 10:47 GMT=
+08:00 Elliott, Robert (Persistent Memory) <span dir=3D"ltr">&lt;<a href=3D=
"mailto:elliott@hpe.com" target=3D"_blank">elliott@hpe.com</a>&gt;</span>:<=
br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left=
:1px #ccc solid;padding-left:1ex"><span class=3D"">&gt; -----Original Messa=
ge-----<br>
&gt; From: Cholerae Hu [mailto:<a href=3D"mailto:choleraehyq@gmail.com">cho=
leraehyq@gmail.com</a>]<br>
&gt; Sent: Wednesday, December 23, 2015 8:36 PM<br>
&gt; Subject: Re: A blocksize problem about dax and ext4<br>
</span><span class=3D"">...<br>
&gt; xfs will silently disable dax when the fs block size is too small,<br>
&gt; i.e. your mmap() operations are backed by page cache in this case.<br>
&gt; Currently the only indication of whether a mapping is DAX backed or<br=
>
&gt; not is the presence of the VM_MIXEDMAP flag (&quot;mm&quot; in the VmF=
lags field<br>
&gt; of /proc/&lt;pid&gt;/smaps)<br>
&gt;<br>
&gt; Did you mean that I should make the blocksize bigger until the mount<b=
r>
&gt; command tell me that dax is enabled?<br>
<br>
</span>To really use DAX, the filesystem block size must match the<br>
system CPU&#39;s page size, which is probably 4096 bytes.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
---<br>
Robert Elliott, HPE Persistent Memory<br>
<br>
</div></div></blockquote></div><br></div>

--001a114fa8ac77890605279d0f66--


--===============0646539351401245494==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0646539351401245494==--
