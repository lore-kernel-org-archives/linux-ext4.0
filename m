From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Zero length files - an alternative approach?
Date: Mon, 30 Mar 2009 08:41:26 -0400
Message-ID: <1238416886.30488.6.camel@think.oraclecorp.com>
References: <87bprka9sg.fsf@newton.gmurray.org.uk>
	 <yw1xab744lqi.fsf@thrashbarg.mansr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:58344 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZC3Mlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 08:41:45 -0400
In-Reply-To: <yw1xab744lqi.fsf@thrashbarg.mansr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2009-03-29 at 12:22 +0100, M=C3=A5ns Rullg=C3=A5rd wrote:
> Graham Murray <graham@gmurray.org.uk> writes:
>=20
> > Just a thought on the ongoing discussion of dataloss with ext4 vs e=
xt3.
> >
> > Taking the common scenario:
> > Read oldfile
> > create newfile file
> > write newfile data
> > close newfile
> > rename newfile to oldfile
> >
> > When using this scenario, the application writer wants to ensure th=
at
> > either the old or new content are present. With delayed allocation,=
 this
> > can lead to zero length files. Most of the suggestions on how to ad=
dress
> > this have involved syncing the data either before the rename or mak=
ing
> > the rename sync the data.
> >
> > What about, instead of 'bringing forward' the allocation and flushi=
ng of
> > the data, would it be possible to instead delay the rename until af=
ter
> > the blocks for newfile have been allocated and the data buffers flu=
shed?
> > This would keep the performance benefits of delayed allocation etc =
and
> > also satisfy the applications developers' apparent dislike of using
> > fsync(). It would give better performance that syncing the data at
> > rename time (either using fsync() or automatically) and satisfy the
> > requirements that either the old or new content is present.
>=20
> Consider this scenario:
>=20
> 1. Create/write/close newfile
> 2. Rename newfile to oldfile

2a. create oldfile again
2b. fsync oldfile

> 3. Open/read oldfile.  This must return the new contents.
> 4. System crash and reboot before delayed allocation/flush complete
> 5. Open/read oldfile.  Old contents now returned.
>=20

What happens to the new generation of oldfile?  We could insert
dependency tracking so that we know the fsync of oldfile is supposed to
also fsync the rename'd new file.  But then picture a loop of operation=
s
doing renames and creating files in the place of the old one...that
dependency tracking gets ugly in a hurry.

Databases know how to do all of this, but filesystems don't implement
most of the database transactional features.

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
