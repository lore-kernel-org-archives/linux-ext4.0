From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Fri, 27 Apr 2012 11:32:46 -0500
Message-ID: <CAH2r5msJVo6Li__QWavggzpz5G3A=-qPqzqSYC9vkzG5_dXc7w@mail.gmail.com>
References: <20120427010610.GE9541@dastard>
	<20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<4111.1335519545@redhat.com>
	<20120427131306.GG9541@dastard>
	<20120427151057.GA16580@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120427151057.GA16580-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 27, 2012 at 10:10 AM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org=
> wrote:
> On Fri, Apr 27, 2012 at 11:13:06PM +1000, Dave Chinner wrote:
>> Right now it is, but there's ben patches in the past to introduce
>> project quotas to ext4. That didn't go far because it was done in a
>> way that was semantically different to XFS (for no reason that I
>> could understand) and nobody wanted two different sets of semantics
>> for the "same" feature. =A0The most common use of project quotas is =
to
>> implement sub-tree quotas,
>
> (Though it's also useful as a way to do safe subtree NFS exports).

Quotas are very important to Samba (and Windows) admins.

See e.g.
http://www.samba.org/samba/docs/man/manpages-3/smbcquotas.1.html

But I would defer to Metze and others on the server side to see
whether XFS or the proposed ext4 quotas match the protocol
requirements which Samba has to support.

Does anyone know whether Samba can handle all of the remote quota
admin operations on Linux/XFS today (and local enforcement)?

--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
