From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Zero length files - an alternative approach?
Date: Sun, 29 Mar 2009 12:22:29 +0100
Message-ID: <yw1xab744lqi.fsf@thrashbarg.mansr.com>
References: <87bprka9sg.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755487AbZC2LXH@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Graham Murray <graham@gmurray.org.uk> writes:

> Just a thought on the ongoing discussion of dataloss with ext4 vs ext=
3.
>
> Taking the common scenario:
> Read oldfile
> create newfile file
> write newfile data
> close newfile
> rename newfile to oldfile
>
> When using this scenario, the application writer wants to ensure that
> either the old or new content are present. With delayed allocation, t=
his
> can lead to zero length files. Most of the suggestions on how to addr=
ess
> this have involved syncing the data either before the rename or makin=
g
> the rename sync the data.
>
> What about, instead of 'bringing forward' the allocation and flushing=
 of
> the data, would it be possible to instead delay the rename until afte=
r
> the blocks for newfile have been allocated and the data buffers flush=
ed?
> This would keep the performance benefits of delayed allocation etc an=
d
> also satisfy the applications developers' apparent dislike of using
> fsync(). It would give better performance that syncing the data at
> rename time (either using fsync() or automatically) and satisfy the
> requirements that either the old or new content is present.

Consider this scenario:

1. Create/write/close newfile
2. Rename newfile to oldfile
3. Open/read oldfile.  This must return the new contents.
4. System crash and reboot before delayed allocation/flush complete
5. Open/read oldfile.  Old contents now returned.

This rollback isn't obviously, to me at least, without problems of its
own.

--=20
M=E5ns Rullg=E5rd
mans@mansr.com
