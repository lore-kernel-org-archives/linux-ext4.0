From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Zero length files - an alternative approach?
Date: Mon, 30 Mar 2009 23:10:20 +0200
Message-ID: <E1LoOkP-0001bk-D6@be1.7eggert.dyndns.org>
References: <cl0KI-3zZ-3@gated-at.bofh.it> <cl1oA-4El-9@gated-at.bofh.it> <clp6o-91-17@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>,
	=?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757871AbZC3VKp@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Chris Mason <chris.mason@oracle.com> wrote:
> On Sun, 2009-03-29 at 12:22 +0100, M=E5ns Rullg=E5rd wrote:

>> Consider this scenario:
>>=20
>> 1. Create/write/close newfile
>> 2. Rename newfile to oldfile
>=20
> 2a. create oldfile again
> 2b. fsync oldfile
>=20
>> 3. Open/read oldfile.  This must return the new contents.
>> 4. System crash and reboot before delayed allocation/flush complete
>> 5. Open/read oldfile.  Old contents now returned.
>>=20
>=20
> What happens to the new generation of oldfile?  We could insert
> dependency tracking so that we know the fsync of oldfile is supposed =
to
> also fsync the rename'd new file.

If rename() is BEFORE create(oldfile) and if create(oldfile) is committ=
ed,
oldfile will be the newly created file. If the sync() is interrupted by=
 the
crash, any intermediate state may appear. If the system crashes before
create(), either the old oldfile or newfile should be visible.
