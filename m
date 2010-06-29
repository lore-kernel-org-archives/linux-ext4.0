From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 15:23:07 -0500
Message-ID: <AANLkTimIh9ZAasPnN5xxGxbupwkct7UihHcMe26r-MD7@mail.gmail.com>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro@zeniv.linux.org.uk, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44661 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0F2UXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jun 2010 16:23:09 -0400
In-Reply-To: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 29, 2010 at 3:02 PM, David Howells <dhowells@redhat.com> wr=
ote:
> Implement a pair of new system calls to provide extended and further =
extensible
> stat functions.
>
> The third of the associated patches provides these new system calls:
>
> =A0 =A0 =A0 =A0struct xstat_dev {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0major;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0minor;
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat_time {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0tv_sec;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0tv_nsec;
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
ruct_version;
> =A0 =A0 =A0 =A0#define XSTAT_STRUCT_VERSION =A0 =A00
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_mode;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_nlink;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_uid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_gid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_blksize;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_dev =A0 =A0 =A0 =A0st_rde=
v;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_dev =A0 =A0 =A0 =A0st_dev=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_ino;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_size;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_atime=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_mtime=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_ctime=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_crtim=
e;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_block=
s;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_inode=
_version;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_data_=
version;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0query_fl=
ags;
> =A0 =A0 =A0 =A0#define XSTAT_QUERY_CREATION_TIME =A0 =A0 =A0 0x000000=
01ULL
> =A0 =A0 =A0 =A0#define XSTAT_QUERY_INODE_VERSION =A0 =A0 =A0 0x000000=
02ULL
> =A0 =A0 =A0 =A0#define XSTAT_QUERY_DATA_VERSION =A0 =A0 =A0 =A00x0000=
0004ULL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0extra_re=
sults[0];
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0ssize_t ret =3D xstat(int dfd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *fi=
lename,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned atfla=
g,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat *=
buffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t buflen)=
;
>
> =A0 =A0 =A0 =A0ssize_t ret =3D fxstat(int fd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat =
*buffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t buflen=
);
>
> which are more fully documented in that patch's description.
>
> The bonuses of these new stat functions are:
>
> =A0(1) The fields in the xstat struct are cleaned up. =A0There are no=
 split or
> =A0 =A0 duplicated fields.
>
> =A0(2) Some extra information is made available (file creation time, =
inode
> =A0 =A0 version number and data version number) where provided by the=
 underlying
> =A0 =A0 filesystem.
>
> =A0 =A0 These are implemented here for Ext4 and AFS, but could also b=
e provided
> =A0 =A0 for CIFS, NTFS and BtrFS and probably others.

NFSv4 protocol also has a "recommended attribute" for create time that =
servers
should return if possible (which presumably now it would be possible to=
 return
for Linux servers)

   time_create         50   nfstime4       R/W      The time of
creation of the object.

SMB2 protocol also returns the equivalent.

> =A0(3) The structure is versioned and extensible, meaning that furthe=
r new system
> =A0 =A0 calls shouldn't be required.

How does a fs return an "unknown" value for one
(e.g. version field) ... 0  or -1  or ...


> =A0(2) What extra bits of information might we like to see available =
through the
> =A0 =A0 stat interface? =A0Security labels? =A0NFS file IDs? =A0Xattr=
s?

The list of mandatory ones for NFS is fairly small, the list of recomme=
nded
one for NFSv4 is larger (see page 44ff of
http://www.ietf.org/rfc/rfc3530.txt e.g.)

One hole that this reminded me about is how to return the superblock
time granularity (for NFSv4 this is attribute 51 "time_delta" which
is called on a superblock not on a file).  We run into time rounding
issues with Samba too.

>
> =A0(4) Should the inode number and data version number fields be 128-=
bit?
This is tricky for SMB2, if you can also provide a device id (or an obj=
ect id of
some sort for the superblock) then 64 bit inode number is ok.


--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
